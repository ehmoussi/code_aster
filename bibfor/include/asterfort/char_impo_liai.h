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
    subroutine char_impo_liai(nomg, type_liai, cmp_nb, cmp_name, cmp_index,  &
                              vale_real, vale_cplx, vale_fonc)
        character(len=8), intent(in) :: nomg
        character(len=16), intent(in) :: type_liai
        character(len=8), intent(out) :: cmp_name(6)
        integer, intent(out) :: cmp_index(6)
        integer, intent(out) :: cmp_nb
        real(kind=8), intent(out) :: vale_real
        character(len=8), intent(out) :: vale_fonc
        complex(kind=8), intent(out):: vale_cplx
    end subroutine char_impo_liai
end interface
