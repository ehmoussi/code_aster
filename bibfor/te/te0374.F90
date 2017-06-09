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

subroutine te0374(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES MATRICES ELEMENTAIRES EN MECANIQUE
!          CORRESPONDANT A UN TERME D'IMPEDANCE EN ONDE INCIDENTE
!           IMPOSEE SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 3D
!
!!          OPTION : 'ONDE_FLUI'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
!!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
!
    integer :: icodre(2)
!!
    character(len=8) :: fami, poum
    character(len=16) :: nomres(2),nomte, option
    real(kind=8) :: nx, ny, nz, sx(9, 9), sy(9, 9), sz(9, 9), jac
    real(kind=8) :: valres(2), rho, celer
    integer :: ipoids, ivf, idfdx, idfdy, igeom, imate
    integer :: ndim, nno, ndi, ipg, npg2, imatuu, kpg, spt
    integer :: idec, jdec, kdec, ldec, nnos, jgano
!
!
!-----------------------------------------------------------------------
    integer :: i, ii, ij, ino, ionde, j, jj
    integer :: jno
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg2,jpoids=ipoids,jvf=ivf,jdfde=idfdx,jgano=jgano)
!
    idfdy = idfdx + 1
    ndi = nno*(2*nno+1)
!
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PONDECR', 'L', ionde)
    call jevech('PMATUUR', 'E', imatuu)
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
    nomres(1) = 'RHO'
    nomres(2) = 'CELE_R'
    call rcvalb(fami, kpg, spt, poum, zi(imate),&
                ' ', 'FLUIDE', 0, ' ', [0.d0],&
                2, nomres, valres, icodre, 1)
    rho = valres(1)
    celer = valres(2)
!
! --- INITIALISATION DE LA MATRICE D'IMPEDANCE
    do 10 i = 1, ndi
        zr(imatuu+i-1) = 0.d0
10  end do
!!
    if (zr(ionde) .eq. 0.d0) then
        goto 999
    else
!
!        CALCUL DES PRODUITS VECTORIELS OMI X OMJ
!
        do 1 ino = 1, nno
            i = igeom + 3*(ino-1) -1
            do 2 jno = 1, nno
                j = igeom + 3*(jno-1) -1
                sx(ino,jno) = zr(i+2) * zr(j+3) - zr(i+3) * zr(j+2)
                sy(ino,jno) = zr(i+3) * zr(j+1) - zr(i+1) * zr(j+3)
                sz(ino,jno) = zr(i+1) * zr(j+2) - zr(i+2) * zr(j+1)
 2          continue
 1      continue
!
!        BOUCLE SUR LES POINTS DE GAUSS
!
        do 101 ipg = 1, npg2
            kdec = (ipg-1)*nno*ndim
            ldec = (ipg-1)*nno
!
            nx = 0.0d0
            ny = 0.0d0
            nz = 0.0d0
!
!           CALCUL DE LA NORMALE AU POINT DE GAUSS IPG
!
            do 102 i = 1, nno
                idec = (i-1)*ndim
                do 102 j = 1, nno
                    jdec = (j-1)*ndim
!
                    nx = nx + zr(idfdx+kdec+idec) * zr(idfdy+kdec+ jdec) * sx(i,j)
                    ny = ny + zr(idfdx+kdec+idec) * zr(idfdy+kdec+ jdec) * sy(i,j)
                    nz = nz + zr(idfdx+kdec+idec) * zr(idfdy+kdec+ jdec) * sz(i,j)
!
102              continue
!
!           CALCUL DU JACOBIEN AU POINT DE GAUSS IPG
!
            jac = sqrt(nx*nx + ny*ny + nz*nz)
!
            do 103 i = 1, nno
!
                do 104 j = 1, i
                    ii = 2*i
                    jj = 2*j
                    ij = (ii-1)*ii/2 + jj
                    zr(imatuu+ij-1) = zr(imatuu+ij-1) - jac* zr( ipoids+ipg-1) * zr(ivf+ldec+i-1)&
                                      & * zr(ivf+ldec+j- 1) *rho / celer
104              continue
103          continue
101      continue
    endif
999  continue
end subroutine
