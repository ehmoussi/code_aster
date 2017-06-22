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

subroutine utidea(nom, itype, versio)
    implicit none
    integer :: itype, versio
    character(len=*) :: nom
!     CORRESPONDANCE NOM DE MAILLE "ASTER" AVEC NUMERO "IDEAS"
!     ------------------------------------------------------------------
    character(len=8) :: nommai
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    itype = 0
    nommai = nom
    if (nommai .eq. 'POI1') then
        itype = 161
    else if (nommai .eq. 'SEG2') then
        itype = 21
    else if (nommai .eq. 'SEG3') then
        itype = 24
    else if (nommai .eq. 'SEG4') then
        itype = 21
    else if (nommai .eq. 'TRIA3') then
        if (versio .eq. 5) then
            itype= 91
        else
            itype = 74
        endif
    else if (nommai .eq. 'TRIA6') then
        if (versio .eq. 5) then
            itype= 92
        else
            itype = 72
        endif
    else if (nommai .eq. 'TRIA7') then
        if (versio .eq. 5) then
            itype= 92
        else
            itype = 72
        endif
    else if (nommai .eq. 'TRIA9') then
        itype = 73
    else if (nommai .eq. 'QUAD4') then
        if (versio .eq. 5) then
            itype= 94
        else
            itype = 71
        endif
    else if (nommai .eq. 'QUAD8') then
        if (versio .eq. 5) then
            itype= 95
        else
            itype = 75
        endif
    else if (nommai .eq. 'QUAD9') then
        if (versio .eq. 5) then
            itype= 95
        else
            itype = 75
        endif
    else if (nommai .eq. 'QUAD12') then
        itype = 76
    else if (nommai .eq. 'TETRA4') then
        itype = 111
    else if (nommai .eq. 'TETRA10') then
        itype = 118
    else if (nommai .eq. 'PENTA6') then
        itype = 112
    else if (nommai .eq. 'PENTA15') then
        itype = 113
    else if (nommai .eq. 'PENTA18') then
        itype = 113
    else if (nommai .eq. 'HEXA8') then
        itype = 115
    else if (nommai .eq. 'HEXA20') then
        itype = 116
    else if (nommai .eq. 'HEXA27') then
        itype = 116
    else if (nommai .eq. 'PYRAM5') then
        itype = 6000
    else if (nommai .eq. 'PYRAM13') then
        itype = 6001
    endif
!
end subroutine
