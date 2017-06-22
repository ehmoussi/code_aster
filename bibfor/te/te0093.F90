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

subroutine te0093(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/tefrep.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'CHAR_MECA_FR2D2D  '
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    integer :: ndim, nno, nnos, npg, i, k, kp, ii, iforc, ivectu
    integer :: ipoids, ivf, idfde, igeom, jgano
    real(kind=8) :: poids, r, fx, fy
!     ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ivectu)
    call tefrep(option, nomte, 'PFR2D2D', iforc)
!
    do kp = 1, npg
        k=(kp-1)*nno
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids)
!
!      --- CALCUL DE LA FORCE AUX PG (A PARTIR DES NOEUDS) ---
        fx = 0.d0
        fy = 0.d0
        do i = 1, nno
            ii = 2 * (i-1)
            fx = fx + zr(ivf+k+i-1) * zr(iforc+ii )
            fy = fy + zr(ivf+k+i-1) * zr(iforc+ii+1)
        end do
!
        if (lteatt('AXIS','OUI')) then
            r = 0.d0
            do i = 1, nno
                r = r + zr(igeom+2*(i-1))*zr(ivf+k+i-1)
            end do
            poids = poids*r
        endif
        do i = 1, nno
            zr(ivectu+2*i-2) = zr(ivectu+2*i-2) + poids * fx * zr(ivf+ k+i-1)
            zr(ivectu+2*i-1) = zr(ivectu+2*i-1) + poids * fy * zr(ivf+ k+i-1)
        end do
    end do
!
end subroutine
