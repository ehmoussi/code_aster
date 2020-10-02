! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine lc0000(BEHinteg,&
                      fami, kpg, ksp, ndim, typmod, l_epsi_varc,&
                      imate, compor, mult_comp, carcri,&
                      instam, instap,&
                      neps, epsm, deps, nsig, sigm_all,&
                      vim, option, angmas, cp, numlc, &
                      sigp, vip, ndsde, dsidep, icomp,&
                      nvi_all, codret)
        use Behaviour_type
        type(Behaviour_Integ), intent(inout) :: BEHinteg
        integer :: imate, ndim, nvi_all, kpg, ksp
        aster_logical, intent(in) :: l_epsi_varc
        integer :: neps, nsig, ndsde
        real(kind=8) :: carcri(*), angmas(3)
        real(kind=8) :: instam, instap
        real(kind=8) :: epsm(neps), deps(neps)
        real(kind=8) :: sigm_all(nsig), sigp(nsig)
        real(kind=8) :: vim(nvi_all), vip(nvi_all)
        real(kind=8) :: dsidep(nsig,neps)
        character(len=16) :: compor(*), option
        character(len=16), intent(in) :: mult_comp
        character(len=8) :: typmod(*)
        character(len=*) :: fami
        aster_logical :: cp
        integer :: icomp
        integer :: numlc
        integer :: codret
    end subroutine lc0000
end interface
