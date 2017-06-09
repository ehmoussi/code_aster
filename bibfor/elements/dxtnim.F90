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

subroutine dxtnim(qsi, eta, nmi)
    implicit  none
    real(kind=8) :: qsi, eta, nmi(3)
!     FONCTIONS D'INTERPOLATION MEMBRANE POUR LES ELEMENTS DKT ET DST
!     ------------------------------------------------------------------
!
    nmi(1) = 1.d0 - qsi - eta
    nmi(2) = qsi
    nmi(3) = eta
!
end subroutine
