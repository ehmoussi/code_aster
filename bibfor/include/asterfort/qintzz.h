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
    subroutine qintzz(modele, ligrel, matez, sigmap, sigmad,&
                      signop, signod, resu)
        character(len=*) :: modele
        character(len=*) :: ligrel
        character(len=*) :: matez
        character(len=*) :: sigmap
        character(len=*) :: sigmad
        character(len=*) :: signop
        character(len=*) :: signod
        character(len=*) :: resu
    end subroutine qintzz
end interface
