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

subroutine fiintf(nomfon, nbpu, param, val, iret,&
                  coderr, resu)
    implicit none
#include "jeveux.h"
#include "asterc/eval_formula.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jedema.h"
#include "asterfort/utmess.h"

!   Arguments
    character(len=*), intent(in) :: nomfon
    integer, intent(in) :: nbpu
    character(len=*), intent(in) :: param(*)
    real(kind=8), intent(in) :: val(*)
    integer, intent(out) :: iret
    character(len=*), intent(in) :: coderr
    real(kind=8), intent(out) :: resu

!   Local variables
    character(len=1) :: cod
    character(len=2) :: codS
    character(len=19) :: nomf
    integer, pointer :: iaddr(:) => null()

    call jemarq()
    nomf = nomfon
    cod = coderr
    call jeveuo(nomf//'.ADDR', 'L', vi=iaddr)

    call eval_formula(iaddr(1), iaddr(2), param, val, nbpu, iret, resu)
    if ( cod .ne. ' ' .and. iret .ne. 0 ) then
        codS = cod//'+'
        call utmess(codS, 'FONCT0_9', sk=nomfon)
        if ( iret .eq. 1 ) then
            call utmess(codS, 'FONCT0_67')
        elseif ( iret .eq. 4 ) then
            call utmess(codS, 'FONCT0_70')
        endif
        call utmess(cod, 'FONCT0_52', sk='See previous traceback.')
    endif

    call jedema()
end subroutine fiintf
