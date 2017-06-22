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
    subroutine xgrdhm(nomte, ndim, mecani, press1, press2,&
                      tempe, enrmec, dimdef, dimcon, nmec,&
                      np1, np2, nenr, dimenr, enrhyd, nfh)
        character(len=16) :: nomte
        integer :: ndim
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        integer :: enrmec(3)
        integer :: dimdef
        integer :: dimcon
        integer :: nmec
        integer :: np1
        integer :: np2
        integer :: nenr
        integer :: dimenr
        integer :: enrhyd(3)
        integer :: nfh
    end subroutine xgrdhm
end interface 
