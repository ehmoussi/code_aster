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

subroutine fgcorr(nbcycl, sigmin, sigmax, method, su,&
                  rcorr)
    implicit none
#include "jeveux.h"
#include "asterfort/utmess.h"
    character(len=*) :: method
    real(kind=8) :: sigmin(*), sigmax(*), su, rcorr(*)
    integer :: nbcycl
!     CORRECTION DE HAIGH : GOODMAN OU GERBER
!     ------------------------------------------------------------------
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  SIGMIN : R   : CONTRAINTES MINIMALES DES CYLES
! IN  SIGMAX : R   : CONTRAINTES MAXIMALES DES CYCLES
! IN  METHOD : K   : METHODE DE CORRECTION GOODMAN OU GERBER
! IN  SU     : R   :
! OUT RCORR  : R   : CORRECTION DE HAIGH POUR CHAQUE CYCLE
!     ------------------------------------------------------------------
!
    real(kind=8) :: valmoy
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    do 10 i = 1, nbcycl
        valmoy = (sigmax(i)+sigmin(i))/2.d0
        if (method .eq. 'GOODMAN') then
            if (valmoy .lt. su) then
                rcorr(i) = 1.d0 - (valmoy/su)
            else
                call utmess('F', 'FATIGUE1_4')
            endif
        else if (method.eq.'GERBER') then
            if (valmoy .lt. su) then
                rcorr(i) = 1.d0 - (valmoy/su)**2
            else
                call utmess('F', 'FATIGUE1_5')
            endif
        endif
10  end do
!
end subroutine
