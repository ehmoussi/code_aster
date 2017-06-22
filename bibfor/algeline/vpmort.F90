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

subroutine vpmort(neq, x, y, my, imode)
    implicit none
    integer :: neq, imode
    real(kind=8) :: x(neq), y(neq, *), my(neq, *)
!     M-ORTHOGONALISATION DU VECTEUR X AVEC LES PRECEDENTS
!     ------------------------------------------------------------------
    real(kind=8) :: r8val, r8norm
    integer :: ieq, iprec
!     ------------------------------------------------------------------
    do 10 iprec = 1, imode - 1
        r8val = 0.d0
        r8norm = 0.d0
        do 20 ieq = 1, neq
            r8val = r8val + x(ieq) * my(ieq,iprec)
            r8norm = r8norm + y(ieq,iprec) * my(ieq,iprec)
20      continue
        r8val = -r8val/r8norm
        do 30 ieq = 1, neq
            x(ieq) = x(ieq) + r8val * y(ieq,iprec)
30      continue
10  end do
end subroutine
