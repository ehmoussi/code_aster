! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine te0488(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/subaco.h"
#include "asterfort/sumetr.h"
#include "asterfort/tecach.h"
#include "asterfort/utpvlg.h"
#include "asterfort/vectan.h"
#include "asterfort/vectgt.h"
#include "asterfort/lteatt.h"
    character(len=16) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
!     CALCUL DES COORDONNEES DES POINTS DE GAUSS
!     POUR LES ELEMENTS ISOPARAMETRIQUES 3D  ET LEURS ELEMENTS DE PEAU
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jgano, nno, kp, ipoids, ivf, igeom, icosu
    integer :: npg, nnos, icopg, ino, ndim, idfde
!
    real(kind=8) :: xx, yy, zz, poids, cova(3, 3), metr(2, 2), jac
    integer :: inbf, nbc, icoq, decpo, ic, ispc, jtab(7), nbsp, iret, jadr
    real(kind=8) :: epais, excen, bas, epc, pgl(3, 3), gm1(3), gm2(3)
    integer :: lzi, lzr, nb1, nb2
    real(kind=8) :: zero, vectg(2, 3), vectt(3, 3)
    real(kind=8) :: vecta(9, 2, 3), vectn(9, 3), vectpt(9, 2, 3)
    real(kind=8) :: poidc(3), hh
    parameter(zero=0.0d0)
    aster_logical :: coq3d, grille, gauss_support
    data gm1 / 0.d0,0.d0,1.d0/
    data poidc / 0.16666666666666666d0, 0.66666666666666663d0,  0.16666666666666666d0/
!
! --------------------------------------------------------------------------------------------------
    coq3d = lteatt('MODELI','CQ3')
    grille= lteatt('MODELI','GRC')
    if (coq3d) then
        call elrefe_info(fami='MASS', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                         jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    else
        call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                         jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    endif
!
    call jevech('PGEOMER', 'L', igeom)
    call tecach('OOO', 'PCOORPG', 'E', iret, nval=7, itab=jtab)
    icopg=jtab(1)
    nbsp=jtab(7)
!
!   Pour les grilles, le nombre de sous points n'est pas actif dans le calcul ==> on blinde
    if (grille) then
        nbsp=1
        call jevech('PCACOQU', 'L', icoq)
        excen = zr(icoq+3)
        if (nno .eq. 3) then
            call dxtpgl(zr(igeom), pgl)
        else if (nno.eq.4) then
            call dxqpgl(zr(igeom), pgl, 'S', iret)
        endif
        call utpvlg(1, 3, pgl, gm1, gm2)
    endif
!
! --------------------------------------------------------------------------------------------------
    nbc = 0
!   En cas de sous points (DKT,DST,COQUE_3D)
    if (nbsp .ne. 1) then
        call jevech('PNBSP_I', 'L', inbf)
        nbc = zi(inbf)
        call jevech('PCACOQU', 'L', icoq)
        epais = zr(icoq)
        if (coq3d) then
            excen = zr(icoq+5)
!           COQUES 3D : on utilise le vecteur normal a chaque point de gauss
!           On prépare vectn pour le calcul de gm2 dans la boucle pg plus bas
            call jevete('&INEL.'//nomte(1:8)//'.DESI', ' ', lzi)
            nb1 = zi(lzi-1+1)
            nb2 = zi(lzi-1+2)
            npg = zi(lzi-1+4)
            call jevete('&INEL.'//nomte(1:8)//'.DESR', ' ', lzr)
            call vectan(nb1, nb2, zr(igeom), zr(lzr), vecta, vectn, vectpt)
        else
            excen = zr(icoq+4)
!           DKT,DST : on utilise le vecteur normal de la plaque. On calcule gm2 une seule fois
            if (nno .eq. 3) then
                call dxtpgl(zr(igeom), pgl)
            else if (nno.eq.4) then
                call dxqpgl(zr(igeom), pgl, 'S', iret)
            endif
            call utpvlg(1, 3, pgl, gm1, gm2)
        endif
        bas=-epais/2.d0+excen
        epc=epais/nbc
    endif
!
! --------------------------------------------------------------------------------------------------
!   Calcul des coordonnées des points de Gauss du support si besoin
    call tecach('NNN','PCOORSU', 'E', iret, iad=icosu)
    gauss_support = (iret.eq.0)
!
!   Boucle point de gauss
    do kp = 1, npg
!       Coordonnées et poids du point de gauss
        xx = 0.d0
        yy = 0.d0
        zz = 0.d0
        do ino = 1, nno
            xx = xx + zr(igeom+3*(ino-1)+0)*zr(ivf+(kp-1)*nno+ino-1)
            yy = yy + zr(igeom+3*(ino-1)+1)*zr(ivf+(kp-1)*nno+ino-1)
            zz = zz + zr(igeom+3*(ino-1)+2)*zr(ivf+(kp-1)*nno+ino-1)
        enddo
        if (ndim .eq. 3) then
!           Cas des elements 3D
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom), poids)
        else if (ndim.eq.2) then
!           Cas des éléments "peau" de 3D
            call subaco(nno, zr(idfde+(kp-1)*ndim*nno), zr(igeom), cova)
            call sumetr(cova, metr, jac)
            poids=jac*zr(ipoids-1+kp)
        else
            ASSERT(.false.)
        endif
!
        if ( gauss_support ) then
            jadr = icosu+(kp-1)*4
            zr(jadr + 0 ) = xx
            zr(jadr + 1 ) = yy
            zr(jadr + 2 ) = zz
            zr(jadr + 3 ) = poids
        endif
!
        if (nbsp .ne. 1) then
            decpo=4*3*nbc*(kp-1)
            if (coq3d) then
!               Calcul de la normale au point de gauss
                call vectgt(1, nb1, zr(igeom), zero, kp, &
                            zr(lzr), epais, vectn, vectg, vectt)
                gm2(1)=vectt(3,1)
                gm2(2)=vectt(3,2)
                gm2(3)=vectt(3,3)
            endif
            do ic = 1, nbc
                do ispc = 1, 3
                    hh=bas+dble(ic-1)*epc+dble(ispc-1)*epc/2.d0
                    zr(icopg+decpo+(ic-1)*12+(ispc-1)*4+0) = xx + hh*gm2(1)
                    zr(icopg+decpo+(ic-1)*12+(ispc-1)*4+1) = yy + hh*gm2(2)
                    zr(icopg+decpo+(ic-1)*12+(ispc-1)*4+2) = zz + hh*gm2(3)
                    zr(icopg+decpo+(ic-1)*12+(ispc-1)*4+3) = poids*epc*poidc(ispc)
                enddo
            enddo
        else if (grille) then
            zr(icopg+4*(kp-1)+0) = xx+excen*gm2(1)
            zr(icopg+4*(kp-1)+1) = yy+excen*gm2(2)
            zr(icopg+4*(kp-1)+2) = zz+excen*gm2(3)
            zr(icopg+4*(kp-1)+3) = poids
        else
            zr(icopg+4*(kp-1)+0) = xx
            zr(icopg+4*(kp-1)+1) = yy
            zr(icopg+4*(kp-1)+2) = zz
            zr(icopg+4*(kp-1)+3) = poids
        endif
    enddo
!
end subroutine
