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

!
!
interface
    subroutine sspace(lraid, lmatra, lmass, neq, nbvec,&
                      nfreq, lprod, itemax, nperm, tol,&
                      toldyn, vect, valpro, nitjac, nitbat,&
                      solveu)
        integer :: nbvec
        integer :: neq
        integer :: lraid
        integer :: lmatra
        integer :: lmass
        integer :: nfreq
        integer :: lprod(neq)
        integer :: itemax
        integer :: nperm
        real(kind=8) :: tol
        real(kind=8) :: toldyn
        real(kind=8) :: vect(neq, nbvec)
        real(kind=8) :: valpro(nbvec)
        integer :: nitjac
        integer :: nitbat
        character(len=19) :: solveu
    end subroutine sspace
end interface
