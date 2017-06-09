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
    subroutine intdevo_oper(nbequ, par, mgen, kgen, agen, &
                            dt, invm_c, op_h1, op_h2, invm_k)
        integer     , intent(in)  :: nbequ
        real(kind=8), intent(in)  :: par(:)
        real(kind=8), pointer, intent(in)  :: mgen(:)
        real(kind=8), pointer, intent(in)  :: kgen(:)
        real(kind=8), pointer, intent(in)  :: agen(:)
        real(kind=8), intent(in)           :: dt
        real(kind=8), pointer, intent(out) :: invm_c(:)
        real(kind=8), pointer, intent(out) :: op_h1(:)
        real(kind=8), pointer, intent(out) :: op_h2(:)
        real(kind=8), pointer, intent(out) :: invm_k(:)
    end subroutine intdevo_oper
end interface
