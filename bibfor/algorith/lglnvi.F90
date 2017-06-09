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

subroutine lglnvi(mod, ndt, ndi, nvi)
!
    implicit none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: ndt, ndi, nvi
    character(len=8) :: mod
! |---------------------------------------------------------------|
! |-- BUT : RECUPERATION DU NOMBRE DE VARIABLES INTERNES ---------|
! |---------------------------------------------------------------|
! =================================================================
! IN  : MOD    : TYPE DE MODELISATION -----------------------------
! OUT : NDT    : NOMBRE TOTAL DE COMPOSANTES DU TENSEUR -----------
! --- : NDI    : NOMBRE DE COMPOSANTES DIRECTES DU TENSEUR --------
! --- : NVI    : NB DE VARIABLES INTERNES -------------------------
! =================================================================
! --- LES VARIABLES INTERNES --------------------------------------
! -----------------------------------------------------------------
! --- VIN(1)          : GAMP --------------------------------------
! --- VIN(2)          : DEFORMATION VOLUMIQUE PLASTIQUE CUMULEE ---
! --- VIN(3)          : DOMAINE DE COMPORTEMENT DU MATERIAU -------
! --- VIN(4)          : ETAT DU MATERIAU --------------------------
! =================================================================
    call jemarq()
! =================================================================
! --- NB DE COMPOSANTES / VARIABLES INTERNES ----------------------
! =================================================================
    if (mod(1:2) .eq. '3D') then
! =================================================================
! - MODELISATION DE TYPE 3D ---------------------------------------
! =================================================================
        ndt = 6
        ndi = 3
        else if ( mod(1:6).eq.'D_PLAN'.or. mod(1:4).eq.'AXIS' .or.&
    mod(1:6).eq.'C_PLAN' ) then
! =================================================================
! - D_PLAN AXIS C_PLAN --------------------------------------------
! =================================================================
        ndt = 4
        ndi = 3
    else if (mod(1:2).eq.'1D') then
! =================================================================
! - MODELISATION DE TYPE 1D NON AUTORISEE -------------------------
! =================================================================
        call utmess('F', 'ALGORITH4_45')
    else
! =================================================================
! - MODELISATION INCONNUE -----------------------------------------
! =================================================================
        call utmess('F', 'ALGORITH2_20')
    endif
! =================================================================
! - NOMBRE DE VARIABLES INTERNES ET DES CONDITIONS NON-LINEAIRES --
! =================================================================
    nvi = 4
! =================================================================
    call jedema()
! =================================================================
end subroutine
