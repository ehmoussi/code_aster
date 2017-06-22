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
            subroutine cteltb(nbma,mesmai,noma,nbval,nkcha,nkcmp,nkvari,&
     &toucmp,nbcmp,typac,ndim,nrval,resu,nomtb,nsymb,chpgs,tych,nival,  &
     &niord)
              integer :: nbma
              character(len=24) :: mesmai
              character(len=8) :: noma
              integer :: nbval
              character(len=24) :: nkcha
              character(len=24) :: nkcmp
              character(len=24) :: nkvari
              aster_logical :: toucmp
              integer :: nbcmp
              character(len=8) :: typac
              integer :: ndim
              character(len=24) :: nrval
              character(len=8) :: resu
              character(len=8) :: nomtb
              character(len=16) :: nsymb
              character(len=19) :: chpgs
              character(len=4) :: tych
              character(len=24) :: nival
              character(len=24) :: niord
            end subroutine cteltb
          end interface 
