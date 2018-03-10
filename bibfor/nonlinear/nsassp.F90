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
subroutine nsassp(model     , nume_dof   , list_load, fonact    ,&
                  ds_measure, valinc     , veelem   , veasse    , cnpilo,&
                  cndonn    , ds_material, cara_elem, ds_contact, matass,&
                  ds_algorom)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmbudi.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdiri.h"
#include "asterfort/nmtime.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
integer :: fonact(*)
character(len=19) :: list_load, matass
character(len=24) :: model, nume_dof, cara_elem
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: veasse(*), veelem(*), valinc(*)
character(len=19) :: cnpilo, cndonn
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION - STATIQUE
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  nume_dof         : name of numbering object (NUME_DDL)
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! IN  MATASS : SD MATRICE ASSEMBLEE
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_vect_maxi = 10
    real(kind=8) :: coef(nb_vect_maxi)
    character(len=19) :: vect(nb_vect_maxi)
    integer :: i_vect, nb_vect
    character(len=19) :: cnffdo, cndfdo, cnfvdo
    character(len=19) :: cnffpi, cndfpi, cndiri
    character(len=19) :: vebudi, vediri
    character(len=19) :: cnfnod, cnbudi, cnsstr, cneltc, cneltf, cnfint
    character(len=19) :: disp_prev
    aster_logical :: lmacr, leltc, leltf, lallv, l_pilo
!
! --------------------------------------------------------------------------------------------------
!
    call vtzero(cndonn)
    call vtzero(cnpilo)
    cnffdo = '&&CNCHAR.FFDO'
    cnffpi = '&&CNCHAR.FFPI'
    cndfdo = '&&CNCHAR.DFDO'
    cndfpi = '&&CNCHAR.DFPI'
    cnfvdo = '&&CNCHAR.FVDO'
!
! --- FONCTIONNALITES ACTIVEES
!
    lmacr = isfonc(fonact,'MACR_ELEM_STAT')
    leltc = isfonc(fonact,'ELT_CONTACT')
    leltf = isfonc(fonact,'ELT_FROTTEMENT')
    lallv = isfonc(fonact,'CONT_ALL_VERIF' )
    l_pilo = isfonc(fonact,'PILOTAGE')
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(fonact, veasse, cnffdo)
!
! - Get Dirichlet loads
!
    call nmasdi(fonact, veasse, cndfdo)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(fonact, veasse, cnfvdo)
!
! --- FORCES NODALES
!
    call nmchex(veasse, 'VEASSE', 'CNFNOD', cnfnod)
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
!
! - Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
    call nmchex(veelem, 'VEELEM', 'CNDIRI', vediri)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmdiri(model    , ds_material, cara_elem, list_load,&
                disp_prev, vediri     , nume_dof , cndiri   )
!
! --- CONDITIONS DE DIRICHLET B.U
!
    call nmchex(veasse, 'VEASSE', 'CNBUDI', cnbudi)
    call nmchex(veelem, 'VEELEM', 'CNBUDI', vebudi)
    call nmbudi(model, nume_dof, list_load, disp_prev, vebudi,&
                cnbudi, matass)
!
! --- CHARGEMENTS DONNES
!
    nb_vect = 7
    coef(1) = 1.d0
    coef(2) = 1.d0
    coef(3) = -1.d0
    coef(4) = -1.d0
    coef(5) = -1.d0
    coef(6) = 1.d0
    coef(7) = 1.d0
    vect(1) = cnffdo
    vect(2) = cnfvdo
    vect(3) = cndiri
    vect(4) = cnbudi
    vect(5) = cnfnod
    vect(6) = ds_material%fvarc_pred(1:19)
    vect(7) = cndfdo
!
! - Internal forces
! 
    if (ds_algorom%phase.eq.'CORR_EF') then
        vect(5) = cnfint
    endif
!
! - Add discrete contact force
!
    if (ds_contact%l_cnctdf) then
        nb_vect = nb_vect + 1
        coef(nb_vect) = -1.d0
        vect(nb_vect) = ds_contact%cnctdf
    endif
!
! --- FORCES ISSUES DES MACRO-ELEMENTS STATIQUES
!
    if (lmacr) then
        call nmchex(veasse, 'VEASSE', 'CNSSTR', cnsstr)
        nb_vect = nb_vect + 1
        coef(nb_vect) = 1.d0
        vect(nb_vect) = cnsstr
    endif
!
! --- FORCES DES ELEMENTS DE CONTACT (XFEM+CONTINUE)
!
    if (leltc .and. (.not.lallv)) then
        call nmchex(veasse, 'VEASSE', 'CNELTC', cneltc)
        nb_vect = nb_vect + 1
        coef(nb_vect) = -1.d0
        vect(nb_vect) = cneltc
    endif
    if (leltf .and. (.not.lallv)) then
        call nmchex(veasse, 'VEASSE', 'CNELTF', cneltf)
        nb_vect = nb_vect + 1
        coef(nb_vect) = -1.d0
        vect(nb_vect) = cneltf
    endif
!
! --- CHARGEMENT DONNE
!
    do i_vect = 1, nb_vect
        call vtaxpy(coef(i_vect), vect(i_vect), cndonn)
    end do
!
! - Get dead Neumann loads (for PILOTAGE)
!
    call nmchex(veasse, 'VEASSE', 'CNFEPI', cnffpi)
!
! - Get Dirichlet loads (for PILOTAGE)
!
    call nmchex(veasse, 'VEASSE', 'CNDIPI', cndfpi)
!
! --- CHARGEMENT PILOTE
!
    if (l_pilo) then
        nb_vect = 2
        coef(1) = 1.d0
        coef(2) = 1.d0
        vect(1) = cnffpi
        vect(2) = cndfpi
        do i_vect = 1, nb_vect
            call vtaxpy(coef(i_vect), vect(i_vect), cnpilo)
        end do
    endif
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
end subroutine
