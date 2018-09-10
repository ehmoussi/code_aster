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
subroutine zevolu(kine_type,&
                  zbeta    , zbetam,&
                  dinst    , tp    ,&
                  k        , n     ,&
                  tdeq     , tfeq  ,&
                  coeffc   ,&
                  m        , ar    , br,&
                  g        , dg)
!
implicit none
!
#include "asterfort/tempeq.h"
#include "asterfort/Metallurgy_type.h"
!
integer, intent(in) :: kine_type
real(kind=8), intent(in) :: zbeta, zbetam
real(kind=8), intent(in) :: tdeq, tfeq
real(kind=8), intent(in) :: k, n
real(kind=8), intent(in) :: dinst, tp
real(kind=8), intent(in) :: coeffc, m, ar, br
real(kind=8), intent(out) :: g, dg
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase (zircaloy)
!
! Compute G function (evolution of beta phase)
!
! --------------------------------------------------------------------------------------------------
!
! In  kine_type           : type of kinematic (heating or cooling)
! In  zbeta               : proportion of beta phase (current)
! In  zbetam              : proportion of beta phase (previous)
! In  dinst               : increment of time
! In  tp                  : current temperature
! In  k                   : material parameter (META_ZIRC)
! In  n                   : material parameter (META_ZIRC)
! In  tdeq                : transformation temperature - Begin
! In  tfeq                : transformation temperature - End
! In  coeffc              : coefficient from material parameters ac*exp(-qsr/tk)
! In  m                   : material parameter (META_ZIRC)
! In  ar                  : material parameter (META_ZIRC)
! In  br                  : material parameter (META_ZIRC)
! Out g                   : g function for evolution of beta phase
! Out dg                  : derivative (by phase) of g function for evolution of beta phase
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: teq, dvteq
!
! --------------------------------------------------------------------------------------------------
!
    g  = 0.d0
    dg = 0.d0
! 
! - Evaluate equivalent temperature
!
    call tempeq(zbeta,&
                tdeq , tfeq ,&
                k    , n    ,&
                teq  , dvteq)
!
! - Compute G function
!
    if (kine_type .eq. HEATING) then
        g  = zbeta-zbetam-dinst*coeffc*((abs(tp-teq))**m)
        dg = 1.d0+m*dinst*coeffc*((abs(tp-teq))**(m-1.d0))*dvteq
    else
        g  = dinst*exp(ar+br*abs(tp-teq))
        dg = 1.d0+abs(tp-teq)*g*(1.d0-2.d0*zbeta)
        dg = dg+dvteq*g*zbeta*(1.d0-zbeta)*(1.d0+br*abs(tp-teq))
        g  = zbeta-zbetam+abs(tp-teq)*g*zbeta*(1.d0-zbeta)
    endif
!
end subroutine
