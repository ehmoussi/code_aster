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
    subroutine lissav(lischa, ichar, charge, typech, genrec,&
                      motclc, prefob, typapp, nomfct, typfct,&
                      phase, npuis)
        character(len=19) :: lischa
        integer :: ichar
        character(len=8) :: charge
        character(len=8) :: typech
        integer :: genrec
        integer :: motclc(2)
        character(len=13) :: prefob
        character(len=16) :: typapp
        character(len=8) :: nomfct
        character(len=16) :: typfct
        real(kind=8) :: phase
        integer :: npuis
    end subroutine lissav
end interface
