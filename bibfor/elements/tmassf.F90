! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine tmassf(geom, icoopg, kpg, hexa, pgl)
    implicit none
!
! Transformation MAtrix to Solid-Shell Frame
!
!
! Evaluation of transformation matrix from global coordinates to solid-shell
! local coordinates.
!
!
! IN  geom     element's nodes coordinates
! IN  icoopg   index to element Gauss point coordinates
! IN  kpg      current Gauss point index
! IN  hexa     true if current solid-shell element is a hexa
! OUT pgl      transformation matrix
!
#include "jeveux.h"
#include "asterf_types.h"
!
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
!
    real(kind=8), intent(in) :: geom(*)
    integer, intent(in) :: icoopg
    integer, intent(in) :: kpg
    aster_logical, intent(in) :: hexa
    real(kind=8), intent(out) :: pgl(3,3)
!
    integer :: i, j, nnob, nshift, iret
    real(kind=8) :: xcoq(3,4)
    real(kind=8) :: zeta, zlamb
!
! --------------------------------------------------------------------------------------------------
!
!      Initializations
!
    if (hexa) then
!      Initializations for SHB8 or SHB20
       nnob=4
       nshift=9
    else
!      Initializations for SHB6 or SHB15
       nnob=3
       nshift=6
    endif
!
!      Identification of the 3 (SHB6 or SHB15) or 4 nodes (SHB8 or SHB20)
!      defining the equivalent 'shell' plane
!
       zeta = zr(icoopg-1+kpg*3)
       zlamb = 0.5d0*(1.d0-zeta)
       do 10 i = 1, nnob
          do 11 j = 1, 3
             xcoq(j,i) = zlamb*geom((i-1)*3+j) + (1.d0-zlamb)*geom(+3*i+nshift+j)
11       continue
10    continue
!
!      Evaluate pgl(3,3) transformation matrix from global coordinate system
!      to local 'shell' coordinate system
!
       if (hexa) then
!         SHB8 OU SHB20
          call dxqpgl(xcoq, pgl, 'S', iret)
       else
!         SHB6 OU SHB15
          call dxtpgl(xcoq, pgl)
       endif
!
end subroutine
