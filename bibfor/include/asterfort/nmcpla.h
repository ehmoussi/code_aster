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
!
! aslint: disable=W1504
!
interface
    subroutine nmcpla(fami, kpg, ksp, ndim, typmod,&
                      imat, compor_plas, compor_creep, carcri, timed, timef,&
                      neps, epsdt, depst, nsig, sigd,&
                      vind, option, nwkin, wkin, sigf,&
                      vinf, ndsde, dsde, nwkout, wkout,&
                      iret)
        integer :: ndsde
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: ndim
        character(len=8) :: typmod(*)
        integer :: imat
        character(len=16), intent(in) :: compor_plas(*)
        character(len=16), intent(in) :: compor_creep(*)
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8) :: timed
        real(kind=8) :: timef
        integer :: neps
        real(kind=8) :: epsdt(6)
        real(kind=8) :: depst(6)
        integer :: nsig
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        character(len=16) :: option
        integer :: nwkin
        real(kind=8) :: wkin(*)
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(*)
        real(kind=8) :: dsde(ndsde)
        integer :: nwkout
        real(kind=8) :: wkout(*)
        integer :: iret
    end subroutine nmcpla
end interface
