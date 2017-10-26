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
! person_in_charge: mickael.abbas at edf.fr
!
!
! THM data structure : Parameters <-> integer definitions
! -------------------------------------------------------------------------
!

! - Type of Biot coefficients
#define BIOT_TYPE_ISOT   0
#define BIOT_TYPE_ISTR   1
#define BIOT_TYPE_ORTH   2
! - Type of saturation
#define SATURATED        0
#define UNSATURATED      1
#define SATURATED_SPEC   2
! - Type of thermal conductivity
#define THER_COND_ISOT   0
#define THER_COND_ISTR   1
#define THER_COND_ORTH   2
! - Coupling laws
#define NO_LAW           0
#define LIQU_SATU        1
#define GAZ              2
#define LIQU_VAPE        3
#define LIQU_VAPE_GAZ    4
#define LIQU_GAZ         5
#define LIQU_GAZ_ATM     6
#define LIQU_AD_GAZ_VAPE 9
#define LIQU_AD_GAZ      10

