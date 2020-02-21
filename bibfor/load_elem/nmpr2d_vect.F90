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
subroutine nmpr2d_vect(l_axis,&
                       nno   , npg , ndof ,&
                       ipoids, ivf , idfde,&
                       geom  , pres, cisa ,&
                       vect)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/vff2dn.h"
!
aster_logical, intent(in) :: l_axis
integer, intent(in) :: nno, npg, ndof
integer, intent(in) :: ipoids, ivf, idfde
real(kind=8), intent(in) :: geom(2, nno)
real(kind=8), intent(in) :: pres(npg), cisa(npg)
real(kind=8), intent(out) :: vect(ndof, nno)
!
! --------------------------------------------------------------------------------------------------
!
! Loads computation
!
! Pressure for faces of 2D elements - Second member
!
! --------------------------------------------------------------------------------------------------
!
! In  nno              : number of nodes
! In  nng              : number of Gauss points
! In  ndof             : number of dof by node
! In  geom             : coordinates of nodes
! In  pres             : pressure at Gauss points
! In  cisa             : shear at Gauss points
! Out vect             : second member
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: ndim = 1
    integer :: kpg, ino, kdec
    real(kind=8) :: poids, r
    real(kind=8) :: nx, ny, tx, ty
!
! --------------------------------------------------------------------------------------------------
!
    vect(1:ndof, 1:nno) = 0.d0
!
! - Loop on Gauss points
!
    do kpg = 1, npg
        kdec = (kpg-1)*nno
! ----- Compute geometric quantities
        call vff2dn(ndim  , nno, kpg,&
                    ipoids, idfde,&
                    geom  , nx, ny, poids)
        if (l_axis) then
            r = 0.d0
            do ino = 1, nno
                r = r + geom(1,ino)*zr(ivf+kdec+ino-1)
            end do
            poids = poids*r
        endif
! ----- Compute vector
        tx = -nx*pres(kpg) - ny*cisa(kpg)
        ty = -ny*pres(kpg) + nx*cisa(kpg)
        do ino = 1, nno
            vect(1,ino) = vect(1,ino) + tx*zr(ivf+kdec+ino-1)*poids
            vect(2,ino) = vect(2,ino) + ty*zr(ivf+kdec+ino-1)*poids
        end do
    enddo
!
end subroutine
