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
    subroutine arlcpl(zocc,nbma1,nbma2,mail,nomo,typmai, &
                     nom1,nom2,ndim,lisrel,charge)
        character(len=24) :: typmai
        character(len=8)  :: mail,nomo
        character(len=8)  :: charge
        character(len=19)  :: lisrel
        character(len=10) :: nom1,nom2
        integer       :: ndim
        integer       :: zocc
        integer       :: nbma1,nbma2
    end subroutine arlcpl
end interface
