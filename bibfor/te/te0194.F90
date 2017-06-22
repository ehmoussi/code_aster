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

subroutine te0194(option, nomte)
    implicit   none
#include "jeveux.h"
!
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/vff2dn.h"
    character(len=16) :: option, nomte
! ......................................................................
!
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          ELEMENTS 2D AXISYMETRIQUES FOURIER
!                          OPTION : 'CHAR_MECA_FR1D2D'
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    integer :: nno, nnos, jgano, ndim, kp, npg, ipoids, ivf, idfde, igeom
    integer :: ivectu, k, i, iforc
    real(kind=8) :: poids, r, fx, fy, fz, nx, ny
!     ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PFR1D2D', 'L', iforc)
    call jevech('PVECTUR', 'E', ivectu)
!
    do 40 kp = 1, npg
        k = (kp-1)*nno
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
!
!        --- CALCUL DE LA FORCE AUX PG (A PARTIR DES NOEUDS) ---
!
        fx = 0.0d0
        fy = 0.0d0
        fz = 0.0d0
        do 10 i = 1, nno
            fx = fx + zr(iforc-1+3* (i-1)+1)*zr(ivf+k+i-1)
            fy = fy + zr(iforc-1+3* (i-1)+2)*zr(ivf+k+i-1)
            fz = fz + zr(iforc-1+3* (i-1)+3)*zr(ivf+k+i-1)
10      continue
!
        r = 0.d0
        do 20 i = 1, nno
            r = r + zr(igeom+2* (i-1))*zr(ivf+k+i-1)
20      continue
        poids = poids*r
!
        do 30 i = 1, nno
            zr(ivectu+3* (i-1)) = zr(ivectu+3* (i-1)) + fx*zr(ivf+k+i- 1)*poids
            zr(ivectu+3* (i-1)+1) = zr(ivectu+3* (i-1)+1) + fy*zr(ivf+ k+i-1 )*poids
            zr(ivectu+3* (i-1)+2) = zr(ivectu+3* (i-1)+2) + fz*zr(ivf+ k+i-1 )*poids
30      continue
!
40  end do
!
end subroutine
