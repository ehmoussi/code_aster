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

subroutine rrldc(a, nordre, x, nves)
!    A. COMTE                                 DATE 31/07/91
!-----------------------------------------------------------------------
!  BUT:  RESOLUTION DE L'EQUATION MATRICIELLE
    implicit none
!                 A*X=B
!
!  OU A EST UNE MATRICE COMPLEXE FACTORISEE LDLT PAR TRLDC
!
!-----------------------------------------------------------------------
!
! A        /I/: MATRICE CARRE COMPLEXE TRIANGULEE LDLT
! NORDRE   /I/: DIMENSION DE LA MATRICE A
! X        /M/: MATRICE IN:SECONDS MEMBRES   OUT:SOLUTIONS
! NVEC     /I/: NOMBRE DE VECTEURS SECOND MEMBRE
!
!-----------------------------------------------------------------------
!
    complex(kind=8) :: a(*), x(nordre, nves), r8val
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, idiag, ilign1, ilign2, in, indiag, nordre
    integer :: nv, nves
!-----------------------------------------------------------------------
    ilign1 = 1
    ilign2 = nordre
!
!     RESOLUTION DESCENDANTE
    do 25 nv = 1, nves
        do 20 in = ilign1, ilign2-1
            r8val = - x (in,nv)
            do 21 i = in+1, ilign2
                idiag=i*(i-1)/2+1
                x(i,nv) = x(i,nv) + r8val*dconjg(a(idiag+i-in))
21          continue
20      continue
25  end do
!
!     RESOLUTION DIAGONALE
    do 39 nv = 1, nves
        do 33 in = ilign1, ilign2
            indiag = in*(in-1)/2+1
            x ( in , nv ) = x ( in , nv ) / a(indiag)
33      continue
39  end do
!
!     RESOLUTION REMONTANTE
    do 45 nv = 1, nves
        do 40 in = ilign2, ilign1+1, -1
            indiag = in*(in-1)/2+1
            r8val = - x ( in , nv )
            do 41 i = 1, in-1
                x(i,nv) = x(i,nv) + r8val*a(indiag+in-i)
41          continue
40      continue
45  end do
!
end subroutine
