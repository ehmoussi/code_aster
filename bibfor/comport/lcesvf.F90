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

function lcesvf(mode, a)
!
!
    implicit none
    real(kind=8) :: lcesvf
#include "asterfort/assert.h"
    integer,intent(in) :: mode
    real(kind=8),intent(in) :: a
! ----------------------------------------------------------------------
!  CALCUL DES FONCTIONS R(A) POUR LA ENDO_SCALAIRE AVEC GRAD_VARI
! ----------------------------------------------------------------------
!  MODE    FONCTION RECHERCHEE
!           0: R(A)
!           1: DRDA(A)
!           2: D2RDA2(A)
!  A       VALEUR DE L'ARGUMENT A
! ----------------------------------------------------------------------
    real(kind=8) :: n, d, dn, dd, d2n, d2d, u, du, d2u
! ----------------------------------------------------------------------
    real(kind=8) :: pk, pm, pp, pq
    common /lces/ pk,pm,pp,pq
! ----------------------------------------------------------------------

      u = exp((pq*a)**2)
      n = (1-a)**2
      d = 1 + (pm-2)*a + a*a + pp*pm*a*a*u

      if (mode.eq.0) then
          lcesvf = n/d
          goto 999
      endif

      du = 2*pq**2*a * exp((pq*a)**2)
      dn = -2*(1-a)
      dd = pm-2 + 2*a + pp*pm*a*(2*u+a*du)

      if (mode.eq.1) then
          lcesvf = (dn*d-dd*n)/d**2
          goto 999
      endif

      d2u = (2*pq**2 + (2*pq**2*a)**2) * exp((pq*a)**2)
      d2n = 2
      d2d = 2 + pp*pm*(2*u+4*a*du+a*a*d2u)

      if (mode.eq.2) then
          lcesvf = ((d2n*d-n*d2d)*d+2*dd*(n*dd-dn*d))/d**3
          goto 999
      endif

      ASSERT(mode.ge.0 .and. mode.le.2)

999 continue
end function
