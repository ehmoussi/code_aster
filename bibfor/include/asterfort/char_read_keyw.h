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
    subroutine char_read_keyw(keywordfact, iocc , val_type, n_keyexcl, keywordexcl,  &
                              n_max_keyword, n_keyword , keywordlist, val_nb, val_r, &
                              val_f, val_c)
        character(len=16), intent(in) :: keywordfact
        integer, intent(in)  :: iocc
        character(len=4), intent(in) :: val_type
        character(len=24), intent(in) :: keywordexcl
        integer, intent(in)  :: n_keyexcl
        integer, intent(in)  :: n_max_keyword
        integer, intent(out) :: n_keyword
        character(len=16), intent(out) :: keywordlist(n_max_keyword)
        integer, intent(out) :: val_nb(n_max_keyword)
        real(kind=8), intent(out) :: val_r(n_max_keyword)
        character(len=8), intent(out) :: val_f(n_max_keyword)
        complex(kind=8), intent(out) :: val_c(n_max_keyword)
    end subroutine char_read_keyw
end interface
