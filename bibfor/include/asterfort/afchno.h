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
    subroutine afchno(chamn, base, gran_name, mesh, nb_node,&
                      nbcpno, desc, nb_equa, typval, rval,&
                      cval, kval)
        character(len=*) :: chamn
        character(len=*) :: base
        character(len=*) :: gran_name
        integer :: nb_node
        integer :: nbcpno(*)
        integer :: desc(*)
        integer :: nb_equa
        character(len=*) :: typval
        real(kind=8) :: rval(*)
        complex(kind=8) :: cval(*)
        character(len=*) :: kval(*)
        character(len=*) :: mesh
    end subroutine afchno
end interface
