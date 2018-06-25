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
!
interface
    subroutine dbr_calcpod_svd2(p, incr_end, g, s, b, nb_sing)
        use Rom_Datastructure_type
        integer, intent(in) :: p
        integer, intent(in) :: incr_end
        real(kind=8), pointer :: g(:)
        real(kind=8), pointer :: b(:)
        real(kind=8), pointer :: s(:)
        integer, intent(out) :: nb_sing
    end subroutine dbr_calcpod_svd2
end interface
