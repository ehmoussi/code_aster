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
interface 
    subroutine xsifl2(basloc, coeff, coeff3, ddld, ddlm,&
                      ddls, dfdi, ff, idepl, igthet,&
                      ithet, jac, ndim, nnop,&
                      nnos, tau1, tau2, nd, xg)
        integer :: nnop
        integer :: ndim
        real(kind=8) :: basloc(9*nnop)
        real(kind=8) :: coeff
        real(kind=8) :: coeff3
        integer :: ddld
        integer :: ddlm
        integer :: ddls
        real(kind=8) :: dfdi(nnop, ndim)
        real(kind=8) :: ff(27)
        integer :: idepl
        integer :: igthet
        integer :: ithet
        real(kind=8) :: jac
        integer :: nnos
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: nd(3)
        real(kind=8) :: xg(3)
    end subroutine xsifl2
end interface 
