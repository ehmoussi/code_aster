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

subroutine conech(macoc, i1, i2)
!
!  ROUTINE CONECH
!    PERMUTATION DE DEUX NOEUDS
!  DECLARATIONS
!    KDUM   : CHARACTER DE TRAVAIL
!    MACOC  : TABLEAU DES NOMS DES NOEUDS   POUR UNE MAILLE FISSURE
!
!  MOT_CLEF : ORIE_FISSURE
!
    implicit none
!
!     ------------------------------------------------------------------
!
    character(len=8) :: kdum
    character(len=8) :: macoc(*)
!
!-----------------------------------------------------------------------
    integer :: i1, i2
!-----------------------------------------------------------------------
    kdum = macoc(i1+2)
    macoc(i1+2) = macoc(i2+2)
    macoc(i2+2) = kdum
!
end subroutine
