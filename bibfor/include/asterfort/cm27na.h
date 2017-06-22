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
    subroutine cm27na(main, nbma, nbno, lima, typema,&
                      milieu, nomima, nomipe, mxnofa, nbhe20,&
                      nbtyma, deffac)
        integer :: nbtyma
        integer :: nbno
        integer :: nbma
        character(len=8) :: main
        integer :: lima(*)
        integer :: typema(*)
        integer :: milieu(4, 24, nbno)
        integer :: nomima(6, nbma)
        integer :: nomipe(8, *)
        integer :: mxnofa
        integer :: nbhe20
        integer :: deffac(8, 0:6, nbtyma)
    end subroutine cm27na
end interface
