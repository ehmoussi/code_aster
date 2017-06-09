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

subroutine nuachp(nuage, lno, chpt)
    implicit none
#include "asterfort/dismoi.h"
#include "asterfort/nuacno.h"
#include "asterfort/utmess.h"
    character(len=*) :: nuage, lno, chpt
!     PASSAGE D'UNE SD NUAGE A UNE SD CHAM_GD
!
! IN  NUAGE  : NOM DE LA SD NUAGE ALLOUEE
! IN  LNO    : LISTE DES NOEUDS A PRENDRE EN COMPTE
! VAR CHPT   : NOM DE LA SD CHAM_GD (CHPT A ETE CREE)
!     ------------------------------------------------------------------
    character(len=4) :: type
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call dismoi('TYPE_CHAMP', chpt, 'CHAMP', repk=type)
!
    if (type .eq. 'NOEU') then
        call nuacno(nuage, lno, chpt)
    else
        call utmess('F', 'CALCULEL_17')
    endif
!
end subroutine
