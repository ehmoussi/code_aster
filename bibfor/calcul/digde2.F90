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

function digde2(modelo)
use calcul_module, only : ca_iamloc_, ca_ilmloc_
implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
    integer :: modelo
    integer :: digde2
!-----------------------------------------------------------------------
! routine identique a digdel mais qui utilise des variables de calcul_module
! pour etre plus rapide.
!
!     entrees:
!        modelo : mode_local (son indice dans &cata.te.modeloc )
!
!     sorties:
!        digde2 : nombre de scalaires representant la grandeur pour le
!                 mode_local
!
!-----------------------------------------------------------------------
    integer :: modloc
!-----------------------------------------------------------------------
    modloc = ca_iamloc_ - 1 + zi(ca_ilmloc_-1+modelo)
    digde2 = zi(modloc-1+3)
end function
