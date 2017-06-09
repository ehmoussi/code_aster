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

subroutine rvdet3(t, d)
    implicit none
!
!
#include "asterfort/rvdet2.h"
    real(kind=8) :: t(*), d
!
!*********************************************************************
!
!   OPERATION REALISEE
!   ------------------
!
!     CALCUL DU DETERMINANT DU TENSEUR 3X3 SYMETRIQUE T
!
!     T EST REPRESENTE PAR LA TABLE DE SES COMPOSANTES DANS L' ORDRE :
!
!        XX, YY, ZZ, XY, XZ, YZ
!
!
!*********************************************************************
!
    real(kind=8) :: aux
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    d = 0.0d0
    aux = 0.0d0
!
    call rvdet2(t(2), t(6), t(6), t(3), aux)
!
    d = t(1)*aux
!
    call rvdet2(t(4), t(6), t(5), t(3), aux)
!
    d = d - t(4)*aux
!
    call rvdet2(t(4), t(2), t(5), t(6), aux)
!
    d = d + t(5)*aux
!
end subroutine
