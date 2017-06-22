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
interface
    subroutine xjacf2(elrefp, elrefc, elc, ndim, fpg,&
                      jinter, ifa, cface, nptf, ipg,&
                      nnop, nnops, igeom, jbasec, xg, jac,&
                      ffp, ffpc, dfdi, nd, tau1, dfdic)
        character(len=8) :: elrefp
        character(len=8) :: elrefc
        character(len=8) :: elc
        integer :: ndim
        character(len=8) :: fpg
        integer :: jinter
        integer :: ifa
        integer :: cface(30, 6)
        integer :: nptf
        integer :: ipg
        integer :: nnop
        integer :: nnops
        integer :: igeom
        integer :: jbasec
        real(kind=8) :: xg(3)
        real(kind=8) :: jac
        real(kind=8) :: ffp(27)
        real(kind=8) :: ffpc(27)
        real(kind=8) :: dfdi(27, 3)
        real(kind=8) :: nd(3)
        real(kind=8) :: tau1(3)
        real(kind=8), intent(out), optional :: dfdic(nnops, 3)
    end subroutine xjacf2
end interface
