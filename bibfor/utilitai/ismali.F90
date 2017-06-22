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

function ismali(typma)
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: ismali
    character(len=8) :: typma
! person_in_charge: samuel.geniaut at edf.fr
! ----------------------------------------------------------------------
!
! FONCTION VALANT TRUE SI LE TYPE DE MAILLE EST LINEAIRE
!        (AUTANT DE NOEUDS QUE DE NOEUDS SOMMET)
!
! ----------------------------------------------------------------------
!
! IN   TYPMA  : TYPE DE MAILLE (TYPE_MAILLE)
! OUT  ISMALI : TRUE SI LE TYPE DE MAILLE EST LINEAIRE
!
    if (typma .eq. 'POI1' .or. typma .eq. 'SEG2' .or. typma .eq. 'TRIA3' .or. typma .eq.&
        'QUAD4' .or. typma .eq. 'TETRA4' .or. typma .eq. 'PYRAM5' .or. typma .eq. 'PENTA6'&
        .or. typma .eq. 'HEXA8') then
!
        ismali=.true.
!
        elseif (typma.eq.'SEG3'   .or.&
     &        typma.eq.'TRIA6'  .or.&
     &        typma.eq.'TRIA7'  .or.&
     &        typma.eq.'QUAD8'  .or.&
     &        typma.eq.'QUAD9'  .or.&
     &        typma.eq.'TETRA10'.or.&
     &        typma.eq.'PYRAM13'.or.&
     &        typma.eq.'PENTA15'.or.&
     &        typma.eq.'PENTA18'.or.&
     &        typma.eq.'HEXA20' .or.&
     &        typma.eq.'HEXA27' ) then
!
        ismali=.false.
!
    else
!
        ASSERT(.false.)
!
    endif
!
end function
