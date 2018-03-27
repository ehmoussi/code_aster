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
            subroutine pj4dco(mocle,moa1,moa2,nbma1,lima1,nbno2,lino2,  &
     &geom1,geom2,corres,l_dmax,dmax,dala, listIntercz, nbIntercz)
              character(len=*) :: mocle
              character(len=8) :: moa1
              character(len=8) :: moa2
              integer :: nbma1
              integer :: lima1(*)
              integer :: nbno2
              integer :: lino2(*)
              character(len=*) :: geom1
              character(len=*) :: geom2
              character(len=16) :: corres
              aster_logical :: l_dmax
              real(kind=8) :: dmax
              real(kind=8) :: dala
              character(len=16), optional :: listIntercz
              integer, optional :: nbIntercz
            end subroutine pj4dco
          end interface 
