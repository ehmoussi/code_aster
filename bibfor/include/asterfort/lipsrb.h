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
    subroutine lipsrb(nomres, matprj, sst1, sst2, intf1,&
                      intf2, lino1, lino2, indin1, indin2,&
                      ddlmas, ddlsla, nbmoma, nbmosl, imast,&
                      tramod)
        character(len=8) :: nomres
        character(len=8) :: matprj
        character(len=8) :: sst1
        character(len=8) :: sst2
        character(len=8) :: intf1
        character(len=8) :: intf2
        character(len=24) :: lino1
        character(len=24) :: lino2
        character(len=24) :: indin1
        character(len=24) :: indin2
        integer :: ddlmas
        integer :: ddlsla
        integer :: nbmoma
        integer :: nbmosl
        integer :: imast
        character(len=24) :: tramod
    end subroutine lipsrb
end interface
