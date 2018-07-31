! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine deflog(ndim, f, epsl, gn, lamb, logl, iret)
!
    implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/diago2.h"
#include "asterfort/diagp3.h"
#include "asterfort/lctr2m.h"
#include "asterfort/pmat.h"
#include "asterfort/r8inir.h"
#include "asterfort/tnsvec.h"
!
    integer, intent(in) :: ndim
    real(kind=8), intent(in) :: f(3,3)
    real(kind=8), intent(out) :: epsl(6)
    real(kind=8), intent(out) :: gn(3, 3)
    real(kind=8), intent(out) :: lamb(3)
    real(kind=8), intent(out) :: logl(3)
    integer, intent(out) :: iret
!
!---------------------------------------------------------------------------------------------------
!     CALCUL DES DEFORMATIONS LOGARITHMIQUES ET DES TERMES NECESSAIRES
!     AU POST TRAITEMENT DES CONTRAINTES ET A LA RIGIDITE TANGENTE
!     SUIVANT ARTICLE MIEHE APEL LAMBRECHT CMAME 2002
! --------------------------------------------------------------------------------------------------
!     IN    NDIM : dimension 2 ou 3
!     IN    F gradient de la transformation calcule sur config initiale
!     OUT   EPSL  deformation logarithmique + GN,LAMB,LOGL pour POSLOG
!     OUT   GN    directions propres du tenseur F
!     OUT   LAMB  valeurs propres du tenseur F
!     OUT   LOGL  log des valeurs propres du tenseur F
!     OUT   IRET  0=OK, 1=vp(Ft.F) trop petites (compression infinie)
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: tr(6), epsl33(3, 3), tr2(3), ft(3, 3), gn2(2, 2)
    real(kind=8) :: C(3, 3)
    integer :: i, j, k
    integer, parameter :: nbvec = 3
! --------------------------------------------------------------------------------------------------
!
    gn = 0.d0
    lamb = 0.d0
    logl = 0.d0
    iret  = 0
!
!     LE CALCUL DES VALEURS PROPRES N'A PAS ENCORE ETE FAIT: On calcule C
    call lctr2m(3, f, ft)
    call pmat(3, ft, f, C)
! --- VALEURS PRINCIPALES = VECTEURS PROPRES
!  VECP : DIM1=I=COMPOSANTE DIM2=J=NUM VECTEUR ASSOCIE A LAMBP(J)
    call tnsvec(3, 3, C, tr, 1.d0)
!
    if (ndim .eq. 3) then
!
!         CALL DIAGO3(TR,GN,LAMB)
!     --------------------------------
!     pour gagner du temps
!     --------------------------------
! --- MATRICE TR = (XX XY XZ YY YZ ZZ) (POUR DIAGP3)
        tr(1) = C(1,1)
        tr(2) = C(1,2)
        tr(3) = C(1,3)
        tr(4) = C(2,2)
        tr(5) = C(2,3)
        tr(6) = C(3,3)
        call diagp3(tr, gn, lamb)
!
    else if (ndim.eq.2) then
!
        tr2(1) = tr(1)
        tr2(2) = tr(2)
        tr2(3) = tr(4)
        call diago2(tr2, gn2, lamb)
        lamb(3) = tr(3)
!
        do i = 1, 2
            do j = 1, 2
                gn(i,j)=gn2(i,j)
            end do
        end do
        gn(3,3)=1.d0
!
    endif
!
    do i = 1, nbvec
        if (lamb(i) .le. r8prem()) then
            iret=1
            goto 999
        endif
        logl(i)=log(lamb(i))*0.5d0
    end do
!
!     EPSL = DEFORMATION LOGARITHMIQUE
    epsl33 = 0.d0
    epsl = 0.d0
!
    do i = 1, 3
        do j = 1, 3
            do k = 1, nbvec
!              Calcul de EPSL dans le repere general
                epsl33(i,j)=epsl33(i,j)+logl(k)*gn(i,k)*gn(j,k)
            end do
        end do
    end do
!
    call tnsvec(3, 3, epsl33, epsl, sqrt(2.d0))
!
999 continue
!
end subroutine
