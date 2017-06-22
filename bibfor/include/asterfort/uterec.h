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

!
!
#include "asterf_types.h"
!
interface
    subroutine uterec(ndim, iflup, iflum, ino, mno,&
                      jno, nsomm, jac, term22, aux,&
                      ltheta, valthe, valunt, niv, ifm,&
                      xn, yn, zn, valhp, valhm,&
                      valtp, valtm, ityp, itemp, itemm,&
                      noe)
        integer :: ndim
        integer :: iflup
        integer :: iflum
        integer :: ino
        integer :: mno
        integer :: jno
        integer :: nsomm
        real(kind=8) :: jac(9)
        real(kind=8) :: term22
        real(kind=8) :: aux
        aster_logical :: ltheta
        real(kind=8) :: valthe
        real(kind=8) :: valunt
        integer :: niv
        integer :: ifm
        real(kind=8) :: xn(9)
        real(kind=8) :: yn(9)
        real(kind=8) :: zn(9)
        real(kind=8) :: valhp(9)
        real(kind=8) :: valhm(9)
        real(kind=8) :: valtp(9)
        real(kind=8) :: valtm(9)
        integer :: ityp
        integer :: itemp
        integer :: itemm
        integer :: noe(9, 6, 3)
    end subroutine uterec
end interface
