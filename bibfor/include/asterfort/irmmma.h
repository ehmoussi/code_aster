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
    subroutine irmmma(fid, nomamd, nbmail, connex, point,&
                      typma, nommai, prefix, nbtyp, typgeo,&
                      nomtyp, nnotyp, renumd, nmatyp, infmed,&
                      modnum, nuanom)
        integer, parameter :: ntymax=69
        integer :: fid
        character(len=*) :: nomamd
        integer :: nbmail
        integer :: connex(*)
        integer :: point(*)
        integer :: typma(*)
        character(len=8) :: nommai(*)
        character(len=6) :: prefix
        integer :: nbtyp
        integer :: typgeo(*)
        character(len=8) :: nomtyp(*)
        integer :: nnotyp(*)
        integer :: renumd(*)
        integer :: nmatyp(*)
        integer :: infmed
        integer :: modnum(ntymax)
        integer :: nuanom(ntymax, *)
    end subroutine irmmma
end interface
