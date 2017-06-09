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

function cos3t(s, pref, epssig)
!
    implicit none
#include "asterfort/lcdete.h"
#include "blas/ddot.h"
    real(kind=8) :: s(6), pref, epssig, cos3t
! --- BUT : CALCUL DE COS(3T) OU T DESIGNE L'ANGLE DE LODE -------------
! ======================================================================
! IN  : N      : DIMENSION DU TENSEUR ----------------------------------
! --- : S      : DEVIATEUR DU TENSEUR DES CONTRAINTES ------------------
! --- : PREF   : PRESSION DE REFERENCE ---------------------------------
! --- : EPSSIG : EPSILON DE TOLERANCE ----------------------------------
! OUT : COS3T  = RAC(54)*DET(S)/(SII)**3 -------------------------------
! ======================================================================
    integer :: ndt, ndi
    real(kind=8) :: sii, siirel, dets, un, mun
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
    parameter       ( un     =  1.0d0  )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    sii=ddot(ndt,s,1,s,1)
    sii = sqrt(sii)
    siirel = sii/pref
    if (siirel .gt. epssig) then
        call lcdete(s, dets)
        cos3t = sqrt(54.d0)*dets/(sii*sii*sii)
    else
        cos3t = un
    endif
! ======================================================================
! --- PROJECTION DU COSINUS POUR COHERENCE -----------------------------
! ======================================================================
    if (cos3t .gt. un) cos3t = un
    if (cos3t .lt. mun) cos3t = mun
! ======================================================================
end function
