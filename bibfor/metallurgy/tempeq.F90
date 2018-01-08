! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
subroutine tempeq(zbeta,&
                  tdeq , tfeq ,&
                  k    , n    ,&
                  teq  , dvteq)
!
implicit none
!
#include "asterc/r8prem.h"
!
real(kind=8), intent(in) :: zbeta
real(kind=8), intent(in) :: tdeq, tfeq
real(kind=8), intent(in) :: k, n
real(kind=8), intent(out) :: teq, dvteq
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase (zircaloy)
!
! Evaluate equivalent temperature
!
! --------------------------------------------------------------------------------------------------
!
! In  zbeta               : proportion of beta phase
! In  tdeq                : transformation temperature - Begin
! In  tfeq                : transformation temperature - End
! In  k                   : material parameter (META_ZIRC)
! In  n                   : material parameter (META_ZIRC)
! Out teq                 : equivalent temperature
! Out dvteq               : derivative of equivalent temperature by proportion of beta phase
!
! --------------------------------------------------------------------------------------------------
!
    if (zbeta .le. r8prem()) then
        teq   = tdeq
        dvteq = 1000.d0
    else if (zbeta .le. 0.99d0) then
        teq   = tdeq+(log(1.d0/(1.d0-zbeta)))**(1.d0/n)/k
        dvteq = -(log(1.d0/(1.d0-zbeta)))**(1.d0/n)/(k*n*(1.d0-zbeta)*log(1.d0-zbeta))
    else
        teq   = tfeq
        dvteq = -(log(100.d0))**(1.d0/n)/(k*n*(0.01d0)*log(0.01d0))
    endif
!
end subroutine
