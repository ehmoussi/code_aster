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
    subroutine lrvcpg(idfimd, nbpgm, nbpga, nomtm, typgeo,&
                      elrefa, fapg, nloc, locnam, permu,&
                      nutyma, nbsp, codret)
        integer :: nbpgm
        integer :: idfimd
        integer :: nbpga
        character(len=8) :: nomtm
        integer :: typgeo
        character(len=8) :: elrefa
        character(len=8) :: fapg
        integer :: nloc
        character(len=64) :: locnam
        integer :: permu(nbpgm)
        integer :: nutyma
        integer :: nbsp
        integer :: codret
    end subroutine lrvcpg
end interface
