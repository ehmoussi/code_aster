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

subroutine coesp4(tauvid, phi0)
    implicit none
!
!
! DESCRIPTION : VALEURS DES COEFFICIENTS DEFINISSANT
! -----------   LE SPECTRE DE TURBULENCE.
!
!
!    PHI0 DEPEND DU TAUX DE VIDE TAUVID.
!    BETA ET GAMMA SONT CONSTANTS.
!
! ******************   DECLARATION DES VARIABLES   *********************
!
! ARGUMENTS
! ---------
    real(kind=8) :: tauvid, phi0
!
! ******************   DEBUT DU CODE EXECUTABLE   **********************
!
    phi0 = (&
           24.042d0 * (tauvid**0.5d0) ) - ( 50.421d0 * (tauvid**1.5d0) ) + ( 63.483d0 * (tauvid**&
           &2.5d0) ) - ( 33.284d0 * (tauvid**3.5d0)&
           )
!
    phi0 = (10.0d0**phi0) / (6.8d-2)
!
end subroutine
