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
#include "asterf_types.h"
!
interface
    subroutine mfrontPrepareStrain(l_simomiehe, l_grotgdep, l_pred, l_czm,&
                                   neps       , epsm      , deps ,&
                                   epsth      , depsth    ,&
                                   stran      , dstran    ,&
                                   detf_)
        aster_logical, intent(in) :: l_simomiehe, l_grotgdep
        aster_logical, intent(in) :: l_pred, l_czm
        integer, intent(in) :: neps
        real(kind=8), intent(in) :: epsm(*), deps(*)
        real(kind=8), intent(in) :: epsth(neps), depsth(neps)
        real(kind=8), intent(out) :: stran(9), dstran(9)
        real(kind=8), optional, intent(out) :: detf_
    end subroutine mfrontPrepareStrain
end interface
