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

subroutine nrsmtt(troisk, j, epsthe, m)
!
    implicit none
!
!
!     BUTS  : CALCUL DU TERME EN THERMIQUE EN J
!             DE L'ENERGIE ELASTIQUE DE SIMO-MIEHE
!     IN  TROISK : 3*MODULE DE COMPRESSIBILITE =E/ ((1.D0-2.D0*NU))
!     IN  J : VARIATION DE VOLUME EN GRANDES DEFORMATIONS = DET (F)
!     IN  EPSTHE : DEFORMATION THERMIQUE =3*alpha*(T-T0)
!     OUT M : VALEUR DU TERME THERMIQUE DE L'ENERGIE ELASTIQUE DE SM
!             M=-3K/2*EPSTHE*(J-1/J)
!
    real(kind=8) :: troisk, j, epsthe, m
!
    m=-troisk/2.d0*epsthe*(j-1/j)
!
end subroutine
