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
    subroutine xstudo(ndime, ninter, npts, nptm, ainter,&
                  nbpi, ip1, ip2, pm1a,pm1b, pm2)
        integer :: ndime  
        integer :: ninter
        integer :: npts
        integer :: nptm
        integer :: nbpi
        integer :: ip1(4)
        integer :: ip2(4)
        integer :: pm1a(4)
        integer :: pm1b(4)
        integer :: pm2(4)
        real(kind=8) :: ainter(*)
    end subroutine xstudo
end interface 
