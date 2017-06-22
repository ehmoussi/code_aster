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

subroutine dismpm(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(PHEN_MODE)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=24) :: repk
    character(len=32) :: nomob
    character(len=*) :: nomobz, repkz
! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN PHENMODE : (1:16)  : PHENOMENE
!                                    (17:32) : MODELISATION
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    integer :: nbtm, jphen, imode
    character(len=16) :: phen, mode
! DEB-------------------------------------------------------------------
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
    phen=nomob(1:16)
    mode=nomob(17:32)
!
    call jelira('&CATA.TM.NOMTM', 'NOMMAX', nbtm)
    call jenonu(jexnom('&CATA.'//phen(1:13)//'.MODL', mode), imode)
    ASSERT(imode.gt.0)
    call jeveuo(jexnum('&CATA.'//phen, imode), 'L', jphen)
!
    if (questi .eq. 'DIM_GEOM') then
        repi=zi(jphen-1+nbtm+2)
    else if (questi.eq.'DIM_TOPO') then
        repi=zi(jphen-1+nbtm+1)
    else
        ierd = 1
    endif
!
    repkz = repk
end subroutine
