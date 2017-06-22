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
    subroutine ccchcr(crit, name_gd, nb_val_in, val_in, cmp_in,&
                      nb_cmp_out, val_out, ichk)
        character(len=16), intent(in) :: crit
        character(len=8), intent(in) :: name_gd
        integer, intent(in) :: nb_val_in
        real(kind=8), intent(in) :: val_in(nb_val_in)
        character(len=8), intent(in) :: cmp_in(nb_val_in)
        integer, intent(in) :: nb_cmp_out
        real(kind=8), intent(out) :: val_out(nb_cmp_out)
        integer, intent(out) :: ichk
    end subroutine ccchcr
end interface
