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
    subroutine poeihm(nomte, option, modint, jgao, nno1,&
                      nno2, ncmp, nvim, vpg, vno)
        character(len=16) :: nomte
        character(len=16) :: option
        character(len=3) :: modint
        integer :: jgao
        integer :: nno1
        integer :: nno2
        integer :: ncmp
        integer :: nvim
        real(kind=8) :: vpg(*)
        real(kind=8) :: vno(*)
    end subroutine poeihm
end interface
