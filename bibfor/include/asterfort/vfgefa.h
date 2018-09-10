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
    subroutine vfgefa(nnos, xs  , t  , xg,&
                      surf, norm, xgf, d ,&
                      iret)
        integer, intent(in) :: nnos
        real(kind=8), intent(in) :: xg(3), xs(3, nnos), t(3, nnos)
        real(kind=8), intent(out) :: surf, norm(3), xgf(3), d
        integer, intent(out) :: iret
    end subroutine vfgefa
end interface
