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

subroutine rc32f2(nbsigr, nocc, saltij, isk, isl,&
                  nk, nl, n0)
    implicit   none
    integer :: nbsigr, nocc(*), isk, isl, nk, nl, n0
    real(kind=8) :: saltij(*)
!
!     MISE A ZERO DES LIGNES ET COLONNES DANS SALT POUR LES
!     SITUATION K ET L SI NOCC = 0
!
!     ------------------------------------------------------------------
    integer :: k, l
!     ------------------------------------------------------------------
!
    nocc(isl) = nl - n0
    if (nocc(isl) .eq. 0) then
        do 30 k = 1, nbsigr
            saltij(nbsigr*(k-1)+isl) = 0.d0
30      continue
        do 32 l = 1, nbsigr
            saltij(nbsigr*(isl-1)+l) = 0.d0
32      continue
    endif
!
    nocc(isk) = nk - n0
    if (nocc(isk) .eq. 0) then
        do 50 k = 1, nbsigr
            saltij(nbsigr*(k-1)+isk) = 0.d0
50      continue
        do 52 l = 1, nbsigr
            saltij(nbsigr*(isk-1)+l) = 0.d0
52      continue
    endif
!
end subroutine
