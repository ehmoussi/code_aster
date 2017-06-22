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

subroutine foc1ma(nbvar, var, fon, nbmax, varmax,&
                  fonmax)
    implicit none
    integer :: nbvar, nbmax
    real(kind=8) :: var(*), fon(*), varmax(*), fonmax(*)
!     "MEDISIS"   CALCUL DES MAXIMA D'UNE FONCTION
!     ----------------------------------------------------------------
    real(kind=8) :: lemax, epsd, eps
!     ----------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    epsd = 1.d-6
    lemax = abs(fon(1))
    eps = epsd * lemax
    nbmax = 1
    varmax(1) = var(1)
    fonmax(1) = fon(1)
    do 100 i = 2, nbvar
        if (abs(fon(i)) .ge. lemax-eps) then
            if (abs(fon(i)) .gt. lemax+eps) then
                nbmax = 1
                lemax = abs(fon(i))
                eps = epsd * lemax
                varmax(nbmax) = var(i)
                fonmax(nbmax) = fon(i)
            else
                nbmax = nbmax + 1
                varmax(nbmax) = var(i)
                fonmax(nbmax) = fon(i)
            endif
        endif
100  end do
end subroutine
