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

subroutine te0460(nomopt, nomte)
!
use HHO_type
use HHO_size_module
use HHO_stabilization_module, only : hhoStabScal, hdgStabScal
use HHO_gradrec_module, only : hhoGradRecVec, hhoGradRecFullVec
use HHO_Meca_module, only : hhoCalcOpMeca, isLargeStrain
use HHO_init_module, only : hhoInfoInitCell
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "blas/dcopy.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!  HHO
!  Mechanics - Precomputation of operators (except for PETIT in 3D)
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
! --------------------------------------------------------------------------------------------------
    character(len=16) :: nomte, nomopt
!
! --- Local variables
!
    integer :: cbs, fbs, total_dofs, gbs, gbs_sym, gbs2
    integer :: j, jgrad, jstab, jcompo
    aster_logical :: l_largestrains
    type(HHO_Data) :: hhoData
    type(HHO_Cell) :: hhoCell
    real(kind=8), dimension(MSIZE_CELL_MAT, MSIZE_TDOFS_VEC)   :: gradfull
    real(kind=8), dimension(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC)  :: stab
    real(kind=8), dimension(MSIZE_CELL_VEC, MSIZE_TDOFS_SCAL)  :: gradfullvec
    real(kind=8), dimension(MSIZE_TDOFS_SCAL, MSIZE_TDOFS_SCAL):: stabvec
    real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_TDOFS_SCAL) :: gradrec_scal
!
    ASSERT(nomopt == 'HHO_PRECALC_MECA')
!
! --- Retrieve HHO informations
!
    call hhoInfoInitCell(hhoCell, hhoData)
!
! -- Number of dofs
!
    call hhoMecaNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs, gbs_sym)
    ASSERT(cbs <= MSIZE_CELL_VEC)
    ASSERT(fbs <= MSIZE_FACE_VEC)
    ASSERT(total_dofs <= MSIZE_TDOFS_VEC)
!
! -- Get ouput field
!
    call jevech('PCHHOGT', 'E', jgrad)
    call jevech('PCHHOST', 'E', jstab)
!
! -- Large strains ?
!
    call jevech('PCOMPOR', 'L', jcompo)
    l_largestrains = isLargeStrain(zk16(jcompo-1+DEFO))
!
    if(hhoCell%ndim == 2) then
!
! ---- if ndim = 2, we save the full operator
!
! ----- Compute Gradient reconstruction
!
        call hhoCalcOpMeca(hhoCell, hhoData, l_largestrains, gradfull, stab)
!
! ----- Save
!
        if(l_largestrains) then
            gbs2 = gbs
        else
            gbs2 = gbs_sym
        endif
!
! -- Copy the results
!
        do j = 1, total_dofs
            call dcopy(gbs2, gradfull(1,j), 1, zr(jgrad + (j-1) * gbs2), 1)
            call dcopy(total_dofs, stab(1,j), 1, zr(jstab + (j-1) * total_dofs), 1)
        end do
!
    elseif(hhoCell%ndim == 3) then
!
! ---- if ndim = 3, we save the scalar operator for large_strain (not for small strains)
! ---- because the matrix are too big to be save
!
        if(l_largestrains) then
! ----- Compute vectoriel Gradient reconstruction
            call hhoGradRecFullVec(hhoCell, hhoData, gradfullvec)
!
! ----- Compute Stabilizatiion
!
            if (hhoData%cell_degree() <= hhoData%face_degree()) then
                call hhoGradRecVec(hhoCell, hhoData, gradrec_scal)
                call hhoStabScal(hhoCell, hhoData, gradrec_scal, stabvec)
            else if (hhoData%cell_degree() == (hhoData%face_degree() + 1)) then
                call hdgStabScal(hhoCell, hhoData, stabvec)
            else
                    ASSERT(ASTER_FALSE)
            end if
!
            call hhoTherNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs2)
! -- Copy the results
            do j = 1, total_dofs
                call dcopy(gbs2, gradfullvec(1,j), 1, zr(jgrad + (j-1) * gbs2), 1)
                call dcopy(total_dofs, stabvec(1,j), 1, zr(jstab + (j-1) * total_dofs), 1)
            end do
        end if
    else
        ASSERT(ASTER_FALSE)
    end if
!
end subroutine
