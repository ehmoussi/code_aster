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

subroutine srlnvi(mod, ndt, ndi, nvi)

!

!!!
!!! MODELE LKR : RECUPERATION DE NDT, NDI ET NVI
!!!

! ===================================================================================
! IN  : MOD : TYPE DE MODELISATION
! OUT : NDT : NOMBRE TOTAL DE COMPOSANTES DU TENSEUR
!     : NDI : NOMBRE DE COMPOSANTES DIRECTES DU TENSEUR
!     : NVI : NB DE VARIABLES INTERNES
! ===================================================================================

    implicit none

#include "asterfort/utmess.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: ndt, ndi, nvi
    character(len=8) :: mod
    
    !!!
    !!! Modelisation 3d
    !!!
    
    if (mod(1:2) .eq. '3D') then
        ndt = 6
        ndi = 3
    
    !!!
    !!! Modelisation d_plan, axi ou c_plan
    !!!
    
    else if (mod(1:6).eq.'D_PLAN'.or. mod(1:4).eq.'AXIS' .or.&
             mod(1:6).eq.'C_PLAN' ) then
        ndt = 4
        ndi = 3
    
    !!!
    !!! Modelisation 1d non autorisee
    !!!
    
    else if (mod(1:2).eq.'1D') then
        call utmess('F', 'ALGORITH4_45')
    
    !!!
    !!! Modelisation inconnue
    !!!
    
    else
        call utmess('F', 'ALGORITH2_20')
    endif
    
    !!!
    !!! Nombre de variables internes
    !!!
    
    nvi = 12

end subroutine
