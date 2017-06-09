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

subroutine satuvg(vg, pc, sat, dsdpc)
!
! SATUVG : CALCUL DE LA SATURATION PAR VAN-GENUCHTEN + REGULARISATION
!  GAUCHE
    implicit none
!
! IN
#include "asterfort/pcapvg.h"
#include "asterfort/reguh1.h"
#include "asterfort/satfvg.h"
    real(kind=8) :: vg(5), pc
! OUT
    real(kind=8) :: sat, dsdpc
!
    real(kind=8) :: satuma, n, m, pr, smax, sr
    real(kind=8) :: s1max, pcmax, dpcmax, bidon
    real(kind=8) :: usn, usm, b1, c1
!
!
    n = vg(1)
    pr = vg(2)
    sr = vg(3)
    smax = vg(4)
    satuma = vg(5)
!
    m=1.d0-1.d0/n
    usn=1.d0/n
    usm=1.d0/m
!
    s1max=(smax-sr)/(1.d0-sr)
!
! FONCTION PROLONGATION A GAUCHE DE S(PC) (S > SMAX)
    call pcapvg(sr, pr, usm, usn, s1max,&
                pcmax, dpcmax, bidon)
    call reguh1(pcmax, smax, 1.d0/dpcmax, b1, c1)
!
    if ((pc.gt.pcmax)) then
!
        call satfvg(sr, pr, n, m, pc,&
                    sat, dsdpc)
!
    else if (pc.le.pcmax) then
!
        sat=1.d0-b1/(c1-pc)
        dsdpc=-b1/((c1-pc)**2.d0)
!
!
    endif
    sat=sat*satuma
!
end subroutine
