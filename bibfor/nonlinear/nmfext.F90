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
subroutine nmfext(eta, fonact, sddyna, veasse, cnfext, ds_contact_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndasva.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
real(kind=8) :: eta
integer :: fonact(*)
character(len=19) :: sddyna
character(len=19) :: veasse(*)
type(NL_DS_Contact), optional, intent(in) :: ds_contact_
character(len=19) :: cnfext
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! RESULTANTE DES EFFORTS EXTERIEURS
!
! --------------------------------------------------------------------------------------------------
!
! IN  SDDYNA : SD DYNAMIQUE
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  ETA    : COEFFICIENT DE PILOTAGE
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! In  ds_contact       : datastructure for contact management
! OUT CNFEXT : CHARGEMENT EXTERIEUR RESULTANT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: cnffdo, cnffpi, cnfvdo, cnvady
    aster_logical :: lctcd, lunil
    real(kind=8) :: coeequ
    aster_logical :: ldyna, lallv, l_pilo
    integer :: ifdo, n
    character(len=19) :: vect(20)
    real(kind=8) :: coef(20)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> CALCUL DES FORCES EXTERNES'
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    lctcd = isfonc(fonact,'CONT_DISCRET' )
    lunil = isfonc(fonact,'LIAISON_UNILATER')
    lallv = isfonc(fonact,'CONT_ALL_VERIF' )
    l_pilo = isfonc(fonact,'PILOTAGE')
!
! --- INITIALISATIONS
!
    ifdo = 0
    cnffdo = '&&CNCHAR.FFDO'
    cnffpi = '&&CNCHAR.FFPI'
    cnfvdo = '&&CNCHAR.FVDO'
    cnvady = '&&CNCHAR.FVDY'
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    call vtzero(cnfext)
!
! --- FORCES DE CONTACT DISCRET
!
    if (lctcd .and. (.not.lallv)) then
        ifdo = ifdo + 1
        coef(ifdo) = -1.d0
        vect(ifdo) = ds_contact_%cnctdc
    endif
!
! --- FORCES DE LIAISON_UNILATER
!
    if (lunil) then
        ifdo = ifdo + 1
        coef(ifdo) = -1.d0
        vect(ifdo) = ds_contact_%cnunil
    endif
!
! - Get dead Neumann loads and multi-step dynamic schemes forces
!
    call nmasfi(fonact, veasse, cnffdo, sddyna)
!
! - Get undead Neumann loads and multi-step dynamic schemes forces
!
    call nmasva(fonact, veasse, cnfvdo, sddyna)
!
! - Get undead Neumann loads for dynamic
!
    if (ldyna) then
        coeequ = ndynre(sddyna,'COEF_MPAS_EQUI_COUR')
        call ndasva(sddyna, veasse, cnvady)
    endif
!
! --- CHARGEMENTS EXTERIEURS DONNEES
!
    ifdo = ifdo + 1
    coef(ifdo) = 1.d0
    vect(ifdo) = cnffdo
    ifdo = ifdo + 1
    coef(ifdo) = 1.d0
    vect(ifdo) = cnfvdo
!
! - Get dead Neumann loads (for PILOTAGE)
!
    if (l_pilo) then
        call nmchex(veasse, 'VEASSE', 'CNFEPI', cnffpi)
        ifdo = ifdo + 1
        coef(ifdo) = eta
        vect(ifdo) = cnffpi
    endif
!
! --- TERMES DE RAPPEL DYNAMIQUE
!
    if (ldyna) then
        ifdo = ifdo + 1
        coef(ifdo) = coeequ
        vect(ifdo) = cnvady
    endif
!
! --- VECTEUR RESULTANT
!
    if (ifdo .gt. 20) then
        ASSERT(.false.)
    endif
    do n = 1, ifdo
        call vtaxpy(coef(n), vect(n), cnfext)
    end do
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cnfext, ifm)
    endif
!
    call jedema()
end subroutine
