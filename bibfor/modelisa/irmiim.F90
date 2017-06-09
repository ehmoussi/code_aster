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

subroutine irmiim(ifmis, ifreq, nfreq, nbno, tabrig)
    implicit none
#include "jeveux.h"
#include "asterfort/wkvect.h"
    integer :: ifmis, nbno, i1, i2, ifreq, nfreq
    character(len=24) :: tabrig
!
    character(len=72) :: texte
    real(kind=8) :: a(3)
!
!-----------------------------------------------------------------------
    integer :: i, j, jrig, nbmode, nsaut
!-----------------------------------------------------------------------
    nbmode = 3*nbno
    call wkvect(tabrig, 'V V R', nbmode*nbmode, jrig)
    rewind ifmis
    read(ifmis,'(A72)') texte
    if (texte(1:4) .eq. 'XXXX') goto 4
    do 1 i1 = 1, nbmode
        do 1 i2 = 1, nbmode
            nsaut = nfreq
            if (i1 .eq. 1 .and. i2 .eq. 1) nsaut = ifreq
            do 2 i = 1, nsaut
                read(ifmis,'(A72)') texte
 2          continue
            read(ifmis,*) (a(j),j=1,3)
            zr(jrig+(i2-1)*nbmode+i1-1) = a(2)
 1      continue
 4  continue
end subroutine
