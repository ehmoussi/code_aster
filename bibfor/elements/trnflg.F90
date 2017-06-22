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

subroutine trnflg(nbx, vectpt, vecl, vecg)
    implicit none
!
    integer :: nbx
    real(kind=8) :: vecl(*), vecg(*), vectpt(9, 3, 3)
!
!     CONSTRUCTION DE LA MATRICE VECG = PLGT * VECL
!
!-----------------------------------------------------------------------
    integer :: i1, ib
!-----------------------------------------------------------------------
    do 10 ib = 1, nbx
!
        i1=6*(ib-1)
!
!     LES TERMES DE FORCE
!
        if (ib .le. nbx-1) then
            vecg(i1+1)=vecl(i1+1)
            vecg(i1+2)=vecl(i1+2)
            vecg(i1+3)=vecl(i1+3)
!
!     LES TERMES DE MOMENT = TPI * MLOCAL  (  TPI = TI  )
!
            vecg(i1+4)=vectpt(ib,1,1)*vecl(i1+4)+vectpt(ib,2,1)*vecl(&
            i1+5) +vectpt(ib,3,1)*vecl(i1+6)
            vecg(i1+5)=vectpt(ib,1,2)*vecl(i1+4)+vectpt(ib,2,2)*vecl(&
            i1+5) +vectpt(ib,3,2)*vecl(i1+6)
            vecg(i1+6)=vectpt(ib,1,3)*vecl(i1+4)+vectpt(ib,2,3)*vecl(&
            i1+5) +vectpt(ib,3,3)*vecl(i1+6)
        else
            vecg(i1+1)=vectpt(ib,1,1)*vecl(i1+1)+vectpt(ib,2,1)*vecl(&
            i1+2) +vectpt(ib,3,1)*vecl(i1+3)
            vecg(i1+2)=vectpt(ib,1,2)*vecl(i1+1)+vectpt(ib,2,2)*vecl(&
            i1+2) +vectpt(ib,3,2)*vecl(i1+3)
            vecg(i1+3)=vectpt(ib,1,3)*vecl(i1+1)+vectpt(ib,2,3)*vecl(&
            i1+2) +vectpt(ib,3,3)*vecl(i1+3)
        endif
10  end do
!
end subroutine
