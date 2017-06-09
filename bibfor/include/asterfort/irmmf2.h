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
    subroutine irmmf2(fid, nomamd, typent, nbrent, nbgrou,&
                      nomgen, nbec, nomast, prefix, typgeo,&
                      nomtyp, nmatyp, nufaen, nufacr, nogrfa,&
                      nofaex, tabaux, infmed, nivinf, ifm)
        integer :: nbgrou
        integer :: nbrent
        integer :: fid
        character(len=*) :: nomamd
        integer :: typent
        character(len=24) :: nomgen(*)
        integer :: nbec
        character(len=8) :: nomast
        character(len=6) :: prefix
        integer :: typgeo(*)
        character(len=8) :: nomtyp(*)
        integer :: nmatyp(*)
        integer :: nufaen(nbrent)
        integer :: nufacr(nbrent)
        character(len=80) :: nogrfa(nbgrou)
        character(len=*) :: nofaex(*)
        integer :: tabaux(*)
        integer :: infmed
        integer :: nivinf
        integer :: ifm
    end subroutine irmmf2
end interface
