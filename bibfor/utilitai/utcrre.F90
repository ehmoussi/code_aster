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

subroutine utcrre(result, nbval)
!
! ----------------------------------------------------------------------
!     UTILITAIRE : CREATION DES RESULTATS
!     **           **           **
! ----------------------------------------------------------------------
!
!
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterc/getres.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsrusd.h"
    integer :: nbval
    character(len=8) :: result
!
!
    integer :: iret
    integer :: nbav
!
    character(len=8) :: k8bid
    character(len=19) :: resu19
    character(len=16) :: typres, nomcmd
!
! ----------------------------------------------------------------------
!
    call getres(k8bid, typres, nomcmd)
!
! --- ALLOCATION (ON DIMENSIONNE PAR DEFAUT A 100)
!
    call jeexin(result(1:8)//'           .DESC', iret)
!
! --- SI LE RESULTAT N'EXISTE PAS, ON ALLOUE A NBVAL VALEURS
!
    if (iret .eq. 0) then
        call rscrsd('G', result, typres, nbval)
    else
! ----- SI LE RESULTAT N'EST PAS ASSEZ GRAND, ON L'AGRANDIT :
        resu19=result
        call jelira(resu19//'.ORDR', 'LONMAX', nbav)
        if (nbval .gt. nbav) call rsagsd(result, nbval)
! ----- S'IL EXISTE, ON DETRUIT TOUT CE QUI SERAIT AU DELA DE NBVAL
        call rsrusd(result, nbval+1)
    endif
!
end subroutine
