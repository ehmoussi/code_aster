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

subroutine nomcod(nom, num, ic, nc)
!    G. JAQUART     DATE 26/05/93
!-----------------------------------------------------------------------
!  BUT:  CONCATENATION D'UN CARACTERE ET D'UN ENTIER
!-----------------------------------------------------------------------
    implicit none
!
!  NOM : CARACTERE A CONCATENER AVEC UN ENTIER
!  NUM : ENTIER A CONCATENER
!  IC  : INDICE DU PREMIER CARACTERE COMPRENANT L'ENTIER
!  NC  : INDICE DU DERNIER CARACTERE
!
!  EXEMPLE D'UTILISATION
!
!  NOMNOE='NO'
!  CALL NOMCOD(NOMNOE,IND,3,8)
!
!
#include "asterfort/assert.h"
    character(len=*) :: nom
    character(len=4) :: format
    integer :: num, ic, nc
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    format='(IX)'
    do 10 i = ic, nc
        nom(i:i)=' '
10  end do
!
    do 20 i = 1, nc-ic+1
        if (num .ge. 10**(i-1) .and. num .lt. 10**i) then
            write (format(3:3),'(I1)') i
            goto 21
        endif
20  end do
!
    ASSERT(.false.)
!
21  continue
    write (nom(ic:ic+i-1),format) num
!
end subroutine
