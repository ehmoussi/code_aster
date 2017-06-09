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

subroutine te0016(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tefrep.h"
    character(len=16) :: option, nomte
!.......................................................................
!
!     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
!          ELEMENTS ISOPARAMETRIQUES 3D
!
!          OPTION : 'CHAR_MECA_FORC_R '
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!              ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
!
    integer :: ipoids, ivf, idfde, igeom, iforc
    integer :: jgano, nno, ndl, kp, npg, ii, i, l, ivectu, ndim, nnos
    real(kind=8) :: poids, fx, fy, fz
!     ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ivectu)
    call tefrep(option, nomte, 'PFR3D3D', iforc)
!
    ndl = 3*nno
    do i = 1, ndl
        zr(ivectu+i-1) = 0.0d0
    end do
!
!
!     BOUCLE SUR LES POINTS DE GAUSS
    do kp = 1, npg
        l = (kp-1)*nno
        call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids)
!
!       CALCUL DE LA FORCE AUX PG (A PARTIR DES NOEUDS) ---
        fx = 0.0d0
        fy = 0.0d0
        fz = 0.0d0
        do i = 1, nno
            ii = 3*(i-1)
            fx = fx + zr(ivf-1+l+i)*zr(iforc+ii )
            fy = fy + zr(ivf-1+l+i)*zr(iforc+ii+1)
            fz = fz + zr(ivf-1+l+i)*zr(iforc+ii+2)
        end do
!
        do i = 1, nno
            ii = 3* (i-1)
            zr(ivectu+ii ) = zr(ivectu+ii ) + poids*zr(ivf+l+i-1)*fx
            zr(ivectu+ii+1) = zr(ivectu+ii+1) + poids*zr(ivf+l+i-1)* fy
            zr(ivectu+ii+2) = zr(ivectu+ii+2) + poids*zr(ivf+l+i-1)* fz
        end do
    end do
!
!
end subroutine
