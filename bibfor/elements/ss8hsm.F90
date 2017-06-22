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

subroutine ss8hsm(geom, para, matuu)
!
    implicit none
!
! Solid-Shell 8 Hourglass Stabilization Matrix
!
!
! Hourglass stabilization Matrix evaluated at the center of the element
! in a corotional frame
!
!
! IN  geom       element node coordinates
! IN  para       material parameters E and nu
! INOUT  matuu  stiffness matrix completed with stabilization terms
!
#include "jeveux.h"
#include "asterfort/asvgam.h"
#include "asterfort/fbbbh8.h"
#include "asterfort/hgksca.h"
#include "asterfort/r8inir.h"
#include "asterfort/ss8rco.h"
#include "asterfort/utbtab.h"
#include "asterfort/utpvgl.h"
!
    real(kind=8), intent(in) :: geom(24)
    real(kind=8), intent(in) :: para(2)
    real(kind=8), intent(inout) :: matuu(*)
!
    integer :: i, j, k
    real(kind=8) :: xeloc(24)
    real(kind=8) :: xk(3,2), gam(4,8)
    real(kind=8), dimension(3,3) :: rr33
    real(kind=8), dimension(24,24) :: rr2424, kstablc, kstabgl, work2424
    real(kind=8) :: bbar(3,8)
!
! --------------------------------------------------------------------------------------------------
!
!      Evaluate rr33(3,3) transformation matrix from global to local
!      corotational frame
!
       call ss8rco(geom, rr33)
!
!      Expressing element nodal coordinates into corotational frame
!
       call utpvgl(8, 3, rr33, geom, xeloc)
!
!      Evaluate [B] bar matrix in corotational frame
!      Use of Flanagan-Belytschko 'mean' form
!
       call fbbbh8(xeloc, bbar)
!
!      Gamma ratio for assumed strain method
!
       call asvgam(2, xeloc, bbar, gam)
!
!      Evaluate hourglass stabilization matrix in corotational frame
!
       call hgksca(para, xeloc, gam, xk, kstablc)
!
!      Assemble rr2424(24,24) transformation matrix from r33(3,3)
!      to express stabilization matrix in global coordinate system
!
       call r8inir(576, 0.d0, rr2424, 1)
       do 10 k = 1, 8
          do 20 j = 1, 3
             do 30 i = 1, 3
                rr2424((k-1)*3+i,(k-1)*3+j) = rr33(i,j)
30           continue
20        continue
10     continue
!
!      Express hourglass stabilization matrix in global coordinate system
!
       call utbtab('ZERO', 24, 24, kstablc, rr2424, work2424, kstabgl)
!
!      Adding stabilization matrix to elementary stiffness matrix considering
!      symmetry
!
       k = 0
       do 40 i = 1, 24
          do 50 j = 1, i
             k = k + 1
             matuu(k) = matuu(k) + kstabgl(i,j)
50        continue
40     continue
!
end subroutine
