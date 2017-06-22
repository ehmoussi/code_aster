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
    subroutine utnorm(igeom, nsomm, naret, ino, poinc1,&
                      poinc2, jno, mno, zrino2, zrino1,&
                      zrjno2, zrjno1, x3, y3, hf,&
                      xn, yn, jac, laxi, jacob,&
                      ifm, niv)
        integer :: igeom
        integer :: nsomm
        integer :: naret
        integer :: ino
        real(kind=8) :: poinc1
        real(kind=8) :: poinc2
        integer :: jno
        integer :: mno
        real(kind=8) :: zrino2
        real(kind=8) :: zrino1
        real(kind=8) :: zrjno2
        real(kind=8) :: zrjno1
        real(kind=8) :: x3
        real(kind=8) :: y3
        real(kind=8) :: hf
        real(kind=8) :: xn(9)
        real(kind=8) :: yn(9)
        real(kind=8) :: jac(9)
        aster_logical :: laxi
        real(kind=8) :: jacob
        integer :: ifm
        integer :: niv
    end subroutine utnorm
end interface
