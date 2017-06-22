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
    subroutine rccome(nommat, pheno, icodre, iarret, k11_ind_nomrc)
        character(len=*), intent(in) :: nommat
        character(len=*), intent(in) :: pheno
        integer, intent(out) :: icodre
        integer, intent(in), optional :: iarret
        character(len=11), intent(out), optional :: k11_ind_nomrc
    end subroutine rccome
end interface
