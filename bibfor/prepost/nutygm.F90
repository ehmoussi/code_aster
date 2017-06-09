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

function nutygm(nomtyp)
    implicit none
    integer :: nutygm
    character(len=8) :: nomtyp
!-----------------------------------------------------------------------
!
!- BUT : CETTE FONCTION RETOURNE LE TYPE GMSH DU TYPE D'ELEMENT ASTER
!
!-----------------------------------------------------------------------
! --- DESCRIPTION DES PARAMETRES
! IN   K8  NOMTYP  : NOM    ASTER DU TYPE D'ELEMENT
! OUT  I   NUTYGM  : NUMERO GMSH  DU TYPE D'ELEMENT
! ----------------------------------------------------------------------
!
    if (nomtyp .eq. 'SEG2') then
        nutygm = 1
    else if (nomtyp.eq.'TRIA3') then
        nutygm = 2
    else if (nomtyp.eq.'QUAD4') then
        nutygm = 3
    else if (nomtyp.eq.'TETRA4') then
        nutygm = 4
    else if (nomtyp.eq.'HEXA8') then
        nutygm = 5
    else if (nomtyp.eq.'PENTA6') then
        nutygm = 6
    else if (nomtyp.eq.'PYRAM5') then
        nutygm = 7
    else if (nomtyp.eq.'POI1') then
        nutygm = 15
    endif
!
end function
