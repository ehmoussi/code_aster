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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmlagm(nbdm  , ndim  , nnl, jdepde, ffl,&
                  dlagrc, dlagrf)
!
implicit none
!
#include "jeveux.h"
!
integer, intent(in) :: nbdm, ndim, nnl
integer, intent(in) :: jdepde
real(kind=8), intent(in) :: ffl(9)
real(kind=8), intent(out) :: dlagrc, dlagrf(2)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute increment of Lagrange multipliers
!
! --------------------------------------------------------------------------------------------------
!
! In  nbdm             : number of components by node for all dof
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  jdepde           : address for increment of displacement from beginning of time step
! In  ffl              : shape function for Lagrange dof
! Out dlagrc           : increment of contact Lagrange from beginning of time step
! Out dlagrf           : increment of friction Lagrange from beginning of time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inoc, inof
!
! --------------------------------------------------------------------------------------------------
!
    dlagrc    = 0.d0
    dlagrf(:) = 0.d0
!
! - Increment of contact Lagrange from beginning of time step
!
    do inoc = 1, nnl
        dlagrc = dlagrc + ffl(inoc)*zr(jdepde+(inoc-1)*nbdm+(ndim+1)- 1)
    end do
!
! - Increment of friction Lagrange from beginning of time step
!
    do inof = 1, nnl
        dlagrf(1) = dlagrf(1) + ffl(inof)*zr(jdepde+(inof-1)*nbdm+(ndim+2)-1)
        if (ndim .eq. 3) then
            dlagrf(2) = dlagrf(2) + ffl(inof)*zr(jdepde+(inof-1)* nbdm+(ndim+3)-1)
        endif
    end do
!
end subroutine
