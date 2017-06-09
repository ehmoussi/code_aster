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
    subroutine xdecfa(elp, nno, igeom, jlsn, jlst, npi,npis,&
                      pinter, pinref, ainter, cooree, cooref, rainter,&
                      noeud, npts, nintar, lst ,lonref, ndim, zxain,&
                      jgrlsn, mipos)
        integer :: ndim
        integer :: jlsn
        integer :: jlst
        integer :: igeom
        integer :: nno
        integer :: npi
        integer :: npis
        integer :: noeud(9)
        integer :: npts
        integer :: nintar
        integer :: zxain
        real(kind=8) :: pinter(*)
        real(kind=8) :: pinref(43*ndim)
        real(kind=8) :: ainter(*)
        real(kind=8) :: cooree(6, ndim)
        real(kind=8) :: cooref(6, ndim)
        real(kind=8) :: rainter(3, 4)
        real(kind=8) :: lst(6)
        real(kind=8) :: lonref
        character(len=8) :: elp
        integer :: jgrlsn
        aster_logical :: mipos
    end subroutine xdecfa
end interface
