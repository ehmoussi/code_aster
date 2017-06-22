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

subroutine inslri(nbx, nbn, lister, listei, valr,&
                  vali)
    implicit none
    integer :: nbx, nbn
    integer :: listei(nbx), vali
    real(kind=8) :: lister(nbx), valr
!
!
! --------------------------------------------------------------------------------------------------
!
!  Insere VALR dans LISTER
!     LISTER est classe du plus grand au plus petit
!     LISTEI contient les VALI
!
!  IN
!     NBX    : nombre maximum de valeur dans les listes
!     VALR   : valeur reelle a inserer dans LISTER
!     VALI   : valeur entiere
!
!  OUT/IN
!     NBN    : nombre actualise de valeur dans les listes. Doit etre initialise a 0 avant l'appel
!     LISTER : liste actualisee des reels
!     LISTEI : liste actualisee des entiers
!
! --------------------------------------------------------------------------------------------------
    integer :: ii, indx
!
    if (nbn .eq. 0) then
        nbn = 1
        listei(1) = vali
        lister(1) = valr
    else
        indx = nbn+1
        do ii = nbn,1,-1
            if (valr .gt. lister(ii)) indx = ii
        enddo
        if (nbn .lt. nbx) nbn = nbn + 1
        do ii = nbn,indx+1,-1
            listei(ii) = listei(ii-1)
            lister(ii) = lister(ii-1)
        enddo
        if (indx .le. nbx) then
            listei(indx) = vali
            lister(indx) = valr
        endif
    endif
end subroutine
