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
            subroutine peecal(tych,resu,nomcha,lieu,nomlie,modele,ichagd&
     &,chpost,nbcmp,nomcmp,nomcp2,nuord,inst,iocc,ligrel,cespoi)
              integer :: nbcmp
              character(len=4) :: tych
              character(len=19) :: resu
              character(len=24) :: nomcha
              character(len=8) :: lieu
              character(len=*) :: nomlie
              character(len=8) :: modele
              integer :: ichagd
              character(len=19) :: chpost
              character(len=8) :: nomcmp(nbcmp)
              character(len=8) :: nomcp2(nbcmp)
              integer :: nuord
              real(kind=8) :: inst
              integer :: iocc
              character(len=19) :: ligrel
              character(len=19) :: cespoi
            end subroutine peecal
          end interface 
