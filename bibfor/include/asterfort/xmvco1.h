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
    subroutine xmvco1(ndim, nno, nnol, sigma, pla,&
                      lact, dtang, nfh, ddls, jac,&
                      ffc, ffp, singu, fk, cstaco,&
                      nd, tau1, tau2, jheavn, ncompn,&
                      nfiss, ifiss, jheafa, ncomph, ifa,&
                      vtmp)
        integer :: ndim
        integer :: nno
        integer :: nnol
        real(kind=8) :: sigma(6)
        integer :: pla(27)
        integer :: lact(8)
        real(kind=8) :: dtang(3)
        integer :: nfh
        integer :: ddls
        integer :: ifiss
        integer :: nfiss
        integer :: jheavn
        integer :: jheafa
        integer :: ncompn
        integer :: ncomph
        integer :: ifa
        real(kind=8) :: jac
        real(kind=8) :: ffc(8)
        real(kind=8) :: ffp(27)
        integer :: singu
        real(kind=8) :: fk(27,3,3)
        real(kind=8) :: cstaco
        real(kind=8) :: nd(3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: vtmp(400)
    end subroutine xmvco1
end interface
