! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine mdflam(dnorm, vitloc, knorm, cnorm, cost, sint,&
                  flim, fseuil, rigifl, defpla, fnorma,&
                  flocal, vnorm, defmax, enfo_fl, def,&
                  deft0, deft)
        real(kind=8) :: dnorm
        real(kind=8) :: vitloc(3)
        real(kind=8) :: knorm
        real(kind=8) :: cnorm
        real(kind=8) :: cost
        real(kind=8) :: sint
        real(kind=8) :: flim
        real(kind=8) :: fseuil
        real(kind=8) :: rigifl
        real(kind=8) :: defpla
        real(kind=8) :: fnorma
        real(kind=8) :: flocal(3)
        real(kind=8) :: vnorm
        real(kind=8) :: defmax
        real(kind=8) :: enfo_fl
        real(kind=8) :: deft0  
        real(kind=8)     , pointer  :: def(:)                 
        real(kind=8)     , pointer  :: deft(:)           
    end subroutine mdflam
end interface
