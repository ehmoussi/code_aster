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
            subroutine rigflu(modele,time,nomcmp,tps,nbchar,char,mate,  &
     &solvez,ma,nu)
              character(len=8) :: modele
              character(len=24) :: time
              character(len=8) :: nomcmp(6)
              real(kind=8) :: tps(6)
              integer :: nbchar
              character(len=8) :: char
              character(len=*) :: mate
              character(len=*) :: solvez
              character(len=8) :: ma
              character(len=14) :: nu
            end subroutine rigflu
          end interface 
