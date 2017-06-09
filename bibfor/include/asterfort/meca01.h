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
    subroutine meca01(optio0, nbordr, jordr, nchar, jcha,&
                      kcha, ctyp, tbgrca, resuco, resuc1,&
                      leres1, noma, modele, ligrmo, mate,&
                      cara, chvarc, codret)
        character(len=*) :: optio0
        integer :: nbordr
        integer :: jordr
        integer :: nchar
        integer :: jcha
        character(len=19) :: kcha
        character(len=4) :: ctyp
        real(kind=8) :: tbgrca(3)
        character(len=8) :: resuco
        character(len=8) :: resuc1
        character(len=19) :: leres1
        character(len=8) :: noma
        character(len=8) :: modele
        character(len=24) :: ligrmo
        character(len=24) :: mate
        character(len=8) :: cara
        character(len=19) :: chvarc
        integer :: codret
    end subroutine meca01
end interface
