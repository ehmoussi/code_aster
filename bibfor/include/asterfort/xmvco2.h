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
    subroutine xmvco2(ndim, nno, nnol, nnos, lamb,&
                      am, delta, pla, lact, nfh,&
                      ddls, ddlm, nfiss, ifiss, jheafa,&
                      ifa, ncomph, jheavn, ncompn, jac, ffc,&
                      ffp, singu, r, fk, vtmp,&
                      p)
        integer :: ndim
        integer :: nno
        integer :: nnol
        integer :: nnos
        real(kind=8) :: lamb(3)
        real(kind=8) :: am(3)
        real(kind=8) :: delta(6)
        integer :: pla(27)
        integer :: lact(8)
        integer :: nfh
        integer :: ddls
        integer :: ddlm
        integer :: nfiss
        integer :: ifiss
        integer :: jheafa
        integer :: jheavn
        integer :: ncompn
        integer :: ifa
        integer :: ncomph
        real(kind=8) :: jac
        real(kind=8) :: ffc(8)
        real(kind=8) :: ffp(27)
        integer :: singu
        real(kind=8) :: r
        real(kind=8) :: fk(27,3,3)
        real(kind=8) :: vtmp(400)
        real(kind=8) :: p(3, 3)
    end subroutine xmvco2
end interface
