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

subroutine te0114(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
!
    character(len=16) :: nomte, option
! ......................................................................
!
!     BUT: CALCUL DES DEFORMATIONS AUX NOEUDS EN MECANIQUE
!          ELEMENTS ISOPARAMETRIQUES 2D FOURIER
!
!            OPTION : 'EPSI_ELGA'
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    real(kind=8) :: r, xh, wi, u(3, 9), depg(54)
    real(kind=8) :: dfdr(9), dfdz(9), poids
    integer :: ipoids, ivf, idfde, igeom
    integer :: npg, nnos, jgano, ndim, kdec, nh
    integer :: nno, kp, iharmo, i, idefo, idepl, idpg, igau, isig
!
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PDEPLAR', 'L', idepl)
    call jevech('PHARMON', 'L', iharmo)
    nh = zi(iharmo)
    xh = dble(nh)
    call jevech('PDEFOPG', 'E', idefo)
!
    do 112 i = 1, 6*npg
        depg (i) = 0.0d0
112  continue
!
    do 113 i = 1, nno
        u(1,i) = zr(idepl + 3 * i - 3)
        u(2,i) = zr(idepl + 3 * i - 2)
        u(3,i) = zr(idepl + 3 * i - 1)
113  continue
!
!    BOUCLE SUR LES POINTS DE GAUSS
!
    do 101 kp = 1, npg
!
        idpg = (kp-1) * 6
        kdec = (kp-1) * nno
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdr, dfdz)
        r = 0.d0
        do 102 i = 1, nno
            r = r + zr(igeom+2*(i-1))*zr(ivf+kdec+i-1)
102      continue
!
        do 106 i = 1, nno
            wi = zr(ivf+kdec+i-1)/r
!
            depg(idpg+1) = depg(idpg+1) + u(1,i) * dfdr(i)
!
            depg(idpg+2) = depg(idpg+2) + u(2,i) * dfdz(i)
!
            depg(idpg+3) = depg(idpg+3) + (u(1,i) + xh * u(3,i)) * wi
!
            depg(idpg+4) = depg(idpg+4) + (u(2,i)*dfdr(i) + u(1,i)* dfdz(i)) * 0.5d0
!
            depg(idpg+5) = depg(idpg+5) - u(1,i) * 0.5d0 * xh * wi + u(3,i) * 0.5d0 * (dfdr(i) - &
                           &wi)
!
            depg(idpg+6) = depg(idpg+6) - u(2,i) * 0.5d0 * xh * wi + u(3,i) * 0.5d0 * dfdz(i)
!
106      continue
!
101  end do
!
    do 120 igau = 1, npg
        do 121 isig = 1, 6
            zr(idefo+6*(igau-1)+isig-1) = depg(6*(igau-1)+isig)
121      continue
120  continue
!
end subroutine
