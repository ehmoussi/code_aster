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
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface
    subroutine coeime(meca, imate, nomail, option, resi,&
                      rigi, ndim, dimdef, dimcon, &
                      addeme, addep1,&
                      nbvari, advime, advico, npg, npi,&
                      defgep, defgem, sigm, sigp, varim,&
                      varip, ouvh, tlint, drde, kpi,&
                      vicphi, unsurn, retcom)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        character(len=16) :: meca
        integer :: imate
        character(len=8) :: nomail
        character(len=16) :: option
        aster_logical :: resi
        aster_logical :: rigi
        integer :: addeme
        integer :: addep1
        integer :: advime
        integer :: advico
        integer :: npg
        integer :: npi
        real(kind=8) :: defgep(dimdef)
        real(kind=8) :: defgem(dimdef)
        real(kind=8) :: sigm(dimcon)
        real(kind=8) :: sigp(dimcon)
        real(kind=8) :: varim(nbvari)
        real(kind=8) :: varip(nbvari)
        real(kind=8) :: ouvh
        real(kind=8) :: tlint
        real(kind=8) :: drde(dimdef, dimdef)
        integer :: kpi
        integer :: vicphi
        real(kind=8) :: unsurn
        integer :: retcom
    end subroutine coeime
end interface
