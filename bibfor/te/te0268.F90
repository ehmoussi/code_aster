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

subroutine te0268(option, nomte)
    implicit none
#include "jeveux.h"
!
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/vff2dn.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES MATRICES ELEMENTAIRES
!                          OPTION : 'RIGI_THER_COEF_F'
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
!-----------------------------------------------------------------------
    integer :: icode, icoefh, jgano, nbres, ndim, nnos
!-----------------------------------------------------------------------
    parameter (nbres=3)
    character(len=8) :: nompar(nbres)
    real(kind=8) :: valpar(nbres), poids, r, z, coefh, nx, ny, theta
    integer :: nno, kp, npg, ipoids, ivf, idfde, igeom
    integer :: itemps, imattt, k, i, j, ij, li, lj
!
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PCOEFHF', 'L', icoefh)
    call jevech('PMATTTR', 'E', imattt)
    theta = zr(itemps+2)
!
    do 40 kp = 1, npg
        k = (kp-1)*nno
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
        r = 0.d0
        z = 0.d0
        do 10 i = 1, nno
            r = r + zr(igeom+2*i-2)*zr(ivf+k+i-1)
            z = z + zr(igeom+2*i-1)*zr(ivf+k+i-1)
10      continue
        poids = poids*r
        valpar(1) = r
        nompar(1) = 'X'
        valpar(2) = z
        nompar(2) = 'Y'
        valpar(3) = zr(itemps)
        nompar(3) = 'INST'
        call fointe('FM', zk8(icoefh), 3, nompar, valpar,&
                    coefh, icode)
        ij = imattt - 1
        do 30 i = 1, nno
            li = ivf + k + i - 1
            do 20 j = 1, i
                lj = ivf + k + j - 1
                ij = ij + 1
                zr(ij) = zr(ij) + poids*theta*zr(li)*zr(lj)*coefh
20          continue
30      continue
40  end do
end subroutine
