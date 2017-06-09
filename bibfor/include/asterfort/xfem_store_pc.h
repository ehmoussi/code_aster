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
    subroutine xfem_store_pc(matass, base, nonu, neq, deeq,&
                         nbnoxfem, nbnomax, ino_xfem, ieq_loc, neq_mloc,&
                         maxi_ddl, iglob_ddl, deca, tab_mloc, pc, kstruct)
        character(len=19) :: matass
        character(len=19) :: pc
        character(len=14) :: nonu
        character(len=1) :: base
        character(len=5) :: kstruct
        integer :: neq
        integer :: deeq(*)
        integer :: nbnoxfem
        integer :: nbnomax
        integer :: ino_xfem(nbnomax)
        integer :: ieq_loc(neq)
        integer :: neq_mloc(nbnoxfem)
        integer :: maxi_ddl
        integer :: iglob_ddl(maxi_ddl*nbnoxfem)
        integer :: deca
        real(kind=8) :: tab_mloc(deca*nbnoxfem)
    end subroutine xfem_store_pc
end interface
