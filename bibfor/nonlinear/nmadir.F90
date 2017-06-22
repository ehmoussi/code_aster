! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine nmadir(numedd, fonact, ds_contact, veasse, vediri,&
                  cndiri)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assvec.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmasco.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: fonact(*)
    character(len=24) :: numedd
    character(len=19) :: veasse(*)
    character(len=19) :: vediri, cndiri
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ASSEMBLAGE DU VECTEUR DES REACTIONS D'APPUI BT.LAMBDA
!
! ----------------------------------------------------------------------
!
! IN  NUMEDD : NOM DE LA NUMEROTATION
! In  ds_contact       : datastructure for contact management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  VEDIRI : VECT_ELEM DES REACTIONS D'APPUIS
! OUT CNDIRI : VECT_ASSE DES REACTIONS D'APPUIS
!
!
!
!
    integer :: ifm, niv
    character(len=1) :: base
    character(len=19) :: cncont
    aster_logical :: lcont
!
! ----------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... ASSEMBLAGE DES REAC. APPUI'
    endif
!
! --- INITIALISATIONS
!
    base = 'V'
    cncont = '&&CNCHAR.DUMM'
    lcont = isfonc(fonact,'CONTACT')
    call vtzero(cndiri)
    call vtzero(cncont)
!
! --- CONTRIBUTIONS DU CONTACT
!
    if (lcont) then
        call nmasco('CNDIRI', fonact, ds_contact, veasse, cncont)
    endif
!
! --- ASSEMBLAGE DES REACTIONS D'APPUI
!
    call assvec(base, cndiri, 1, vediri, [1.d0],&
                numedd, ' ', 'ZERO', 1)
!
! --- CONTRIBUTIONS DU CONTACT
!
    if (lcont) then
        call vtaxpy(1.d0, cncont, cndiri)
    endif
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cndiri, 6)
    endif
!
end subroutine
