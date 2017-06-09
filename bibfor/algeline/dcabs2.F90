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

function dcabs2(c)
    implicit none
! CALCUL DU MODULE D'UN NOMBRE COMPLEXE
!-----------------------------------------------------------------------
!  IN : C : NOMBRE COMPLEXE DONT ON VEUT CALCULER LE MODULE
!-----------------------------------------------------------------------
    real(kind=8) :: dcabs2
    complex(kind=8) :: c
    complex(kind=8) :: cbar, ccbar
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    cbar = dconjg(c)
    ccbar = c*cbar
    dcabs2 = dble(sqrt(dble(ccbar)))
end function
