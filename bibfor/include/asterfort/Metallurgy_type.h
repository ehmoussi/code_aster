! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
! Metallurgy data structure
! -------------------------------------------------------------------------
!
!
! - Phases for steel
!
#define STEEL_NBVARI     7
#define PFERRITE         1
#define PPERLITE         2
#define PBAINITE         3
#define PMARTENS         4
#define SIZE_GRAIN       5
#define STEEL_TEMP       6
#define TEMP_MARTENSITE  7
!
! - Phases for zircaloy
!
#define ZIRC_NBVARI      4
!
! - Kinetic
!
#define COOLING          0
#define HEATING          1
