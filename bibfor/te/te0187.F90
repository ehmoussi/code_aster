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

subroutine te0187(option, nomte)
!.......................................................................
!
!     BUT: CALCUL DU VECTEUR INTENSITE ACTIVE AUX NOEUDS
!          ELEMENTS ISOPARAMETRIQUES 3D
!
!          OPTION : 'INTE_ELNO'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
    implicit none
!
#include "jeveux.h"
#include "asterc/r8pi.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
!
    integer :: icodre(1)
    character(len=16) :: nomte, option
    character(len=8) :: fami, poum
    real(kind=8) :: omega
    real(kind=8) :: omerho, pi
    complex(kind=8) :: vitx(27), vity(27), vitz(27)
!
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), jac
    integer :: idfde, igeom, idino, ipino
!
    integer :: iinte, ipres, imate, ifreq
    integer :: jgano, nno, ino, i, kpg, spt
!
!
!-----------------------------------------------------------------------
    integer :: ipoids, ivf, mater, ndim, nnos, npg
    real(kind=8) :: rho(1)
!-----------------------------------------------------------------------
    call elrefe_info(fami='NOEU',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PPRESSC', 'L', ipres)
    call jevech('PMATERC', 'L', imate)
    call jevech('PINTER', 'E', iinte)
!
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    mater=zi(imate)
    call rcvalb(fami, kpg, spt, poum, mater,&
                ' ', 'FLUIDE', 0, ' ', [0.d0],&
                1, 'RHO', rho, icodre, 1)
!
    pi=r8pi()
    call jevech('PFREQR', 'L', ifreq)
    omega=2.d0*pi*zr(ifreq)
    omerho=omega*rho(1)
!
!
!    BOUCLE SUR LES NOEUDS
    do 30 ino = 1, nno
!
        idino=iinte+(ino-1)*6-1
        ipino=ipres+ino-1
        call dfdm3d(nno, ino, ipoids, idfde, zr(igeom),&
                    jac, dfdx, dfdy, dfdz)
!
        vitx(ino)=(0.0d0,0.0d0)
        vity(ino)=(0.0d0,0.0d0)
        vitz(ino)=(0.0d0,0.0d0)
!
        do 20 i = 1, nno
!
            vitx(ino)=vitx(ino)+dfdx(i)*zc(ipres+i-1)
            vity(ino)=vity(ino)+dfdy(i)*zc(ipres+i-1)
            vitz(ino)=vitz(ino)+dfdz(i)*zc(ipres+i-1)
20      continue
!
        vitx(ino)=vitx(ino)*(0.d0,1.d0)/omerho
        vity(ino)=vity(ino)*(0.d0,1.d0)/omerho
        vitz(ino)=vitz(ino)*(0.d0,1.d0)/omerho
!
        zr(idino+1)=0.5d0*dble(zc(ipino)*dconjg(vitx(ino)))
        zr(idino+2)=0.5d0*dble(zc(ipino)*dconjg(vity(ino)))
        zr(idino+3)=0.5d0*dble(zc(ipino)*dconjg(vitz(ino)))
        zr(idino+4)=0.5d0*dimag(zc(ipino)*dconjg(vitx(ino)))
        zr(idino+5)=0.5d0*dimag(zc(ipino)*dconjg(vity(ino)))
        zr(idino+6)=0.5d0*dimag(zc(ipino)*dconjg(vitz(ino)))
30  end do
!
end subroutine
