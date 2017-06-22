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
    subroutine prjlis(moda, maa, modb, mab, nbnoa,&
                      nbnob, motcle, linta, lintb, intfa,&
                      intfb, fpliao, fplibo, iada, iadb,&
                      numlis, matprj, modgen, ssta, sstb)
        character(len=8) :: moda
        character(len=8) :: maa
        character(len=8) :: modb
        character(len=8) :: mab
        integer :: nbnoa
        integer :: nbnob
        character(len=16) :: motcle(2)
        character(len=8) :: linta
        character(len=8) :: lintb
        character(len=8) :: intfa
        character(len=8) :: intfb
        character(len=24) :: fpliao
        character(len=24) :: fplibo
        integer :: iada(3)
        integer :: iadb(3)
        integer :: numlis
        character(len=8) :: matprj
        character(len=8) :: modgen
        character(len=8) :: ssta
        character(len=8) :: sstb
    end subroutine prjlis
end interface
