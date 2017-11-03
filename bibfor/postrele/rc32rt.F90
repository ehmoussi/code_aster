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

subroutine rc32rt(pi, pj, simpij)
    implicit   none
#include "jeveux.h"
#include "asterfort/jeveuo.h"
    real(kind=8) :: pi, pj, simpij

!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3200
!     ROCHET THERMIQUE : CALCUL DE LA CONTRAINTE DE MEMBRANE DE PRESSION
!
!     ------------------------------------------------------------------
!
    real(kind=8) :: s1, s2, rayon, ep
    integer :: jvalin

! DEB ------------------------------------------------------------------
!
    simpij=0.d0
    s1=0.d0
    s2=0.d0
!
! --- CONTRAINTE MOYENNE DUE A LA PRESSION : partie ze200a
!
    call jeveuo('&&RC3200.INDI', 'L', jvalin)
    rayon = zr(jvalin+6) 
    ep = zr(jvalin+7) 
    s1 = rayon*abs(pi)/ep
    s2 = rayon*abs(pj)/ep
    simpij = max(s1,s2)
!
end subroutine
