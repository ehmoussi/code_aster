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

function diinst(sddisc, numins)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    real(kind=8) :: diinst
#include "jeveux.h"
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: numins
    character(len=19) :: sddisc
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! ACCES A LA VALEUR D'UN INSTANT
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION LOCALE OU
! IN  NUMINS : NUMERO D'INSTANTS
! OUT DIINST : VALEUR DE L'INSTANT
!
!
!
!
!
    integer :: iret, jinst
    character(len=24) :: tpsdit
    character(len=16) :: typeco
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    if (numins .lt. 0) then
        ASSERT(.false.)
    endif
    typeco = ' '
!
    call gettco(sddisc, typeco)
!
! --- ACCES SD LISTE D'INSTANTS
!
    if (typeco .eq. 'LISTR8_SDASTER') then
        call jeveuo(sddisc(1:19)//'.VALE', 'L', jinst)
    else if (typeco.eq.'LIST_INST') then
        call jeveuo(sddisc(1:8)//'.LIST.DITR', 'L', jinst)
    else
        tpsdit = sddisc(1:19)//'.DITR'
        call jeexin(tpsdit, iret)
        if (iret .eq. 0) then
            diinst = 0.d0
            goto 99
        else
            call jeveuo(tpsdit, 'L', jinst)
        endif
    endif
!
! --- VALEUR DE L'INSTANT
!
    diinst = zr(jinst+numins)
 99 continue
!
    call jedema()
end function
