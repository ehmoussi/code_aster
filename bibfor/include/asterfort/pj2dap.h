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
            subroutine pj2dap(ino2,geom2,geom1,tria3,cobary,itr3,nbtrou,&
     &btdi,btvr,btnb,btlc,btco,l_dmax,dmax,dala,loin,dmin)
              integer :: ino2
              real(kind=8) :: geom2(*)
              real(kind=8) :: geom1(*)
              integer :: tria3(*)
              real(kind=8) :: cobary(3)
              integer :: itr3
              integer :: nbtrou
              integer :: btdi(*)
              real(kind=8) :: btvr(*)
              integer :: btnb(*)
              integer :: btlc(*)
              integer :: btco(*)
              aster_logical :: l_dmax
              real(kind=8) :: dmax
              real(kind=8) :: dala
              aster_logical :: loin
              real(kind=8) :: dmin
            end subroutine pj2dap
          end interface 
