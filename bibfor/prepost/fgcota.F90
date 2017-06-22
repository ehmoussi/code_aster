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

subroutine fgcota(npic, pic, ncyc, sigmin, sigmax)
!      COMPTAGE DES CYCLES POUR LA METHODE TAHERI
!       ----------------------------------------------------------------
!      IN  NPIC    NOMBRE  DE PICS
!          PIC     VALEURS DES PICS
!      OUT NCYC    NOMBRE  DE  CYCLE
!      OUT SIGMAX  CONTRAINTES MAXIMALES DES CYCLES
!          SIGMIN  CONTRAINTES MINIMALES DES CYCLES
!       ----------------------------------------------------------------
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
    real(kind=8) :: pic(*), e1, e2, sigmax(*), sigmin(*)
    integer :: npic, ncyc, k
    aster_logical :: cyczer
!       ----------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    ncyc = 0
    i = 1
    cyczer = .true.
!
!
    do 21 k = 2, npic
        if ((pic(k) .gt. pic(1)) .or. (pic(k) .lt. pic(1))) then
            cyczer = .false.
        endif
 21 end do
!
    if (cyczer) then
        sigmax(1) = pic(1)
        sigmin(1) = pic(1)
        ncyc = 1
!
        call utmess('A', 'FATIGUE1_39')
!
        goto 999
    endif
!
  2 continue
    if (i+2 .gt. npic) then
        goto 100
    endif
    e1 = abs ( pic(i+1) - pic(i) )
    e2 = abs ( pic(i+2) - pic(i+1) )
!
    if (e1 .ge. e2) then
        ncyc = ncyc + 1
        if (pic(i) .ge. pic(i+1)) then
            sigmax(ncyc) = pic(i)
            sigmin(ncyc) = pic(i+1)
        else
            sigmax(ncyc) = pic(i+1)
            sigmin(ncyc) = pic(i)
        endif
    else
        ncyc = ncyc + 1
        if (pic(i+1) .ge. pic(i+2)) then
            sigmax(ncyc) = pic(i+1)
            sigmin(ncyc) = pic(i+2)
        else
            sigmax(ncyc) = pic(i+2)
            sigmin(ncyc) = pic(i+1)
        endif
    endif
    i= i+2
    goto 2
!
!  --- TRAITEMENT DU RESIDU -------
!
100 continue
    if (i+1 .eq. npic) then
        ncyc = ncyc+1
        if (pic(i) .ge. pic(i+1)) then
            sigmax(ncyc) = pic(i)
            sigmin(ncyc) = pic(i+1)
        else
            sigmax(ncyc) = pic(i+1)
            sigmin(ncyc) = pic(i)
        endif
    endif
!
999 continue
!
end subroutine
