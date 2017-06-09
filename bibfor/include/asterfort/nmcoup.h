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

!
#include "asterf_types.h"
!
! aslint: disable=W1504
!
interface
    subroutine nmcoup(fami, kpg, ksp, ndim, typmod,&
                      imat, compor, mult_comp, lcpdb, carcri, timed,&
                      timef, neps, epsdt, depst, nsig,&
                      sigd, vind, option, angmas, nwkin,&
                      wkin, sigf, vinf, ndsde, dsde,&
                      nwkout, wkout, iret)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: ndim
        character(len=8) :: typmod(*)
        integer :: imat
        character(len=16), intent(in) :: compor(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8), intent(in) :: carcri(*)
        aster_logical :: lcpdb
        real(kind=8) :: timed
        real(kind=8) :: timef
        integer :: neps
        real(kind=8) :: epsdt(*)
        real(kind=8) :: depst(*)
        integer :: nsig
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        character(len=16) :: option
        real(kind=8) :: angmas(*)
        integer :: nwkin
        real(kind=8) :: wkin(*)
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(*)
        integer :: ndsde
        real(kind=8) :: dsde(*)
        integer :: nwkout
        real(kind=8) :: wkout(*)
        integer :: iret
    end subroutine nmcoup
end interface
