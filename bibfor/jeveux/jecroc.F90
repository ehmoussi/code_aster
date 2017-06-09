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

subroutine jecroc(nomlu)
    implicit none
#include "asterfort/jjallc.h"
#include "asterfort/jjcroc.h"
#include "asterfort/jjvern.h"
#include "asterfort/jxveuo.h"
#include "asterfort/utmess.h"
    character(len=*), intent(in) :: nomlu
!     ------------------------------------------------------------------
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
!     ------------------------------------------------------------------
    character(len=32) :: noml32
    integer :: icre, iret, jctab, itab(1)
    character(len=8) :: nume
!-----------------------------------------------------------------------
    integer :: ibacol, l
!-----------------------------------------------------------------------
    data             nume  / '$$XNUM  '/
! DEB ------------------------------------------------------------------
    l = len(nomlu)
    if (l .ne. 32) then
        call utmess('F', 'JEVEUX_95')
    endif
!
    icre = 3
    noml32 = nomlu
    call jjvern(noml32, icre, iret)
!
    if (iret .eq. 0) then
        call utmess('F', 'JEVEUX_25', sk=noml32(1:24))
    else
        if (iret .eq. 1) then
!         ----- OBJET DE TYPE REPERTOIRE
            if (nomlu(25:32) .eq. nume) then
                call utmess('F', 'JEVEUX_96', sk=noml32)
            endif
            call jxveuo('E', itab, 1, jctab)
            call jjcroc('        ', icre)
        else if (iret .eq. 2) then
!         ----- REPERTOIRE DE COLLECTION --
            call jjallc(iclaco, idatco, 'E', ibacol)
            call jjcroc(nomlu(25:32), icre)
        else
            call utmess('F', 'JEVEUX_97', sk=noml32)
        endif
    endif
! FIN ------------------------------------------------------------------
end subroutine
