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

subroutine te0554(nomopt, nomte)
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/dffno.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/normev.h"
#include "asterfort/pmat.h"
#include "asterfort/provec.h"
#include "asterfort/tecael.h"
    character(len=16) :: nomopt, nomte
!
!                 CALCUL DE ROSETTE, OPTION : SIRO_ELEM
!
! IN   OPTION    : OPTION DE CALCUL
! IN   NOMTE     : NOM DU TYPE ELEMENT
!
! ----------------------------------------------------------------------
    integer :: isig, nnop, ndim, nnos, npg, ipoids, ivf, idfde, jgano, i
    integer :: igeom, j, ifonc, ino, iadzi, iazk24, isigm, iaux1, iaux2
!
    real(kind=8) :: prec, nort1, nort2, norno
    real(kind=8) :: vtan1(3), vtan2(3), vt1(3), vt2(3), vno(3)
    real(kind=8) :: sigg(3, 3), mlg(3, 3), mtmp(3, 3), sigl(3, 3), mgl(3, 3)
    real(kind=8) :: det
    real(kind=8) :: dff(162)
!
    character(len=8) :: elrefe
    parameter(prec=1.0d-10)
! ----------------------------------------------------------------------
!
!    call tecael(iadzi, iazk24, noms=0)
    call tecael(iadzi, iazk24 )
    call elref1(elrefe)
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nnop,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PSIG3D', 'L', isig)
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PPJSIGM', 'E', isigm)
!
!     CALCUL DES DERIVEES DES FONCTIONS DE FORMES AUX NOEUDS DE L'ELREFE
    call dffno(elrefe, ndim, nnop, nnos, dff)
!
! --- ------------------------------------------------------------------
! --- CALCUL DU REPERE LOCAL : (VT1, VT2, VNO)
!        VT1, VT2 = VECTEURS TANGENTS A L'ELEMENT
!        VNO = VECTEUR NORMAL A L'ELEMENT
!
!     INITIALISATION
    do 9 i = 1, 3
        vt1(i) = 0.d0
        vt2(i) = 0.d0
        vno(i) = 0.d0
        do 8 j = i, 3
            sigg(i,j)=0.d0
 8      continue
 9  end do
!
! --- ------------------------------------------------------------------
! --- BOUCLE SUR LES NOEUDS DE L'ELEMENT
    do 10 ino = 1, nnop
!
        do 12 i = 1, 3
            vtan1(i) = 0.d0
            vtan2(i) = 0.d0
12      continue
!
        do 20 ifonc = 1, nnop
            iaux1 = igeom-1+2*(ifonc-1)
            iaux2 = (ino-1)*nnop*2 + ifonc
            vtan1(1) = vtan1(1) + zr(iaux1+1)*dff(iaux2)
            vtan1(2) = vtan1(2) + zr(iaux1+2)*dff(iaux2)
            vtan2(3) = 1.d0
20      continue
!
        vt1(1)=vt1(1)+vtan1(1)
        vt1(2)=vt1(2)+vtan1(2)
        vt1(3)=vt1(3)+vtan1(3)
        vt2(1)=vt2(1)+vtan2(1)
        vt2(2)=vt2(2)+vtan2(2)
        vt2(3)=vt2(3)+vtan2(3)
!
        sigg(1,1)=sigg(1,1)+zr(isig+4*(ino-1))
        sigg(2,2)=sigg(2,2)+zr(isig+4*(ino-1)+1)
        sigg(3,3)=sigg(3,3)+zr(isig+4*(ino-1)+2)
        sigg(1,2)=sigg(1,2)+zr(isig+4*(ino-1)+3)
!
10  end do
! --- ------------------------------------------------------------------
! --- VECTEURS TANGENTS PAR MOYENNE DE CHAQUE COMPOSANTE
    vt1(1)=vt1(1)/nnop
    vt1(2)=vt1(2)/nnop
    vt1(3)=vt1(3)/nnop
    vt2(1)=vt2(1)/nnop
    vt2(2)=vt2(2)/nnop
    vt2(3)=vt2(3)/nnop
! --- ------------------------------------------------------------------
! --- TENSEUR DES CONTRAINTES PAR MOYENNE DE CHAQUE COMPOSANTE
    sigg(1,1)=sigg(1,1)/nnop
    sigg(2,2)=sigg(2,2)/nnop
    sigg(3,3)=sigg(3,3)/nnop
    sigg(1,2)=sigg(1,2)/nnop
    sigg(1,3)=sigg(1,3)/nnop
    sigg(2,3)=sigg(2,3)/nnop
    sigg(2,1)=  sigg(1,2)
    sigg(3,1)=  sigg(1,3)
    sigg(3,2)=  sigg(2,3)
!
    call normev(vt1, nort1)
    call normev(vt2, nort2)
    call provec(vt1, vt2, vno)
    call normev(vno, norno)
    call provec(vno, vt1, vt2)
!
    det=vt1(1)*vt2(2)*vno(3)+vt2(1)*vno(2)*vt1(3)+vno(1)*vt1(2)*vt2(3)&
     &   -vno(1)*vt2(2)*vt1(3)-vt1(1)*vno(2)*vt2(3)-vt2(1)*vt1(2)*vno(3)
    ASSERT(abs(det).gt.prec)
!
    
    mgl(1,1) = vno(1)
    mgl(2,1) = vt1(1)
    mgl(3,1) = vt2(1)
    mgl(1,2) = vno(2)
    mgl(2,2) = vt1(2)
    mgl(3,2) = vt2(2)
    mgl(1,3) = vno(3)
    mgl(2,3) = vt1(3)
    mgl(3,3) = vt2(3)
!
    mlg(1,1) = vno(1)
    mlg(2,1) = vno(2)
    mlg(3,1) = vno(3)
    mlg(1,2) = vt1(1)
    mlg(2,2) = vt1(2)
    mlg(3,2) = vt1(3)
    mlg(1,3) = vt2(1)
    mlg(2,3) = vt2(2)
    mlg(3,3) = vt2(3)
!
    call pmat(3, sigg, mlg, mtmp)
    call pmat(3, mgl, mtmp, sigl)

! --- ------------------------------------------------------------------
! --- CALCUL DES OPTIONS : SIRO_ELEM_SIT1 & SIRO_ELEM_SIT2

    zr(isigm-1+8) = sigg(1,1)*vt1(1)+sigg(1,2)*vt1(2)
    zr(isigm-1+9) = sigg(2,1)*vt1(1)+sigg(2,2)*vt1(2)
    zr(isigm-1+10)= sigg(3,3)*vt1(3)
    zr(isigm-1+11)= sigl(2,2)
!
    zr(isigm-1+12)= sigg(1,1)*vt2(1)+sigg(1,2)*vt2(2)
    zr(isigm-1+13)= sigg(2,1)*vt2(1)+sigg(2,2)*vt2(2)
    zr(isigm-1+14)= sigg(3,3)*vt2(3)
    zr(isigm-1+15)= sigl(3,3)
! --- ------------------------------------------------------------------
! --- CALCUL DES OPTIONS : SIRO_ELEM_SIGN & SIRO_ELEM_SIGT
    zr(isigm-1+1)= sigg(1,1)*vno(1)+sigg(1,2)*vno(2)
    zr(isigm-1+2)= sigg(2,1)*vno(1)+sigg(2,2)*vno(2)
    zr(isigm-1+3)= sigg(3,3)*vno(3)
    zr(isigm-1+4)= sigl(1,1)
    zr(isigm-1+5)= sigg(1,1)*vt1(1)+sigg(1,2)*vt1(2)
    zr(isigm-1+6)= sigg(2,1)*vt1(1)+sigg(2,2)*vt1(2)
    zr(isigm-1+7)= sigg(3,3)*vt1(3)
    zr(isigm-1+16)= sigl(2,1)

!
!
end subroutine
