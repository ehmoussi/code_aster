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
    subroutine dismoi(questi, nomob, typeco, repi, repk,&
                      arret, ier)
        character(len=*), intent(in) :: questi
        character(len=*), intent(in) :: nomob
        character(len=*), intent(in) :: typeco
        integer, optional, intent(out) :: repi
        character(len=*), optional, intent(out) :: repk
        character(len=*), optional, intent(in) :: arret
        integer, optional, intent(out) :: ier
    end subroutine dismoi
end interface 
