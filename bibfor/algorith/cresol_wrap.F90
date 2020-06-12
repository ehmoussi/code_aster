! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine cresol_wrap(solveu, base, xfem)
    implicit none
#include "jeveux.h"
#include "asterfort/cresol.h"
    character(len=19) :: solveu
    character(len=1) :: base
    character(len=3) :: xfem
! person_in_charge: nicolas.sellenet at edf.fr
! ----------------------------------------------------------------------
!
!     CREATION D'UNE SD_SOLVEUR PAR LECTURE DU MOT CLE SOLVEUR
!
! IN/JXOUT K19 SOLVEU  : SD_SOLVEUR
!
! ----------------------------------------------------------------------
!
    call cresol(solveu, base, xfem)
!
end subroutine
