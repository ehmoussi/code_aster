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
subroutine nmpr3d_vect(nno   , npg , ndof,&
                       poidsg, vff , dff ,&
                       geom  , pres, vect)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/subaco.h"
#include "asterfort/sumetr.h"
!
integer, intent(in) :: nno, npg, ndof
real(kind=8), intent(in) :: poidsg(npg), vff(nno, npg), dff(2, nno, npg)
real(kind=8), intent(in) :: geom(3, nno)
real(kind=8), intent(in) :: pres(npg)
real(kind=8), intent(out) :: vect(ndof, nno)
!
! --------------------------------------------------------------------------------------------------
!
! Loads computation
!
! Pressure for faces of 3D elements - Second member
!
! --------------------------------------------------------------------------------------------------
!
! In  nno              : number of nodes
! In  nng              : number of Gauss points
! In  ndof             : number of dof by node
! In  poidsg           : weight of Gauss points
! In  vff              : shape functions at Gauss points
! In  dff              : derivative of shape functions at Gauss point point
! In  geom             : coordinates of nodes
! In  pres             : pressure at Gauss points
! Out vect             : second member
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kpg, n, i
    real(kind=8) :: cova(3, 3), metr(2, 2), jac
!
! --------------------------------------------------------------------------------------------------
!
    vect(1:ndof, 1:nno) = 0.d0
!
! - Loop on Gauss points
!
    do kpg = 1, npg
! ----- Covariant basis
        call subaco(nno, dff(1, 1, kpg), geom, cova)
! ----- Metric tensor
        call sumetr(cova, metr, jac)
! ----- Compute
        do n = 1, nno
            do i = 1, 3
                vect(i,n) = vect(i,n) - &
                            poidsg(kpg) * jac * pres(kpg) * cova(i,3)*vff(n,kpg)
            enddo
        enddo
     enddo
!
end subroutine
