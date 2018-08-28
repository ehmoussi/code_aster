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
subroutine mmvitm(nbdm , ndim , nne  , nnm  ,&
                  ffe  , ffm  ,&
                  vitme, vitmm, vitpe, vitpm,&
                  accme, accmm)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
!
integer, intent(in) :: nbdm, ndim, nne, nnm
real(kind=8), intent(in) :: ffe(9), ffm(9)
real(kind=8), intent(out) :: accme(3), vitme(3), accmm(3), vitmm(3)
real(kind=8), intent(out) :: vitpe(3), vitpm(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute increment of speeds/accelerations
!
! --------------------------------------------------------------------------------------------------
!
! In  nbdm             : number of components by node for all dof
! In  ndim             : dimension of problem (2 or 3)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! Out vitme            : speed for contact point at beginning of time step
! Out vitmm            : speed for projection of contact point at beginning of time step
! Out vitpe            : speed for contact point at end of time step
! Out vitpm            : speed for projection of contact point at end of time step
! Out accme            : acceleration for contact point at beginning of time step
! Out accmm            : acceleration for projection of contact point at beginning of time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jvitm, jvitp, jaccm
    integer :: idim, inoe, inom
!
! --------------------------------------------------------------------------------------------------
!
    vitpm(:) = 0.d0
    vitpe(:) = 0.d0
    vitme(:) = 0.d0
    accme(:) = 0.d0
    vitmm(:) = 0.d0
    accmm(:) = 0.d0
    vitpe(:) = 0.d0
!
    call jevech('PVITE_P', 'L', jvitp)
    call jevech('PVITE_M', 'L', jvitm)
    call jevech('PACCE_M', 'L', jaccm)
!
! - For slave nodes
!
    do idim = 1, ndim
        do inoe = 1, nne
            vitpe(idim) = vitpe(idim) + ffe(inoe)* zr(jvitp+(inoe-1)* nbdm+idim-1)
            vitme(idim) = vitme(idim) + ffe(inoe)* zr(jvitm+(inoe-1)* nbdm+idim-1)
            accme(idim) = accme(idim) + ffe(inoe)* zr(jaccm+(inoe-1)* nbdm+idim-1)
        end do
    end do
!
! - For master nodes
!
    do idim = 1, ndim
        do inom = 1, nnm
            vitpm(idim) = vitpm(idim) + ffm(inom)* zr(jvitp+nne*nbdm+( inom-1)*ndim+idim-1)
            vitmm(idim) = vitmm(idim) + ffm(inom)* zr(jvitm+nne*nbdm+( inom-1)*ndim+idim-1)
            accmm(idim) = accmm(idim) + ffm(inom)* zr(jaccm+nne*nbdm+( inom-1)*ndim+idim-1)
        end do
    end do
!
end subroutine
