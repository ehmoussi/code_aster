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

subroutine mdgeph(neq, nbmode, bmodal, xgene, u)
!     CONVERTIT EN BASE PHYSIQUE MODE VECTEUR
!     REM U EST INITIALISE A 0.
!
!-----------------------------------------------------------------------
!                             ARGUMENTS
! .________________.____.______________________________________________.
!        NOM        MODE                    ROLE
!  ________________ ____ ______________________________________________
!    NEQ            <--   NB D'EQUATIONS DU SYSTEME ASSEMBLE
!    NBMODE         <--   NB DE MODES NORMAUX CONSIDERES
!    BMODAL         <--   BASE MODALE CONSIDEREE
!    XGENE          <--   VECTEUR DES COORDONNEES GENERALISEES
!    U              <--   VECTEUR DES COORDONNEES PHYSIQUES
! .________________.____.______________________________________________.
    implicit none
    real(kind=8) :: bmodal(neq, nbmode), xgene(nbmode), u(neq)
    integer :: i, j, nbmode, neq
!-----------------------------------------------------------------------
    do 10 i = 1, neq
        u(i)=0.0d0
        do 10 j = 1, nbmode
            u(i) = u(i) + bmodal(i,j)*xgene(j)
10      continue
end subroutine
