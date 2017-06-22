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

subroutine brseff(k0, mu0, e0s, e0d, sigeff)
!
!     ROUTINE ANCIENNEMENT NOMMEE SIGMA_EFF
!
!
    implicit none
    real(kind=8) :: e0d(6), sigeff(6)
    integer :: i
!
!       CLASSEMENT DES CONTRAINTES ET DES DEFORMATION:*
!      I=1,3 => SIGMA II
!      I=4   => SIGMA 12
!      I=5   => SIGMA 13
!      I=6   => SIGMA 23
!
!
!       TENSEUR DES CONTRAINTES EFFECTIVES DANS LA PATE (NIVEAU P1)
!
!       CONTRAINTE SPHéRIQUE
!-----------------------------------------------------------------------
    real(kind=8) :: e0s, sigs, k0, mu0
!-----------------------------------------------------------------------
    sigs=k0*e0s
!     PARTIE DEVIATORIQUE , ATTENTION LES EOD SONT EN FAIT DES GAMMA ...
    do 10 i = 1, 3
        sigeff(i)=sigs+mu0*e0d(i)
10  end do
!     LES TROIS TERMES HORS DIAGONALES SONT ENCORE DES GAMMA...
    do 20 i = 4, 6
        sigeff(i)=mu0*e0d(i)
20  end do
!
end subroutine
