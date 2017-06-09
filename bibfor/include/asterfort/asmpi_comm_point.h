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
! aslint: disable=W1304
interface
    subroutine asmpi_comm_point(optmpi, typsca, nudest, numess, nbval, &
                                vi, vi4, vr, sci, sci4, &
                                scr)
        character(len=*), intent(in) :: optmpi
        character(len=*), intent(in) :: typsca
        integer, intent(in) :: nudest
        integer, intent(in) :: numess
        integer, intent(in), optional :: nbval
        integer, intent(inout), optional :: vi(*)
        integer(kind=4), intent(inout), optional :: vi4(*)
        real(kind=8), intent(inout), optional :: vr(*)
        integer, intent(inout), optional :: sci
        integer(kind=4), intent(inout), optional :: sci4
        real(kind=8), intent(inout), optional :: scr
    end subroutine asmpi_comm_point
end interface
