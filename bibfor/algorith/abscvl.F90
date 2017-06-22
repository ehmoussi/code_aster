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

subroutine abscvl(ndim, tabar, xg, s)
    implicit none
!
#include "jeveux.h"
#include "asterfort/abscvf.h"
#include "asterfort/assert.h"
#include "asterfort/reereg.h"
#include "asterfort/utmess.h"
    integer :: ndim
    real(kind=8) :: xg(ndim), s, tabar(*)
!
!                      TROUVER L'ABSCISSE CURVILIGNE D'UN POINT
!                      SUR UNE ARETE QUADRATIQUE A PARTIR DE SES
!                      COORDONNEES DANS L'ELEMENT REEL
!
!     ENTREE
!       NDIM     : DIMENSION TOPOLOGIQUE DU MAILLAGE
!       TABAR    : COORDONNEES DES 3 NOEUDS QUI DEFINISSENT L'ARETE
!       XG       : COORDONNEES DU POINT DANS L'ELEMENT REEL
!
!     SORTIE
!       S        : ABSCISSE CURVILIGNE DU POINT P PAR RAPPORT AU
!                  PREMIER POINT STOCKE DANS COORSG
!     ----------------------------------------------------------------
!
    real(kind=8) :: xgg, a, b, ksider
    real(kind=8) :: tabelt(3), xe(1)
    integer :: iret, k
    character(len=8) :: elp
!
!......................................................................
!
!     TABAR : XE2=-1  /  XE1= 1  /  XE3= 0
!     XE2 ETANT LE POINT D'ORIGINE
!
!      RECHERCHE DE LA MONOTONIE SUR CHAQUE AXE

!   recherche d'un axe sur lequel projete le SE3
    xgg=0.d0

    do 10 k=1, ndim
      a = tabar(k)+tabar(ndim+k)-2*tabar(2*ndim+k)
      b = tabar(ndim+k)-tabar(k)
!
      if (abs(a) .le. 1.d-6) then
        if (abs(b) .gt. 1.d-6) then
!         JE BALANCE SUR K
          tabelt(1)=tabar(k)
          tabelt(2)=tabar(ndim+k)
          tabelt(3)=tabar(2*ndim+k)
          xgg =xg(k)
!         on a trouve un axe sur lequel projete le SE3
          exit
        else if (abs(b).le.1.d-6) then
          if (k .lt. ndim) then
!           on teste l'axe suivant
            goto 10
          else if (k.eq.ndim) then
!           LES 3 POINTS SONT CONFONDUS!
            call utmess('F', 'XFEM_66')
          endif
        endif
      else if (abs(a).gt.1.d-6) then
        ksider = -b/a
        if (ksider .gt. -1.d0 .and. ksider .lt. 1.d0) then
          if (k .lt. ndim) then
!           on teste l'axe suivant
            cycle
          else if (k.eq.ndim) then
!           L'ARETE EST TROP ARRONDIE :
!           IL Y A 2 SOLUTIONS SUIVANT CHAQUE AXE
            call utmess('F', 'XFEM_66')
          endif
        else if (ksider.gt.1.d0 .or. ksider.lt.-1.d0) then
          tabelt(1)=tabar(k)
          tabelt(2)=tabar(ndim+k)
          tabelt(3)=tabar(2*ndim+k)
          xgg =xg(k)
!         on a trouve un axe sur lequel projete le SE3
          exit
        endif
      endif
!
10  end do
!
!   ALIAS DE L'ARETE (QUADRATIQUE)
    elp='SE3'
!
!     CALCUL COORDONNEES DE REF (ETA) DE XGG SUR L'ARETE
    call reereg('S', elp, 3, tabelt, [xgg],&
                1, xe, iret)
    ASSERT(xe(1).ge.-1 .and. xe(1).le.1)
!
!     CALCUL ABSCISSE CURVILIGNE (S) DE XGG
!     ---L'ORIGINE EST LE 1ER PT DE COORSG---
    call abscvf(ndim, tabar, xe(1), s)
!
end subroutine
