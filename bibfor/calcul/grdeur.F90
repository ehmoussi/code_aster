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

function grdeur(nompar)

use calcul_module, only : ca_iaopds_, ca_iaoppa_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/utmess.h"

    character(len=8) :: nompar
    integer :: grdeur
!-----------------------------------------------------------------------
!   entrees:
!      nompar : nom d'1 parametre de l'option que l'on calcule.
!   sorties:
!      grdeur : grandeur associee au parametre
!-----------------------------------------------------------------------
    integer :: jpar, nbpar
!-------------------------------------------------------------------

    nbpar = zi(ca_iaopds_-1+2) + zi(ca_iaopds_-1+3) + zi(ca_iaopds_-1+4)
    jpar = indik8(zk8(ca_iaoppa_),nompar,1,nbpar)
    if (jpar .eq. 0) then
        call utmess('F', 'CALCUL_14', sk=nompar)
    endif
    grdeur = zi(ca_iaopds_-1+4+jpar)
end function
