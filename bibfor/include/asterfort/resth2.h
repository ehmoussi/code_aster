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
    subroutine resth2(modele, ligrel, lchar, nchar, ma,&
                      cartef, nomgdf, carteh, nomgdh, cartet,&
                      nomgdt, cartes, nomgds, chgeom, chsour,&
                      psourc)
        character(len=8) :: modele
        character(len=24) :: ligrel
        character(len=8) :: lchar(1)
        integer :: nchar
        character(len=8) :: ma
        character(len=19) :: cartef
        character(len=19) :: nomgdf
        character(len=19) :: carteh
        character(len=19) :: nomgdh
        character(len=19) :: cartet
        character(len=19) :: nomgdt
        character(len=19) :: cartes
        character(len=19) :: nomgds
        character(len=24) :: chgeom
        character(len=24) :: chsour
        character(len=8) :: psourc
    end subroutine resth2
end interface
