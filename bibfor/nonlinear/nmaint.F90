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
subroutine nmaint(numedd, fonact, vefint,&
                  cnfint, sdnume, ds_contact_)
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
integer :: fonact(*)
character(len=24) :: numedd
character(len=19) :: vefint, cnfint
character(len=19) :: sdnume
type(NL_DS_Contact), optional, intent(in) :: ds_contact_
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ASSEMBLAGE DU VECTEUR DES FORCES INTERNES
!
! --------------------------------------------------------------------------------------------------
!
! IN  NUMEDD : NOM DE LA NUMEROTATION
! IN  FONACT : FONCTIONNALITES ACTIVEES
! In  ds_contact       : datastructure for contact management
! IN  VEFINT : VECT_ELEM FORCES INTERNES
! IN  CNFINT : VECT_ASSE FORCES INTERNES
! IN  SDNUME : SD NUMEROTATION
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=1) :: base
    aster_logical :: lcont
    character(len=19) :: cncont
    integer :: neq, i, endo
    integer :: endop1, endop2
    aster_logical :: lendo
    real(kind=8), pointer :: vale(:) => null()
!
! --------------------------------------------------------------------------------------------------
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
    cncont = '&&CNCHAR.DUMM'
    call vtzero(cnfint)
    call vtzero(cncont)
!
! --- CONTRIBUTIONS DU CONTACT
!
    if (lcont) then
        if (present(ds_contact_)) then
            call nmasco(cncont, ds_contact_)
        endif
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
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cnfint, 6)
    endif
!
    call jedema()
end subroutine
