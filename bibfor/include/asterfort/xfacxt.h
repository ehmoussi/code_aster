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
    subroutine xfacxt(elp, jpint, jmilt, jnit, jcnset, pinter,&
                      ninter, jphe, ndim, ainter,nface,nptf, cface,&
                      igeom, jlsn, jlst, jaint, jgrlsn)
        integer :: ninter
        integer :: nface
        integer :: cface(30,6)
        integer :: jcnset
        integer :: jnit
        integer :: jmilt
        integer :: jpint
        integer :: nptf
        integer :: ndim
        integer :: jphe
        integer :: igeom
        integer :: jlsn
        integer :: jaint
        integer :: jlst
        integer :: jgrlsn
        real(kind=8) :: pinter(*)
        real(kind=8) :: ainter(*)
        character(len=8) :: elp
    end subroutine xfacxt
end interface
