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

subroutine rc32rs(mater, lpmpb, lsn,&
                  lther, lfat, lefat)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/rc32r1.h"
#include "asterfort/rc32r0.h"
#include "asterfort/rc32r8.h"
    character(len=8) :: mater
    aster_logical :: lpmpb, lsn, lther, lfat, lefat
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE B3200 et ZE200
!     AFFICHAGE DES RESULTATS DANS LA TABLE DE SORTIE
!
!     ------------------------------------------------------------------
    character(len=8) :: nomres
    character(len=16) :: concep, nomcmd
! DEB ------------------------------------------------------------------
!
    call getres(nomres, concep, nomcmd)
!
    call tbcrsd(nomres, 'G')
!
    if (lfat) then
        call rc32r1(nomres, lefat)
    else
        call rc32r0(nomres, lpmpb, lsn, lther)
    endif
!
    if (lther) call rc32r8(nomres, mater, lfat)
!
end subroutine
