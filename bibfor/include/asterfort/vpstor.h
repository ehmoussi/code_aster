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
    subroutine vpstor(ineg, typ, modes, nbmode, neq,&
                      vecpr8, vecpc8, mxresf, nbpari, nbparr,&
                      nbpark, nopara, mod45, resufi, resufr,&
                      resufk, iprec)
        integer :: mxresf
        integer :: neq
        integer :: ineg
        character(len=*) :: typ
        character(len=*) :: modes
        integer :: nbmode
        real(kind=8) :: vecpr8(neq, *)
        complex(kind=8) :: vecpc8(neq, *)
        integer :: nbpari
        integer :: nbparr
        integer :: nbpark
        character(len=*) :: nopara(*)
        character(len=4) :: mod45
        integer :: resufi(mxresf, *)
        real(kind=8) :: resufr(mxresf, *)
        character(len=*) :: resufk(mxresf, *)
        integer :: iprec
    end subroutine vpstor
end interface
