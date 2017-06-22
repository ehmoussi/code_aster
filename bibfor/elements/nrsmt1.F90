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

subroutine nrsmt1(k, j, u)
!
    implicit none
!
!
!     BUTS  : CALCUL DU TERME EN J DE L'ENERGIE ELASTIQUE DE SIMO-MIEHE
!     IN  K : MODULE DE COMPRESSIBILITE =E/ (3*(1.D0-2.D0*NU))
!     IN  J : VARIATION DE VOLUME EN GRANDES DEFORMATIONS = DET (F)
!     OUT U : VALEUR DU PREMIER TERME DE L'ENERGIE ELASTIQUE DE SM
!             U=K/2*((J*J-1)/2-ln(J))
! -----------------------------------------------------------------
    real(kind=8) :: k, j, u
!
    u=k/2.d0* (j*j/2.d0-1.d0/2.d0-log(j))
!
end subroutine
