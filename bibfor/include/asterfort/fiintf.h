! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

interface
    subroutine fiintf(nomfon, nbpu, param, val, iret,&
                      coderr, resu)
        character(len=*), intent(in) :: nomfon
        integer, intent(in) :: nbpu
        character(len=*), intent(in) :: param(*)
        real(kind=8), intent(in) :: val(*)
        integer, intent(out) :: iret
        character(len=*), intent(in) :: coderr
        real(kind=8), intent(out) :: resu(:)
    end subroutine fiintf
end interface
