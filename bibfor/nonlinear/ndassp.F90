! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
!
subroutine ndassp(model          , nume_dof , ds_material, cara_elem,&
                  ds_constitutive, list_load, ds_measure , fonact, ds_contact,&
                  sddyna         , valinc   , solalg     , veelem, veasse    ,&
                  ldccvg         , cndonn   , sdnume     , matass)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmaint.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmbudi.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdiri.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmtime.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
integer :: ldccvg
integer :: fonact(*)
character(len=19) :: list_load, sddyna, sdnume, matass
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: model, nume_dof
character(len=24) :: cara_elem
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: solalg(*), valinc(*)
character(len=19) :: veasse(*), veelem(*)
character(len=19) :: cndonn
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION - DYNAMIQUE
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  sddyna           : datastructure for dynamic
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! In  ds_contact       : datastructure for contact management
! IN  SDNUME : SD NUMEROTATION
! IN  MATASS  : SD MATRICE ASSEMBLEE
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_vect_maxi = 10
    real(kind=8) :: coef(nb_vect_maxi)
    character(len=19) :: vect(nb_vect_maxi)
    character(len=24) :: mate, varc_refe
    integer :: i_vect, nb_vect, iterat
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady, cnsstr
    character(len=19) :: cndumm
    character(len=19) :: vebudi
    character(len=19) :: cnfint, cndiri
    character(len=19) :: vefint, vediri
    character(len=19) :: cnbudi
    character(len=19) :: disp_prev, vitmoi, accmoi
    character(len=19) :: veclag
    aster_logical :: ldepl, lvite, lacce, l_macr
    real(kind=8) :: coeequ
!
! --------------------------------------------------------------------------------------------------
!
    ldccvg = -1
    iterat = 0
    call vtzero(cndonn)
    cndumm = '&&CNCHAR.DUMM'
    cnffdo = '&&CNCHAR.FFDO'
    cndfdo = '&&CNCHAR.DFDO'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
    mate      = ds_material%field_mate
    varc_refe = ds_material%varc_refe
!
! --- TYPE DE FORMULATION SCHEMA DYNAMIQUE GENERAL
!
    ldepl  = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.1
    lvite  = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.2
    lacce  = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.3
    l_macr = isfonc(fonact,'MACR_ELEM_STAT')
!
! --- COEFFICIENTS POUR MULTI-PAS
!
    coeequ = ndynre(sddyna,'COEF_MPAS_EQUI_COUR')
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(valinc, 'VALINC', 'VITMOI', vitmoi)
    call nmchex(valinc, 'VALINC', 'ACCMOI', accmoi)
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(veelem, 'VEELEM', 'CNFINT', vefint)
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(fonact, veasse, cnffdo, sddyna)
!
! - Get Dirichlet loads
!
    call nmasdi(fonact, veasse, cndfdo)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(fonact, veasse, cnfvdo, sddyna)
!
! - Get undead Neumann loads for dynamic
!
    call ndasva(sddyna, veasse, cnvady)
!
! --- QUEL VECTEUR D'INCONNUES PORTE LES LAGRANGES ?
!
    if (ldepl) then
        veclag = disp_prev
    else if (lvite) then
!        VECLAG = VITMOI
!       VILAINE GLUTE POUR L'INSTANT
        veclag = disp_prev
    else if (lacce) then
        veclag = accmoi
    else
        ASSERT(.false.)
    endif
!
! --- CONDITIONS DE DIRICHLET B.U
!
    call nmchex(veasse, 'VEASSE', 'CNBUDI', cnbudi)
    call nmchex(veelem, 'VEELEM', 'CNBUDI', vebudi)
    call nmbudi(model, nume_dof, list_load, veclag, vebudi,&
                cnbudi, matass)
!
! - Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nmchex(veelem, 'VEELEM', 'CNDIRI', vediri)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmdiri(model    , ds_material, cara_elem, list_load,&
                disp_prev, vediri     , nume_dof , cndiri   )
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
! --- CALCUL DES FORCES INTERIEURES
!
    call nmfint(model, mate  , cara_elem, varc_refe, ds_constitutive,&
                fonact, iterat, sddyna, ds_measure, valinc         ,&
                solalg, ldccvg, vefint)
!
! --- ERREUR SANS POSSIBILITE DE CONTINUER
!
    if (ldccvg .eq. 1) goto 999
!
! --- ASSEMBLAGE DES FORCES INTERIEURES
!
    call nmaint(nume_dof, fonact, veasse, vefint,&
                cnfint, sdnume)
!
! - List of vectors
!
    nb_vect = 8
    coef(1) = 1.d0
    coef(2) = 1.d0
    coef(3) = -1.d0
    coef(4) = -1.d0
    coef(5) = -1.d0
    coef(6) = 1.d0
    coef(7) = 1.d0
    coef(8) = coeequ
    vect(1) = cnffdo
    vect(2) = cnfvdo
    vect(3) = cnbudi
    vect(4) = cnfint
    vect(5) = cndiri
    vect(6) = ds_material%fvarc_pred(1:19)
    vect(7) = cndfdo
    vect(8) = cnvady
!
! - Add discrete contact force
!
    if (ds_contact%l_cnctdf) then
        nb_vect = nb_vect + 1
        coef(nb_vect) = -1.d0
        vect(nb_vect) = ds_contact%cnctdf
    endif
!
! - Force from sub-structuring
!
    if (l_macr) then
        call nmchex(veasse, 'VEASSE', 'CNSSTR', cnsstr)
        nb_vect = nb_vect + 1
        coef(nb_vect) = -1.d0
        vect(nb_vect) = cnsstr
    endif
!
! --- CHARGEMENT DONNE
!
    do i_vect = 1, nb_vect
        call vtaxpy(coef(i_vect), vect(i_vect), cndonn)
    end do
!
999 continue
!
end subroutine
