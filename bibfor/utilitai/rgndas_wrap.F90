! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rgndas_wrap(nume_ddlz, i_equa, type_equaz, name_nodez,&
                  name_cmpz, ligrelz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/rgndas.h"
!
character(len=*), intent(in) :: nume_ddlz
integer, intent(in) :: i_equa
character(len=1), intent(out) :: type_equaz
character(len=*), intent(out) :: name_nodez
character(len=*), intent(out) :: name_cmpz
character(len=*), intent(out) :: ligrelz
!
! --------------------------------------------------------------------------------------------------
!
! Get and/or print information about dof (node, component, etc.)
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_ddl      : name of numbering (NUME_DDL)
! In  i_equa        : index of equation
! Out type_equa      : type of dof
!                 / 'A' : physical dof (node+component)
!                 / 'B' : Lagrange dof (boundary condition) simple given boundary condition
!                 / 'C' : Lagrange dof (boundary condition) linear relation
!                 / 'D' : generalized dof - Substructuring
!                 / 'E' : generalized dof - Links
! Out name_node      : name of the node
! Out name_cmp       : name of the component
! Out ligrel         : name of LIGREL for non-physical node (Lagrange)
!
! --------------------------------------------------------------------------------------------------
!
    call rgndas(nume_ddlz, i_equa , .false., type_equaz=type_equaz, &
                    name_nodez=name_nodez, name_cmpz=name_cmpz, ligrelz=ligrelz)
!
end subroutine
