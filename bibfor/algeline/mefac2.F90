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

function mefac2(n, m)
    implicit none
!
    integer :: n, m
    real(kind=8) :: mefac2
!     CALCUL DE L'EXPRESSION FACTORIELLE SUIVANTE :
!     (N+M-1)!/(M-1)!/(N-1)! = N(N+1)...(N+M-1)/(M-1)/.../1
!     OPERATEUR APPELANT : OP0144 , FLUST3, MEFIST, MEFMAT
! ----------------------------------------------------------------------
!     OPTION DE CALCUL   : CALC_FLUI_STRU , CALCUL DES PARAMETRES DE
!     COUPLAGE FLUIDE-STRUCTURE POUR UNE CONFIGURATION DE TYPE "FAISCEAU
!     DE TUBES SOUS ECOULEMENT AXIAL"
! ----------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    mefac2 = n
    do 1 i = 1, m-1
        mefac2 = mefac2*(n+i)/i
 1  end do
!
end function
