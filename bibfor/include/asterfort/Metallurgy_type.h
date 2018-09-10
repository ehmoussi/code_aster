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
#define META_NONE        0
#define META_STEEL       1
#define META_ZIRC        2
!
! - Phases for steel
!
#define STEEL_NBVARI     8
#define PFERRITE         1
#define PPERLITE         2
#define PBAINITE         3
#define PMARTENS         4
#define PAUSTENITE       5
#define SIZE_GRAIN       6
#define STEEL_TEMP       7
#define TEMP_MARTENSITE  8
!
! - Phases for zircaloy
!
#define ZIRC_NBVARI      5
#define PALPHA1          1
#define PALPHA2          2
#define PBETA            3
#define ZIRC_TEMP        4
#define TIME_TRAN        5
!
! - Kinetic
!
#define COOLING          0
#define HEATING          1
