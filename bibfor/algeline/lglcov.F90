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

function lglcov(seuil, toler)
!
    implicit none
#include "asterf_types.h"
    aster_logical :: lglcov
    real(kind=8) :: seuil, toler
! --- BUT : TESTE DE CONVERGENCE ---------------------------------------
! ======================================================================
! IN  : SEUIL  : VALEUR DU SEUIL (F(N+1)) ------------------------------
! ----- SIGC   : PARAMETRE MATERIAU ------------------------------------
! ----- TOLER  : TOLERANCE DE CONVERGENCE ------------------------------
! OUT : LGLCOV : .TRUE.   SI CONVERGENCE -------------------------------
! ------------ : .FALSE.  SINON ----------------------------------------
! ======================================================================
! --- INITIALISATION ---------------------------------------------------
! ======================================================================
    if (abs(seuil) .le. toler) then
        lglcov = .true.
    else
        lglcov = .false.
    endif
! ======================================================================
end function
