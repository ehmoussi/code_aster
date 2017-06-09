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

subroutine coesp1(ren, phi0, eps, frc, beta)
    implicit none
!
!
! DESCRIPTION : VALEURS DES COEFFICIENTS DEFINISSANT
! -----------   LE SPECTRE DE TURBULENCE.
!
!
!    PHI0, EPS ET BETA DEPENDENT DU REYNOLDS REN.
!    FRC EST CONSTANT.
!
! ******************   DECLARATION DES VARIABLES   *********************
!
! ARGUMENTS
! ---------
    real(kind=8) :: ren, phi0, eps, frc, beta
!
! ******************   DEBUT DU CODE EXECUTABLE   **********************
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (ren .le. 1.5d+4) then
        phi0 = 2.1808d0
    else if (ren .le. 5.0d+4) then
        phi0 = 20.42d0 - 14.00d-4 * ren - 9.81d-8 * ren*ren + 11.97d-12 * ren*ren*ren - 35.95d-17&
               & * ren*ren*ren*ren + 34.69d-22 * ren*ren*ren*ren*ren
    else
        phi0 = 38.6075d0
    endif
    phi0 = phi0 * 1.3d-4
!
    if (ren .le. 3.5d+4) then
        eps = 0.7d0
        beta = 3.0d0
    else if (ren .gt. 5.5d+4) then
        eps = 0.6d0
        beta = 4.0d0
    else
        eps = 0.3d0
        beta = 4.0d0
    endif
!
    frc = 0.2d0
!
end subroutine
