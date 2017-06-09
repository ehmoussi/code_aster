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

subroutine te0094(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'CHAR_ME_FF2D2D  '
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    integer :: ndim, nno, nnos, kp, npg, i, k, itemps, ifr2d, ivectu, icode
    integer :: nbres, jgano, ipoids, ivf, idfde, igeom
    parameter     ( nbres=3 )
    real(kind=8) :: valpar(nbres)
    real(kind=8) :: poids, r, z, tx, ty
    character(len=8) :: nompar(nbres)
!     ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PFF2D2D', 'L', ifr2d)
    call jevech('PTEMPSR', 'L', itemps)
    nompar(1) = 'X'
    nompar(2) = 'Y'
    nompar(3) = 'INST'
    valpar(3) = zr(itemps)
    call jevech('PVECTUR', 'E', ivectu)
!
    do kp = 1, npg
        k=(kp-1)*nno
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids)
        r = 0.d0
        z = 0.d0
        do i = 1, nno
            r = r + zr(igeom+2*i-2)*zr(ivf+k+i-1)
            z = z + zr(igeom+2*i-1)*zr(ivf+k+i-1)
        end do
        if (lteatt('AXIS','OUI')) poids = poids*r
        valpar(1) = r
        valpar(2) = z
        call fointe('FM', zk8(ifr2d ), 3, nompar, valpar,&
                    tx, icode)
        call fointe('FM', zk8(ifr2d+1), 3, nompar, valpar,&
                    ty, icode)
        do i = 1, nno
            zr(ivectu+2*i-2) = zr(ivectu+2*i-2) + poids * tx * zr(ivf+ k+i-1)
            zr(ivectu+2*i-1) = zr(ivectu+2*i-1) + poids * ty * zr(ivf+ k+i-1)
        end do
    end do
end subroutine
