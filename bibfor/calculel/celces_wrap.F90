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

subroutine celces_wrap(celz, basez, cesz)
! A_UTIL
    implicit none
#include "asterf_types.h"
#include "asterfort/celces.h"
!
    character(len=*) :: celz, cesz, basez
! ------------------------------------------------------------------
! BUT : TRANSFORMER UN CHAM_ELEM (CELZ) EN CHAM_ELEM_S (CESZ)
!       LES ELEMENTS DONT LA MAILLE SUPPORT EST TARDIVE SONT
!       IGNORES.
! ------------------------------------------------------------------
!     ARGUMENTS:
! CELZ    IN/JXIN  K19 : SD CHAM_ELEM A TRANSFORMER
! BASEZ   IN       K1  : BASE DE CREATION POUR CESZ : G/V/L
! CESZ    IN/JXOUT K19 : SD CHAM_ELEM_S A CREER
!     ------------------------------------------------------------------
!
    call celces(celz, basez, cesz)
end subroutine
