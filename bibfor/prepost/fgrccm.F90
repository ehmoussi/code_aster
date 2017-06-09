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

subroutine fgrccm(nbextr, ext, ncyc, sigmin, sigmax)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/utmess.h"
    real(kind=8) :: ext(*), sigmin(*), sigmax(*)
    integer :: nbextr, ncyc
!     DETERMINATION DES CYCLES PAR LA METHODE DE COMPTAGE RCCM
!     ------------------------------------------------------------------
! IN  NBEXTR : I   : NOMBRE D'EXTREMA
! IN  EXT    : R   : VALEURS DES EXTREMA
! OUT NCYC   : I   : NOMBRE DE CYCLES
! OUT SIGMIN : R   : CONTRAINTES MINIMALES DES CYCLES
! OUT SIGMAX : R   : CONTRAINTES MAXIMALES DES CYCLES
!     ------------------------------------------------------------------
!     -----------------------------------------------------------------
!
    real(kind=8) :: moyext, a
    aster_logical :: cyczer
!
! ------------------------------------------------------------
!
! --- CALCUL DE LA VALEUR MOYENNE DES CONTRAINTES ---
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    moyext = 0.d0
!
    cyczer = .true.
!
    do 21 i = 2, nbextr
        if ((ext(i) .gt. ext(1)) .or. (ext(i) .lt. ext(1))) then
            cyczer = .false.
        endif
 21 end do
!
    if (cyczer) then
        sigmax(1) = ext(1)
        sigmin(1) = ext(1)
        ncyc = 1
!
        call utmess('A', 'FATIGUE1_39')
!
        goto 999
    endif
!
    do 1 i = 1, nbextr
        moyext = moyext + ext(i)
  1 end do
    moyext = moyext/nbextr
!
! --- DETECTION DES CYCLES
!
    a = dble(nbextr/2)
    ncyc = int(a)
    do 2 i = 1, ncyc
        sigmax(i) = ext(nbextr-i+1)
        sigmin(i) = ext(i)
  2 end do
    if (nbextr .ne. (2*ncyc)) then
        ncyc = ncyc + 1
        if (ext(ncyc) .ge. moyext) then
            sigmax(ncyc) = ext(ncyc)
            sigmin(ncyc) = -ext(ncyc) + 2 * moyext
        else
            sigmax(ncyc) = -ext(ncyc) + 2 * moyext
            sigmin(ncyc) = ext(ncyc)
        endif
    endif
!
999 continue
!
end subroutine
