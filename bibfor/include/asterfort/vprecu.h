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
    subroutine vprecu(modes, nomsy, nbvect, lposi, nomvec,&
                      nbpara, nopara, nomvai, nomvar, nomvak,&
                      neq, nbmode, typmod, nbpari, nbparr,&
                      nbpark)
        character(len=*), intent(in) :: modes
        character(len=*), intent(in) :: nomsy
        integer, intent(in) :: nbvect
        integer, intent(in) :: lposi(*)
        character(len=*), intent(in) :: nomvec
        integer, intent(in) :: nbpara
        character(len=*), intent(in) :: nopara
        character(len=*), intent(in) :: nomvai
        character(len=*), intent(in) :: nomvar
        character(len=*), intent(in) :: nomvak
        integer, intent(out) :: neq
        integer, intent(out) :: nbmode
        character(len=*), intent(out) :: typmod
        integer, intent(out) :: nbpari
        integer, intent(out) :: nbparr
        integer, intent(out) :: nbpark
    end subroutine vprecu
end interface
