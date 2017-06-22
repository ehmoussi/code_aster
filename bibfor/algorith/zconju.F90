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

subroutine zconju(zin, prea, pima)
    implicit none
!
!  BUT:  RENDRE LES PARTIES REELLE, IMAGINAIRE D'UN COMPLEXE*16
!   ROUTINE PLUS PRECISE QUE LES REAL ET IMAG FORTRAN
!
!  ATTENTION PREA ET PIMA DOIVENT BIEN ETRE DES REAL*8 DANS LA
!   SUBROUTINE APPELANTE
!
!-----------------------------------------------------------------------
!
! ZIN      /I/: COMPLEXE A DECORTIQUER
! PREA     /O/: PARTIE REELLE CORRESPONDANTE
! PIMA     /O/: PARTIE IMAGINAIRE CORRESPONDANTE
!
!-----------------------------------------------------------------------
    complex(kind=8) :: zin
    real(kind=8) :: prea, pima
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    prea = dble(zin)
    pima = dimag(zin)
!
end subroutine
