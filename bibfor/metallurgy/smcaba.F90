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
subroutine smcaba(x , nb_hist, trc, ftrc, ind,&
                  dz)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/rslsvd.h"
#include "asterfort/smcosl.h"
!
real(kind=8), intent(in) :: x(5)
integer, intent(in) :: nb_hist
real(kind=8), intent(in) :: trc((3*nb_hist), 5)
real(kind=8), intent(in) :: ftrc((3*nb_hist), 3)
integer, intent(in) :: ind(6)
real(kind=8), intent(inout) :: dz(4)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase
!
! Compute barycenter and update increments of phases
!
! --------------------------------------------------------------------------------------------------
!
! In  x                   : given set of parameters
! In  nb_hist             : number of graph in TRC diagram
! In  trc                 : values of functions for TRC diagram
! In  ftrc                : values of derivatives (by temperature) of functions for TRC diagram
! In  ind                 : index of the six nearest TRC curves
! IO  dz                  : increments of phases
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: zero = 0.d0
    integer :: ifail, i, nz
    real(kind=8) :: som, alemb(6), a(6, 6), b(6)
    real(kind=8) :: epsmac, work(96), s(6), u(6, 6), v(6, 6)
!
! --------------------------------------------------------------------------------------------------
!
    epsmac = r8prem()
!
! - Prepare system
!
    call smcosl(x, nb_hist, trc, ind,&
                a, b)
!
! - Solve system
!
    call rslsvd(6, 6, 6, a(1, 1), s(1),&
                u(1, 1), v(1, 1), 1, b(1), epsmac,&
                ifail, work(1))
    ASSERT(ifail .eq. 0)
!
    do i = 1, 6
        alemb(i) = b(i)
    end do
    som = zero
    do i = 1, 6
        if (alemb(i) .lt. zero) then
            alemb(i) = zero
        endif
        som = som + alemb(i)
    end do
!
! - Update increment of phases
!
    if (som .eq. zero) then
        do nz = 1, 3
            dz(nz) = ftrc(ind(1),nz)
        end do
    else
        do nz = 1, 3
            dz(nz) = zero
            do i = 1, 6
                dz(nz) = dz(nz) + alemb(i)*ftrc(ind(i),nz)/som
            end do
        end do
    endif
!
end subroutine
