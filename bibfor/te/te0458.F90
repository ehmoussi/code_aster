! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine te0458(nomopt, nomte)
!
use HHO_type
use HHO_size_module, only : hhoMecaDofs
use HHO_init_module, only : hhoInfoInitCell
use HHO_Dirichlet_module, only : hhoDiriReadNameFunc, hhoDiriMecaProjFunc, hhoDiriDeca
!
    implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jevecd.h"
#include "asterfort/jevech.h"
#include "asterfort/HHO_size_module.h"
#include "blas/dcopy.h"
!
! --------------------------------------------------------------------------------------------------
!  HHO - Mechanics
!  Option: AFFE_CHAR_CINE_F
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: nomte, nomopt
!
! -- Local variables

    type(HHO_Data) :: hhoData
    type(HHO_Cell) :: hhoCell
    real(kind=8) :: rhs_cine(MSIZE_FDOFS_VEC)
    integer :: j_func, j_vect, j_time, cbs, fbs, total_dofs, faces_dofs, nbnodes_deca, offset
    character(len=8) :: nomfunct(3,MAX_FACE)
!
    ASSERT(nomopt.eq.'HHO_CINE_F_MECA')
!
! --- Retrieve HHO informations
!
    call hhoInfoInitCell(hhoCell, hhoData)
!
! --- Read Name of function
!
    call jevech('PFONC', 'L', j_func)
    call hhoDiriReadNameFunc(hhoCell, zk8(j_func), nomfunct)
!
! -- Get current time
    call jevech('PINSTPR', 'L', j_time)
!
! --- Projection of the boundary conditions
!
    call hhoDiriMecaProjFunc(hhoCell, hhoData, nomfunct, zr(j_time), rhs_cine)
!
! -- Save
!
    nbnodes_deca = hhoDiriDeca()
    call jevech('PCINE', 'E', j_vect)
    call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
    faces_dofs = total_dofs - cbs
! -- We use this offset because we can't use DDL_MECA for the moment
    offset = (nbnodes_deca - 1) * fbs + 1
    call dcopy(faces_dofs, rhs_cine, 1, zr(j_vect-1+offset), 1)
!
end subroutine
