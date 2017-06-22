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

subroutine te0437(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/bsigmc.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nbsigm.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
! FONCTION REALISEE:  CALCUL DE L'OPTION FORC_NODA
!                        POUR ELEMENTS 3D NON LOCAUX A GRAD. DE DEF.
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
    real(kind=8) :: nharm, bsigm(81), geo(81)
! DEB ------------------------------------------------------------------
!
! ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
! ---- GEOMETRIE ET INTEGRATION
!      ------------------------
!-----------------------------------------------------------------------
    integer :: i, icomp, icontm, idepl, idfde, igeom, ipoids
    integer :: iretc, iretd, ivectu, ivf, jgano, kp, ku
    integer :: n, nbsig, ndim, ndimsi, nno, nnob
    integer :: npg1
    real(kind=8) :: zero
!-----------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnob,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
! --- INITIALISATIONS :
!     -----------------
    zero = 0.0d0
    nharm = zero
!
! - SPECIFICATION DE LA DIMENSION
!
    ndimsi = ndim*2
!
! ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
!      -----------------------------------------
    nbsig = nbsigm()
!
! ---- PARAMETRES EN ENTREE
!      --------------------
! ----     COORDONNEES DES CONNECTIVITES
    call jevech('PGEOMER', 'L', igeom)
! ----     CONTRAINTES AUX POINTS D'INTEGRATION
    call jevech('PCONTMR', 'L', icontm)
!
!         CHAMPS POUR LA REACTUALISATION DE LA GEOMETRIE
    do 10 i = 1, ndim*nno
        geo(i) = zr(igeom-1+i)
10  end do
    call tecach('ONO', 'PDEPLMR', 'L', iretd, iad=idepl)
    call tecach('ONO', 'PCOMPOR', 'L', iretc, iad=icomp)
    if ((iretd.eq.0) .and. (iretc.eq.0)) then
        if (zk16(icomp+2) (1:6) .ne. 'PETIT ') then
            do 20 i = 1, ndim*nno
                geo(i) = geo(i) + zr(idepl-1+i)
20          continue
        endif
    endif
! ---- PARAMETRES EN SORTIE
!      --------------------
! ----     VECTEUR DES FORCES INTERNES (BT*SIGMA)
    call jevech('PVECTUR', 'E', ivectu)
!
! ---- CALCUL DU VECTEUR DES FORCES INTERNES (BT*SIGMA) :
!      --------------------------------------------------
    call bsigmc(nno, ndim, nbsig, npg1, ipoids,&
                ivf, idfde, zr(igeom), nharm, zr(icontm),&
                bsigm)
!
! ---- AFFECTATION DU VECTEUR EN SORTIE :
!      ----------------------------------
    do 50 n = 1, nnob
        do 30 i = 1, ndim
            ku = (ndimsi+ndim)* (n-1) + i
            kp = ndim* (n-1) + i
            zr(ivectu+ku-1) = bsigm(kp)
30      continue
        do 40 i = 1, ndimsi
            ku = (ndimsi+ndim)* (n-1) + i + ndim
            zr(ivectu+ku-1) = 0.d0
40      continue
50  end do
    do 70 n = nnob + 1, nno
        do 60 i = 1, ndim
            ku = (ndimsi+ndim)*nnob + ndim* (n-nnob-1) + i
            kp = ndim* (n-1) + i
            zr(ivectu+ku-1) = bsigm(kp)
60      continue
70  end do
!
! FIN ------------------------------------------------------------------
end subroutine
