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

subroutine epsimc(option, xyz, nno, npg, ndim,&
                  nbsig, ni, eps)
!.======================================================================
    implicit none
!
!      EPSIMC   -- CONSTRUCTION DU VECTEUR DES DEFORMATIONS INITIALES
!                  DEFINIES EN CHAQUE POINT D'INTEGRATION
!                  A PARTIR DES DONNEES UTILISATEUR POUR L'ELEMENT
!                  COURANT
!
!   ARGUMENT        E/S  TYPE         ROLE
!    OPTION         IN    K16       NOM  DE L'OPTION
!    XYZ(1)         IN     R        COORDONNEES DES CONNECTIVITES
!    NNO            IN     I        NOMBRE DE NOEUDS DE L'ELEMENT
!    NPG            IN     I        NOMBRE DE POINTS D'INTEGRATION
!                                   DE L'ELEMENT
!    NDIM           IN     I        DIMENSION  DE L'ELEMENT ( 2 OU 3)
!    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE A
!                                   L'ELEMENT
!    NI(1)          IN     R        FONCTIONS DE FORME
!    EPS(1)         OUT    R        DEFORMATIONS AUX POINTS
!                                   D'INTEGRATION
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
    character(len=16) :: option
    real(kind=8) :: xyz(1), ni(1), eps(1)
! -----  VARIABLES LOCALES
    character(len=8) :: nompar(4)
    real(kind=8) :: valpar(4)
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
! --- INITIALISATIONS :
!     -----------------
!-----------------------------------------------------------------------
    integer :: i, idefi, ier, igau, itemps, nbsig, ndim
    integer :: nno, npg
    real(kind=8) :: deux, exx, exy, exz, eyy, eyz, ezz
    real(kind=8) :: xgau, ygau, zero, zgau
!-----------------------------------------------------------------------
    zero = 0.0d0
    deux = 2.0d0
!
    do 10 i = 1, nbsig*npg
        eps(i) = zero
10  end do
!
!      -------
! ---- CAS 2D
!      -------
    if (ndim .eq. 2) then
!
! ---- RECUPERATION DES DEFORMATIONS
!      -----------------------------
        if (option(16:16) .eq. 'R') then
!
            call jevech('PEPSINR', 'L', idefi)
            exx=zr(idefi)
            eyy=zr(idefi+1)
            ezz=zr(idefi+2)
            exy=zr(idefi+3)
!
! ---  BOUCLE SUR LES POINTS D'INTEGRATION
!      -----------------------------------
            do 20 igau = 1, npg
                eps(1+nbsig*(igau-1)) = exx
                eps(2+nbsig*(igau-1)) = eyy
                eps(3+nbsig*(igau-1)) = ezz
                eps(4+nbsig*(igau-1)) = exy*deux
20          continue
        else
            call jevech('PEPSINF', 'L', idefi)
            call jevech('PTEMPSR', 'L', itemps)
            nompar(1) = 'X'
            nompar(2) = 'Y'
            nompar(3) = 'INST'
            valpar(3) = zr(itemps)
!
! ---  BOUCLE SUR LES POINTS D'INTEGRATION
!      -----------------------------------
            do 30 igau = 1, npg
!
!  --      COORDONNEES DU POINT D'INTEGRATION COURANT
!          -----------------------------------------
                xgau = zero
                ygau = zero
!
                do 40 i = 1, nno
                    xgau = xgau + ni(i+nno*(igau-1))*xyz(1+2*(i-1))
                    ygau = ygau + ni(i+nno*(igau-1))*xyz(2+2*(i-1))
40              continue
!
                valpar(1) = xgau
                valpar(2) = ygau
!
!  --        INTERPOLATION
!            -------------
                call fointe('FM', zk8(idefi ), 3, nompar, valpar,&
                            exx, ier)
                call fointe('FM', zk8(idefi+1), 3, nompar, valpar,&
                            eyy, ier)
                call fointe('FM', zk8(idefi+2), 3, nompar, valpar,&
                            ezz, ier)
                call fointe('FM', zk8(idefi+3), 3, nompar, valpar,&
                            exy, ier)
!
                eps(1+nbsig*(igau-1)) = exx
                eps(2+nbsig*(igau-1)) = eyy
                eps(3+nbsig*(igau-1)) = ezz
                eps(4+nbsig*(igau-1)) = exy*deux
!
30          continue
!
        endif
!
!      -------
! ---- CAS 3D
!      -------
    else if (ndim.eq.3) then
!
! ---- RECUPERATION DES DEFORMATIONS
!      -----------------------------
        if (option(16:16) .eq. 'R') then
!
            call jevech('PEPSINR', 'L', idefi)
            exx=zr(idefi)
            eyy=zr(idefi+1)
            ezz=zr(idefi+2)
            exy=zr(idefi+3)
            exz=zr(idefi+4)
            eyz=zr(idefi+5)
!
! ---  BOUCLE SUR LES POINTS D'INTEGRATION
!      -----------------------------------
            do 50 igau = 1, npg
                eps(1+nbsig*(igau-1)) = exx
                eps(2+nbsig*(igau-1)) = eyy
                eps(3+nbsig*(igau-1)) = ezz
                eps(4+nbsig*(igau-1)) = exy*deux
                eps(5+nbsig*(igau-1)) = exz*deux
                eps(6+nbsig*(igau-1)) = eyz*deux
50          continue
        else
            call jevech('PEPSINF', 'L', idefi)
            call jevech('PTEMPSR', 'L', itemps)
            nompar(1) = 'X'
            nompar(2) = 'Y'
            nompar(3) = 'Z'
            nompar(4) = 'INST'
            valpar(4) = zr(itemps)
!
! ---  BOUCLE SUR LES POINTS D'INTEGRATION
!      -----------------------------------
            do 60 igau = 1, npg
!
!  --      COORDONNEES DU POINT D'INTEGRATION COURANT
!          -----------------------------------------
                xgau = zero
                ygau = zero
                zgau = zero
!
                do 70 i = 1, nno
                    xgau = xgau + ni(i+nno*(igau-1))*xyz(1+3*(i-1))
                    ygau = ygau + ni(i+nno*(igau-1))*xyz(2+3*(i-1))
                    zgau = zgau + ni(i+nno*(igau-1))*xyz(3+3*(i-1))
70              continue
!
                valpar(1) = xgau
                valpar(2) = ygau
                valpar(3) = zgau
!
!  --        INTERPOLATION
!            -------------
                call fointe('FM', zk8(idefi ), 4, nompar, valpar,&
                            exx, ier)
                call fointe('FM', zk8(idefi+1), 4, nompar, valpar,&
                            eyy, ier)
                call fointe('FM', zk8(idefi+2), 4, nompar, valpar,&
                            ezz, ier)
                call fointe('FM', zk8(idefi+3), 4, nompar, valpar,&
                            exy, ier)
                call fointe('FM', zk8(idefi+4), 4, nompar, valpar,&
                            exz, ier)
                call fointe('FM', zk8(idefi+5), 4, nompar, valpar,&
                            eyz, ier)
!
                eps(1+nbsig*(igau-1)) = exx
                eps(2+nbsig*(igau-1)) = eyy
                eps(3+nbsig*(igau-1)) = ezz
                eps(4+nbsig*(igau-1)) = exy*deux
                eps(5+nbsig*(igau-1)) = exz*deux
                eps(6+nbsig*(igau-1)) = eyz*deux
!
60          continue
!
        endif
!
    endif
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
