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

subroutine fcthyp(typfct, x, y)
    implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
    real(kind=8) :: x, y
    character(len=8) :: typfct
!
!        CALCUL DE ARGUMENT SINUS HYPERBOLIQUE ASINH
!                  ARGUMENT COSINUS HYPERBOLIQUE ACOSH
!                  DERIVEE ARGUMENT COSINUS HYPERBOLIQUE DACOSH
!                  DERIVEE ARGUMENT SINUS HYPERBOLIQUE DASINH
!     ENTREE
!       TYPFCT  : ALIAS DE LA FONCTION
!       X       : ABSCISSE DU POINT
!
!     SORTIE
!       Y       : VALEUR DE LA FONCTION
!......................................................................
!
!
    if (typfct .eq. 'ACOSH') then
        ASSERT((x*x-1).ge.r8prem() .and. (x+sqrt(x*x-1)) .gt.r8prem())
        y=log(x+sqrt(x*x-1))
    else if (typfct.eq.'ASINH') then
        ASSERT((x+sqrt(x*x+1)).gt.r8prem())
        y=log(x+sqrt(x*x+1))
    else if (typfct.eq.'DACOSH') then
        ASSERT((x*x-1).gt.r8prem())
        y=1/sqrt(x*x-1)
    else if (typfct.eq.'DASINH') then
        y=1/sqrt(x*x+1)
    endif
!
end subroutine
