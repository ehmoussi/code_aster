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
subroutine mfrontExternalStateVariable(carcri,&
                                       fami  , kpg      , ksp, imate, &
                                       temp  , dtemp    , &
                                       predef, dpred    , &
                                       neps  , epsth    , depsth, rela_comp)
!
implicit none
!
#include "asterc/mfront_get_external_state_variable.h"
#include "asterfort/assert.h"
#include "asterfort/mfront_varc.h"
#include "asterfort/Behaviour_type.h"
!
real(kind=8), intent(in) :: carcri(*)
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp
integer, intent(in) :: imate
real(kind=8), intent(out) :: temp, dtemp
real(kind=8), intent(out) :: predef(*), dpred(*)
integer, intent(in) :: neps
real(kind=8), intent(out) :: epsth(neps), depsth(neps)
character(len=16),optional,intent(in) :: rela_comp
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour (MFront)
!
! Prepare external state variables
!
! --------------------------------------------------------------------------------------------------
!
! In  carcri           : parameters for comportment
! In  fami             : Gauss family for integration point rule
! In  imate            : coded material address
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! Out temp             : temperature at beginning of current step time
! Out dtemp            : increment of temperature during current step time
! Out predef           : external state variables at beginning of current step time
! Out dpred            : increment of external state variables during current step time
! In  neps             : number of components of strains
! Out epsth            : thermic strains at beginning of current step time
! Out depsth           : increment of thermic strains during current step time
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_varc_maxi = 8
    integer :: nb_varc, jvariexte
    character(len=8) :: list_varc(nb_varc_maxi)
!
! --------------------------------------------------------------------------------------------------
!
    jvariexte = nint(carcri(IVARIEXTE))
    call mfront_get_external_state_variable(int(carcri(14)), int(carcri(15)),&
                                            list_varc      , nb_varc)
!
    ASSERT(nb_varc .le. nb_varc_maxi)
!
    if (present(rela_comp)) then
        call mfront_varc(fami   , kpg      , ksp, imate, &
                        nb_varc, list_varc, jvariexte, &
                        temp   , dtemp    , &
                        predef , dpred    , &
                        neps   , epsth    , depsth, rela_comp)
    else
        call mfront_varc(fami   , kpg      , ksp, imate, &
                        nb_varc, list_varc, jvariexte, &
                        temp   , dtemp    , &
                        predef , dpred    , &
                        neps   , epsth    , depsth)
    endif
!
end subroutine
