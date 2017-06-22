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

subroutine mltalc(local, global, adress, sn, lgsn,&
                  place, sni, supnd, nbass)
! person_in_charge: olivier.boiteau at edf.fr
! aslint: disable=W1304
    implicit none
    integer(kind=4) :: local(*), global(*)
    integer :: sn, lgsn(*), place(*), adress(*)
    integer :: sni, supnd(*), nbass
    integer :: k, longsn, is
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    longsn = lgsn(sn)
    do 110 k = adress(sn), adress(sn) + longsn - 1
        local(k) = 0
110  end do
    do 120 k = adress(sn) + longsn, adress(sn+1) - 1
        local(k) = int(place(global(k)), 4)
120  end do
    nbass = 0
    is = supnd(sni+1)
    k = adress(sn) + longsn
!      DO WHILE (K.LT.ADRESS(SN+1).AND.GLOBAL(K).LT.IS)
130  continue
    if (k .lt. adress(sn+1) .and. global(k) .lt. is) then
        nbass = nbass + 1
        k = k + 1
        goto 130
! FIN DO WHILE
    endif
end subroutine
