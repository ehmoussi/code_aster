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
    subroutine char_beam_lcs(mesh, model, connex_inv, keywordfact, iocc, node_nume,&
                             node_name, cmp_name_loc, n_keyword, cmp_valr_loc, &
                             cmp_name_glo, cmp_acti_glo, cmp_valr_glo)
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        character(len=19), intent(in) :: connex_inv
        character(len=16), intent(in) :: keywordfact
        integer, intent(in) :: iocc
        integer, intent(in) :: node_nume
        integer, intent(in) :: n_keyword
        character(len=8), intent(in) :: node_name
        character(len=16), intent(in) :: cmp_name_loc(6)
        real(kind=8), intent(in) :: cmp_valr_loc(6)
        character(len=16), intent(out) :: cmp_name_glo(6)
        integer, intent(out) :: cmp_acti_glo(6)
        real(kind=8), intent(out) :: cmp_valr_glo(6)
    end subroutine char_beam_lcs
end interface
