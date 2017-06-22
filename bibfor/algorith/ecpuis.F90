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

subroutine ecpuis(e, sigy, alfafa, unsurn, pm,&
                  dp, rp, rprim)
    implicit none
!
!     ARGUMENTS:
!     ----------
    real(kind=8) :: dp, rprim, e, sigy, pm, rp, alfafa, unsurn
! ----------------------------------------------------------------------
! BUT: EVALUER LA FONCTION D'ECROUISSAGE ISOTROPE AVEC LOI EN PUISSANCE
!    IN: DP     : DEFORMATION PLASTIQUE CUMULEE
!   OUT: RP     : R(PM+DP)
!   OUT: RPRIM  : R'(PM+DP)
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    real(kind=8) :: p0, rp0, coef
!
    p0=1.d-10
    if ((pm+dp) .le. p0) then
        rp0= sigy*(e/alfafa/sigy*(p0))**unsurn + sigy
        rp= sigy+(pm+dp)*(rp0-sigy)/p0
        rprim=(rp0-sigy)/p0
    else
        coef = e/alfafa/sigy
        rp= sigy*(e/alfafa/sigy*(pm+dp))**unsurn + sigy
        rprim= unsurn * sigy * coef * (coef*(pm+dp))**(unsurn-1.d0)
    endif
!
end subroutine
