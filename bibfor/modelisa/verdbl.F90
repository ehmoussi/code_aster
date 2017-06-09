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

subroutine verdbl(deblig, cnl, ier, irteti)
    implicit none
#include "asterfort/utmess.h"
!       VERIFIE QUE L ITEM LUT EST EN DEBUT DE LIGNE ( DEBUT ATTENDU )
!       ----------------------------------------------------------------
!       IN      DEBLIG  =       0 > DANS LA LIGNE  ( # 1ERE POSITION)
!                       =       1 > DEBUT DE LIGNE ( = 1ERE POSITION)
!               CNL     =       NUMERO LIGNE
!       OUT     IER     =       0 > VRAI ( RETURN )
!                       =       1 > FAUX ( RETURN 1 )
!       ----------------------------------------------------------------
    integer :: ier, deblig
    character(len=14) :: cnl
!
!-----------------------------------------------------------------------
    integer :: irteti
!-----------------------------------------------------------------------
    irteti = 0
    if (deblig .eq. 0) then
        call utmess('E', 'MODELISA7_66', sk=cnl)
        ier = 1
        irteti = 1
        goto 9999
    else
        irteti = 0
        goto 9999
    endif
!
9999  continue
end subroutine
