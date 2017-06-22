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

subroutine te0111(option, nomte)
!
!
    implicit none
    character(len=16) :: nomte, option
!
! --------------------------------------------------------------------------------------------------
!
!    ELEMENT MECABL2
!       OPTION : 'MASS_INER'
!
! --------------------------------------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/jevech.h"
#include "asterfort/lonele.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
    integer ::          icodre(1)
    real(kind=8) ::     valres(1)
    character(len=16) :: nomres(1)
!
    integer :: imater, igeom, lsect, lcastr
    real(kind=8) :: r8bid, rho, xl, aire
! --------------------------------------------------------------------------------------------------
!
    call jevech('PMATERC', 'L', imater)
    r8bid = 0.0d0
    nomres(1) = 'RHO'
    call rcvalb('RIGI', 1, 1, '+', zi(imater), ' ', 'ELAS',  0, '  ', [r8bid],&
                1, nomres, valres, icodre, 1)
    rho = valres(1)
    if ( rho.le.r8prem() ) then
        call utmess('F', 'ELEMENTS5_45')
    endif
!
    call jevech('PCACABL', 'L', lsect)
    aire = zr(lsect)
!
!   Longueur de l'élément
    xl = lonele(igeom=igeom)
!
    call jevech('PMASSINE', 'E', lcastr)
    zr(lcastr) = rho * aire * xl
    zr(lcastr+1) =( zr(igeom+4) + zr(igeom+1) ) / 2.d0
    zr(lcastr+2) =( zr(igeom+5) + zr(igeom+2) ) / 2.d0
    zr(lcastr+3) =( zr(igeom+6) + zr(igeom+3) ) / 2.d0
!
!   inertie de l'element ---
    zr(lcastr+4) = 0.d0
    zr(lcastr+5) = 0.d0
    zr(lcastr+6) = 0.d0
    zr(lcastr+7) = 0.d0
    zr(lcastr+8) = 0.d0
    zr(lcastr+9) = 0.d0
end subroutine
