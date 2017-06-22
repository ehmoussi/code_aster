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

subroutine te0175(option, nomte)
!.......................................................................
!
!     BUT: CALCUL DU VECTEUR INTENSITE ACTIVE AUX NOEUDS
!          ELEMENTS ISOPARAMETRIQUES 2D
!
!          OPTION : 'INTE_ELNO'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!              ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
    implicit none
#include "jeveux.h"
#include "asterc/r8pi.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
!
    integer :: idfde, igeom, idino, kpg, spt
    integer :: iinte, ipres, imate, ifreq, npg, ipoids, ivf
    integer :: nno, ino, i, ndim, nnos, jgano, mater
    real(kind=8) :: omerho, pi, dfdx(9), dfdy(9), jac, rho(1)
    integer :: icodre(1)
    character(len=8) :: fami, poum
    character(len=16) :: nomte, option
    complex(kind=8) :: vitx, vity
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
    call elrefe_info(fami='NOEU',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PPRESSC', 'L', ipres)
    call jevech('PMATERC', 'L', imate)
    call jevech('PINTER', 'E', iinte)
!
    mater=zi(imate)
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    call rcvalb(fami, kpg, spt, poum, mater,&
                ' ', 'FLUIDE', 0, '   ', [0.d0],&
                1, 'RHO', rho, icodre, 1)
!
    call jevech('PFREQR', 'L', ifreq)
    pi=r8pi()
    omerho=2.d0*pi*zr(ifreq)*rho(1)
!
!    BOUCLE SUR LES NOEUDS
    do 30 ino = 1, npg
        idino=iinte+(ino-1)*4-1
        call dfdm2d(nno, ino, ipoids, idfde, zr(igeom),&
                    jac, dfdx, dfdy)
!
        vitx=(0.0d0,0.0d0)
        vity=(0.0d0,0.0d0)
        do 20 i = 1, nno
            vitx=vitx+dfdx(i)*zc(ipres+i-1)
            vity=vity+dfdy(i)*zc(ipres+i-1)
20      continue
!
        vitx=vitx*(0.d0,1.d0)/omerho
        vity=vity*(0.d0,1.d0)/omerho
!
        zr(idino+1)=0.5d0*dble(zc(ipres+ino-1)*dconjg(vitx))
        zr(idino+2)=0.5d0*dble(zc(ipres+ino-1)*dconjg(vity))
        zr(idino+3)=0.5d0*dimag(zc(ipres+ino-1)*dconjg(vitx))
        zr(idino+4)=0.5d0*dimag(zc(ipres+ino-1)*dconjg(vity))
30  end do
!
end subroutine
