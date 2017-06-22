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

subroutine pha300(ifoi, ptf, phase)
    implicit none
!     PROJECTION D'UN SPECTRE D'EXCITATION TURBULENTE REPARTIE SUR UNE
!     BASE MODALE PERTURBEE PAR COUPLAGE FLUIDE-STRUCTURE
!     VALEURS DES PHASES POUR LES INTERSPECTRES GRAPPE1, DEBIT 300M3/H
!-----------------------------------------------------------------------
! IN  : IFOI   : COMPTEUR DES INTERSPECTRES AU-DESSUS DE LA DIAGONALE
!                IFO = (IFO2-1)*(IFO2-2)/2 + IFO1
!                IFO1 INDICE DE LIGNE , IFO2 INDICE DE COLONNE (IFO2>1)
! IN  : PTF    : VALEUR DE LA FREQUENCE
! OUT : PHASE  : VALEUR DE LA PHASE
!
!
#include "jeveux.h"
#include "asterc/r8pi.h"
    integer :: ifoi
    real(kind=8) :: ptf, phase
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    real(kind=8) :: pi
!-----------------------------------------------------------------------
    pi = r8pi()
!
    select case (ifoi)
!
    case (1)
        phase = pi
!
    case (2)
        if (ptf .le. 70.d0) then
            phase = pi
        else if (ptf.gt.70.d0 .and. ptf.le.130.d0) then
            phase = -2.d0*pi/3.d0
        else
            phase = pi
        endif
!
    case (3)
        if (ptf .le. 55.d0) then
            phase = 0.d0
        else if (ptf.gt.55.d0 .and. ptf.le.75.d0) then
            phase = pi/4.d0
        else if (ptf.gt.75.d0 .and. ptf.le.90.d0) then
            phase = 2.d0*pi/3.d0
        else if (ptf.gt.90.d0 .and. ptf.le.115.d0) then
            phase = 5.d0*pi/6.d0
        else if (ptf.gt.115.d0 .and. ptf.le.130.d0) then
            phase = 2.d0*pi/3.d0
        else
            phase = pi/2.d0
        endif
!
    case (4)
        if (ptf .le. 30.d0) then
            phase = pi
        else if (ptf.gt.30.d0 .and. ptf.le.50.d0) then
            phase = 0.d0
        else if (ptf.gt.50.d0 .and. ptf.le.65.d0) then
            phase = pi/3.d0
        else if (ptf.gt.65.d0 .and. ptf.le.80.d0) then
            phase = 0.d0
        else if (ptf.gt.80.d0 .and. ptf.le.110.d0) then
            phase = 2.d0*pi/3.d0
        else if (ptf.gt.110.d0 .and. ptf.le.130.d0) then
            phase = pi/3.d0
        else
            phase = 0.d0
        endif
!
    case (5)
        if (ptf .le. 30.d0) then
            phase = 0.d0
        else if (ptf.gt.30.d0 .and. ptf.le.50.d0) then
            phase = pi
        else if (ptf.gt.50.d0 .and. ptf.le.65.d0) then
            phase = -pi/2.d0
        else if (ptf.gt.65.d0 .and. ptf.le.80.d0) then
            phase = pi
        else if (ptf.gt.80.d0 .and. ptf.le.110.d0) then
            phase = 0.d0
        else
            phase = -pi/2.d0
        endif
!
    case (6)
        if (ptf .le. 30.d0) then
            phase = 0.d0
        else
            phase = pi
        endif
!
    case (7)
        if (ptf .le. 5.d0) then
            phase = pi
        else if (ptf.gt.5.d0 .and. ptf.le.105.d0) then
            phase = 0.d0
        else
            phase = pi
        endif
!
    case (8)
        if (ptf .le. 110.d0) then
            phase = pi
        else if (ptf.gt.110.d0 .and. ptf.le.125.d0) then
            phase = -pi/2.d0
        else
            phase = -pi/4.d0
        endif
!
    case (9)
        if (ptf .le. 50.d0) then
            phase = pi
        else if (ptf.gt.50.d0 .and. ptf.le.125.d0) then
            phase = pi/3.d0
        else
            phase = -2.d0*pi/3.d0
        endif
!
    case (10)
        if (ptf .le. 10.d0) then
            phase = -pi/2.d0
        else if (ptf.gt.10.d0 .and. ptf.le.20.d0) then
            phase = 0.d0
        else if (ptf.gt.20.d0 .and. ptf.le.25.d0) then
            phase = -pi/2.d0
        else if (ptf.gt.25.d0 .and. ptf.le.110.d0) then
            phase = pi
        else if (ptf.gt.110.d0 .and. ptf.le.125.d0) then
            phase = 2.d0*pi/3.d0
        else
            phase = pi/2.d0
        endif
!
    case (11)
        phase = pi
!
    case (12)
        if (ptf .le. 35.d0) then
            phase = 0.d0
        else if (ptf.gt.35.d0 .and. ptf.le.45.d0) then
            phase = -pi/2.d0
        else if (ptf.gt.45.d0 .and. ptf.le.55.d0) then
            phase = 0.d0
        else if (ptf.gt.55.d0 .and. ptf.le.65.d0) then
            phase = -pi/4.d0
        else if (ptf.gt.65.d0 .and. ptf.le.75.d0) then
            phase = pi/12.d0
        else if (ptf.gt.75.d0 .and. ptf.le.90.d0) then
            phase = 0.d0
        else if (ptf.gt.90.d0 .and. ptf.le.105.d0) then
            phase = -pi/6.d0
        else if (ptf.gt.105.d0 .and. ptf.le.115.d0) then
            phase = -2.d0*pi/3.d0
        else if (ptf.gt.115.d0 .and. ptf.le.125.d0) then
            phase = pi/6.d0
        else
            phase = pi/4.d0
        endif
!
    case (13)
        if (ptf .le. 30.d0) then
            phase = 0.d0
        else if (ptf.gt.30.d0 .and. ptf.le.45.d0) then
            phase = pi
        else if (ptf.gt.45.d0 .and. ptf.le.50.d0) then
            phase = pi/4.d0
        else if (ptf.gt.50.d0 .and. ptf.le.60.d0) then
            phase = -pi/2.d0
        else if (ptf.gt.60.d0 .and. ptf.le.90.d0) then
            phase = pi/8.d0
        else if (ptf.gt.90.d0 .and. ptf.le.110.d0) then
            phase = pi/4.d0
        else if (ptf.gt.110.d0 .and. ptf.le.130.d0) then
            phase = 0.d0
        else
            phase = -pi/6.d0
        endif
!
    case (14)
        if (ptf .le. 45.d0) then
            phase = 0.d0
        else if (ptf.gt.45.d0 .and. ptf.le.55.d0) then
            phase = pi/4.d0
        else if (ptf.gt.55.d0 .and. ptf.le.80.d0) then
            phase = 0.d0
        else if (ptf.gt.80.d0 .and. ptf.le.90.d0) then
            phase = pi/3.d0
        else
            phase = pi
        endif
!
    case (15)
        if (ptf .le. 95.d0) then
            phase = pi
        else
            phase = 7.d0*pi/12.d0
        endif
!
    end select
end subroutine
