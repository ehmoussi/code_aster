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
module HHO_tracemat_module
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
#include "blas/dger.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Module to compute trace matrix
!
! --------------------------------------------------------------------------------------------------
    public   :: hhoTraceMatScal
!    private  ::
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoTraceMatScal(hhoCell, min_order_cell, max_order_cell, &
                                & hhoFace, min_order_face, max_order_face, traceMat)
!
    implicit none
!
        type(HHO_Cell), intent(in) :: hhoCell
        integer, intent(in)        :: min_order_cell
        integer, intent(in)        :: max_order_cell
        type(HHO_Face), intent(in) :: hhoFace
        integer, intent(in)        :: min_order_face
        integer, intent(in)        :: max_order_face
        real(kind=8), intent(out)  :: traceMat(MSIZE_FACE_SCAL,MSIZE_CELL_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the scalar trace matrix of a Cell and a associated Face form order
!     "min_order" to order "max_order"
!   In hhoCell     : the current HHO Cell
!   In min_order   : minimum order to evaluate cell
!   In max_order   : maximum order to evaluate cell
!   In hhoFace     : the current HHO Face
!   In min_order   : minimum order to evaluate face
!   In max_order   : maximum order to evaluate face
!   Out traceMat   : trace matrix
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_basis_face) :: hhoBasisFace
        type(HHO_quadrature)  :: hhoQuad
        real(kind=8) :: BSCellEval(MSIZE_CELL_SCAL), BSFaceEval(MSIZE_FACE_SCAL)
        integer :: rowsMat, colsMat, ipg, ndim
!
        ndim = hhoCell%ndim
! ----- init basis
        call hhoBasisCell%initialize(hhoCell)
        call hhoBasisFace%initialize(hhoFace)
! ----- dimension of traceMat
        colsMat = hhoBasisCell%BSSize(min_order_cell, max_order_cell)
        rowsMat = hhoBasisFace%BSSize(min_order_face, max_order_face)
!
        traceMat = 0.d0
!
! ----- get quadrature
        call hhoQuad%GetQuadFace(hhoFace, max_order_cell + max_order_face)
!
! ----- Loop on quadrature point
        do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval cell basis function at the quadrature point
            call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), &
                                    & min_order_cell, max_order_cell, BSCellEval)
! --------- Eval face basis function at the quadrature point
            call hhoBasisFace%BSEval(hhoFace, hhoQuad%points(1:3,ipg), &
                                    & min_order_face, max_order_face, BSFaceEval)
! --------  Eval traceMat
            call dger(rowsMat, colsMat, hhoQuad%weights(ipg), BSFaceEval, 1, BSCellEval, 1, &
                    & traceMat, MSIZE_FACE_SCAL)
        end do
!
!        call hhoPrintMat(traceMat)
!
    end subroutine
!
end module
