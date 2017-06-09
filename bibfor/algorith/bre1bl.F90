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

subroutine bre1bl(k0, k1, k2, eta1, eta2,&
                  e1i, e2i, a, t, b,&
                  pw, e1f)
!
!     CALCUL DE E2F AVEC HYPOTHESE D ECOULEMENT ETAGE 2
!
    implicit none
!
!
!-----------------------------------------------------------------------
    real(kind=8) :: k0, k1, k2
    real(kind=8) :: a, b, e1f, e1i, e2i, eta1, eta2
    real(kind=8) :: pw, t, t10, t11, t12, t13, t14
    real(kind=8) :: t16, t17, t18, t2, t31, t38, t5
    real(kind=8) :: t6, t7, t8
!-----------------------------------------------------------------------
    t2 = k1 + k0
    t5 = t / eta1 * t2
    t6 = exp(-t5)
    t7 = pw * k1
    t8 = pw * k0
    t10 = k0 * e2i * k1
    t11 = k0 ** 2
    t12 = e2i * t11
    t13 = k0 * a
    t14 = eta1 * t13
    t16 = k0 * b * k1
    t17 = b * t11
    t18 = k1 ** 2
    t31 = exp(t5)
    t38 = t2 ** 2
    e1f = -0.1d1 / (t18 + 0.2d1 * k0 * k1 + t11) * (t7 + t8 - t10 - t12 - t14 + t16 + t17 - t18 *&
          & e1i - 0.2d1 * e1i * k0 * k1 - t11 * e1i) * t6 + 0.1d1 / t38 * t6 * (t7 + t8 - t10 - t&
          &12 +t * k1 * t13 + t * a * t11 - t14 + t16 + t17) * t31
!
end subroutine
