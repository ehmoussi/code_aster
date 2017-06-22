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

subroutine te0090(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/tefrep.h"
#include "asterfort/vff2dn.h"
    character(len=16) :: option, nomte
! ......................................................................
!
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'CHAR_MECA_FR1D2D'
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    integer :: nno, nnos, jgano, ndim, kp, npg, ipoids, ivf, idfde, igeom
    integer :: ivectu, k, i, iforc, ii
    real(kind=8) :: poids, r, fx, fy, nx, ny
    aster_logical :: laxi
!     ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ivectu)
    call tefrep(option, nomte, 'PFR1D2D', iforc)
!
!
    do 40 kp = 1, npg
        k = (kp-1)*nno
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
!
!        --- CALCUL DE LA FORCE AUX PG (A PARTIR DES NOEUDS) ---
        fx = 0.0d0
        fy = 0.0d0
        do 10 i = 1, nno
            ii = 2* (i-1)
            fx = fx + zr(iforc+ii)*zr(ivf+k+i-1)
            fy = fy + zr(iforc+ii+1)*zr(ivf+k+i-1)
 10     continue
!
        if (laxi) then
            r = 0.d0
            do 20 i = 1, nno
                r = r + zr(igeom+2* (i-1))*zr(ivf+k+i-1)
 20         continue
            poids = poids*r
        endif
!
        do 30 i = 1, nno
            zr(ivectu+2* (i-1)) = zr(ivectu+2* (i-1)) + fx*zr(ivf+k+i- 1)*poids
            zr(ivectu+2* (i-1)+1) = zr(ivectu+2* (i-1)+1) + fy*zr(ivf+ k+i-1 )*poids
 30     continue
!
 40 end do
!
end subroutine
