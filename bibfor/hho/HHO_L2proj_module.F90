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
module HHO_L2proj_module
!
use HHO_rhs_module
use HHO_massmat_module
use HHO_quadrature_module
use HHO_type
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/utmess.h"
#include "blas/dposv.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Module to compute L2 prjoection
!
! --------------------------------------------------------------------------------------------------
    public :: hhoL2ProjFaceScal, hhoL2ProjFaceVec
    public :: hhoL2ProjCellScal, hhoL2ProjCellVec, hhoL2ProjCellMat
!    private  ::
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoL2ProjFaceScal(hhoFace, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
    implicit none
!
        type(HHO_Face), intent(in)          :: hhoFace
        type(HHO_Quadrature), intent(in)    :: hhoQuad
        real(kind=8), intent(in)            :: FuncValuesQP(MAX_QP_FACE)
        integer, intent(in)                 :: degree
        real(kind=8), intent(out)           :: coeff_L2Proj(MSIZE_FACE_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the L2-prjoection of a scalar given function on P^k(F,R)
!   In hhoFace      : the current HHO Face
!   In hhoQuad      : Quadrature for the face
!   In FuncValuesQP : Values of the function to project at the quadrature points
!   In degree       : degree of the projection k
!   Out coeff_L2Proj: coefficient after projection
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: faceMass(MSIZE_FACE_SCAL, MSIZE_FACE_SCAL)
        integer :: info = 0, mbs
! --------------------------------------------------------------------------------------------------
!
        if(2 * degree > hhoQuad%order) then
            call utmess('F', 'HHO1_12')
        end if
!
! ----- Compute face mass matrix
!
        call hhoMassMatFaceScal(hhoFace, 0, degree, faceMass, mbs)
!
! ---- Compute rhs
!
        call hhoMakeRhsFaceScal(hhoFace, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
! ---- Solve the system
!
        call dposv('U', mbs, 1, faceMass, MSIZE_FACE_SCAL, coeff_L2Proj, MSIZE_FACE_SCAL, info)
!
! ---- Sucess ?
!
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoL2ProjFaceVec(hhoFace, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
    implicit none
!
        type(HHO_Face), intent(in)          :: hhoFace
        type(HHO_Quadrature), intent(in)    :: hhoQuad
        real(kind=8), intent(in)            :: FuncValuesQP(3, MAX_QP_FACE)
        integer, intent(in)                 :: degree
        real(kind=8), intent(out)           :: coeff_L2Proj(MSIZE_FACE_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the L2-prjoection of a vectorial given function on P^k(F;R^d)
!   In hhoFace      : the current HHO Face
!   In hhoQuad      : Quadrature for the face
!   In FuncValuesQP : Values of the function to project at the quadrature points
!   In degree       : degree of the projection k
!   Out coeff_L2Proj: coefficient after projection
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: faceMass(MSIZE_FACE_SCAL, MSIZE_FACE_SCAL)
        integer :: info = 0, mbs
!
! --------------------------------------------------------------------------------------------------
!
        if(2 * degree > hhoQuad%order) then
            call utmess('F', 'HHO1_12')
        end if
!
! ----- Compute face mass matrix
!
        call hhoMassMatFaceScal(hhoFace, 0, degree, faceMass, mbs)
!
! ---- Compute rhs
!
        call hhoMakeRhsFaceVec(hhoFace, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
! ---- Solve the system
!
        call dposv('U', mbs, hhoFace%ndim + 1, faceMass, MSIZE_FACE_SCAL, coeff_L2Proj, mbs, info)
!
! ---- Sucess ?
!
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoL2ProjCellScal(hhoCell, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Quadrature), intent(in)    :: hhoQuad
        real(kind=8), intent(in)            :: FuncValuesQP(MAX_QP_CELL)
        integer, intent(in)                 :: degree
        real(kind=8), intent(out)           :: coeff_L2Proj(MSIZE_CELL_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the L2-prjoection of a scalar given function on a cell
!   In hhoCell      : the current HHO Cell
!   In hhoQuad      : Quadrature for the Cell
!   In FuncValuesQP : Values of the function to project at the quadrature points
!   In degree       : degree of the projection k
!   Out coeff_L2Proj: coefficient after projection
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: cellMass(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL)
        integer :: info = 0, mbs
! --------------------------------------------------------------------------------------------------
!
        if(2 * degree > hhoQuad%order) then
            call utmess('F', 'HHO1_12')
        end if
!
! ----- Compute Cell mass matrix
!
        call hhoMassMatCellScal(hhoCell, 0, degree, cellMass, mbs)
!
! ---- Compute rhs
!
        call hhoMakeRhsCellScal(hhoCell, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
! ---- Solve the system
!
        call dposv('U', mbs, 1, cellMass, MSIZE_CELL_SCAL, coeff_L2Proj, MSIZE_CELL_SCAL, info)
!
! ---- Sucess ?
!
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoL2ProjCellVec(hhoCell, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Quadrature), intent(in)    :: hhoQuad
        real(kind=8), intent(in)            :: FuncValuesQP(3, MAX_QP_CELL)
        integer, intent(in)                 :: degree
        real(kind=8), intent(out)           :: coeff_L2Proj(MSIZE_CELL_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the L2-prjoection of a vectorial given function on a cell
!   In hhoCell      : the current HHO Cell
!   In hhoQuad      : Quadrature for the cace
!   In FuncValuesQP : Values of the function to project at the quadrature points
!   In degree       : degree of the projection k
!   Out coeff_L2Proj: coefficient after projection
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: cellMass(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL)
        integer :: info = 0, mbs
!
! --------------------------------------------------------------------------------------------------
!
        if(2 * degree > hhoQuad%order) then
            call utmess('F', 'HHO1_12')
        end if
!
! ----- Compute cell mass matrix
!
        call hhoMassMatCellScal(hhoCell, 0, degree, cellMass, mbs)
!
! ---- Compute rhs
!
        call hhoMakeRhsCellVec(hhoCell, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
! ---- Solve the system
!
        call dposv('U', mbs, hhoCell%ndim, cellMass, MSIZE_CELL_SCAL, coeff_L2Proj, mbs, info)
!
! ---- Sucess ?
!
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoL2ProjCellMat(hhoCell, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Quadrature), intent(in)    :: hhoQuad
        real(kind=8), intent(in)            :: FuncValuesQP(3, 3, MAX_QP_CELL)
        integer, intent(in)                 :: degree
        real(kind=8), intent(out)           :: coeff_L2Proj(MSIZE_CELL_MAT)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the L2-prjoection of a matricial given function on a cell
!   In hhoCell      : the current HHO Cell
!   In hhoQuad      : Quadrature for the cace
!   In FuncValuesQP : Values of the function to project at the quadrature points
!   In degree       : degree of the projection k
!   Out coeff_L2Proj: coefficient after projection
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: cellMass(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL)
        integer :: info = 0, ndim2, mbs
!
! --------------------------------------------------------------------------------------------------
!
        if(2 * degree > hhoQuad%order) then
            call utmess('F', 'HHO1_12')
        end if
!
! ----- Compute cell mass matrix
!
        call hhoMassMatCellScal(hhoCell, 0, degree, cellMass, mbs)
!
! ---- Compute rhs
!
        call hhoMakeRhsCellMat(hhoCell, hhoQuad, FuncValuesQP, degree, coeff_L2Proj)
!
! ---- Solve the system
!
        ndim2 = hhoCell%ndim * hhoCell%ndim
        call dposv('U', mbs, ndim2, cellMass, MSIZE_CELL_SCAL, coeff_L2Proj, mbs, info)
!
! ---- Sucess ?
!
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
    end subroutine
!
end module
