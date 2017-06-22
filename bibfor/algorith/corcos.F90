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

function corcos(d1, d2, mes1, uc, kt,&
                kl, omega)
    implicit none
!
! *****************   DECLARATIONS DES VARIABLES   ********************
!
!
! ARGUMENTS
! ---------
#include "jeveux.h"
    real(kind=8) :: d1, d2, omega, kt, uc, kl, mes1
!
!
! VARIABLES LOCALES
! -----------------
    real(kind=8) :: corcos
!
!
!
! CALCUL DE LA FONCTION DE COHERENCE
!
!
    corcos=exp(-kt*d2)*exp(-kl*d1)&
     &                    *cos(omega*mes1/uc)
!
!
end function
