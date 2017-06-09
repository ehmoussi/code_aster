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

subroutine te0026(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES MATRICES DE RIGIDITE_GEOMETRIQUE EN MECANIQUE
!          ELEMENTS ISOPARAMETRIQUES 3D
!
!          OPTION : 'RIGI_MECA_GE '
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
!
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
    character(len=16) :: nomte, option
    real(kind=8) :: a(3, 3, 27, 27)
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), poids
    integer :: ipoids, ivf, idfde, igeom
    integer :: jgano, nno, kp, npg1, i, j, imatuu
!
!
!
!-----------------------------------------------------------------------
    integer :: ic, icontr, ijkl, ik, k, l, ndim
    integer :: nnos
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTRR', 'L', icontr)
!
    call jevech('PMATUUR', 'E', imatuu)
!
    do 50 k = 1, 3
        do 40 l = 1, 3
            do 30 i = 1, nno
                do 20 j = 1, i
                    a(k,l,i,j) = 0.d0
20              continue
30          continue
40      continue
50  end do
!
!
!    BOUCLE SUR LES POINTS DE GAUSS
!
    do 80 kp = 1, npg1
!
        ic = icontr + (kp-1)*6
        call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy, dfdz)
!
        do 70 i = 1, nno
            do 60 j = 1, i
!
                a(1,1,i,j) = a(1,1,i,j) + poids* (zr(ic)*dfdx(i)*dfdx( j)+zr(ic+1)*dfdy(i)* dfdy(&
                             &j)+zr(ic+2)*dfdz(i)*dfdz(j)+ zr(ic+3)* (dfdx(i)*dfdy(j)+dfdy(i)*dfd&
                             &x(j))+ zr(ic+4)* (dfdz(i)*dfdx(j)+dfdx(i)*dfdz(j))+ zr(ic+5)* (dfdy&
                             &(i)* dfdz(j)+dfdz(i)*dfdy(j)))
!
60          continue
70      continue
!
80  end do
!
    do 100 i = 1, nno
        do 90 j = 1, i
            a(2,2,i,j) = a(1,1,i,j)
            a(3,3,i,j) = a(1,1,i,j)
90      continue
100  end do
!
! PASSAGE DU STOCKAGE RECTANGULAIRE (A) AU STOCKAGE TRIANGULAIRE (ZR)
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
140  end do
!
end subroutine
