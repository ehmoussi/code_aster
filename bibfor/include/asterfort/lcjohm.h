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
#include "asterf_types.h"
!
interface
    subroutine lcjohm(imate, resi, rigi, kpi, npg,&
                      nomail, addeme, advico, ndim, dimdef,&
                      dimcon, nbvari, defgem, defgep, varim,&
                      varip, sigm, sigp, drde, ouvh,&
                      retcom)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: imate
        aster_logical :: resi
        aster_logical :: rigi
        integer :: kpi
        integer :: npg
        character(len=8) :: nomail
        integer :: addeme
        integer :: advico
        integer :: ndim
        real(kind=8) :: defgem(dimdef)
        real(kind=8) :: defgep(dimdef)
        real(kind=8) :: varim(nbvari)
        real(kind=8) :: varip(nbvari)
        real(kind=8) :: sigm(dimcon)
        real(kind=8) :: sigp(dimcon)
        real(kind=8) :: drde(dimdef, dimdef)
        real(kind=8) :: ouvh
        integer :: retcom
    end subroutine lcjohm
end interface
