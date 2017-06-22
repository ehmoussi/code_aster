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
    subroutine lcumfe(fami, kpg, ksp, ndim, typmod,&
                      imate, tinstm, tinstp, epstm, depst,&
                      sigm, vim, option, rela_plas, sigp,&
                      vip, dsidpt, proj)
        integer, intent(in) :: ndim
        integer, intent(in) :: imate
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        character(len=8), intent(in) :: typmod(*)
        character(len=16), intent(in) :: rela_plas
        character(len=16), intent(in) :: option
        character(len=*), intent(in) :: fami
        real(kind=8) :: tinstm
        real(kind=8) :: tinstp
        real(kind=8) :: epstm(12)
        real(kind=8) :: depst(12)
        real(kind=8) :: sigm(6)
        real(kind=8) :: vim(25)
        real(kind=8) :: sigp(6)
        real(kind=8) :: vip(25)
        real(kind=8) :: dsidpt(6, 6, 2)
        real(kind=8) :: proj(6, 6)
    end subroutine lcumfe
end interface
