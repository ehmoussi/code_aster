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
    subroutine utersa(ndim, iflup, iflum, ino, mno,&
                      jno, ivois, ma, iel, nbnv,&
                      nbsv, iavalp, iavalm, nsomm, jac,&
                      ltheta, valthe, valunt, niv, ifm,&
                      ityp, xn, yn, zn, term22,&
                      aux, jad, jadv, noe)
        integer :: ndim
        integer :: iflup
        integer :: iflum
        integer :: ino
        integer :: mno
        integer :: jno
        integer :: ivois
        character(len=8) :: ma
        integer :: iel
        integer :: nbnv
        integer :: nbsv
        integer :: iavalp
        integer :: iavalm
        integer :: nsomm
        real(kind=8) :: jac(9)
        aster_logical :: ltheta
        real(kind=8) :: valthe
        real(kind=8) :: valunt
        integer :: niv
        integer :: ifm
        integer :: ityp
        real(kind=8) :: xn(9)
        real(kind=8) :: yn(9)
        real(kind=8) :: zn(9)
        real(kind=8) :: term22
        real(kind=8) :: aux
        integer :: jad
        integer :: jadv
        integer :: noe(9, 6, 3)
    end subroutine utersa
end interface
