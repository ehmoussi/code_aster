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
    subroutine posddl(typesd  , resu, node_name, cmp_name, node_nume,&
                      dof_nume)
        character(len=*), intent(in) :: typesd
        character(len=*), intent(in) :: resu
        character(len=*), intent(in) :: node_name
        character(len=*), intent(in) :: cmp_name
        integer, intent(out) :: node_nume
        integer, intent(out) :: dof_nume
    end subroutine posddl
end interface
