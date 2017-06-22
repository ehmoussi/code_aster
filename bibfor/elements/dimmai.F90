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

subroutine dimmai(typem, dimma)
    implicit none
    character(len=*) :: typem
    integer :: dimma
!
    if (typem(1:2) .eq. 'TE' .or. typem(1:2) .eq. 'PE' .or. typem(1:2) .eq. 'HE') then
        dimma=3
    else if (typem(1:3).eq.'QUA' .or. typem(1:3).eq.'TRI') then
        dimma=2
    else if (typem(1:3).eq.'SEG') then
        dimma=1
    else
!  POUR DES CONDITIONS AUX LIMITES PONCTUELLES
        dimma=0
!        CALL UTMESG('F','VOLUFINI_1',1,TYPEM(1:4),0,0,0,0.D0)
    endif
end subroutine
