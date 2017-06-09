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
    subroutine xmmco2(ndim, nno, nnos, nnol, ddls,&
                      ddlm, dsidep, p, r, nfh,&
                      jac, ffp, ffc, pla, singu,&
                      nfiss, jheafa, jheavn, ncompn, ifa, ncomph,&
                      ifiss, fk, mmat)
        integer :: ndim
        integer :: nno
        integer :: nnos
        integer :: nnol
        integer :: ddls
        integer :: ddlm
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: p(3, 3)
        real(kind=8) :: r
        integer :: nfh
        real(kind=8) :: jac
        real(kind=8) :: ffp(27)
        real(kind=8) :: ffc(8)
        integer :: pla(27)
        integer :: singu
        integer :: nfiss
        integer :: jheafa
        integer :: jheavn
        integer :: ncompn
        integer :: ifa
        integer :: ncomph
        integer :: ifiss
        real(kind=8) :: fk(27,3,3)
        real(kind=8) :: mmat(216, 216)
    end subroutine xmmco2
end interface
