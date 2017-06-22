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
            subroutine numero(nume_ddlz,base,old_nume_ddlz,modelocz, &
      modelz,list_loadz,nb_matr_elem,list_matr_elem,sd_iden_relaz)
              character(len=*), intent(inout) :: nume_ddlz
              character(len=2), intent(in) :: base
              character(len=*) ,optional, intent(in) :: old_nume_ddlz
              character(len=*) ,optional, intent(in) :: modelocz
              character(len=*) ,optional, intent(in) :: modelz
              character(len=*) ,optional, intent(in) :: list_loadz
              integer ,optional, intent(in) :: nb_matr_elem
              character(len=24) ,optional, intent(in) :: list_matr_elem(*)
              character(len=*) ,optional, intent(in) :: sd_iden_relaz
            end subroutine numero
          end interface 
