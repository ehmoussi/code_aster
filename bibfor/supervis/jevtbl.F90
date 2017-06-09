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

function jevtbl(questi)
    implicit none
    real(kind=8) :: jevtbl
#include "asterfort/assert.h"
    character(len=*) :: questi
!    BUT : RETOURNER LA VALEUR D'UN MOT CLE DE DEBUT/MEMOIRE
!     ------------------------------------------------------------------
! IN  QUESTI  : MOT CLE A SCRUTER : TAILLE_BLOC / TAILLE_GROUP_ELEM
! OUT JEVTBL  : VALEUR DU MOT CLE
!     ------------------------------------------------------------------
    real(kind=8) :: tbloc, tgrel
    common /rtblje/tbloc,tgrel
! ----------------------------------------------------------------------
    if (questi .eq. 'TAILLE_BLOC') then
        jevtbl=tbloc
    else if (questi.eq.'TAILLE_GROUP_ELEM') then
        jevtbl=tgrel
    else
        ASSERT(.false.)
    endif
end function
