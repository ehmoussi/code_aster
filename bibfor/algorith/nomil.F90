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

subroutine nomil(typma, nm, nbar)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/utmess.h"
    character(len=8), intent(in):: typma
    integer, intent(out) :: nm(12), nbar
!
!-----------------------------------------------------------------------
!     BUT: RETOURNE UN TABLEAU DONNANT LE NUMÉRO LOCAL D'UN NOEUD 
!           MILIEU PORTÉ SUR CHAQUE ARETE D'UNE MAILLE QUADRATIQUE
!
! ARGUMENTS D'ENTRÉE:
!      TYPMA     : TYPE DE LA MAILLE
! ARGUMENTS DE SORTIE:
!      NM        : NUMERO LOCAL DU MILIEU DE CHAQUE ARETE
!      NBAR      : NOMBRE D'ARETES DE LA MAILLE
!
!-----------------------------------------------------------------------
!
!
! --- VARIABLES
!
    integer :: i
!
    nbar=0
    do i=1, 12
       nm(i)=0
    end do
!
    if (typma .eq. 'HEXA20') then
        nbar=12
!
        nm(1)=9
        nm(2)=10
        nm(3)=11
        nm(4)=12
        nm(5)=17
        nm(6)=18
        nm(7)=19
        nm(8)=20
        nm(9)=13
        nm(10)=14
        nm(11)=15
        nm(12)=16
    else if (typma.eq.'PENTA15') then
        nbar=9
!
        nm(1)=7
        nm(2)=8
        nm(3)=9
        nm(4)=13
        nm(5)=14
        nm(6)=15
        nm(7)=10
        nm(8)=11
        nm(9)=12
    else if (typma.eq.'PYRAM13') then
        nbar=8
!
        nm(1)=6
        nm(2)=7
        nm(3)=8
        nm(4)=9
        nm(5)=10
        nm(6)=11
        nm(7)=12
        nm(8)=13
    else if (typma.eq.'TETRA10') then
        nbar=6
!
        nm(1)=5
        nm(2)=7
        nm(3)=8
        nm(4)=6
        nm(5)=9
        nm(6)=10
    else if (typma.eq.'QUAD8') then
        nbar=4
!
        nm(1)=5
        nm(2)=6
        nm(3)=7
        nm(4)=8
    else if (typma.eq.'TRIA6') then
        nbar=3
!
        nm(1)=4
        nm(2)=5
        nm(3)=6
    else if (typma.eq.'SEG3') then
        nbar=1
!
        nm(1)=3
    else
        call utmess('F', 'ALGORITH8_92', sk=typma)
    endif
!
end subroutine
