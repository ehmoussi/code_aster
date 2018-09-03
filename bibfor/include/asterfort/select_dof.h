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
    subroutine select_dof(list_equa, tabl_equa , list_idx_dof,&
                          nume_ddlz, chamnoz   ,&
                          nb_nodez , list_nodez,&
                          nb_cmpz  , list_cmpz)
        integer, pointer, optional :: list_equa(:)
        integer, pointer, optional :: tabl_equa(:,:)
        integer, pointer, optional :: list_idx_dof(:)
        character(len=*), optional, intent(in) :: nume_ddlz
        character(len=*), optional, intent(in) :: chamnoz
        integer, optional, intent(in) :: nb_nodez
        integer, pointer, optional :: list_nodez(:)
        integer, optional, intent(in) :: nb_cmpz
        character(len=8), pointer, optional :: list_cmpz(:)
    end subroutine select_dof
end interface
