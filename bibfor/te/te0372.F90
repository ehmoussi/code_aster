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

subroutine te0372(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES MATRICES ELEMENTAIRES EN MECANIQUE
!          CORRESPONDANT A UN TERME D'AMORTISSEMENT EN ONDE INCIDENTE
!           IMPOSEE SUR DES FACES 1D D'ELEMENTS ISOPARAMETRIQUES 2D
!
!!          OPTION : 'ONDE_FLUI'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rcvalb.h"
#include "asterfort/vff2dn.h"
!
    integer :: icodre(2), kpg, spt
    character(len=8) :: fami, poum
    character(len=16) :: nomres(2), nomte, option
    real(kind=8) :: nx, ny, poids
    real(kind=8) :: valres(2), rho, celer
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: ndi, nno, kp, npg, imatuu
    integer :: ldec, ionde
    aster_logical :: laxi
!
!
!-----------------------------------------------------------------------
    integer :: i, ii, ij, j, jgano, jj, ndim
    integer :: nnos
    real(kind=8) :: r
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    ndi = nno* (2*nno+1)
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
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
    do 10 i = 1, ndi
        zr(imatuu+i-1) = 0.d0
 10 end do
!
    if (zr(ionde) .eq. 0.d0) goto 60
!
    do 50 kp = 1, npg
        ldec = (kp-1)*nno
!
        nx = 0.0d0
        ny = 0.0d0
!
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
!
        if (laxi) then
            r = 0.d0
            do 20 i = 1, nno
                r = r + zr(igeom+2* (i-1))*zr(ivf+ldec+i-1)
 20         continue
            poids = poids*r
        endif
!
        do 40 i = 1, nno
            do 30 j = 1, i
                ii = 2*i
                jj = 2*j
                ij = (ii-1)*ii/2 + jj
                zr(imatuu+ij-1) = zr(imatuu+ij-1) - poids*zr(ivf+ldec+ i-1)*zr(ivf+ldec+j-1)* rho&
                                  &/celer
 30         continue
 40     continue
 50 end do
 60 continue
!
end subroutine
