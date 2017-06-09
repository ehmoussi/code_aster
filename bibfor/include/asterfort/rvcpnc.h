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
    subroutine rvcpnc(mcf, iocc, nch19, gd, typegd,&
                      nbcpc, nlscpc, nomojb, repere, option,&
                      quant, codir, dir, iret)
        character(len=*) :: mcf
        integer :: iocc
        character(len=19) :: nch19
        integer :: gd
        character(len=4) :: typegd
        integer :: nbcpc
        character(len=24) :: nlscpc
        character(len=24) :: nomojb
        character(len=8) :: repere
        character(len=16) :: option
        character(len=24) :: quant
        integer :: codir
        real(kind=8) :: dir(*)
        integer :: iret
    end subroutine rvcpnc
end interface
