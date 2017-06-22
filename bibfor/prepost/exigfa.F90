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

function exigfa(dgf, ngf)
    implicit none
#include "asterf_types.h"
    aster_logical :: exigfa
    integer :: dgf(*), ngf
!     INDIQUE L'EXISTENCE DU NUM GROUPE NGF DANS DESCRIPTEUR-GROUPE DGF
!     DGF    = DESCRIPTEUR-GROUPE DE LA FAMILLE (VECTEUR ENTIERS)
!     NGF    = NUMERO DU GROUPE
!     ------------------------------------------------------------------
    integer :: iand
    integer :: iec, reste, code
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    iec = ( ngf - 1 ) / 30
    reste = ngf - 30 * iec
    code = 2**reste
    iec = iec + 1
    exigfa = iand ( dgf(iec),code ) .eq. code
end function
