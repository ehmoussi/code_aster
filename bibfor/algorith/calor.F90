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

function calor(mdal, t, dt, deps, dp1,&
               dp2, signe, alp11, alp12, coeps,&
               ndim)
    implicit none
!
    integer :: i, ndim
    real(kind=8) :: t, dt, deps(6), dp1, dp2, alp11, alp12, signe, coeps
    real(kind=8) :: calor, mdal(6), calome, rac2
! --- CALCUL DE LA CHALEUR REDUITE Q' SELON FORMULE DOCR ---------------
! ======================================================================
    rac2 = sqrt(2.d0)
    calome = 0.d0
!
    do 10 i = 1, ndim
        calome=calome+mdal(i)*deps(i)*(t-dt/2.0d0)
10  end do
    do 20 i = ndim+1, 2*ndim
        calome=calome+mdal(i)*deps(i)*(t-dt/2.0d0)*rac2
20  end do
    calor = calome + 3.0d0*alp11*(t-dt/2.0d0)*signe*dp1 - 3.0d0*(alp11+alp12)*(t-dt/2.d0)*dp2 + c&
            &oeps*dt
! ======================================================================
end function
