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

subroutine nmaint(numedd, fonact, ds_contact, veasse, vefint,&
                  cnfint, sdnume)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assvec.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmasco.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: fonact(*)
    character(len=24) :: numedd
    character(len=19) :: veasse(*)
    character(len=19) :: vefint, cnfint
    character(len=19) :: sdnume
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ASSEMBLAGE DU VECTEUR DES FORCES INTERNES
!
! ----------------------------------------------------------------------
!
! IN  NUMEDD : NOM DE LA NUMEROTATION
! In  ds_contact       : datastructure for contact management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  VEFINT : VECT_ELEM FORCES INTERNES
! IN  CNFINT : VECT_ASSE FORCES INTERNES
! IN  SDNUME : SD NUMEROTATION
!
!
!
!
    integer :: ifm, niv
    character(len=1) :: base
    aster_logical :: lcont, lmacr
    character(len=19) :: cncont, cnsstr
    integer :: neq, i, endo
    integer :: endop1, endop2
    aster_logical :: lendo
    real(kind=8), pointer :: vale(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... ASSEMBLAGE DES FORCES INTERNES'
    endif
!
! --- INITIALISATIONS
!
    base = 'V'
    lcont = isfonc(fonact,'CONTACT')
    lmacr = isfonc(fonact,'MACR_ELEM_STAT')
    cncont = '&&CNCHAR.DUMM'
    call vtzero(cnfint)
    call vtzero(cncont)
!
! --- CONTRIBUTIONS DU CONTACT
!
    if (lcont) then
        call nmasco('CNFINT', fonact, ds_contact, veasse, cncont)
    endif
!
! --- ASSEMBLAGE DES FORCES INTERIEURES
!
    call assvec(base, cnfint, 1, vefint, [1.d0],&
                numedd, ' ', 'ZERO', 1)
!
    lendo = isfonc(fonact,'ENDO_NO')
!
    if (lendo) then
        call jeveuo(sdnume(1:19)//'.ENDO', 'L', endo)
        call jeveuo(cnfint(1:19)//'.VALE', 'E', vr=vale)
!
        call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
!
        endop1 = 0
        endop2 = 0
!
        do i = 1, neq
!
            if (zi(endo+i-1) .eq. 2) then
                if (vale(i) .ge. 0.d0) then
                    endop2 = endop2+1
                    vale(i) = 0.d0
                else
                    endop1 = endop1+1
                endif
            endif
!
        end do
    endif
!
! --- CONTRIBUTIONS DU CONTACT
!
    if (lcont) then
        call vtaxpy(1.d0, cncont, cnfint)
    endif
!
! --- FORCES ISSUES DES MACRO-ELEMENTS STATIQUES
!
    if (lmacr) then
        call nmchex(veasse, 'VEASSE', 'CNSSTR', cnsstr)
        call vtaxpy(1.d0, cnsstr, cnfint)
    endif
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cnfint, 6)
    endif
!
    call jedema()
end subroutine
