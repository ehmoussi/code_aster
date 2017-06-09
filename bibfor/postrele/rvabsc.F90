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

subroutine rvabsc(mailla, tnd, nbn, tabsc, tcoor)
    implicit none
!
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: mailla
    integer :: tnd(*), nbn
    real(kind=8) :: tabsc(*), tcoor(*)
!
!***********************************************************************
!
!  OPERATION REALISEE
!  ------------------
!
!     CALCUL DES ABSCISSES CURVILIGNES LE LONG D' UNE LISTE DE NOEUDS
!
!  ARGUMENTS EN ENTREE
!  -------------------
!
!     MAILLA : NOM DU MAILLAGE
!     TND    : TABLE DES NUMEROS DE NOEUDS
!     NBN    : NOMBRE DE NOEUDS
!
!  ARGUMENTS EN SORTIE
!  -------------------
!
!     TABSC : LE TABLEAU DES ABSCISSES
!     TCOOR : LE TABLEAU DES COORDONNEES (ORDRE X,Y,Z)
!
!***********************************************************************
!
!  -----------------------------------------
!
!
!  ---------------------------------
!
!  VARIABLES LOCALES
!  -----------------
!
    integer ::  i
    real(kind=8) :: xc, xp, yc, yp, l, zzc, zzp
    real(kind=8), pointer :: vale(:) => null()
!
!==================== CORPS DE LA ROUTINE =============================
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    call jeveuo(mailla//'.COORDO    .VALE', 'L', vr=vale)
!
    tabsc(1) = 0.0d0
!
    xp = vale(1+ (tnd(1)-1)*3 + 1-1)
    yp = vale(1+ (tnd(1)-1)*3 + 2-1)
    zzp = vale(1+ (tnd(1)-1)*3 + 3-1)
!
    tcoor(1) = xp
    tcoor(2) = yp
    tcoor(3) = zzp
!
    do 10, i = 2, nbn, 1
!
    xc = vale(1+ (tnd(i)-1)*3 + 1-1)
    yc = vale(1+ (tnd(i)-1)*3 + 2-1)
    zzc = vale(1+ (tnd(i)-1)*3 + 3-1)
!
    l = sqrt((xc-xp)*(xc-xp)+(yc-yp)*(yc-yp)+(zzc-zzp)*(zzc-zzp))
!
    tabsc(i) = tabsc(i-1) + l
!
    tcoor(3*(i-1) + 1) = xc
    tcoor(3*(i-1) + 2) = yc
    tcoor(3*(i-1) + 3) = zzc
!
    xp = xc
    yp = yc
    zzp = zzc
!
    10 end do
!
    call jedema()
end subroutine
