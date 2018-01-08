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
subroutine smcavo(x, nb_hist, trc, ind)
!
implicit none
!
real(kind=8), intent(in) :: x(5)
integer, intent(in) :: nb_hist
real(kind=8), intent(in) :: trc((3*nb_hist), 5)
integer, intent(out) :: ind(6)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase
!
! Find the six nearest TRC curves for given set of parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  x                   : given set of parameters
! In  nb_hist             : number of graph in TRC diagram
! In  trc                 : values of functions for TRC diagram
! Out ind                 : index of the six nearest TRC curves
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: sdx, d(6), dx(5)
    integer :: invois, i, j, i_hist
!
! --------------------------------------------------------------------------------------------------
!
    ind(:) = 0
    d(:)   = 10.d25

    do i_hist = 1, 3*nb_hist
! ----- Compute distances
        do i = 1, 3
            dx(i) = (x(i)-trc(i_hist,i))**2
        end do
        do i = 4, 5
            dx(i) = ((x(i)-trc(i_hist,i))/x(i))**2
        end do
! ----- Total distance
        sdx = 0.d0
        do i = 1, 5
            sdx = sdx+dx(i)
        end do
! ----- Find nearest
        if (sdx .ge. d(6)) then
            cycle
        else
            do i = 6, 1, -1
                if (sdx .lt. d(i)) then
                    invois = i
                endif
            end do
            if (invois .eq. 6) then
                d(6)   = sdx
                ind(6) = i_hist
            else
                do j = 6, invois+1, -1
                    d(j)   = d(j-1)
                    ind(j) = ind(j-1)
                end do
                d(invois)   = sdx
                ind(invois) = i_hist
            endif
        endif
    end do
end subroutine
