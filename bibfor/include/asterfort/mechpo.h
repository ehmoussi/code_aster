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
    subroutine mechpo(souche, charge, modele, chdep2, chdynr,&
                      suropt, lpain, lchin, nbopt, typcoe,&
                      alpha, calpha)
        character(len=*) :: souche
        character(len=*) :: charge
        character(len=*) :: modele
        character(len=*) :: chdep2
        character(len=*) :: chdynr
        character(len=*) :: suropt
        character(len=*) :: lpain(*)
        character(len=*) :: lchin(*)
        integer :: nbopt
        character(len=*) :: typcoe
        real(kind=8) :: alpha
        complex(kind=8) :: calpha
    end subroutine mechpo
end interface
