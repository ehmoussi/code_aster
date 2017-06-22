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

subroutine te0463(option, nomte)
!
! aslint: disable=W0104
!
! --------------------------------------------------------------------------------------------------
!
!     Calcul des coordonnées des sous points de GAUSS sur les familles de la liste MATER
!     pour les éléments POU_D_EM et POU_D_TGM
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=16) :: option, nomte
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fmater.h"
#include "asterfort/jevech.h"
#include "asterfort/matrot.h"
#include "asterfort/pmfinfo.h"
#include "asterfort/ppga1d.h"
#include "asterfort/utpvlg.h"
!
! --------------------------------------------------------------------------------------------------
!   nombre max de famille dans MATER, de points de GAUSS
    integer :: nfpgmx, nbpgmx
    parameter (nfpgmx=10,nbpgmx=3)
!
    integer :: ndim, nno, nnos, npg, jgano, icopg, idfde, ipoids, ivf, igeom, ndim1
    integer :: jacf, iorien, ipos, nfpg, ifpg, npgfa(nfpgmx)
    integer :: ig, ifi, decga, k, decfpg(nfpgmx)
    real(kind=8) :: copg(4, 4), copgfa(3, nbpgmx, nfpgmx), pgl(3, 3), gm1(3)
    real(kind=8) :: gm2(3)
    character(len=8) :: fami(nfpgmx)
!
    integer :: nbfibr, nbgrfi, tygrfi, nbcarm, nug(10)
!
! --------------------------------------------------------------------------------------------------
!
    if ((nomte.ne.'MECA_POU_D_EM') .and. (nomte.ne.'MECA_POU_D_TGM')) then
        ASSERT(.false.)
    endif
    call jevech('PGEOMER', 'L', igeom)
    ndim = 3
! --------------------------------------------------------------------------------------------------
!   Coordonnées de sous-points de gauss
    call jevech('PCOOPGM', 'E', icopg)
! --------------------------------------------------------------------------------------------------
!   Récupération des caractéristiques des fibres
    call pmfinfo(nbfibr,nbgrfi,tygrfi,nbcarm,nug,jacf=jacf)
!
    call jevech('PCAORIE', 'L', iorien)
    call matrot(zr(iorien), pgl)
    decga=nbfibr*ndim
!
    call fmater(nfpgmx, nfpg, fami)
    decfpg(1)=0
    do ifpg = 1, nfpg
        call elrefe_info(fami=fami(ifpg),ndim=ndim1,nno=nno,nnos=nnos,&
                         npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
        if (ifpg .lt. nfpg) decfpg(ifpg+1)=decfpg(ifpg)+npg
!       Position des points de GAUSS dans l'espace utilisateur
        call ppga1d(ndim, nno, npg, zr(ipoids), zr(ivf), zr(idfde), zr( igeom), copg)
        npgfa(ifpg) = npg
        do ig = 1, npg
            do k = 1, ndim
                copgfa(k,ig,ifpg)=copg(k,ig)
            enddo
        enddo
    enddo
!
    gm1(1)=0.d0
    do ifi = 1, nbfibr
        gm1(2)=zr(jacf+(ifi-1)*nbcarm)
        gm1(3)=zr(jacf+(ifi-1)*nbcarm+1)
        call utpvlg(1, 3, pgl, gm1, gm2)
        do ifpg = 1, nfpg
            do ig = 1, npgfa(ifpg)
                ipos = icopg+(decfpg(ifpg)+ig-1)*decga+(ifi-1)*ndim
                zr(ipos+0) =copgfa(1,ig,ifpg)+gm2(1)
                zr(ipos+1) =copgfa(2,ig,ifpg)+gm2(2)
                zr(ipos+2) =copgfa(3,ig,ifpg)+gm2(3)
            enddo
        enddo
    enddo
!
end subroutine
