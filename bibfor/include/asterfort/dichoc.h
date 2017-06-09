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
    subroutine dichoc(nbt, neq, nno, nc, icodma,&
                      dul, utl, xg, pgl, klv,&
                      duly, dvl, dpe, dve, force,&
                      varmo, varpl, dimele)
        integer :: neq
        integer :: nbt
        integer :: nno
        integer :: nc
        integer :: icodma
        real(kind=8) :: dul(neq)
        real(kind=8) :: utl(neq)
        real(kind=8) :: xg(6)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: klv(nbt)
        real(kind=8) :: duly
        real(kind=8) :: dvl(neq)
        real(kind=8) :: dpe(neq)
        real(kind=8) :: dve(neq)
        real(kind=8) :: force(3)
        real(kind=8) :: varmo(8)
        real(kind=8) :: varpl(8)
        integer :: dimele
    end subroutine dichoc
end interface
