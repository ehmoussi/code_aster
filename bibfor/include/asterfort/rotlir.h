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
    subroutine rotlir(nomres, sst1, intf1, lino1, codret,&
                      indin1, tramo1, ddla1, nbeq1, imast,&
                      numlia)
        character(len=8) :: nomres
        character(len=8) :: sst1
        character(len=8) :: intf1
        character(len=24) :: lino1
        integer :: codret
        character(len=24) :: indin1
        character(len=24) :: tramo1
        integer :: ddla1
        integer :: nbeq1
        integer :: imast
        integer :: numlia
    end subroutine rotlir
end interface
