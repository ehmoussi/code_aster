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

subroutine irmifr(ifmis, freq, ifreq, nfreq, ic)
    implicit none
#include "asterc/r8prem.h"
    integer :: ifmis, ifreq, nfreq, ic
    real(kind=8) :: freq
!
    character(len=72) :: texte
    real(kind=8) :: a(3)
!
!-----------------------------------------------------------------------
    integer :: i, j
!-----------------------------------------------------------------------
    rewind ifmis
    read(ifmis,'(A72)') texte
    read(ifmis,'(A72)') texte
    ic = 1
    nfreq = 0
 1  continue
    nfreq = nfreq + 1
    read(ifmis,'(A72)') texte
    if (texte(1:3) .eq. 'CHA') then
        nfreq = nfreq -1
    else
        goto 1
    endif
    rewind ifmis
    read(ifmis,'(A72)') texte
    read(ifmis,'(A72)') texte
    do 3 i = 1, nfreq
        read(ifmis,*) (a(j),j=1,3)
        if (freq .le. (a(1)*1.0001d0)) then
            ifreq = i
            if (i .gt. 1 .and. freq .lt. (a(1)*0.9999d0)) then
                ifreq = ifreq-1
            endif
            if (freq .le. r8prem( )) ic = 2
            if (i .eq. 1 .and. nfreq .eq. 1) ic = 0
            if (i .eq. nfreq .and. freq .ge. (a(1)*0.9999d0)) then
                ic = 0
                ifreq = nfreq
            endif
            goto 4
        endif
 3  end do
    ifreq = nfreq
    ic = 0
 4  continue
end subroutine
