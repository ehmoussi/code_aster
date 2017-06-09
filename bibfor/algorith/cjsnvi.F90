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

subroutine cjsnvi(mod, ndt, ndi, nvi)
    implicit none
#include "asterfort/utmess.h"
!
!       CJS        : DONNE NOMBRE CONTARINTES ET NOMBRE VARIABLES DE
!                    CJS
!       ----------------------------------------------------------------
!       IN
!           MOD    :  TYPE DE MODELISATION
!       OUT
!           NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
!           NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
!           NVI    :  NB DE VARIABLES INTERNES
!       ----------------------------------------------------------------
    integer :: ndt, ndi, nvi
!
! VARIABLES LOALES POUR SE PREMUNIR D APPELS DU TYPE
! CALL CJSNVI(MOD,IBID,IBID,NVI)
!
    integer :: ndtloc, ndiloc
    character(len=8) :: mod
!       ----------------------------------------------------------------
!
! -     NB DE COMPOSANTES / VARIABLES INTERNES -------------------------
!
!
! - 3D
    if (mod(1:2) .eq. '3D') then
        ndtloc = 6
        ndiloc = 3
!
! - D_PLAN AXIS
    else if (mod(1:6).eq.'D_PLAN'.or.mod(1:4).eq.'AXIS') then
        ndtloc = 4
        ndiloc = 3
!
! - C_PLAN
    else if (mod(1:6).eq.'C_PLAN') then
        call utmess('F', 'ALGORITH2_15')
!
! - 1D
    else if (mod(1:2).eq.'1D') then
        call utmess('F', 'ALGORITH2_15')
! - 1D
    else
        call utmess('F', 'ALGORITH2_20')
    endif
    nvi = ndtloc+10
    ndt = ndtloc
    ndi = ndiloc
end subroutine
