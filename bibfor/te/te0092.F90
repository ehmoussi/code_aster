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

subroutine te0092(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
!                          OPTION : 'RIGI_MECA_GEOM  '
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    real(kind=8) :: dfdx(9), dfdy(9), poids, r, zero, un, axis
    real(kind=8) :: sxx, sxy, syy
    integer :: nno, kp, k, npg, ii, jj, i, j, imatuu, kd1, kd2, ij1, ij2
    integer :: ipoids, ivf, idfde, igeom, icontr, kc
!
!
!-----------------------------------------------------------------------
    integer :: jgano, ndim, nnos
!-----------------------------------------------------------------------
    zero=0.d0
    un  =1.d0
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTRR', 'L', icontr)
    call jevech('PMATUUR', 'E', imatuu)
!
    axis=zero
    r   =un
    if (lteatt('AXIS','OUI')) axis=un
!
    do 101 kp = 1, npg
        k=(kp-1)*nno
        kc=icontr+4*(kp-1)
        sxx=zr(kc )
        syy=zr(kc+1)
        sxy=zr(kc+3)
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy)
        if (axis .gt. 0.5d0) then
            r = zero
            do 102 i = 1, nno
                r = r + zr(igeom+2*(i-1))*zr(ivf+k+i-1)
102          continue
            do 103 i = 1, nno
                dfdx(i)=dfdx(i)+zr(ivf+k+i-1)/r
103          continue
            poids=poids*r
        endif
!
        kd1=2
        kd2=1
        do 106 i = 1, 2*nno, 2
            kd1=kd1+2*i-3
            kd2=kd2+2*i-1
            ii = (i+1)/2
            do 107 j = 1, i, 2
                jj = (j+1)/2
                ij1=imatuu+kd1+j-2
                ij2=imatuu+kd2+j-1
                zr(ij2) = zr(ij2) +poids*( dfdx(ii)*(dfdx(jj)*sxx+ dfdy(jj)*sxy)+ dfdy(ii)*(dfdx(&
                          &jj)*sxy+dfdy(jj)*syy))
                zr(ij1) = zr(ij2)
107          continue
106      continue
!
101  end do
end subroutine
