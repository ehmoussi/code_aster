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

subroutine chpnua(nx, chpt, lno, nuage)
    implicit none
#include "asterfort/cnonua.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
    integer :: nx
    character(len=*) :: chpt, lno, nuage
!     PASSAGE D'UNE SD CHAM_GD A UNE SD NUAGE
!
! IN  NX     : DIMENSION D'ESPACE DU NUAGE (1,2 OU 3)
! IN  CHPT   : NOM DE LA SD CHAM_GD
! IN  LNO    : LISTE DES NOEUDS A PRENDRE EN COMPTE
! OUT NUAGE  : SD NUAGE PRODUITE
!     ------------------------------------------------------------------
    character(len=4) :: type
!     ------------------------------------------------------------------
!
    call dismoi('TYPE_CHAMP', chpt, 'CHAMP', repk=type)
!
    if (type .eq. 'NOEU') then
        call cnonua(nx, chpt, lno, nuage)
    else if (type(1:2) .eq. 'EL') then
        call utmess('F', 'UTILITAI_34')
    else
        call utmess('F', 'CALCULEL_17')
    endif
!
end subroutine
