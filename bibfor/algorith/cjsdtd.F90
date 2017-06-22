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

subroutine cjsdtd(mod, q, dtddq)
    implicit none
#include "asterfort/utmess.h"
!     CALCUL DE LA DERIVEE DU TENSEUR TD PAR RAPPORT A Q
!     TD = DEVIATEUR( DET(Q) * INVERSE(Q) )
!     ------------------------------------------------------------------
!     IN   MOD      :  MODELISATION
!          Q        :  TENSEUR (6 COMPOSANTES)
!     OUT  DTDDQ    :  TENSEUR RESULTAT (6 COMPOSANTES)
!          DTDDQ(I,J) = D TD(I) / D Q(J)
!     ------------------------------------------------------------------
!
    integer :: ndt, ndi
    real(kind=8) :: q(6), dtddq(6, 6)
    real(kind=8) :: zero, deux, trois, quatre, rc2
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    parameter     ( zero   = 0.d0   )
    parameter     ( deux   = 2.d0   )
    parameter     ( trois  = 3.d0   )
    parameter     ( quatre = 4.d0   )
!
    character(len=8) :: mod
!
    common /tdim/   ndt, ndi
!
!-----------------------------------------------------------------------
!
!
!------------------------------
! ATTENTION A LA PRISE EN COMPTE DE COEFFICIENTS 1/DEUX ET RC2 EN
!           FACTEUR DE CERTAINS TERMES
!
!
    rc2 = sqrt(2.d0)
!
!
!
! - MODELISATION 3D:
!
    if (mod(1:2) .eq. '3D') then
!
        dtddq(1,1) = ( - q(2) - q(3) ) / trois
        dtddq(2,1) = ( - q(2) + deux*q(3) ) / trois
        dtddq(3,1) = ( deux*q(2) - q(3) ) / trois
        dtddq(4,1) = zero
        dtddq(5,1) = zero
        dtddq(6,1) = - q(6)
!
!
        dtddq(1,2) = ( - q(1) + deux*q(3) ) / trois
        dtddq(2,2) = ( - q(1) - q(3) ) / trois
        dtddq(3,2) = ( deux*q(1) - q(3) ) / trois
        dtddq(4,2) = zero
        dtddq(5,2) = - q(5)
        dtddq(6,2) = zero
!
!
        dtddq(1,3) = ( - q(1) + deux*q(2) ) / trois
        dtddq(2,3) = ( deux*q(1) - q(2) ) / trois
        dtddq(3,3) = ( - q(1) - q(2) ) / trois
        dtddq(4,3) = - q(4)
        dtddq(5,3) = zero
        dtddq(6,3) = zero
!
!
        dtddq(1,4) = deux * q(4) / trois / deux
        dtddq(2,4) = deux * q(4) / trois / deux
        dtddq(3,4) = - quatre * q(4) / trois / deux
        dtddq(4,4) = - q(3)
        dtddq(5,4) = q(6) / rc2
        dtddq(6,4) = q(5) / rc2
!
!
        dtddq(1,5) = deux * q(5) / trois / deux
        dtddq(2,5) = - quatre * q(5) / trois / deux
        dtddq(3,5) = deux * q(5) / trois / deux
        dtddq(4,5) = q(6) / rc2
        dtddq(5,5) = - q(2)
        dtddq(6,5) = q(5) / rc2
!
!
        dtddq(1,6) = - quatre * q(6) / trois / deux
        dtddq(2,6) = deux * q(6) / trois / deux
        dtddq(3,6) = deux * q(6) / trois / deux
        dtddq(4,6) = q(5) / rc2
        dtddq(5,6) = q(4) / rc2
        dtddq(6,6) = - q(1)
!
!
!
! - MODELISATION 2D : D_PLAN ET AXIS
!
        else if ( mod(1:6) .eq. 'D_PLAN' .or. mod(1:4) .eq. 'AXIS'&
    ) then
!
!
        dtddq(1,1) = ( - q(2) - q(3) ) / trois
        dtddq(2,1) = ( - q(2) + deux*q(3) ) / trois
        dtddq(3,1) = ( deux*q(2) - q(3) ) / trois
        dtddq(4,1) = zero
!
!
        dtddq(1,2) = ( - q(1) + deux*q(3) ) / trois
        dtddq(2,2) = ( - q(1) - q(3) ) / trois
        dtddq(3,2) = ( deux*q(1) - q(3) ) / trois
        dtddq(4,2) = zero
!
!
        dtddq(1,3) = ( - q(1) + deux*q(2) ) / trois
        dtddq(2,3) = ( deux*q(1) - q(2) ) / trois
        dtddq(3,3) = ( - q(1) - q(2) ) / trois
        dtddq(4,3) = - q(4)
!
!
        dtddq(1,4) = deux * q(4) / trois / deux
        dtddq(2,4) = deux * q(4) / trois / deux
        dtddq(3,4) = - quatre * q(4) / trois / deux
        dtddq(4,4) = - q(3)
!
!
!
!
!
    else if (mod(1:6) .eq. 'C_PLAN' .or. mod(1:2) .eq. '1D') then
        call utmess('F', 'ALGORITH2_15')
    endif
!
end subroutine
