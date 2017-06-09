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
interface 
    subroutine ionfixe_3d(alfeq, sfeq, csh, csheff, temp,&
                          nasol, ssol, alsol, alpal, cash)
        real(kind=8) :: alfeq
        real(kind=8) :: sfeq
        real(kind=8) :: csh
        real(kind=8) :: csheff
        real(kind=8) :: temp
        real(kind=8) :: nasol
        real(kind=8) :: ssol
        real(kind=8) :: alsol
        real(kind=8) :: alpal
        real(kind=8) :: cash
    end subroutine ionfixe_3d
end interface 
