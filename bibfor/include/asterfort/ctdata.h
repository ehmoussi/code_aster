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
            subroutine ctdata(mesnoe,mesmai,nkcha,tych,toucmp,nkcmp,    &
     &nkvari,nbcmp,ndim,chpgs,noma,nbno,nbma,nbval,tsca)
              character(len=24) :: mesnoe
              character(len=24) :: mesmai
              character(len=24) :: nkcha
              character(len=4) :: tych
              aster_logical :: toucmp
              character(len=24) :: nkcmp
              character(len=24) :: nkvari
              integer :: nbcmp
              integer :: ndim
              character(len=19) :: chpgs
              character(len=8) :: noma
              integer :: nbno
              integer :: nbma
              integer :: nbval
              character(len=1) :: tsca
            end subroutine ctdata
          end interface 
