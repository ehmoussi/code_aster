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
module HHO_massmat_module
!
use HHO_basis_module
use HHO_quadrature_module
use HHO_type
use HHO_utils_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/HHO_size_module.h"
#include "blas/dsyr.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Module to compute mass matrix
!
! --------------------------------------------------------------------------------------------------
    public   :: hhoMassMatCellScal, hhoMassMatFaceScal
!    private  ::
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMassMatCellScal(hhoCell, min_order, max_order, massMat, mbs)
!
    implicit none
!
        type(HHO_Cell), intent(in) :: hhoCell
        integer, intent(in)        :: min_order
        integer, intent(in)        :: max_order
        real(kind=8), intent(out)  :: massMat(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL)
        integer, intent(out), optional :: mbs
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the scalar mass matrix of a Cell form order "min_order" to order "max_order"
!   In hhoCell     : the current HHO Cell
!   In min_order   : minimum order to evaluate
!   In max_order   : maximum order to evaluate
!   Out massMat    : mass matrix
!   Out, Opt mbs   : number of rows of the mass matrix
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_quadrature)  :: hhoQuad
        real(kind=8), dimension(MSIZE_CELL_SCAL):: basisScalEval
        integer :: dimMat = 0, ipg, ndim = 0
! --------------------------------------------------------------------------------------------------
!
        ndim = hhoCell%ndim
! ----- init basis
        call hhoBasisCell%initialize(hhoCell)
! ----- dimension of massMat
        dimMat = hhoBasisCell%BSSize(min_order, max_order)
        massMat = 0.d0
!
! ----- get quadrature
        call hhoQuad%GetQuadCell(hhoCell, 2 * max_order)
!
! ----- Loop on quadrature point
        do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval bais function at the quadrature point
            call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), min_order,max_order,&
                              & basisScalEval)
! --------  Eval massMat
            call dsyr('U', dimMat, hhoQuad%weights(ipg), basisScalEval, 1, massMat, MSIZE_CELL_SCAL)
        end do
!
! ----- Copy the lower part
!
        call hhoCopySymPartMat('U', massMat(1:dimMat, 1:dimMat))
!        call hhoPrintMat(massMat)
!
        if(present(mbs)) then
            mbs = dimMat
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMassMatFaceScal(hhoFace, min_order, max_order, massMat, mbs)
!
    implicit none
!
        type(HHO_Face), intent(in) :: hhoFace
        integer, intent(in)        :: min_order
        integer, intent(in)        :: max_order
        real(kind=8), intent(out)  :: massMat(MSIZE_FACE_SCAL, MSIZE_FACE_SCAL)
        integer, intent(out), optional :: mbs
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the scalar mass matrix of a Face form order "min_order" to order "max_order"
!   In hhoFace     : the current HHO Face
!   In min_order   : minimum order to evaluate
!   In max_order   : maximum order to evaluate
!   Out massMat    : mass matrix
!   Out, Opt mbs   : number of rows of the mass matrix
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_face) :: hhoBasisFace
        type(HHO_quadrature)  :: hhoQuad
        real(kind=8), dimension(MSIZE_FACE_SCAL) :: basisScalEval
        integer :: dimMat = 0, ipg, ndim = 0
! --------------------------------------------------------------------------------------------------
!
        ndim = hhoFace%ndim
! ----- init basis
        call hhoBasisFace%initialize(hhoFace)
! ----- dimension of massMat
        dimMat = hhoBasisFace%BSSize(min_order, max_order)
        massMat = 0.d0
!
! ----- get quadrature
        call hhoQuad%GetQuadFace(hhoFace, 2 * max_order)
!
! ----- Loop on quadrature point
        do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval bais function at the quadrature point
            call hhoBasisFace%BSEval(hhoFace, hhoQuad%points(1:3,ipg), min_order, &
                                    & max_order, basisScalEval)
! --------  Eval massMat
            call dsyr('U', dimMat, hhoQuad%weights(ipg), basisScalEval, 1, massMat, MSIZE_FACE_SCAL)
        end do
!
! ----- Copy the lower part
!
        call hhoCopySymPartMat('U', massMat(1:dimMat, 1:dimMat))
!        call hhoPrintMat(massMat)
!
        if(present(mbs)) then
            mbs = dimMat
        end if
!
    end subroutine
!
end module
