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
module HHO_eval_module
!
use HHO_type
use HHO_basis_module
use HHO_quadrature_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/fointe.h"
#include "asterfort/HHO_size_module.h"
#include "blas/ddot.h"
#include "blas/dscal.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Evalutaion
!
! Some common utilitaries to evalutaion HHO fonction
!
! --------------------------------------------------------------------------------------------------
    public :: hhoEvalScalCell, hhoEvalScalFace, hhoEvalVecCell, hhoEvalVecFace
    public :: hhoEvalMatCell, hhoEvalSymMatCell
    public :: hhoFuncFScalEvalQp, hhoFuncRScalEvalQp, hhoFuncRVecEvalQp, hhoFuncRVecEvalCellQp
!    private  ::
!
contains
!
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoEvalScalCell(hhoCell, hhoBasisCell, order, pt, coeff, size_coeff) result(eval)
!
    implicit none
!
        type(HHO_Cell), intent(in)                  :: hhoCell
        type(HHO_basis_cell), intent(inout)         :: hhoBasisCell
        integer, intent(in)                         :: order
        real(kind=8), dimension(3), intent(in)      :: pt
        real(kind=8), dimension(:), intent(in)      :: coeff
        integer, intent(in)                         :: size_coeff
        real(kind=8)                                :: eval
!
! --------------------------------------------------------------------------------------------------
!
!   evaluate a scalar function at a point pt
!   In hhoCell      : a HHo cell
!   In hhoBasisCell : basis cell
!   In Order        : polynomial order of the function
!   In pt           : point where evaluate
!   In coeff        : polynomial coefficient of the function
!   In size_coeff   : number of coefficient
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_CELL_SCAL) :: BSCEval
!
        eval = 0.d0
!
! --- Evaluate basis function at pt
        call hhoBasisCell%BSEval(hhoCell, pt, 0, order, BSCEval)
!
        eval = ddot(size_coeff, coeff, 1, BSCEval, 1)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoEvalScalFace(hhoFace, hhoBasisFace, order, pt, coeff, size_coeff) result(eval)
!
    implicit none
!
        type(HHO_Face), intent(in)                  :: hhoFace
        type(HHO_basis_face), intent(inout)         :: hhoBasisFace
        integer, intent(in)                         :: order
        real(kind=8), dimension(3), intent(in)      :: pt
        real(kind=8), dimension(:), intent(in)      :: coeff
        integer, intent(in)                         :: size_coeff
        real(kind=8)                                :: eval
!
! --------------------------------------------------------------------------------------------------
!
!   evaluate a scalar at a point pt
!   In hhoFace      : a HHo Face
!   In hhoBasisFace : basis Face
!   In Order        : polynomial order of the function
!   In pt           : point where evaluate
!   In coeff        : polynomial coefficient of the function
!   In size_coeff   : number of coefficient
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_FACE_SCAL) :: BSFEval
!
        eval = 0.d0
!
! --- Evaluate basis function at pt
        call hhoBasisFace%BSEval(hhoFace, pt, 0, order, BSFEval)
!
        eval = ddot(size_coeff, coeff, 1, BSFEval, 1)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoEvalVecCell(hhoCell, hhoBasisCell, order, pt, coeff, size_coeff) result(eval)
!
    implicit none
!
        type(HHO_Cell), intent(in)                  :: hhoCell
        type(HHO_basis_cell), intent(inout)         :: hhoBasisCell
        integer, intent(in)                         :: order
        real(kind=8), dimension(3), intent(in)      :: pt
        real(kind=8), dimension(:), intent(in)      :: coeff
        integer, intent(in)                         :: size_coeff
        real(kind=8)                                :: eval(3)
!
! --------------------------------------------------------------------------------------------------
!
!   evaluate a vector at a point pt
!   In hhoCell      : a HHo cell
!   In hhoBasisCell : basis cell
!   In Order        : polynomial order of the function
!   In pt           : point where evaluate
!   In coeff        : polynomial coefficient of the function
!   In size_coeff   : number of coefficient
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_CELL_SCAL) :: BSCEval
        integer :: i, size_cmp, deca
!
        eval = 0.d0
        size_cmp = size_coeff / hhoCell%ndim
!
! --- Evaluate basis function at pt
        call hhoBasisCell%BSEval(hhoCell, pt, 0, order, BSCEval)
!
        deca = 0
        do i = 1, hhoCell%ndim
            eval(i) = ddot(size_cmp, coeff(deca+1: deca+size_cmp), 1, BSCEval, 1)
            deca = deca + size_cmp
        end do
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoEvalVecFace(hhoFace, hhoBasisFace, order, pt, coeff, size_coeff) result(eval)
!
    implicit none
!
        type(HHO_Face), intent(in)                  :: hhoFace
        type(HHO_basis_face), intent(inout)         :: hhoBasisFace
        integer, intent(in)                         :: order
        real(kind=8), dimension(3), intent(in)      :: pt
        real(kind=8), dimension(:), intent(in)      :: coeff
        integer, intent(in)                         :: size_coeff
        real(kind=8)                                :: eval(3)
!
! --------------------------------------------------------------------------------------------------
!
!   evaluate a vector at a point pt
!   In hhoFace      : a HHo Face
!   In hhoBasisFace : basis Face
!   In Order        : polynomial order of the function
!   In pt           : point where evaluate
!   In coeff        : polynomial coefficient of the function
!   In size_coeff   : number of coefficient
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_FACE_SCAL) :: BSFEval
        integer :: i, size_cmp, deca
!
        eval = 0.d0
        size_cmp = size_coeff / (hhoFace%ndim + 1)
!
! --- Evaluate basis function at pt
        call hhoBasisFace%BSEval(hhoFace, pt, 0, order, BSFEval)
!
        deca = 0
        do i = 1, (hhoFace%ndim + 1)
            eval(i) = ddot(size_cmp, coeff(deca+1: deca+size_cmp), 1, BSFEval, 1)
            deca = deca + size_cmp
        end do
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoEvalMatCell(hhoCell, hhoBasisCell, order, pt, coeff, size_coeff) result(eval)
!
    implicit none
!
        type(HHO_Cell), intent(in)                  :: hhoCell
        type(HHO_basis_cell), intent(inout)         :: hhoBasisCell
        integer, intent(in)                         :: order
        real(kind=8), dimension(3), intent(in)      :: pt
        real(kind=8), dimension(:), intent(in)      :: coeff
        integer, intent(in)                         :: size_coeff
        real(kind=8)                                :: eval(3,3)
!
! --------------------------------------------------------------------------------------------------
!
!   evaluate a matrix at a point pt
!   In hhoCell      : a HHo cell
!   In hhoBasisCell : basis cell
!   In Order        : polynomial order of the function
!   In pt           : point where evaluate
!   In coeff        : polynomial coefficient of the function
!   In size_coeff   : number of coefficient
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_CELL_SCAL) :: BSCEval
        integer :: i, j, size_cmp, deca
!
        eval = 0.d0
        size_cmp = size_coeff / (hhoCell%ndim * hhoCell%ndim)
!
! --- Evaluate basis function at pt
        call hhoBasisCell%BSEval(hhoCell, pt, 0, order, BSCEval)
!
        deca = 0
        do i = 1, hhoCell%ndim
            do j = 1, hhoCell%ndim
                eval(i,j) = ddot(size_cmp, coeff(deca+1: deca+size_cmp), 1, BSCEval, 1)
                deca = deca + size_cmp
            end do
        end do
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoEvalSymMatCell(hhoCell, hhoBasisCell, order, pt, coeff, size_coeff) result(eval)
!
    implicit none
!
        type(HHO_Cell), intent(in)                  :: hhoCell
        type(HHO_basis_cell), intent(inout)         :: hhoBasisCell
        integer, intent(in)                         :: order
        real(kind=8), dimension(3), intent(in)      :: pt
        real(kind=8), dimension(:), intent(in)      :: coeff
        integer, intent(in)                         :: size_coeff
        real(kind=8)                                :: eval(6)
!
! --------------------------------------------------------------------------------------------------
!
!   evaluate a symetrix matrix at a point pt
!   In hhoCell      : a HHo cell
!   In hhoBasisCell : basis cell
!   In Order        : polynomial order of the function
!   In pt           : point where evaluate
!   In coeff        : polynomial coefficient of the function
!   In size_coeff   : number of coefficient
!   Out mat         : format (XX YY ZZ SQRT(2)*XY SQRT(2)*XZ SQRT(2)*YZ)
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_CELL_SCAL) :: BSCEval
        real(kind=8) :: mat(3,3)
        integer :: i, j, size_cmp, deca
!
        if(hhoCell%ndim == 2) then
            size_cmp = size_coeff / 3
        else if(hhoCell%ndim == 3) then
            size_cmp = size_coeff / 6
        else
            ASSERT(ASTER_FALSE)
        end if
!
! --- Evaluate basis function at pt
        call hhoBasisCell%BSEval(hhoCell, pt, 0, order, BSCEval)
!
        deca = 0
        mat = 0.d0
        do i = 1, hhoCell%ndim
            mat(i,i) = ddot(size_cmp, coeff(deca+1: deca+size_cmp), 1, BSCEval, 1)
            deca = deca + size_cmp
        end do
!
        do i = 1, hhoCell%ndim
            do j = i+1, hhoCell%ndim
                mat(i,j) = ddot(size_cmp, coeff(deca+1: deca+size_cmp), 1, BSCEval, 1)
                mat(j,i) = mat(i,j)
                deca = deca + size_cmp
            end do
        end do
!
        ASSERT(deca == size_coeff)
!
        eval = 0.d0
!
        eval(1) = mat(1,1)
        eval(2) = mat(2,2)
        eval(3) = mat(3,3)
! ---- We don't multiply extra-digonal terms by srqt(2) since we have already multiply
! ---- the basis function by srqt(2)
        eval(4) = mat(1,2)
        eval(5) = mat(1,3)
        eval(6) = mat(2,3)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoFuncFScalEvalQp(hhoQuad, nomfunc, nbpara, nompara, valpara, ndim, FuncValuesQp,&
                                    & coeff_mult)
!
    implicit none

        type(HHO_Quadrature), intent(in)   :: hhoQuad
        character(len=8), intent(in)       :: nomfunc
        integer, intent(in)                :: nbpara
        character(len=8), intent(in)       :: nompara(*)
        real(kind=8), intent(inout)        :: valpara(*)
        integer, intent(in)                :: ndim
        real(kind=8), intent(out)          :: FuncValuesQP(*)
        real(kind=8), optional, intent(in) :: coeff_mult
!
!
! --------------------------------------------------------------------------------------------------
!   HHO - Evaluation
!
!   Evaluate an analytical function (*_F) at the quadrature points F(X, Y, ...)
!   In hhoQuad  : Quadrature
!   In nomfunc  : name of the function
!   In nbpara   : number of parameter of the function
!   In nompara  : name of parameters
!   In valpara  : values of parameter
!   In ndim     : spacial dimension of the function (the coordinate-parameters (X,Y,Z) are
!                 always the first parameters) (ndim=0, if the function does not depend on (X,Y,Z))
!   Out FuncValues : values of the function at the quadrature points
!   In coeff_mult  : multply all values by this coefficient (optional)
!
! --------------------------------------------------------------------------------------------------
!
        integer :: npg, ipg, iret
!
        npg = hhoQuad%nbQuadPoints
! ---- Value of the function at the quadrature point
!
        if(ndim == 0) then
            do ipg = 1, npg
                call fointe('FM', nomfunc, nbpara, nompara, valpara, FuncValuesQP(ipg), iret)
                ASSERT(iret == 0)
            end do
        elseif(ndim <= 3) then
            do ipg = 1, npg
                valpara(1:ndim) = hhoQuad%points(1:ndim, ipg)
                call fointe('FM', nomfunc, nbpara, nompara, valpara, FuncValuesQP(ipg), iret)
                ASSERT(iret == 0)
            end do
        else
            ASSERT(ASTER_FALSE)
        end if
!
        if(present(coeff_mult)) then
            call dscal(npg, coeff_mult, FuncValuesQP, 1)
        end if
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoFuncRScalEvalQp(hhoQuad, nnoEF, funcnoEF, FuncValuesQp, coeff_mult)
!
    implicit none
!
        type(HHO_Quadrature), intent(in)   :: hhoQuad
        integer, intent(in)                :: nnoEF
        real(kind=8), intent(in)           :: funcnoEF(*)
        real(kind=8), intent(out)          :: FuncValuesQP(MAX_QP_FACE)
        real(kind=8), optional, intent(in) :: coeff_mult
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Evaluate a function (*_R) at the quadrature points (given at the nodes)
!   In hhoQuad  : Quadrature
!   In nnoEF    : number of nodes of the EF face (not the HHO face)
!   In funcnoEF : values of the function at the nodes of the EF face
!   Out FuncValues : values of the function at the quadrature points
!   In coeff_mult  : multply all values by this coefficient (optional)
!
! --------------------------------------------------------------------------------------------------
!
        integer :: npg
!
        FuncValuesQP = 0.d0
        npg = hhoQuad%nbQuadPoints
        ASSERT(npg <=  MAX_QP_FACE)
!
! ----- We assume that the function is constant on each face and the value is given by the middle
!       node (which is shared by only 2 faces and is the last node in EF face)
!
        FuncValuesQP(1:npg) = funcnoEF(nnoEF)
!
        if(present(coeff_mult)) then
            call dscal(npg, coeff_mult, FuncValuesQP, 1)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoFuncRVecEvalQp(hhoFace, hhoQuad, nnoEF, funcnoEF, FuncValuesQp, coeff_mult)
!
    implicit none
!
        type(HHO_Face), intent(in)         :: hhoFace
        type(HHO_Quadrature), intent(in)   :: hhoQuad
        integer, intent(in)                :: nnoEF
        real(kind=8), intent(in)           :: funcnoEF(*)
        real(kind=8), intent(out)          :: FuncValuesQP(3,MAX_QP_FACE)
        real(kind=8), optional, intent(in) :: coeff_mult
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Evaluate a function (*_R) at the quadrature points (given at the nodes)
!   In hhoFace  : Face HHO (!!! The EF face have to be plane)
!   In hhoQuad  : Quadrature
!   In nnoEF    : number of nodes of the EF face (not the HHO face)
!   In funcnoEF : values of the function at the nodes of the EF face
!   Out FuncValues : values of the function at the quadrature points
!   In coeff_mult  : multply all values by this coefficient (optional)
!
! --------------------------------------------------------------------------------------------------
!
        integer :: npg, ino, idim, celldim
!
        FuncValuesQP = 0.d0
        npg = hhoQuad%nbQuadPoints
        celldim = hhoFace%ndim + 1
        ASSERT(npg <=  MAX_QP_FACE)
!
! ----- We assume that the function is constant on each face and the value is given by the middle
!       node (which is shared by only 2 faces and is the last node in EF face)
!
        ino = (nnoEF - 1) * celldim
        do idim = 1, celldim
            FuncValuesQP(idim, 1:npg) = funcnoEF(ino + idim)
        end do
!
        if(present(coeff_mult)) then
            call dscal(3 * npg, coeff_mult, FuncValuesQP, 1)
        end if
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoFuncRVecEvalCellQp(hhoCell, hhoQuad, nnoEF, funcnoEF, FuncValuesQp, coeff_mult)
!
    implicit none
!
        type(HHO_Cell), intent(in)         :: hhoCell
        type(HHO_Quadrature), intent(in)   :: hhoQuad
        integer, intent(in)                :: nnoEF
        real(kind=8), intent(in)           :: funcnoEF(*)
        real(kind=8), intent(out)          :: FuncValuesQP(3,MAX_QP_CELL)
        real(kind=8), optional, intent(in) :: coeff_mult
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Evaluate a function (*_R) at the quadrature points (given at the nodes)
!   In hhoCell  : Cell HHO
!   In hhoQuad  : Quadrature
!   In nnoEF    : number of nodes of the EF Cell (not the HHO Cell)
!   In funcnoEF : values of the function at the nodes of the EF cell
!   Out FuncValues : values of the function at the quadrature points
!   In coeff_mult  : multply all values by this coefficient (optional)
!
! --------------------------------------------------------------------------------------------------
!
        integer :: npg, ino, idim, ipg
        real(kind=8) :: val
!
        FuncValuesQP = 0.d0
        npg = hhoQuad%nbQuadPoints
        ASSERT(npg <=  MAX_QP_CELL)
!
!
        do ipg = 1, npg
            do idim = 1, hhoCell%ndim
                val = 0.d0
                do ino = 1, nnoEF
                    ASSERT(ASTER_FALSE)
! il faut interpoler les résultats aux pg
                    val = val + funcnoEF(ino) * funcnoEF(ino + idim)
                end do
                FuncValuesQP(idim, ipg) = val
            end do
        end do
!
        if(present(coeff_mult)) then
            call dscal(3 * npg, coeff_mult, FuncValuesQP, 1)
        end if
!
    end subroutine
!
end module
