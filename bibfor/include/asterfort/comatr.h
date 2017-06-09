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
    subroutine comatr(option, typev, nbproc, rang, vnconv,&
                      dim1i, dim2i, vecti, dim1r, dim2r,&
                      vectr, dim1c, dim2c, vectc)
        integer :: dim1c
        integer :: dim1r
        integer :: dim1i
        integer :: nbproc
        character(len=1) :: option
        character(len=1) :: typev
        integer :: rang
        integer :: vnconv(nbproc)
        integer :: dim2i
        integer :: vecti(dim1i, *)
        integer :: dim2r
        real(kind=8) :: vectr(dim1r, *)
        integer :: dim2c
        complex(kind=8) :: vectc(dim1c, *)
    end subroutine comatr
end interface
