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
            subroutine pebpct(ligrel,nbma,lma,cham,nomcmp,dim,bfix,borne&
     &,norme,seuil,lseuil,borpct,voltot,carele,cespoi)
              integer :: dim
              character(len=*) :: ligrel
              integer :: nbma
              character(len=24) :: lma
              character(len=19) :: cham
              character(len=8) :: nomcmp
              integer :: bfix
              real(kind=8) :: borne(2)
              character(len=8) :: norme
              real(kind=8) :: seuil
              aster_logical :: lseuil
              real(kind=8) :: borpct(dim)
              real(kind=8) :: voltot
              character(len=8) :: carele
              character(len=19) :: cespoi
            end subroutine pebpct
          end interface 
