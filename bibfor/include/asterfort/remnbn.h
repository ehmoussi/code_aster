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
    subroutine remnbn(basmod, nbmod, nbddr, nbdax, flexdr,&
                      flexga, flexax, tetgd, tetax, cmode,&
                      vecmod, neq, beta)
        integer :: neq
        integer :: nbdax
        integer :: nbddr
        integer :: nbmod
        character(len=8) :: basmod
        character(len=24) :: flexdr
        character(len=24) :: flexga
        character(len=24) :: flexax
        character(len=24) :: tetgd
        character(len=24) :: tetax
        complex(kind=8) :: cmode(nbmod+nbddr+nbdax)
        complex(kind=8) :: vecmod(neq)
        real(kind=8) :: beta
    end subroutine remnbn
end interface
