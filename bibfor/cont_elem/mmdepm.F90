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
subroutine mmdepm(nbdm  , ndim  ,&
                  nne   , nnm   ,&
                  jdepm , jdepde,&
                  ffe   , ffm   ,&
                  ddeple, ddeplm,&
                  deplme, deplmm)
!
implicit none
!
#include "jeveux.h"
!
integer, intent(in) :: nbdm, ndim, nne, nnm
integer, intent(in) :: jdepde, jdepm
real(kind=8), intent(in) :: ffe(9), ffm(9)
real(kind=8), intent(out) :: ddeple(3), deplme(3)
real(kind=8), intent(out) :: ddeplm(3), deplmm(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute increment of displacements
!
! --------------------------------------------------------------------------------------------------
!
! In  nbdm             : number of components by node for all dof
! In  ndim             : dimension of problem (2 or 3)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! Out ddeple           : increment of displacement for contact point
! Out ddeplm           : increment of displacement for projection of contact point
! Out deplme           : displacement for contact point at beginning of time step
! Out deplmm           : displacement for projection of contact point at beginning of time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: idim, inoe
!
! --------------------------------------------------------------------------------------------------
!
    ddeplm(:) = 0.d0
    deplmm(:) = 0.d0
    ddeple(:) = 0.d0
    deplme(:) = 0.d0
!
! - Displacement for contact point at beginning of time step
!
    do idim = 1, ndim
        do inoe = 1, nne
            deplme(idim) = deplme(idim) + ffe(inoe)*zr(jdepm+(inoe-1)*nbdm+idim-1)
        end do
    end do
!
! - Increment of displacement for contact point
!
    do idim = 1, ndim
        do inoe = 1, nne
            ddeple(idim) = ddeple(idim) + ffe(inoe)*zr(jdepde+(inoe-1)*nbdm+idim-1)
        end do
    end do
!
! - Displacement for projection of contact point at beginning of time step
!
    do idim = 1, ndim
        do inoe = 1, nnm
            deplmm(idim) = deplmm(idim) + ffm(inoe)* zr(jdepm+nne*nbdm+(inoe-1)*ndim+idim-1)
        end do
    end do
!
! - Increment of displacement for projection of contact point
!
    do idim = 1, ndim
        do inoe = 1, nnm
            ddeplm(idim) = ddeplm(idim) + ffm(inoe)* zr(jdepde+nne*nbdm+(inoe-1)*ndim+idim-1)
        end do
    end do
!
end subroutine
