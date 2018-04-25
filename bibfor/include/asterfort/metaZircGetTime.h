! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine metaZircGetTime(zbetam   ,&
                               t1c      , t2c  ,&
                               t1r      , t2r  ,&
                               tm       , tp   ,&
                               tdeq     , tfeq ,&
                               time_curr, time_incr, time_tran_p,&
                               time_tran, l_integ)
        use Metallurgy_type
        real(kind=8), intent(in) :: zbetam
        real(kind=8), intent(in) :: t1c, t2c
        real(kind=8), intent(in) :: t1r, t2r
        real(kind=8), intent(in) :: tm, tp, tdeq, tfeq
        real(kind=8), intent(in) :: time_curr, time_incr, time_tran_p
        real(kind=8), intent(out) :: time_tran
        aster_logical, intent(out) :: l_integ
    end subroutine metaZircGetTime
end interface
