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
    subroutine aceat2(nbtuy, eltuy, notuy, nbpart, noex1,&
                      noex2, nbmap, elpar, nopar, nno)
        integer :: nno
        integer :: nbpart
        integer :: nbtuy
        integer :: eltuy(nbtuy)
        integer :: notuy(nno*nbtuy)
        integer :: noex1(nbpart)
        integer :: noex2(nbpart)
        integer :: nbmap(nbpart)
        integer :: elpar(nbpart, nbtuy)
        integer :: nopar(nbpart, nno, nbtuy)
    end subroutine aceat2
end interface
