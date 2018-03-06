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
subroutine nmassc(fonact, sddyna, ds_measure, ds_contact, veasse, cnpilo,&
                  cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmtime.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/isfonc.h"
!
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: cnpilo, cndonn
integer :: fonact(*)
character(len=19) :: sddyna
character(len=19) :: veasse(*)
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CORRECTION)
!
! CALCUL DU SECOND MEMBRE POUR LA CORRECTION
!
! --------------------------------------------------------------------------------------------------
!
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  SDDYNA : SD POUR LA DYNAMIQUE
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_contact       : datastructure for contact management
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nb_vect_maxi = 10
    real(kind=8) :: coef(nb_vect_maxi)
    character(len=19) :: vect(nb_vect_maxi)
    integer :: i_vect, nb_vect
    character(len=19) :: cnffdo, cndfdo, cnfvdo, cnvady
    character(len=19) :: cnffpi, cndfpi, cndiri
    character(len=19) :: cnfint, cnbudi
    real(kind=8) :: coeequ
    aster_logical :: ldyna, l_pilo
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... CALCUL SECOND MEMBRE'
    endif
!
! --- INITIALISATIONS
!
    cnffdo = '&&CNCHAR.FFDO'
    cnffpi = '&&CNCHAR.FFPI'
    cndfdo = '&&CNCHAR.DFDO'
    cndfpi = '&&CNCHAR.DFPI'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(veasse, 'VEASSE', 'CNBUDI', cnbudi)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
!
! --- FONCTIONNALITES ACTIVEES
!
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    l_pilo = isfonc(fonact,'PILOTAGE')
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
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
    call nmasva(veasse, cnfvdo, sddyna)
!
! - Get undead Neumann loads for dynamic
!
    if (ldyna) then
        coeequ = ndynre(sddyna,'COEF_MPAS_EQUI_COUR')
        call ndasva(sddyna, veasse, cnvady)
    endif
!
! --- CHARGEMENTS DONNES AVEC PRISE EN COMPTE L'ERREUR DE L'ERREUR QUI
!    FAITE SUR LES DDLS IMPOSES (CNDFDO - CNBUDI)
!
    nb_vect = 6
    coef(1) = 1.d0
    coef(2) = 1.d0
    coef(3) = -1.d0
    coef(4) = -1.d0
    coef(5) = -1.d0
    coef(6) = 1.d0
!
    vect(1) = cnffdo
    vect(2) = cnfvdo
    vect(3) = cnfint
    vect(4) = cnbudi
    vect(5) = cndiri
    vect(6) = cndfdo
!
    if (ldyna) then
        nb_vect = nb_vect + 1
        coef(nb_vect) = coeequ
        vect(nb_vect) = cnvady
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
