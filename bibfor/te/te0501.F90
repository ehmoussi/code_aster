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

subroutine te0501(option, nomte)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/ntfcma.h"
#include "asterfort/rcfode.h"
!
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
!    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
!                          OPTION : 'RIGI_THER_TRANS'
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
!
    real(kind=8) :: dfdx(9), dfdy(9), poids, r, tpg, xkpt, alpha
    integer :: kp, i, j, k, itemps, ifon(3), imattt, igeom, imate
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfde, jgano
! DEB ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: ij, itemp, itempi
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPER', 'L', itemp)
    call jevech('PTEMPEI', 'L', itempi)
    call jevech('PMATTTR', 'E', imattt)
!
    call ntfcma(' ',zi(imate), ifon)
    do 101 kp = 1, npg
        k=(kp-1)*nno
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy)
        r = 0.d0
        tpg = 0.d0
        do 102 i = 1, nno
            r = r + zr(igeom+2*(i-1))*zr(ivf+k+i-1)
            tpg =tpg + zr(itempi+i-1)*zr(ivf+k+i-1)
102      continue
        if (lteatt('AXIS','OUI')) poids = poids*r
!
        call rcfode(ifon(2), tpg, alpha, xkpt)
!
        ij = imattt - 1
        do 103 i = 1, nno
!
            do 103 j = 1, i
                ij = ij + 1
                zr(ij) = zr(ij) + poids*( alpha*(dfdx(i)*dfdx(j)+dfdy( i)*dfdy(j)) )
!
103          continue
101  end do
!
! FIN ------------------------------------------------------------------
end subroutine
