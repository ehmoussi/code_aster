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
    subroutine utmess_core(typ, idmess, nk, valk, ni,&
                           vali, nr, valr, fname)
        character(len=*), intent(in) :: typ
        character(len=*), intent(in) :: idmess
        integer, intent(in) :: nk
        character(len=*), intent(in) :: valk(*)
        integer, intent(in) :: ni
        integer, intent(in) :: vali(*)
        integer, intent(in) :: nr
        real(kind=8), intent(in) :: valr(*)
        character(len=*), intent(in) :: fname
    end subroutine utmess_core
end interface
