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
    subroutine vpecst(ifm, typres, omgmin, omgmax, nbfre1,&
                      nbfre2, nbfreq, nblagr, typep, typcon,&
                      dimc1, zimc1)
        integer :: ifm
        character(len=16) :: typres
        real(kind=8) :: omgmin
        real(kind=8) :: omgmax
        integer :: nbfre1
        integer :: nbfre2
        integer :: nbfreq
        integer :: nblagr
        character(len=1) :: typep
        character(len=8) :: typcon
        real(kind=8) :: dimc1
        complex(kind=8) :: zimc1
    end subroutine vpecst
end interface
