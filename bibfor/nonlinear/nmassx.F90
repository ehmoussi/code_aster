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
subroutine nmassx(model, nume_dof, ds_material, cara_elem,&
                  ds_constitutive, list_load, fonact, ds_measure,&
                  sddyna, valinc, solalg, veelem, veasse,&
                  ldccvg, cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/assvec.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdiri.h"
#include "asterfort/nmfint.h"
#include "asterfort/nmtime.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
integer :: ldccvg
integer :: fonact(*)
character(len=19) :: list_load, sddyna
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24) :: model, nume_dof
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: cara_elem
character(len=19) :: solalg(*), valinc(*)
character(len=19) :: veasse(*), veelem(*)
character(len=19) :: cndonn
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION EN EXPLICITE
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  sddyna           : datastructure for dynamic
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDYNA : SD DYNAMIQUE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! OUT LDCCVG : CODE RETOUR INTEGRATION DU COMPORTEMENT
!                0 - OK
!                1 - ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
!                2 - ERREUR DANS LES LDC SUR LA NON VERIFICATION DE
!                    CRITERES PHYSIQUES
!                3 - SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: mate, varc_refe
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady
    character(len=19) :: cndumm
    character(len=19) :: cndiri, cnfint
    character(len=19) :: vediri, vefint
    character(len=19) :: disp_prev, vite_prev, acce_prev
    integer :: iterat
    integer :: i_vect, nb_vect
    real(kind=8) :: coef(8)
    character(len=19) :: vect(8)
    real(kind=8) :: coeequ
!
! --------------------------------------------------------------------------------------------------
!
    mate      = ds_material%field_mate
    varc_refe = ds_material%varc_refe
    iterat = 0
    call vtzero(cndonn)
    cndumm = '&&CNCHAR.DUMM'
    cnffdo = '&&CNCHAR.FFDO'
    cndfdo = '&&CNCHAR.DFDO'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(veelem, 'VEELEM', 'CNFINT', vefint)
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(valinc, 'VALINC', 'VITMOI', vite_prev)
    call nmchex(valinc, 'VALINC', 'ACCMOI', acce_prev)
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
! --- CALCUL DU VECTEUR DES CHARGEMENTS FIXES        (NEUMANN)
!
    call nmasfi(fonact, sddyna, veasse, cnffdo, cndumm)
!
! --- CALCUL DU VECTEUR DES CHARGEMENTS FIXES        (DIRICHLET)
!
    call nmasdi(fonact, veasse, cndfdo, cndumm)
!
! --- CALCUL DU VECTEUR DES CHARGEMENTS VARIABLES    (NEUMANN)
!
    call nmasva(sddyna, veasse, cnfvdo)
!
! --- CALCUL DU VECTEUR DES CHARGEMENTS VARIABLES DYNAMIQUES (NEUMANN)
!
    call ndasva('PRED', sddyna, veasse, cnvady)
!
! - Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nmchex(veelem, 'VEELEM', 'CNDIRI', vediri)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmdiri(model    , ds_material, cara_elem, list_load,&
                disp_prev, vediri     , nume_dof , cndiri   ,&
                sddyna   , vite_prev  , acce_prev)
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
! --- CALCUL DES FORCES INTERIEURES
!
    call nmfint(model, mate  , cara_elem, varc_refe , ds_constitutive,&
                fonact, iterat, sddyna, ds_measure, valinc         ,&
                solalg, ldccvg, vefint)
!
! --- ASSEMBLAGE DES FORCES INTERIEURES
!
    call assvec('V', cnfint, 1, vefint, [1.d0], nume_dof, ' ', 'ZERO', 1)
!
! --- CHARGEMENTS DONNES
!
    nb_vect = 7
    coef(1) = 1.d0
    coef(2) = 1.d0
    coef(3) = -1.d0
    coef(4) = 1.d0
    coef(5) = 1.d0
    coef(6) = -1.d0
    coef(7) = coeequ
    vect(1) = cnffdo
    vect(2) = cnfvdo
    vect(3) = cnfint
    vect(4) = ds_material%fvarc_pred(1:19)
    vect(5) = cndfdo
    vect(6) = cndiri
    vect(7) = cnvady
!
! --- CHARGEMENT DONNE
!
    if (nb_vect .gt. 8) then
        ASSERT(.false.)
    endif
    do i_vect = 1, nb_vect
        call vtaxpy(coef(i_vect), vect(i_vect), cndonn)
    end do
!
end subroutine
