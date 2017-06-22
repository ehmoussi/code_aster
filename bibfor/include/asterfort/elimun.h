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
    subroutine elimun(noma, nomo, motfac, nzocu, nbgdcu,&
                      compcu, nopono, nolino, lisnoe, poinoe,&
                      nnoco)
        character(len=8) :: noma
        character(len=8) :: nomo
        character(len=16) :: motfac
        integer :: nzocu
        character(len=24) :: nbgdcu
        character(len=24) :: compcu
        character(len=24) :: nopono
        character(len=24) :: nolino
        character(len=24) :: lisnoe
        character(len=24) :: poinoe
        integer :: nnoco
    end subroutine elimun
end interface
