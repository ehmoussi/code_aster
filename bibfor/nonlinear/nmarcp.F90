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

subroutine nmarcp(typost, sdpost, vecmod, freqr, imode)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmlesd.h"
    character(len=4) :: typost
    character(len=19) :: sdpost
    character(len=19) :: vecmod
    real(kind=8) :: freqr
    integer :: imode
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - ARCHIVAGE)
!
! VECTEUR DE DEPL. POUR LE MODE
!
! ----------------------------------------------------------------------
!
!
! IN  TYPOST : TYPE DE POST-TRAITEMENTS (STABILITE OU MODE_VIBR)
! IN  SDPOST : SD POUR POST-TRAITEMENTS (CRIT_STAB ET MODE_VIBR)
! OUT VECMOD : VECTEUR DE DEPLACEMENT POUR LE MODE
! OUT FREQR  : FREQUENCE ATTACHEE AU MODE
! OUT IMODE  : VAUT ZEOR S'IL N'Y A PAS DE MODE
!
!
!
!
    integer :: ibid, numord
    character(len=24) :: k24bid
    real(kind=8) :: r8bid
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- MODE SELECTIONNE: INFOS DANS SDPOST
!
    if (typost .eq. 'VIBR') then
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_FREQ_VIBR', ibid, freqr,&
                    k24bid)
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_NUME_VIBR', numord, r8bid,&
                    k24bid)
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_MODE_VIBR', ibid, r8bid,&
                    vecmod)
    else if (typost .eq. 'FLAM') then
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_FREQ_FLAM', ibid, freqr,&
                    k24bid)
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_NUME_FLAM', numord, r8bid,&
                    k24bid)
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_MODE_FLAM', ibid, r8bid,&
                    vecmod)
    else if (typost .eq. 'STAB') then
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_FREQ_STAB', ibid, freqr,&
                    k24bid)
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_NUME_STAB', numord, r8bid,&
                    k24bid)
        call nmlesd('POST_TRAITEMENT', sdpost, 'SOLU_MODE_STAB', ibid, r8bid,&
                    vecmod)
    else
        ASSERT(.false.)
    endif
!
! --- EXTRACTION DU MODE
!
    if (freqr .eq. r8vide()) then
        imode = 0
    else
        imode = 1
    endif
!
    call jedema()
end subroutine
