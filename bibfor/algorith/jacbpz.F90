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

subroutine jacbpz(kn, cn, jacobc, jacobk)
    implicit none
! DESCRIPTION : CALCUL DES MATRICES JACOBIENNES LIEES A LA FORCE
! -----------   NON-LINEAIRE DE CHOC F(X,DX)
!
!               CAS DE LA BUTEE PLANE SUIVANT Z LOCAL
!
!               APPELANT : CALJAC
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
! ARGUMENTS
! ---------
    real(kind=8) :: kn, cn
    real(kind=8) :: jacobc(3, *), jacobk(3, *)
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
!  1. MATRICE JACOBIENNE DE RAIDEUR
!     -----------------------------
    jacobk(1,1) = 0.0d0
    jacobk(1,2) = 0.0d0
    jacobk(1,3) = 0.0d0
!
    jacobk(3,1) = 0.0d0
    jacobk(3,2) = 0.0d0
    jacobk(3,3) = - kn
!
    jacobk(2,1) = 0.0d0
    jacobk(2,2) = 0.0d0
    jacobk(2,3) = 0.0d0
!
!  2. MATRICE JACOBIENNE D'AMORTISSEMENT
!     ----------------------------------
    jacobc(1,1) = 0.0d0
    jacobc(1,2) = 0.0d0
    jacobc(1,3) = 0.0d0
!
    jacobc(3,1) = 0.0d0
    jacobc(3,2) = 0.0d0
    jacobc(3,3) = - cn
!
    jacobc(2,1) = 0.0d0
    jacobc(2,2) = 0.0d0
    jacobc(2,3) = 0.0d0
!
! --- FIN DE JACBPZ.
end subroutine
