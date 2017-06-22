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

function compr8(a, comp, b, eps, crit)
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: compr8
    real(kind=8) :: a, b, eps
    integer :: crit
    character(len=2) :: comp
!
! person_in_charge: samuel.geniaut at edf.fr
! ----------------------------------------------------------------------
!
! FONCTION COMPARANT 2 REELS (REAL*8) ENTRE EUX
!     =.TRUE. SI    A.COMP.B A LA PRECISION PREC DONNEE
!
!     A = B EN ABSOLU   <=> |A-B| <= EPS
!     A = B EN RELATIF  <=> |A-B| <= EPS.MIN(|A|,|B|)
!
!     A <= B EN ABSOLU  <=> A <= B + EPS
!     A <= B EN RELATIF <=> A <= B + EPS.MIN(|A|,|B|)
!
!     A < B EN ABSOLU   <=> A < B - EPS
!     A < B EN RELATIF  <=> A < B - EPS.MIN(|A|,|B|)
!
!     A >= B EN ABSOLU  <=> A >= B - EPS
!     A >= B EN RELATIF <=> A >= B - EPS.MIN(|A|,|B|)
!
!     A > B EN ABSOLU   <=> A > B + EPS
!     A > B EN RELATIF  <=> A > B + EPS.MIN(|A|,|B|)
!
! ----------------------------------------------------------------------
!
! IN   A      : REEL A GAUCHE DU SIGNE
! IN   B      : REEL A DROITE DU SIGNE
! IN   EPS    : PRECISION
! IN   CRIT   : CRITERE (=0 si ABSOLU ou 1 si RELATIF)
! IN   COMP   : TYPE DE COMPARAISON ENTRE REELS : =, <, >, >=, <=
! OUT  COMPR8 : TRUE SI LA RELATION EST VERIFIEE
!
    real(kind=8) :: minab, min, tole
!
    compr8=.false.
    minab = min(abs(a),abs(b))
!
!     --------------------
!     TESTS PRELIMINAIRES
!     --------------------
!
!     TEST DE LA PRECISION (POSITIVE OU NULLE)
    ASSERT(eps.ge.0.d0)
!
    ASSERT(crit.eq.0.or.crit.eq.1)
!
!     --------------------
!     COMPARAISONS
!     --------------------
!
    if (crit .eq. 0) tole=eps
    if (crit .eq. 1) tole=eps*minab
!
    if (comp .eq. 'EQ') then
!
        if (abs(a-b) .le. tole) compr8=.true.
!
    else if (comp.eq.'LE') then
!
        if (a .le. b+tole) compr8=.true.
!
    else if (comp.eq.'LT') then
!
        if (a .lt. b-tole) compr8=.true.
!
    else if (comp.eq.'GE') then
!
        if (a .ge. b-tole) compr8=.true.
!
    else if (comp.eq.'GT') then
!
        if (a .gt. b+tole) compr8=.true.
!
    else
!
        ASSERT(.false.)
!
    endif
!
!
end function
