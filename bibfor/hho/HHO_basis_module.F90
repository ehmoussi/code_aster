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
module HHO_basis_module
!
use HHO_monogen_module
use HHO_type
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/binomial.h"
#include "asterfort/utmess.h"
#include "blas/ddot.h"
! --------------------------------------------------------------------------------------------------
!
! HHO - generic
!
! Module to generate basis function used for HHO methods
!
! --------------------------------------------------------------------------------------------------
!
    type HHO_basis_cell
        type(HHO_monomials) :: hhoMono
! ----- member function
        contains
        procedure, pass :: initialize => hhoBasisCellInit
        procedure, pass :: BSSize => hhoBSCellSize
        procedure, pass :: BVSize => hhoBVCellSize
        procedure, pass :: BMSize => hhoBMCellSize
        procedure, pass :: BSRange => hhoBSCellRange
        procedure, pass :: BVRange => hhoBVCellRange
        procedure, pass :: BMRange => hhoBMCellRange
        procedure, pass :: BSEval => hhoBSCellEval
        procedure, pass :: BSEvalGrad => hhoBSCellGradEv
        procedure, pass :: BVEvalSymGrad => hhoBVCellSymGdEv
    end type
!
    type HHO_basis_face
        type(HHO_monomials) :: hhoMono
! ----- member function
        contains
        procedure, pass :: initialize => hhoBasisFaceInit
        procedure, pass :: BSSize => hhoBSFaceSize
        procedure, pass :: BVSize => hhoBVFaceSize
        procedure, pass :: BSRange => hhoBSFaceRange
        procedure, pass :: BVRange => hhoBVFaceRange
        procedure, pass :: BSEval => hhoBSFaceEval
    end type
! --------------------------------------------------------------------------------------------------
! --------------------------------------------------------------------------------------------------
    public  :: HHO_basis_cell, HHO_basis_face
    private :: map_face, hhoBasisCellInit, hhoBasisFaceInit, hhoBSCellSize, hhoBSFaceSize
    private :: hhoBVCellSize, hhoBVFaceSize, hhoBMCellSize
    private :: hhoBSCellRange, hhoBVCellRange, hhoBMCellRange, hhoBSFaceRange, hhoBVFaceRange
    private :: hhoBSCellEval, hhoBSFaceEval, hhoBSCellGradEv, hhoBVCellSymGdEv, check_order
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine check_order(min_order, max_order, maxAutorized)
!
    implicit none
!
        integer, intent(in) :: min_order
        integer, intent(in) :: max_order
        integer, intent(in) :: maxAutorized
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   control the order of integration of [min_order, max_order] has to be included in
!   [0, maxAutorized]
!   In min_order  : minmun order
!   In max_order  : maximum order
!   In maxAutorized : maximum autorized order
!
! --------------------------------------------------------------------------------------------------
!
        ASSERT(min_order <= max_order)
!
        if(max_order > maxAutorized) then
            call utmess('F', 'HHO1_10', ni=2, vali=(/max_order, maxAutorized /))
        end if
!
        if(min_order < 0) then
            call utmess('F', 'HHO1_11', si=min_order)
        end if
!
    end subroutine
!
! -- member functions
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBasisCellInit(this, hhoCell)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        class(HHO_basis_cell), intent(out)  :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   initialize hho basis for a cell
!   In hhoCell  : the current HHO cell
!   Out this    : HHO_basis_cell
!
! --------------------------------------------------------------------------------------------------
!
        call this%hhoMono%initialize(hhoCell%ndim, MAX_DEGREE_CELL)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBasisFaceInit(this, hhoFace)
!
    implicit none
!
        type(HHO_Face), intent(in)               :: hhoFace
        class(HHO_basis_face), intent(out)       :: this
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   initialize hho basis for a face
!   In hhoFace     : the current HHO face
!   Out this       : HHO_basis_face
!
! --------------------------------------------------------------------------------------------------
!
        call this%hhoMono%initialize(hhoFace%ndim, MAX_DEGREE_FACE)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoBSCellSize(this, min_order, max_order) result(size_basis)
!
    implicit none
!
        class(HHO_basis_cell), intent(in)      :: this
        integer, intent(in)                    :: min_order
        integer, intent(in)                    :: max_order
        integer                                :: size_basis
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis cell
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out size_basis          : size of the scalar basis
! --------------------------------------------------------------------------------------------------
!
        integer :: size_min, size_max
!
        call this%BSRange(min_order, max_order, size_min, size_max)
        size_basis = size_max - size_min + 1
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoBSFaceSize(this, min_order, max_order) result(size_basis)
!
    implicit none
!
        class(HHO_basis_face), intent(in)       :: this
        integer, intent(in)                     :: min_order
        integer, intent(in)                     :: max_order
        integer                                 :: size_basis
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis Face
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out size_basis          : size of the scalar basis
! --------------------------------------------------------------------------------------------------
!
        integer :: size_min, size_max
!
        call this%BSRange(min_order, max_order, size_min, size_max)
        size_basis = size_max - size_min + 1
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBSCellRange(this, min_order, max_order, ifrom, ito)
!
    implicit none
!
        class(HHO_basis_cell), intent(in)       :: this
        integer, intent(in)                     :: min_order
        integer, intent(in)                     :: max_order
        integer, intent(out)                    :: ifrom
        integer, intent(out)                    :: ito
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis cell
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out ifrom               : first index of the monomials
!   Out ito                 : last index of the monomials
! --------------------------------------------------------------------------------------------------
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        if(min_order == 0) then
            ifrom = 1
        else
            ifrom = binomial(min_order-1 + this%hhoMono%ndim, min_order-1) + 1
        end if
!
        ito = binomial(max_order + this%hhoMono%ndim, max_order)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBSFaceRange(this, min_order, max_order, ifrom, ito)
!
    implicit none
!
        class(HHO_basis_face), intent(in)       :: this
        integer, intent(in)                     :: min_order
        integer, intent(in)                     :: max_order
        integer, intent(out)                    :: ifrom
        integer, intent(out)                    :: ito
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO BS Face
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out ifrom               : first index of the monomials
!   Out ito                 : last index of the monomials
! --------------------------------------------------------------------------------------------------
!
! ---- Check the order
        call check_order(min_order, max_order,this%hhoMono%maxOrder())
!
        if(min_order == 0) then
            ifrom = 1
        else
            ifrom = binomial(min_order-1 + this%hhoMono%ndim, min_order-1) + 1
        end if
!
        ito = binomial(max_order + this%hhoMono%ndim, max_order)
!
    end subroutine
!
    function hhoBVCellSize(this, min_order, max_order) result(size_basis)
!
!===================================================================================================
!
!===================================================================================================
!
    implicit none
!
        class(HHO_basis_cell), intent(in)      :: this
        integer, intent(in)                    :: min_order
        integer, intent(in)                    :: max_order
        integer                                :: size_basis
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis cell
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out size_basis          : size of the scalar basis
! --------------------------------------------------------------------------------------------------
!
        integer :: size_min, size_max
!
        call this%BSRange(min_order, max_order, size_min, size_max)
        size_basis = this%hhoMono%ndim * (size_max - size_min + 1)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoBVFaceSize(this, min_order, max_order) result(size_basis)
!
    implicit none
!
        class(HHO_basis_face), intent(in)       :: this
        integer, intent(in)                     :: min_order
        integer, intent(in)                     :: max_order
        integer                                 :: size_basis
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis Face
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out size_basis          : size of the scalar basis
! --------------------------------------------------------------------------------------------------
!
        integer :: size_min, size_max
!
        call this%BSRange(min_order, max_order, size_min, size_max)
        size_basis = (this%hhoMono%ndim+1) * (size_max - size_min + 1)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBVCellRange(this, min_order, max_order, ifrom, ito)
!
    implicit none
!
        class(HHO_basis_cell), intent(in)       :: this
        integer, intent(in)                     :: min_order
        integer, intent(in)                     :: max_order
        integer, intent(out)                    :: ifrom
        integer, intent(out)                    :: ito
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis cell
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out ifrom               : first index of the monomials
!   Out ito                 : last index of the monomials
! --------------------------------------------------------------------------------------------------
!
        integer :: ndim
!
        ndim = this%hhoMono%ndim
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        if(min_order == 0) then
            ifrom = 1
        else
            ifrom = ndim * binomial(min_order-1 + ndim, min_order-1) + 1
        end if
!
        ito = ndim * binomial(max_order + ndim, max_order)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBVFaceRange(this, min_order, max_order, ifrom, ito)
!
    implicit none
!
        class(HHO_basis_face), intent(in)       :: this
        integer, intent(in)                     :: min_order
        integer, intent(in)                     :: max_order
        integer, intent(out)                    :: ifrom
        integer, intent(out)                    :: ito
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO BS Face
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out ifrom               : first index of the monomials
!   Out ito                 : last index of the monomials
! --------------------------------------------------------------------------------------------------
!
        integer :: ndim
!
        ndim = this%hhoMono%ndim
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        if(min_order == 0) then
            ifrom = 1
        else
            ifrom = (ndim+1) * binomial(min_order-1 + ndim, min_order-1) + 1
        end if
        ito = (ndim+1) * binomial(max_order + ndim, max_order)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoBMCellSize(this, min_order, max_order) result(size_basis)
!
    implicit none
!
        class(HHO_basis_cell), intent(in)      :: this
        integer, intent(in)                    :: min_order
        integer, intent(in)                    :: max_order
        integer                                :: size_basis
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis cell
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out size_basis          : size of the matrix basis
! --------------------------------------------------------------------------------------------------
!
        integer :: size_min, size_max, ndim2
!
        ndim2 = this%hhoMono%ndim * this%hhoMono%ndim
!
        call this%BSRange(min_order, max_order, size_min, size_max)
        size_basis = ndim2 * (size_max - size_min + 1)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBMCellRange(this, min_order, max_order, ifrom, ito)
!
    implicit none
!
        class(HHO_basis_cell), intent(in)       :: this
        integer, intent(in)                     :: min_order
        integer, intent(in)                     :: max_order
        integer, intent(out)                    :: ifrom
        integer, intent(out)                    :: ito
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   size of the matrix basis for the specified range [min_order, max_order]
!   In this                 : HHO Basis cell
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out ifrom               : first index of the monomials
!   Out ito                 : last index of the monomials
! --------------------------------------------------------------------------------------------------
!
        integer :: ndim, ndim2
!
        ndim = this%hhoMono%ndim
        ndim2 = ndim * ndim
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        if(min_order == 0) then
            ifrom = 1
        else
            ifrom = ndim2 * binomial(min_order-1 + ndim, min_order-1) + 1
        end if
        ito = ndim2 * binomial(max_order + ndim, max_order)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBSCellEval(this, hhoCell, point, min_order, max_order, basisScalEval)
!
    implicit none
!
        type(HHO_Cell), intent(in)                              :: hhoCell
        class(HHO_basis_cell), intent(inout)                    :: this
        real(kind=8), dimension(3), intent(in)                  :: point
        integer, intent(in)                                     :: min_order
        integer, intent(in)                                     :: max_order
        real(kind=8), dimension(MSIZE_CELL_SCAL), intent(out)   :: basisScalEval
!
! --------------------------------------------------------------------------------------------------
!   HHO - basis functions
!
!   evaluate hho basis scalar for a cell
!   In hhoCell              : the current HHO cell
!   In this                 : HHO_basis_scalar_cell
!   In point                : point where evaluate
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out basisScalEval       : evaluation of the scalar basis
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) :: peval
        integer :: imono, ifrom, ito, size_basis, ind
        integer, dimension(3) :: power
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        size_basis = this%BSSize(min_order, max_order)
        call this%BSRange(min_order, max_order, ifrom, ito)
! ----  scaled point
        peval = 0.d0
        peval = (point - hhoCell%barycenter) / (0.5d0 * hhoCell%length_box)
!
! ----- Eval monomials
        call this%hhoMono%eval(peval)
!
        basisScalEval = 0.d0
!
! ----- Loop on the monomial
        ind = 0
        if(hhoCell%ndim == 1) then
            do imono = ifrom, ito
                ind = ind + 1
                power(1) = this%hhoMono%monomials(1, imono)
                basisScalEval(imono) = this%hhoMono%monoEval(1, power(1))
            end do
        else if(hhoCell%ndim == 2) then
            do imono = ifrom, ito
                ind = ind + 1
                power(1:2) = this%hhoMono%monomials(1:2, imono)
                basisScalEval(imono) = this%hhoMono%monoEval(1, power(1)) * &
                                       this%hhoMono%monoEval(2, power(2))
            end do
        else if(hhoCell%ndim == 3) then
            do imono = ifrom, ito
                ind = ind + 1
                power(1:3) = this%hhoMono%monomials(1:3, imono)
                basisScalEval(imono) = this%hhoMono%monoEval(1, power(1)) * &
                                       this%hhoMono%monoEval(2, power(2)) * &
                                       this%hhoMono%monoEval(3, power(3))
            end do
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!

!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBSCellGradEv(this, hhoCell, point, min_order, max_order, BSGradEval)
!
    implicit none
!
        type(HHO_Cell), intent(in)                              :: hhoCell
        class(HHO_basis_cell), intent(inout)                    :: this
        real(kind=8), dimension(3), intent(in)                  :: point
        integer, intent(in)                                     :: min_order
        integer, intent(in)                                     :: max_order
        real(kind=8), dimension(3,MSIZE_CELL_SCAL),  intent(out):: BSGradEval
!
! --------------------------------------------------------------------------------------------------
!   HHO - basis functions
!
!   evaluate hho basis scalar for a 3D cell
!   In hhoCell              : the current HHO cell
!   In this                 : HHO_basis_scalar_cell
!   In point                : point where evaluate
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out BSGradEval   : evaluation of the gradient of the scalar basis
!
! --------------------------------------------------------------------------------------------------
!
        integer :: size_basis, ifrom, ito
        real(kind=8), dimension(3) :: peval, func, dfunc
        integer :: ind, imono
        integer, dimension(3) :: power
        real(kind=8) :: ihx, ihy, ihz
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        size_basis = this%BSSize(min_order, max_order)
        call this%BSRange(min_order, max_order, ifrom, ito)
!
        ihx = 2.d0 / hhoCell%length_box(1)
        ihy = 2.d0 / hhoCell%length_box(2)
        ihz = 2.d0 / hhoCell%length_box(3)
! ----  scaled point
        peval = (point - hhoCell%barycenter) / (0.5d0 * hhoCell%length_box)
!
! ----- Eval monomials
        call this%hhoMono%eval(peval)
!
        BSGradEval = 0.d0
!
! ----- Loop on the monomial
        ind = 0
        if(hhoCell%ndim == 1) then
            do imono = ifrom, ito
                ind = ind + 1
                power(1) = this%hhoMono%monomials(1, imono)
!
                func(1) =  this%hhoMono%monoEval(1, power(1))
!
                if(power(1) == 0) then
                    dfunc(1) = 0.d0
                else
                    dfunc(1) = power(1) * this%hhoMono%monoEval(1, power(1)-1) * ihx
                end if
!
                BSGradEval(1,ind) = dfunc(1)
            end do
        else if(hhoCell%ndim == 2) then
            do imono = ifrom, ito
                ind = ind + 1
                power(1:2) = this%hhoMono%monomials(1:2, imono)
!
                func(1:2) = (/this%hhoMono%monoEval(1, power(1)),&
                            & this%hhoMono%monoEval(2, power(2)) /)
!
                if(power(1) == 0) then
                    dfunc(1) = 0.d0
                else
                    dfunc(1) = power(1) * this%hhoMono%monoEval(1, power(1)-1) * ihx
                end if
                if(power(2) == 0) then
                    dfunc(2) = 0.d0
                else
                    dfunc(2) = power(2) * this%hhoMono%monoEval(2, power(2)-1) * ihy
                end if
!
                BSGradEval(1, ind) = dfunc(1) * func(2)
                BSGradEval(2, ind) = func(1)  * dfunc(2)
            end do
        else if(hhoCell%ndim == 3) then
            do imono = ifrom, ito
                ind = ind + 1
                power(1:3) = this%hhoMono%monomials(1:3, imono)
!
                func(1:3) = (/this%hhoMono%monoEval(1, power(1)),&
                            & this%hhoMono%monoEval(2, power(2)),&
                            & this%hhoMono%monoEval(3, power(3)) /)
!
                if(power(1) == 0) then
                    dfunc(1) = 0.d0
                else
                    dfunc(1) = power(1) * this%hhoMono%monoEval(1, power(1)-1) * ihx
                end if
                if(power(2) == 0) then
                    dfunc(2) = 0.d0
                else
                    dfunc(2) = power(2) * this%hhoMono%monoEval(2, power(2)-1) * ihy
                end if
                if(power(3) == 0) then
                    dfunc(3) = 0.d0
                else
                    dfunc(3) = power(3) * this%hhoMono%monoEval(3, power(3)-1) * ihz
                end if
!
                BSGradEval(1, ind) = dfunc(1) * func(2)  * func(3)
                BSGradEval(2, ind) = func(1)  * dfunc(2) * func(3)
                BSGradEval(3, ind) = func(1)  * func(2)  * dfunc(3)
            end do
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBVCellSymGdEv(this, hhoCell, point, min_order, max_order, BVSymGradEval)
!
    implicit none
!
        type(HHO_Cell), intent(in)                              :: hhoCell
        class(HHO_basis_cell), intent(inout)                    :: this
        real(kind=8), dimension(3), intent(in)                  :: point
        integer, intent(in)                                     :: min_order
        integer, intent(in)                                     :: max_order
        real(kind=8), dimension(6,MSIZE_CELL_VEC),  intent(out) :: BVSymGradEval
!
! --------------------------------------------------------------------------------------------------
!   HHO - basis functions
!
!   evaluate hho gradient basis vectoriel for a 3D cell
!   In hhoCell              : the current HHO cell
!   In this                 : HHO_basis_cell
!   In point                : point where evaluate
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out BVSymGradEval       : evaluation of the symmetric gradient of the vectoriel basis
!
!   Be carefull the format of symetric matrix M is a vector of six components
!   (M11, M22, M33, Rac2*M12, Rac2*M13, Rac2*M23)
!
! --------------------------------------------------------------------------------------------------
!
        integer :: size_basis, size_basis_scal, ind, imono
        real(kind=8), parameter :: rac2sur2 = sqrt(2.d0) / 2.d0
        real(kind=8), dimension(3,MSIZE_CELL_SCAL) :: BSGradEval
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        size_basis = this%BVSize(min_order, max_order)
!
        size_basis_scal = this%BSSize(min_order, max_order)
!
! ----- Eval scalar gradient
!
        call this%BSEvalGrad(hhoCell, point, min_order, max_order, BSGradEval)
!
! ----- Loop on the monomial
        BVSymGradEval = 0.d0
        ind = 0
        if(hhoCell%ndim == 2) then
! -------- dir = 1
            do imono = 1, size_basis_scal
                ind = ind + 1
!
                BVSymGradEval(1, ind) = BSGradEval(1,imono)
                BVSymGradEval(4, ind) = BSGradEval(2,imono) * rac2sur2
            end do
! -------- dir = 2
            do imono = 1, size_basis_scal
                ind = ind + 1
!
                BVSymGradEval(2, ind) = BSGradEval(2,imono)
                BVSymGradEval(4, ind) = BSGradEval(1,imono) * rac2sur2
            end do
        else if(hhoCell%ndim == 3) then
! -------- dir = 1
            do imono = 1, size_basis_scal
                ind = ind + 1
!
                BVSymGradEval(1, ind) = BSGradEval(1,imono)
                BVSymGradEval(4, ind) = BSGradEval(2,imono) * rac2sur2
                BVSymGradEval(5, ind) = BSGradEval(3,imono) * rac2sur2
            end do
! -------- dir = 2
            do imono = 1, size_basis_scal
                ind = ind + 1
!
                BVSymGradEval(2, ind) = BSGradEval(2,imono)
                BVSymGradEval(4, ind) = BSGradEval(1,imono) * rac2sur2
                BVSymGradEval(6, ind) = BSGradEval(3,imono) * rac2sur2
            end do
! -------- dir = 3
            do imono = 1, size_basis_scal
                ind = ind + 1
!
                BVSymGradEval(3, ind) = BSGradEval(3,imono)
                BVSymGradEval(5, ind) = BSGradEval(1,imono) * rac2sur2
                BVSymGradEval(6, ind) = BSGradEval(2,imono) * rac2sur2
            end do
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoBSFaceEval(this, hhoFace, point, min_order, max_order, basisScalEval)
!
    implicit none
!
        type(HHO_Face), intent(in)                              :: hhoFace
        class(HHO_basis_face), intent(inout)                    :: this
        real(kind=8), dimension(3), intent(in)                  :: point
        integer, intent(in)                                     :: min_order
        integer, intent(in)                                     :: max_order
        real(kind=8), dimension(MSIZE_FACE_SCAL), intent(out)   :: basisScalEval
!
! --------------------------------------------------------------------------------------------------
!   HHO - basis functions
!
!   evaluate hho basis scalar function for a face
!   In hhoFace              : the current HHO Face
!   In this                 : HHO_basis_face
!   In point                : point where evaluate
!   In min_order            : minimum order
!   In max_order            : maximum order
!   Out basisScalEval       : evaluation of the scalar basis function
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) :: peval
        integer :: ind, imono, ifrom, ito, size_mono, i_basis
        integer, dimension(2) :: power
        real(kind=8), dimension(MSIZE_FACE_SCAL) :: basisMonoEval
!
! ---- Check the order
        call check_order(min_order, max_order, this%hhoMono%maxOrder())
!
        size_mono = this%BSSize(0, max_order)
!
! ----  scaled point
        peval = map_face(hhoFace, point)
!
! ----- Eval monomials
        call this%hhoMono%eval(peval)
!
        basisMonoEval = 0.d0
!
! ----- Loop on the monomial
        if(hhoFace%ndim == 0) then
            basisMonoEval(1) = 1.d0
        else if(hhoFace%ndim == 1) then
            do imono = 1, size_mono
                power(1) = this%hhoMono%monomials(1, imono)
                basisMonoEval(imono) = this%hhoMono%monoEval(1, power(1))
            end do
        else if(hhoFace%ndim == 2) then
            do imono = 1, size_mono
                power(1:2) = this%hhoMono%monomials(1:2, imono)
                basisMonoEval(imono) = this%hhoMono%monoEval(1, power(1)) * &
                                   & this%hhoMono%monoEval(2, power(2))
            end do
        else
            ASSERT(ASTER_FALSE)
        end if
!
        basisScalEval = 0.d0
        call this%BSRange(min_order, max_order, ifrom, ito)
!
! ----- Loop on the basis function
        ind = 0
        do i_basis = ifrom, ito
            ind = ind + 1
            basisScalEval(ind) = ddot(i_basis, hhoFace%coeff_ONB(:, i_basis), 1, basisMonoEval, 1)
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function map_face(hhoFace, point) result(proj)
!
    implicit none
!
        type(HHO_Face), intent(in)                 :: hhoFace
        real(kind=8), dimension(3), intent(in)     :: point
        real(kind=8), dimension(3)                 :: proj
!
! --------------------------------------------------------------------------------------------------
!   HHO - basis functions
!
!   map a point in global coordinates to local coordinates
!   In hhoFace              : the current HHO Face
!   In point                : point to project
!   Out proj                : projection
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) :: ep
        real(kind=8) :: eta, xi, h
!
        ep(1:3) = point(1:3) - hhoFace%barycenter(1:3)
        proj = 0.d0
!
        if(hhoFace%ndim == 2) then
!
            eta = dot_product(ep, hhoFace%local_basis(1:3,1))
            xi  = dot_product(ep, hhoFace%local_basis(1:3,2))
!
            proj(1:3) =  [ eta, xi, 0.d0 ]
        elseif(hhoFace%ndim == 1) then
!
            h = hhoFace%diameter
            eta = dot_product(ep, hhoFace%local_basis(1:3,1))
!
            proj(1:3) = [ 2.d0 * eta / h, 0.d0, 0.d0 ]
        elseif(hhoFace%ndim == 0) then
            proj = 1.d0
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
end module
