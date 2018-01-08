! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine smcosl(x, nb_hist, trc, ind,&
                  a, b)
!
implicit none
!
real(kind=8), intent(in) :: x(5)
integer, intent(in) :: nb_hist
real(kind=8), intent(in) :: trc((3*nb_hist), 5)
integer, intent(in) :: ind(6)
real(kind=8), intent(out) :: a(6, 6), b(6)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase
!
! Prepare system to compute barycenter
!
! --------------------------------------------------------------------------------------------------
!
! In  x                   : given set of parameters
! In  nb_hist             : number of graph in TRC diagram
! In  trc                 : values of functions for TRC diagram
! In  ind                 : index of the six nearest TRC curves
! Out a                   : matrix of system
! Out b                   : second member of system
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: zero = 0.d0, un = 1.d0
    integer :: j, i
!
! --------------------------------------------------------------------------------------------------
!
    b(:)   = zero
    a(:,:) = zero
!
! - Matrix
!
    do i = 1, 3
        do j = 1, 6
            a(i,j)=trc(ind(j),i)
        end do
    end do
    do j = 1, 6
        a(4,j) = trc(ind(j),4)/x(4)
        a(5,j) = trc(ind(j),5)/x(5)
        a(6,j) = un
    end do
!
! - Second member 
!
    do i = 1, 3
        b(i)= x(i)
    end do
    b(4) = un
    b(5) = un
    b(6) = un
!
end subroutine
