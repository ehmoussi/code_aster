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

subroutine te0474(option, nomte)
    implicit none
!
! 'RIGI_MECA_GE' option for SHB elements
!
!
! 'RIGI_MECA_GE' option for solid-shell elements SHB6, SHB8, SHB15 & SHB20.
! Computation of 3D elementary matrix.
!
!
! IN  option   'RIGI_MECA_GE'
! IN  nomte    elment type name
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/jevech.h"
#include "asterfort/r8inir.h"
!
#include "asterfort/dfdmshb.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/sshini.h"
#include "asterfort/tmassf.h"
#include "asterfort/tpsivp_shb.h"
!
    character(len=16) :: option
    character(len=16) :: nomte
!
    aster_logical :: hexa, shb6, shb8
    integer :: i, ic, icont, icoopg, idfde, igeom
    integer :: ijkl, ik, imatuu, ipoids, ivf
    integer :: j, k, kpg, l, ndim, nno, nnos, npg
    character(len=4) :: fami
    real(kind=8) :: poids, scfact, tmp
    real(kind=8) :: sigma(6)
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27)
    real(kind=8), dimension(3,3) :: pgl, invjac
    real(kind=8) :: a(3,3,27,27)
!
! ......................................................................
!
    parameter(scfact = 0.2025d0)
    parameter(fami = 'RIGI')
!
! - Finite element informations
!
    call elrefe_info(fami=fami, ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jcoopg=icoopg, jvf=ivf, jdfde=idfde)
!
! - Geometry
!
    call jevech('PGEOMER', 'L', igeom)
!
!   Retrieving stresses
!
    call jevech('PCONTRR', 'L', icont)
!
!   Initialization of specific SHB variables
!
    call sshini(nno, nnos, hexa, shb6, shb8)
!
! - Outputs - Stiffness matrix
!
    call jevech('PMATUUR', 'E', imatuu)
!
! - Other initializations
!
    do 50 k = 1, 3
       do 40 l = 1, 3
          do 30 i = 1, nno
             do 20 j = 1, i
                a(k,l,i,j) = 0.d0
20           continue
30        continue
40     continue
50  continue
!
!
! - Loop over Gauss points \ Start
!
    do 80 kpg = 1, npg
!
!      Evaluate pgl(3,3) transformation matrix from global coordinate system
!      to local 'shell' coordinate system
!
       call tmassf(zr(igeom), icoopg, kpg, hexa, pgl)
!
!      Evaluating shape function derivatives
       call dfdmshb(nno, kpg, ipoids, idfde, zr(igeom), invjac, poids, dfdx, dfdy, dfdz)
!
       ic = icont+18*(kpg-1)-1
!
!      Retrieving stresses (stored in local frame)
       do 940 i = 1, 6
          sigma(i) = zr(ic+i)
940    continue
!
!      Glut \ Start
       tmp      = sigma(5) 
       sigma(5) = sigma(6)
       sigma(6) = tmp
!      Glut \ End
!
!      Expressing strain tensor at T+ from local to global frame
       call tpsivp_shb(pgl, sigma, .false._1)
!
       if (shb6) then
          sigma(5) = scfact * sigma(5)
          sigma(6) = scfact * sigma(6)
       end if
!
       do 70 i = 1, nno
          do 60 j = 1, i
             a(1,1,i,j) = a(1,1,i,j)&
                        + poids * ( sigma(1) *  dfdx(i)*dfdx(j)&
                        +           sigma(2) *  dfdy(i)*dfdy(j)&
                        +           sigma(3) *  dfdz(i)*dfdz(j)&
                        +           sigma(4) * (dfdx(i)*dfdy(j)+dfdy(i)*dfdx(j))&
                        +           sigma(5) * (dfdz(i)*dfdx(j)+dfdx(i)*dfdz(j))&
                        +           sigma(6) * (dfdy(i)*dfdz(j)+dfdz(i)*dfdy(j)))
60        continue
70     continue
!
80  continue
!
! - Loop over Gauss points \ End
!
    do 100 i = 1, nno
       do 90 j = 1, i
          a(2,2,i,j) = a(1,1,i,j)
          a(3,3,i,j) = a(1,1,i,j)
90     continue
100 continue
!
!   Transforming a (rectangular) to zr(imatuu) (triangular)
!
    do 140 k = 1, 3
        do 130 l = 1, 3
            do 120 i = 1, nno
                ik = ((3*i+k-4)* (3*i+k-3))/2
                do 110 j = 1, i
                    ijkl = ik + 3* (j-1) + l
                    zr(imatuu+ijkl-1) = a(k,l,i,j)
110              continue
120          continue
130      continue
140  continue
!
end subroutine
