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
subroutine mmreac(nbdm  , ndim  ,&
                  nne   , nnm   ,&
                  jgeom , jdepm , jdepde , ppe,&
                  geomae, geomam, ddepmam)
!
implicit none
!
#include "jeveux.h"
!
integer, intent(in) :: nbdm, ndim, nne, nnm
integer, intent(in) :: jgeom, jdepm, jdepde
real(kind=8), intent(in) :: ppe
real(kind=8), intent(out) :: geomae(9, 3), geomam(9, 3), ddepmam(9, 3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Update geometry
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  nbdm             : number of components by node for all dof
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  jgeom            : address for initial geometry
! In  jdepm            : address for displacement at beginning of time step
! In  jdepde           : address for increment of displacement from beginning of time step
! In  ppe              : coefficient to update geometry
!                         PPE = 0 --> POINT_FIXE
!                         PPE = 1 --> NEWTON_GENE (FULL)
! Out geomae           : updated geometry for slave nodes
! Out geomam           : updated geometry for master nodes
! Out ddepmam          : increment of displacement from beginning of time step for master nodes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inoe, inom, idim
!
! --------------------------------------------------------------------------------------------------
!
    geomae(:,:)  = 0.d0
    geomam(:,:)  = 0.d0
    ddepmam(:,:) = 0.d0
!
! - Slave nodes
!
    do inoe = 1, nne
        do idim = 1, ndim
            geomae(inoe,idim) = zr(jgeom+(inoe-1)*ndim+idim-1)+&
                                zr(jdepm+(inoe-1)*nbdm+idim-1)+&
                                ppe*zr(jdepde+(inoe-1)*nbdm+idim-1)
        end do
    end do
!
! - Master nodes
!
    do  inom = 1, nnm
        do idim = 1, ndim
            geomam(inom,idim) = zr(jgeom+nne*ndim+(inom-1)*ndim+idim-1)+&
                                zr(jdepm+nne*nbdm+(inom-1)*ndim+idim-1)+&
                                ppe*zr(jdepde+nne*nbdm+(inom-1)*ndim+idim-1)
            ddepmam(inom,idim) = zr(jdepde+nne*nbdm+(inom-1)*ndim+idim-1)
        end do
    end do
!
end subroutine
