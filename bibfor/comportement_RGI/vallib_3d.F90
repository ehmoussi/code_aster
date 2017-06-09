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

subroutine vallib_3d(khi, dallib, alf, alfeq, dafm,&
                     casol, nasol, alsol)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d :
!     calcul de la vitesse de fixation de l'aluminium dans les csh
!=====================================================================
    implicit none
    real(kind=8) :: khi
    real(kind=8) :: dallib
    real(kind=8) :: alf
    real(kind=8) :: alfeq
    real(kind=8) :: dafm
    real(kind=8) :: alsol
    real(kind=8) :: casol
    real(kind=8) :: nasol
!     on ne fixe de l alu dans les csh ou on les relargue
!     on fait en sorte que cette vitesse soit grande devant
!     celle de formation d aft et afm de façon a la priovilegier
    dallib=100.d0*khi*(dlog10(alfeq)-dlog10(alf))
end subroutine
