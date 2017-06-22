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

subroutine mhomss(young, nu, cmatlo, dsidep)
    implicit none
!
! Modified HOOKE Matrix for Solid-Shell elements
!
!
! Evaluation of modified HOOKE Matrix for Solid-Shell elements in case of
! linear or non linear material
!
!
! IN  young    young modulus
! IN  nu       Poisson's coefficient
! IN  dsideps  tangent operator d sigma / d epsilon
! OUT cmatlo   modified HOOKE matrix
!
#include "asterfort/r8inir.h"
!
    real(kind=8), intent(in) :: young
    real(kind=8), intent(in) :: nu
    real(kind=8), intent(out) :: cmatlo(6,6)
    real(kind=8), optional, intent(in) :: dsidep(6,6)
!
    real(kind=8) :: lambda, mu
!
! ......................................................................
!
    call r8inir(36, 0.d0, cmatlo, 1)
    mu    = 0.5d0*young/(1.d0+nu)
!
!   Common cmatlo componentss
    cmatlo(3,3) = young
    cmatlo(5,5) = mu
    cmatlo(6,6) = mu
!
!   Specific cmatlo components
    if (present(dsidep)) then
!
!      Non linear tangent modified Hook matrix
       cmatlo(1,1) = dsidep(1,1)
       cmatlo(2,1) = dsidep(2,1)
       cmatlo(4,1) = dsidep(4,1) * 0.5d0
       cmatlo(1,2) = dsidep(1,2)
       cmatlo(2,2) = dsidep(2,2)
       cmatlo(4,2) = dsidep(4,2) * 0.5d0
       cmatlo(1,4) = dsidep(1,4) * 0.5d0
       cmatlo(2,4) = dsidep(2,4) * 0.5d0
       cmatlo(4,4) = dsidep(4,4) * 0.5d0
!
    else
!
!      Linear modified Hook matrix
       lambda = young*nu/(1.d0-nu*nu)
!
       cmatlo(1,1) = lambda + 2.d0*mu
       cmatlo(2,2) = cmatlo(1,1)
       cmatlo(1,2) = lambda
       cmatlo(2,1) = lambda
       cmatlo(4,4) = mu
!
    endif
!
end subroutine
