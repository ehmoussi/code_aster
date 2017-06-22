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
    subroutine voiuti(numa, codvoi, nvoima, nscoma, iarepe,&
                      iaddvo, iadvoi, nbvois, livois, tyvois,&
                      nbnovo, nbsoco, lisoco)
        integer :: nscoma
        integer :: nvoima
        integer :: numa
        character(len=*) :: codvoi
        integer :: iarepe
        integer :: iaddvo
        integer :: iadvoi
        integer :: nbvois
        integer :: livois(1:nvoima)
        integer :: tyvois(1:nvoima)
        integer :: nbnovo(1:nvoima)
        integer :: nbsoco(1:nvoima)
        integer :: lisoco(1:nvoima, 1:nscoma, 1:2)
    end subroutine voiuti
end interface
