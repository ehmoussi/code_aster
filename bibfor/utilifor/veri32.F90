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

subroutine veri32()
    implicit none
! person_in_charge: jacques.pellet at edf.fr
! BUT : ARRETER LE CODE SI L'ON EST SUR UNE MACHINE OU LES ENTIERS
!       SONT STOCKES SUR 32 BITS OU MOINS
#include "asterc/loisem.h"
#include "asterfort/utmess.h"
!
    if (loisem() .le. 4) then
        call utmess('F', 'UTILITAI_22')
    endif
end subroutine
