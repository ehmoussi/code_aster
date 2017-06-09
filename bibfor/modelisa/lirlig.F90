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

subroutine lirlig(ifl, cnl, lig, ilec)
    implicit none
#include "asterfort/codent.h"
#include "asterfort/utmess.h"
    integer :: ifl, ilec
    character(len=14) :: cnl
    character(len=80) :: lig
!       LECTURE DE LA LIGNE SUIVANTE ET STOCKAGE DANS LE BUFFER LIG
!       ----------------------------------------------------------------
!       IN      IFL     = NUMERO UNITE FICHIER MAILLAGE
!               ILEC    = 1     >  PREMIERE LECTURE DU FICHIER
!                       = 2     >  SECONDE  LECTURE DU FICHIER
!       OUT     CNL     = NUMERO LIGNE LUE (CHAINE)
!               LIG     = LIGNE LUE
!       ----------------------------------------------------------------
    integer :: nl, nl1, nl2, i
    save                nl1, nl2
    character(len=255) :: lirlg
    data nl1,nl2    /0,0/
!
    cnl = ' '
    read(unit=ifl,fmt=1,end=100) lirlg
    do 10 i = 81, 255
        if (lirlg(i:i) .eq. '%') goto 12
        if (lirlg(i:i) .ne. ' ') then
            call utmess('F', 'MODELISA4_92', sk=lirlg)
        endif
10  continue
12  continue
    lig = lirlg(1:80)
!
    if (ilec .eq. 1) then
        nl1 = nl1 + 1
        nl = nl1
    else
        nl2 = nl2 + 1
        nl = nl2
    endif
!
    cnl(1:14) = '(LIGNE       )'
    call codent(nl, 'D', cnl(8:13))
!
    goto 9999
!
100  continue
    if (nl1 .eq. 0) then
        call utmess('F', 'MODELISA4_94')
    else
        call utmess('F', 'MODELISA4_93', si=nl1)
    endif
!
    1   format(a80)
!
9999  continue
end subroutine
