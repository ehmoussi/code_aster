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

subroutine aptypm(mesh     , elem_nume, elem_ndim, elem_nbnode, elem_type,&
                  elem_name)
!
implicit none
!
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/mmtypm.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: elem_nume
    integer, intent(out) :: elem_ndim
    integer, intent(in) :: elem_nbnode
    character(len=8), intent(out) :: elem_type
    character(len=8), intent(out) :: elem_name
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Get parameters for current element
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  elem_nume        : index of element in mesh datastructure
! Out elem_ndim        : dimension of element
! In  elem_nbnode      : number of nodes of element
! Out elem_type        : type of element
! Out elem_name        : name of element
!
! --------------------------------------------------------------------------------------------------
!
    call mmtypm(mesh, elem_nume, elem_nbnode, elem_type, elem_ndim)
    call jenuno(jexnum(mesh//'.NOMMAI', elem_nume), elem_name)
!
end subroutine
