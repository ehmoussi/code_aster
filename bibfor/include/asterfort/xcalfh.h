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
interface 
    subroutine xcalfh(option, thmc, ndim, dimcon,&
                      addep1, adcp11, addeme, congep, dsde,&
                      grap1, rho11, pesa, tperm, &
                      dimenr,&
                      adenhy, nfh)
        integer :: dimenr
        integer :: dimcon
        character(len=16) :: option
        character(len=16) :: thmc
        integer :: ndim
        integer :: addep1
        integer :: adcp11
        integer :: addeme
        real(kind=8) :: congep(1:dimcon)
        real(kind=8) :: dsde(1:dimcon, 1:dimenr)
        real(kind=8) :: grap1(3)
        real(kind=8) :: rho11
        real(kind=8) :: pesa(3)
        real(kind=8) :: tperm(ndim,ndim)
        integer :: adenhy
        integer :: nfh
    end subroutine xcalfh
end interface 
