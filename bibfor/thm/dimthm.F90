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
subroutine dimthm(ndlno, ndlnm, ndim)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/lteatt.h"
!
!
    integer, intent(in)  :: ndim
    integer, intent(out) :: ndlno
    integer, intent(out) :: ndlnm
!
! --------------------------------------------------------------------------------------------------
!
! THM - Initializations
!
! Get number of dof on boundary
!
! --------------------------------------------------------------------------------------------------
!
!     NDDLNO NOMBRE DE DDL DES NOEUDS EXTREMITE DE SEGMENTS
!     NDDLM  NOMBRE DE DDL DES NOEUDS MILIEU DE SEGMENTS OU FACE
!
! --------------------------------------------------------------------------------------------------
!
    ndlno = 0
    ndlnm = 0
    if (lteatt('TYPMOD3','SUSHI')) then
        ndlnm = 2
    else
        if (ds_thm%ds_elem%l_dof_meca) then
            ndlnm = ndim
        endif
    endif
!
    if (lteatt('TYPMOD3','SUSHI')) then
        ndlno = 0
    else
        if (ds_thm%ds_elem%l_dof_meca) then
            ndlno = ndim
        endif
        if (ds_thm%ds_elem%l_dof_ther) then
            ndlno = ndlno + 1
        endif
        if (ds_thm%ds_elem%l_dof_pre1) then
            ndlno = ndlno + 1
        endif
        if (ds_thm%ds_elem%l_dof_pre2) then
            ndlno = ndlno + 1
        endif
    endif
!
end subroutine
