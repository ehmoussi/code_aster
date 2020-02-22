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
!
subroutine te0449(option, nomte)
!
use HHO_type
use HHO_size_module
use HHO_statcond_module, only : hhoCondStaticMeca
use HHO_init_module, only : hhoInfoInitCell
use HHO_Meca_module
use HHO_utils_module
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/tecach.h"
#include "asterfort/writeVector.h"
#include "asterfort/readVector.h"
#include "asterfort/readMatrix.h"
#include "asterfort/writeMatrix.h"
#include "blas/dscal.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: HHO
!
! Options: COND_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    type(HHO_Data) :: hhoData
    type(HHO_Cell) :: hhoCell
    integer :: cbs, fbs, total_dofs, faces_dofs, iret, iad
    real(kind=8) :: rhs(MSIZE_TDOFS_VEC), rhs_loc(MSIZE_FDOFS_VEC)
    real(kind=8), dimension(MSIZE_FDOFS_VEC, MSIZE_FDOFS_VEC)  :: lhs_loc
    real(kind=8), dimension(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC)  :: lhs
    aster_logical :: l_lhs_sym
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(option == 'HHO_COND_MECA')
!
    l_lhs_sym = ASTER_TRUE
    lhs = 0.d0
    rhs = 0.d0
!
! - Get HHO informations
!
    call hhoInfoInitCell(hhoCell, hhoData, l_ortho_ = ASTER_FALSE)
!
! - Number of dofs
!
    call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
    ASSERT(total_dofs <= MSIZE_TDOFS_VEC)
!
! - Get the rhs vector
!
    call readVector('PVEELE1', total_dofs, rhs)
!
! - Get the lhs matrix
!
    call tecach('ONO', 'PMAELS1', 'L', iret, iad=iad)
    if (iret .eq. 0) then
        l_lhs_sym = ASTER_TRUE
        call readMatrix('PMAELS1', total_dofs, total_dofs, l_lhs_sym, lhs)
    else
        call tecach('ONO', 'PMAELNS1', 'L', iret, iad=iad)
        if (iret .eq. 0) then
            l_lhs_sym = ASTER_FALSE
            call readMatrix('PMAELNS1', total_dofs, total_dofs, l_lhs_sym, lhs)
        else
            ASSERT(ASTER_FALSE)
        end if
    endif
!
! - Static condensation
!
    call hhoCondStaticMeca(hhoCell, hhoData, lhs, rhs, l_lhs_sym, lhs_loc, rhs_loc)
!
! - Copy data
! - !!! we have to save the opposite of the residu (the minus is add during the assembling)
!
    faces_dofs = total_dofs - cbs
    call dscal(faces_dofs, -1.d0, rhs_loc, 1)
!
! - Copy of rhs_loc in PVECTUR ('OUT' to fill)
!
    call writeVector('PVECTUR', faces_dofs, rhs_loc)
!
! - Copy of lhs_loc ('OUT' to fill)
!
    if(l_lhs_sym) then
        call writeMatrix('PMATUUR', faces_dofs, faces_dofs, l_lhs_sym, lhs_loc)
    else
        call writeMatrix('PMATUNS', faces_dofs, faces_dofs, l_lhs_sym, lhs_loc)
    end if
!
end subroutine
