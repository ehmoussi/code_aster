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
    subroutine ngfint(option, typmod, ndim, nddl, neps,&
                      npg, w, b, compor, fami,&
                      mat, angmas, lgpg, crit, instam,&
                      instap, ddlm, ddld, ni2ldc, sigmam,&
                      vim, sigmap, vip, fint, matr,&
                      codret)
        integer :: lgpg
        integer :: npg
        integer :: neps
        integer :: nddl
        character(len=16) :: option
        character(len=8) :: typmod(*)
        integer :: ndim
        real(kind=8) :: w(0:npg-1)
        real(kind=8) :: b(neps, npg, nddl)
        character(len=16) :: compor(*)
        character(len=*) :: fami
        integer :: mat
        real(kind=8) :: angmas(3)
        real(kind=8) :: crit(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        real(kind=8) :: ddlm(nddl)
        real(kind=8) :: ddld(nddl)
        real(kind=8) :: ni2ldc(0:neps-1)
        real(kind=8) :: sigmam(0:neps*npg-1)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: sigmap(0:neps*npg-1)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: fint(nddl)
        real(kind=8) :: matr(nddl, nddl)
        integer :: codret
    end subroutine ngfint
end interface
