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

subroutine te0192(option, nomte)
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
!                          OPTION : 'CHAR_MECA_PRES_R'
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
!
    integer :: nno, nnos, jgano, ndim, kp, npg, ipoids, ivf, idfde, igeom
    integer :: ipres, ivectu, k, i
    real(kind=8) :: poids, r, tx, ty, nx, ny, pres
!     ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PPRESSR', 'L', ipres)
    call jevech('PVECTUR', 'E', ivectu)
!
    do 30 kp = 1, npg
        k = (kp-1)*nno
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
        r = 0.d0
        pres = 0.d0
        do 10 i = 1, nno
            r = r + zr(igeom+2* (i-1))*zr(ivf+k+i-1)
            pres = pres + zr(ipres+i-1)*zr(ivf+k+i-1)
10      continue
!
        poids = poids*r
        tx = -nx*pres
        ty = -ny*pres
!
        do 20 i = 1, nno
            zr(ivectu+3*i-3) = zr(ivectu+3*i-3) + tx*zr(ivf+k+i-1)* poids
            zr(ivectu+3*i-2) = zr(ivectu+3*i-2) + ty*zr(ivf+k+i-1)* poids
            zr(ivectu+3*i-1) = 0.d0
20      continue
30  end do
!
end subroutine
