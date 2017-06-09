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
    subroutine umatwp(pfumat, stress, statev, ddsdde,&
                      sse, spd, scd, rpl, ddsddt,&
                      drplde, drpldt, stran, dstran, time,&
                      dtime, temp, dtemp, predef, dpred,&
                      cmname, ndi, nshr, ntens, nstatv,&
                      props, nprops, coords, drot, pnewdt,&
                      celent, dfgrd0, dfgrd1, noel, npt,&
                      layer, kspt, kstep, kinc)
        integer :: pfumat
        real(kind=8) :: stress(*)
        real(kind=8) :: statev(*)
        real(kind=8) :: ddsdde(*)
        real(kind=8) :: sse
        real(kind=8) :: spd
        real(kind=8) :: scd
        real(kind=8) :: rpl
        real(kind=8) :: ddsddt(*)
        real(kind=8) :: drplde(*)
        real(kind=8) :: drpldt
        real(kind=8) :: stran(*)
        real(kind=8) :: dstran(*)
        real(kind=8) :: time(*)
        real(kind=8) :: dtime
        real(kind=8) :: temp
        real(kind=8) :: dtemp
        real(kind=8) :: predef(*)
        real(kind=8) :: dpred(*)
        character(len=*) :: cmname
        integer :: ndi
        integer :: nshr
        integer :: ntens
        integer :: nstatv
        real(kind=8) :: props(*)
        integer :: nprops
        real(kind=8) :: coords(*)
        real(kind=8) :: drot(*)
        real(kind=8) :: pnewdt
        real(kind=8) :: celent
        real(kind=8) :: dfgrd0(3,3)
        real(kind=8) :: dfgrd1(3,3)
        integer :: noel
        integer :: npt
        integer :: layer
        integer :: kspt
        integer :: kstep
        integer :: kinc
    end subroutine umatwp
end interface
