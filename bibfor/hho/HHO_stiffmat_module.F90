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
! person_in_charge: mickael.abbas at edf.fr
!
module HHO_stiffmat_module
!
use HHO_type
use HHO_quadrature_module
use HHO_basis_module
use HHO_utils_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/HHO_size_module.h"
#include "blas/dsyrk.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Module to compute stiffness matrix
!
! --------------------------------------------------------------------------------------------------
    public  :: hhoStiffMatCellScal, hhoSymStiffMatCellVec
!    private  ::
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoStiffMatCellScal(hhoCell, min_order, max_order, stiffMat)
!
!
    implicit none
!
        type(HHO_Cell), intent(in) :: hhoCell
        integer, intent(in)        :: min_order
        integer, intent(in)        :: max_order
        real(kind=8), intent(out)  :: stiffMat(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL)
!
!
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the scalar stiffness matrix of a Cell form order "min_order" to order "max_order"
!   In hhoCell     : the current HHO Cell
!   In min_order   : minimum order to evaluate
!   In max_order   : maximum order to evaluate
!   Out stiffMat    : stiffness matrix
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_quadrature)  :: hhoQuad
        real(kind=8), dimension(3,MSIZE_CELL_SCAL) :: BSGradEval
        integer :: dimMat, ipg, ndim
!
        ndim = hhoCell%ndim
! ----- init basis
        call hhoBasisCell%initialize(hhoCell)
! ----- dimension of stiffMat
        dimMat = hhoBasisCell%BSSize(min_order, max_order)
        stiffMat = 0.d0
!
! ----- get quadrature: derivative polynome of degree max_order-1
        call hhoQuad%GetQuadCell(hhoCell, 2 * (max_order-1))
!
! ----- Loop on quadrature point
        do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval bais function at the quadrature point
            call hhoBasisCell%BSEvalGrad(hhoCell, hhoQuad%points(1:3,ipg), &
                                        & min_order, max_order, BSGradEval)
!
! --------  Eval stiffMat
            call dsyrk('U', 'T', dimMat, ndim, hhoQuad%weights(ipg), BSGradEval, 3, &
                        & 1.d0, stiffMat, MSIZE_CELL_SCAL)
        end do
!
! ----- Copy the lower part
!
        call hhoCopySymPartMat('U', stiffMat(1:dimMat, 1:dimMat))
!    call hhoPrintMat(stiffMat)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoSymStiffMatCellVec(hhoCell, min_order, max_order, stiffMat)
!
    implicit none
!
        type(HHO_Cell), intent(in) :: hhoCell
        integer, intent(in)        :: min_order
        integer, intent(in)        :: max_order
        real(kind=8), intent(out)  :: stiffMat(MSIZE_CELL_VEC, MSIZE_CELL_VEC)
!
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the symmetric stiffness matrix of a vectoriel Cell
!   form order "min_order" to order "max_order"
!   In hhoCell     : the current HHO Cell
!   In min_order   : minimum order to evaluate
!   In max_order   : maximum order to evaluate
!   Out stiffMat    : symmetric stiffness matrix
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_quadrature)  :: hhoQuad
        real(kind=8), dimension(6,MSIZE_CELL_VEC) :: BVGradEval
        integer :: dimMat, ipg
!
! ----- init basis
        call hhoBasisCell%initialize(hhoCell)
! ----- dimension of stiffMat
        dimMat = hhoBasisCell%BVSize(min_order, max_order)
        stiffMat = 0.d0
!
! ----- get quadrature: derivative polynome of degree max_order-1
        call hhoQuad%GetQuadCell(hhoCell, 2 * (max_order-1))
!
! ----- Loop on quadrature point
        do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval basis function at the quadrature point
            call hhoBasisCell%BVEvalSymGrad(hhoCell, hhoQuad%points(1:3,ipg), &
                                            & min_order, max_order, BVGradEval)
!
! --------  Eval stiffMat
            call dsyrk('U', 'T', dimMat, 6, hhoQuad%weights(ipg), BVGradEval, 6, &
                        & 1.d0, stiffMat, MSIZE_CELL_VEC)
        end do
!
! ----- Copy the lower part
!
        call hhoCopySymPartMat('U', stiffMat(1:dimMat, 1:dimMat))
!
    end subroutine
!
end module
