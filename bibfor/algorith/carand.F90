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

subroutine carand(randd, gr)
!
! ROUTINE CARAND : TIRAGE STATISTIQUE SUR LOI UNIFORME
! AVEC FONCTION VRAIEMENT ALEATOIRE KLOKLO SI GR=0
! GR EST LA GRAINE
!
!
    implicit none
!
#include "asterc/kloklo.h"
    integer :: hvlue, lvlue, testv, nextn, time(9)
    real(kind=8) :: randd, gr
    integer :: ind, mplier, modlus, mobymp, momdmp
!
    common  /seed/nextn
!
    parameter (mplier=16807,modlus=2147483647,mobymp=127773,&
     &           momdmp=2836)
!
    ind = nint(gr)
    if (ind .eq. 0) then
        if (nextn .eq. 0) then
            call kloklo(time)
            nextn = time(5)+time(6)+time(7)
        endif
    else
        if (nextn .eq. 0) then
            nextn = ind
        endif
    endif
!
    hvlue = nextn / mobymp
    lvlue = mod(nextn, mobymp)
    testv = mplier*lvlue - momdmp*hvlue
    if (testv .gt. 0) then
        nextn = testv
    else
        nextn = testv + modlus
    endif
    randd = abs(dble(nextn)/dble(modlus))
!
end subroutine
