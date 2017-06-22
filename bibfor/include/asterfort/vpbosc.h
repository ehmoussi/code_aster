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
    subroutine vpbosc(typres, nbmode, nbvect, omeshi, valpro,&
                      nvpro, vpinf, vpmax, precdc, method,&
                      omecor)
        integer :: nvpro
        character(len=16) :: typres
        integer :: nbmode
        integer :: nbvect
        complex(kind=8) :: omeshi
        complex(kind=8) :: valpro(nvpro)
        real(kind=8) :: vpinf
        real(kind=8) :: vpmax
        real(kind=8) :: precdc
        character(len=8) :: method
        real(kind=8) :: omecor
    end subroutine vpbosc
end interface
