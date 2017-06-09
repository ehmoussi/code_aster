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

subroutine b3d_elas(var0, nvari, nvar0, depsv, dgamd6,&
                    xk0, xmu0, sigef6, varf, hydra0,&
                    hydra1)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!=====================================================================
!     calcul de l increment de contrainte elastique
!=====================================================================
    implicit none
    integer :: nvari, nvar0
    real(kind=8) :: var0(nvari), varf(nvari)
    real(kind=8) :: depsv, xk0, xmu0, hydra0, hydra1
    real(kind=8) :: sigef6(6), dgamd6(6)
    integer :: i
    real(kind=8) :: dsige, sig0
!     (cf ordre du stockage ds les variables internes dans idva10)
!     rem: castem travaille avec les gamma et non les epsilon (gamma=2*epsilon)
!     pour les termes de ciasaillement
    do i = 1, 3
        dsige=xk0*depsv+xmu0*dgamd6(i)
!      prise en compte eventuelle degradation chimique
        if (hydra1 .lt. hydra0) then
            sig0=var0(nvar0+i)*hydra1/hydra0
        else
            sig0=var0(nvar0+i)
        end if
        sigef6(i)=sig0+dsige
        varf(nvar0+i)=sigef6(i)
    end do
    do i = 4, 6
        dsige=xmu0*dgamd6(i)
!      prise en compte eventuelle degradation chimique
        if (hydra1 .lt. hydra0) then
            sig0=var0(nvar0+i)*hydra1/hydra0
        else
            sig0=var0(nvar0+i)
        end if
        sigef6(i)=sig0+dsige
        varf(nvar0+i)=sigef6(i)
    end do
!      do i=1,6
!       print*,'sigef(',i,')=',sigef6(i)
!      end do
!      read*
end subroutine
