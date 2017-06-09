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

subroutine ib1mai()
! person_in_charge: mathieu.courtois at edf.fr
!
!
    use parameters_module, only : ST_OK
    implicit none
#include "asterfort/ststat.h"
!     INITIALISATION, COMME IB0MAI, POUR LA PARTIE FORTRAN 90
!
!     LE JOUR OU ON FERA D'AUTRES INITIALISATIONS, IL FAUT CREER
!     UNE ROUTINE STINIT() A APPELER DANS UTMESG
!     (QUI APPELLE IB1MAI POUR LE MOMENT)
    call ststat(ST_OK)
end subroutine
