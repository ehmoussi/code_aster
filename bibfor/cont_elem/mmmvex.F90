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
subroutine mmmvex(nnl, nbcps, ndexfr, vectff)
!
implicit none
!
#include "asterfort/isdeco.h"
!
integer, intent(in) :: nnl, nbcps, ndexfr
real(kind=8), intent(inout) :: vectff(18)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Modify vector for excluded nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  ndexfr           : integer for EXCL_FROT_* keyword
! IO  vectff           : vector for DOF [friction]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, l, ii, nbcpf
    integer :: ndexcl(10)
!
! --------------------------------------------------------------------------------------------------
!
    nbcpf = nbcps - 1
!
    if (ndexfr .ne. 0) then
        call isdeco([ndexfr], ndexcl, 10)
        do i = 1, nnl
            if (ndexcl(i) .eq. 1) then
                do l = 1, nbcpf
                    if ((l.eq.2) .and. (ndexcl(10).eq.0)) then
                        cycle
                    endif
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = 0.d0
                end do
            endif
        end do
    endif
!
end subroutine
