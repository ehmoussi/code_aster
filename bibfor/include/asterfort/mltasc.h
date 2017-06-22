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
    subroutine mltasc(nbloc, lgbloc, adinit, nommat, lonmat,&
                      factol, factou, typsym)
        integer :: lonmat
        integer :: nbloc
        integer :: lgbloc(*)
        integer :: adinit(lonmat)
        character(len=*) :: nommat
        character(len=24) :: factol
        character(len=24) :: factou
        integer :: typsym
    end subroutine mltasc
end interface
