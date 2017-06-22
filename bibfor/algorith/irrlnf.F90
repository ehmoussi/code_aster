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

subroutine irrlnf(nmat, materf, yf, eloupl, vinf)
    implicit none
! person_in_charge: jean-luc.flejou at edf.fr
! --- -------------------------------------------------------------
!
!    IRRAD3M  : CORRESPONDANCE ENTRE LES VARIABLES INTERNES ET LES
!               EQUATIONS DU SYSTEME DIFFERENTIEL INTEGREES PAR NEWTON
!
! --- -------------------------------------------------------------
!  IN
!     NMAT   : DIMENSION MATER
!     MATERF : COEF MATERIAU
!     YF     : VARIABLES INTERNES INTEGREES PAR NEWTON
!     ELOUPL : ELASTIQUE OU PLASTIQUE (0 OU 1)
!     IDPLAS : INDICATEUR PLASTIQUE
!  OUT
!     VINF   : VARIABLES INTERNES INTEGREES
! --- -------------------------------------------------------------
    integer :: nmat
    real(kind=8) :: yf(*), vinf(*), materf(nmat, 2), eloupl
!
!     DEFORMATION PLASTIQUE CUMULEE
    vinf(1) = yf(1)
!     FONCTION SEUIL DE FLUAGE
    vinf(2) = yf(2)
!     DEFORMATION EQUIVALENTE DE FLUAGE
    vinf(3) = yf(3)
!     DEFORMATION DE GONFLEMENT
    vinf(4) = yf(4)
!     INDICATEUR PLASTIQUE
    vinf(5) = eloupl
!     IRRADIATION
    vinf(6) = materf(18,2)
!     TEMPERATURE
    vinf(7) = materf(22,2)
end subroutine
