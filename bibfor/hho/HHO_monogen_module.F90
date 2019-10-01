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
module HHO_monogen_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/assert.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic tools
!
! Monomial generator
!
! --------------------------------------------------------------------------------------------------
!
! -- Maximum order of function for the moment
    integer, parameter, private :: max_order = 3
!
    type HHO_monomials
! ----- maximum degree of the monomials
        integer :: max_order = max_order
! ----- number of variate of the monomial (X, Y, Z)
        integer :: ndim = 0
! ----- coefficient of the monomial
        integer, dimension(3,20) :: monomials = 0
! ----- degree of the monomial
        integer, dimension(20)   :: degree_mono = 0
! ----- table with the evaluation of the monomial
        real(kind=8), dimension(3,0:max_order) :: monoEval = 0.d0
!
! ----- member function
        contains
        procedure, pass :: initialize => hhoMonomialsInit
        procedure, pass :: eval => hhoMonomialsEval
        procedure, pass :: maxOrder
        procedure, pass :: dim => dim_mono
    end type HHO_monomials
!
    public   :: HHO_monomials
    private  :: hhoMonomialsInit, hhoMonomialsEval, dim_mono, maxOrder
!
contains
!---------------------------------------------------------------------------------------------------
! -- member function for HHO_monomials type
!---------------------------------------------------------------------------------------------------
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMonomialsInit(this, ndim, order)
!
    implicit none
!
        class(HHO_monomials), intent(inout) :: this
        integer, intent(in) :: ndim
        integer, intent(in) :: order
!
! --------------------------------------------------------------------------------------------------
!   HHO - generic tools
!
!   Initialization of HHO_monomials type
!   In ndim     : dimension of the monomials
!   In order    : degree of the monomials <= max_degree
!   InOut this : HHO_Monomials
!
! --------------------------------------------------------------------------------------------------
!
!   Initialize the monomial tables until order 7
        ASSERT(order <= max_order)
        this%max_order = order
!
        if (ndim == 1) then
            this%monomials(1, 1:10) = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
            this%degree_mono(1:10)  = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
        else if(ndim == 2) then
            this%monomials(1:2,1:10) = reshape( &
                                                    ! ordre 0
                                                    &(/ 0, 0, &
                                                    ! ordre 1
                                                    & 1, 0, 0, 1, &
                                                    ! ordre 2
                                                    & 2, 0, 0, 2, &
                                                    & 1, 1, &
                                                    ! ordre 3
                                                    & 3, 0, 0, 3, &
                                                    & 2, 1, 1, 2  &
                                                                    & /), (/2,10/))
! --------------------------------------------- Useless for the moment
!                                                    ! ordre 4
!                                                    & 4, 0, 0, 4, &
!                                                    & 3, 1, 1, 3, &
!                                                    & 2, 2, &
!                                                    ! ordre 5
!                                                    & 5, 0, 0, 5, &
!                                                    & 4, 1, 1, 4, &
!                                                    & 3, 2, 2, 3, &
!                                                    ! ordre 6
!                                                    & 6, 0, 0, 6, &
!                                                    & 5, 1, 1, 5, &
!                                                    & 4, 2, 2, 4 ,&
!                                                    & 3, 3, &
!                                                    ! ordre 7
!                                                    & 7, 0, 0, 7, &
!                                                    & 6, 1, 1, 6, &
!                                                    & 5, 2, 2, 5, &
!                                                    & 4, 3, 3, 4  &
!
            this%degree_mono(1:10) = [ 0, 1, 1, 2, 2, 2, 3, 3, 3, 3 ]
        else if(ndim == 3) then
            this%degree_mono(1:10) = [ 0, 1, 1, 1, 2, 2, 2, 2, 2, 2 ]
            this%degree_mono(11:20) = 3
            this%monomials(1:3,1:20) = reshape((/ &
                    !ordre 0
                    & 0, 0, 0, &
                    ! ordre 1
                    & 1, 0, 0, 0, 1, 0, 0, 0, 1, &
                    ! ordre 2
                    & 2, 0, 0, 0, 2, 0, 0, 0, 2, &
                    & 1, 1, 0, 1, 0, 1, 0, 1, 1, &
                    ! ordre 3
                    & 3, 0, 0, 0, 3, 0, 0, 0, 3, &
                    & 2, 1, 0, 2, 0, 1, 1, 2, 0, 0, 2, 1, 1, 0, 2, 0, 1, 2, &
                    & 1, 1, 1 &
                                & /), (/3,20/))
! --------------- useless for the moment
!                    ! ordre 4
!                    & 4, 0, 0, 0, 4, 0, 0, 0, 4, &
!                    & 3, 1, 0, 3, 0, 1, 1, 3, 0, 0, 3, 1, 1, 0, 3, 0, 1, 3, &
!                    & 2, 2, 0, 2, 0, 2, 0, 2, 2, &
!                    & 2, 1, 1, 1, 2, 1, 1, 1, 2, &
!                    ! ordre 5
!                    & 5, 0, 0, 0, 5, 0, 0, 0, 5, &
!                    & 4, 1, 0, 4, 0, 1, 1, 4, 0, 0, 4, 1, 1, 0, 4, 0, 1, 4, &
!                    & 3, 2, 0, 3, 0, 2, 2, 3, 0, 0, 3, 2, 2, 0, 3, 0, 2, 3, &
!                    & 3, 1, 1, 1, 3, 1, 1, 1, 3, &
!                    & 2, 2, 1, 2, 1, 2, 1, 2, 2, &
!                    ! ordre 6
!                    & 6, 0, 0, 0, 6, 0, 0, 0, 6, &
!                    & 5, 1, 0, 5, 0, 1, 1, 5, 0, 0, 5, 1, 1, 0, 5, 0, 1, 5, &
!                    & 4, 2, 0, 4, 0, 2, 2, 4, 0, 0, 4, 2, 2, 0, 4, 0, 2, 4, &
!                    & 4, 1, 1, 1, 4, 1, 1, 1, 4, &
!                    & 3, 3, 0, 3, 0, 3, 0, 0, 3, &
!                    & 3, 2, 1, 3, 1, 2, 2, 3, 1, 1, 3, 2, 2, 1, 3, 1, 2, 3, &
!                    & 2, 2, 2, &
!                    ! ordre 7
!                    & 7, 0, 0, 0, 7, 0, 0, 0, 7, &
!                    & 6, 1, 0, 6, 0, 1, 1, 6, 0, 0, 6, 1, 1, 0, 6, 0, 1, 6, &
!                    & 5, 2, 0, 5, 0, 2, 2, 5, 0, 0, 5, 2, 2, 0, 5, 0, 2, 5, &
!                    & 5, 1, 1, 1, 5, 1, 1, 1, 5, &
!                    & 4, 3, 0, 4, 0, 3, 3, 4, 0, 0, 4, 3, 3, 0, 4, 0, 3, 4, &
!                    & 4, 2, 1, 4, 1, 2, 2, 4, 1, 1, 4, 2, 2, 1, 4, 1, 2, 4, &
!                    & 3, 3, 1, 3, 1, 3, 1, 3, 3, &
!                    & 3, 2, 2, 2, 3, 2, 2, 2, 3  &
!
        else
            ASSERT(ASTER_FALSE)
        end if
!
        this%ndim = ndim
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMonomialsEval(this, point)
!
    implicit none
!
        class(HHO_monomials), intent(inout) :: this
        real(kind=8), dimension(3), intent(in) :: point
!
! --------------------------------------------------------------------------------------------------
!   InOut  this      : HHO monomials
!   In  point        : coordinates of the point to evaluate
! --------------------------------------------------------------------------------------------------
!
        integer :: i
!
        if(this%ndim >= 1) then
            this%monoEval(1,0) = 1.d0
            do i = 1, this%max_order
                this%monoEval(1,i) = point(1) * this%monoEval(1,i-1)
            end do
!
            if(this%ndim >= 2) then
                this%monoEval(2,0) = 1.d0
                do i = 1, this%max_order
                    this%monoEval(2,i) = point(2) *this%monoEval(2,i-1)
                end do
!
                if(this%ndim == 3) then
                    this%monoEval(3,0) = 1.d0
                    do i = 1, this%max_order
                        this%monoEval(3,i) = point(3) * this%monoEval(3,i-1)
                    end do
                end if
            end if
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
    function maxOrder(this) result(degree)
!
    implicit none
!
        class(HHO_monomials), intent(in) :: this
        integer                          :: degree
!
! --------------------------------------------------------------------------------------------------
!
!   return the maximum order of a HHO_monomials type
!   In this     : a HHo Data
!   Out degree  : max_order
! --------------------------------------------------------------------------------------------------
!
        degree = this%max_order
!
    end function
!
    function dim_mono(this) result(ndim)
!
    implicit none
!
        class(HHO_monomials), intent(in) :: this
        integer                          :: ndim
!
! --------------------------------------------------------------------------------------------------
!
!   return the dimension of a HHO_monomials type
!   In this     : a HHo Data
!   Out degree  : ndim
! --------------------------------------------------------------------------------------------------
!
        ndim = this%ndim
!
    end function
!
end module
