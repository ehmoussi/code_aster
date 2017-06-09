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
    subroutine pjcorr(nomo2, chbid, cns1z, ces2z, ligrel,&
                      corres, option, nompar, iret)
        character(len=8) :: nomo2
        character(len=19) :: chbid
        character(len=*) :: cns1z
        character(len=*) :: ces2z
        character(len=19) :: ligrel
        character(len=16) :: corres
        character(len=16) :: option
        character(len=8) :: nompar
        integer :: iret
    end subroutine pjcorr
end interface
