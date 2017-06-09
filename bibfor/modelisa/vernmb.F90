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

subroutine vernmb(icl, cnl, ier, irteti)
    implicit none
#include "asterfort/utmess.h"
!       VERIFIE QUE L ITEM LUT EST UN NOMBRE ( NOMBRE ATTENDU )
!       ----------------------------------------------------------------
!       NOMBRE          =       REEL OU ENTIER (LXSCAN)
!       IN      ICL     =       CLASSE ITEM
!               CNL     =       NUMERO LIGNE
!       OUT     IER     =       0 > VRAI ( RETURN )
!                       =       1 > FAUX ( RETURN 1 )
!       ----------------------------------------------------------------
    integer :: icl, ier
    character(len=14) :: cnl
!
!-----------------------------------------------------------------------
    integer :: irteti
!-----------------------------------------------------------------------
    irteti = 0
    if (icl .ne. 1 .and. icl .ne. 2) then
        call utmess('E', 'MODELISA7_85', sk=cnl)
        ier=1
        irteti = 1
        goto 9999
    else
        irteti = 0
        goto 9999
    endif
!
9999  continue
end subroutine
