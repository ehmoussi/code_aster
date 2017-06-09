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

subroutine te0284(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/bsigmc.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/epsimc.h"
#include "asterfort/jevech.h"
#include "asterfort/nbsigm.h"
#include "asterfort/ortrep.h"
#include "asterfort/sigimc.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES EN 2D
!                      OPTION : 'CHAR_MECA_EPSI_R  ','CHAR_MECA_EPSI_F '
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    character(len=4) :: fami
    real(kind=8) :: sigi(162), epsi(162), bsigma(81), repere(7)
    real(kind=8) :: instan, nharm, xyz(81), bary(3)
    integer :: dimcoo, idim
!
!
!
! ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
! ---- GEOMETRIE ET INTEGRATION
!      ------------------------
!-----------------------------------------------------------------------
    integer :: i, idfde, igeom, iharmo, imate, ipoids, iret
    integer :: itemps, ivectu, ivf, jgano, nbsig, ndim, nno
    integer :: nnos, npg
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    fami = 'RIGI'
    call elrefe_info(fami=fami,ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
    dimcoo = ndim
!
! --- INITIALISATIONS :
!     -----------------
    zero = 0.0d0
    instan = zero
!
! ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
!      -----------------------------------------
    nbsig = nbsigm()
    if (nbsig .eq. 6) ndim=3
!
    do 10 i = 1, nbsig*npg
        epsi(i) = zero
        sigi(i) = zero
10  end do
!
    do 20 i = 1, ndim*nno
        bsigma(i) = zero
20  end do
!
! ---- RECUPERATION DE L'HARMONIQUE DE FOURIER
!      ---------------------------------------
    call tecach('NNO', 'PHARMON', 'L', iret, iad=iharmo)
    if (iharmo .eq. 0) then
        nharm = zero
    else
        nharm = dble( zi(iharmo) )
    endif
!
! ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
!      ----------------------------------------------
    call jevech('PGEOMER', 'L', igeom)
    if (ndim .eq. dimcoo) then
        do 100 i = 1, ndim*nno
            xyz(i) = zr(igeom+i-1)
100      continue
    else
        do 110 i = 1, nno
            do 120 idim = 1, ndim
                if (idim .le. dimcoo) then
                    xyz(idim+ndim*(i-1)) = zr(igeom-1+idim+dimcoo*(i- 1))
                else
                    xyz(idim+ndim*(i-1)) = 0.d0
                endif
120          continue
110      continue
    endif
!
! ---- RECUPERATION DU MATERIAU
!      ------------------------
    call jevech('PMATERC', 'L', imate)
!
! ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
!      ------------------------------------------------------------
!     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )
!
    bary(1) = 0.d0
    bary(2) = 0.d0
    bary(3) = 0.d0
    do 150 i = 1, nno
        do 140 idim = 1, dimcoo
            bary(idim) = bary(idim)+zr(igeom+idim+dimcoo*(i-1)-1)/nno
140      continue
150  end do
    call ortrep(dimcoo, bary, repere)
!
!
! ---- RECUPERATION DE L'INSTANT
!      -------------------------
    call tecach('NNO', 'PTEMPSR', 'L', iret, iad=itemps)
    if (itemps .ne. 0) instan = zr(itemps)
!
! ---- CONSTRUCTION DU VECTEUR DES DEFORMATIONS INITIALES DEFINIES AUX
! ---- POINTS D'INTEGRATION A PARTIR DES DONNEES UTILISATEUR
!      -----------------------------------------------------
    call epsimc(option, zr(igeom), nno, npg, ndim,&
                nbsig, zr(ivf), epsi)
!
! ---- CALCUL DU VECTEUR DES CONTRAINTES INITIALES AUX POINTS
! ---- D'INTEGRATION
!      -------------
    call sigimc(fami, nno, ndim, nbsig, npg,&
                zr(ivf), xyz, instan, zi(imate), repere,&
                epsi, sigi)
!
! ---- CALCUL DU VECTEUR DES FORCES DUES AUX CONTRAINTES INITIALES
! ---- (I.E. BT*SIG_INITIALES)
!      ----------------------
    call bsigmc(nno, ndim, nbsig, npg, ipoids,&
                ivf, idfde, zr(igeom), nharm, sigi,&
                bsigma)
!
! ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE AVEC LE
! ---- VECTEUR DES FORCES DUES AUX CONTRAINTES INITIALES
!      -------------------------------------------------
    call jevech('PVECTUR', 'E', ivectu)
!
    do 30 i = 1, ndim*nno
        zr(ivectu+i-1) = bsigma(i)
30  end do
!
! FIN ------------------------------------------------------------------
end subroutine
