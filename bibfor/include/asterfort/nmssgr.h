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
    subroutine nmssgr(  hexa,   shb6,   shb8, icoopg,&
                        fami,    nno,    npg, ipoids,    ivf,&
                       idfde,   geom, typmod, option,  imate,&
                      compor,   lgpg,   crit, instam, instap,&
                       deplm,  deplp, angmas,   sigm,    vim,&
                      matsym,   sigp,    vip,  matuu,  vectu,&
                      codret)
        aster_logical, intent(in) :: hexa
        aster_logical, intent(in) :: shb6
        aster_logical, intent(in) :: shb8
        integer, intent(in) ::  icoopg
        character(len=*), intent(in) :: fami
        integer, intent(in) :: nno
        integer, intent(in) :: npg
        integer, intent(in) :: ipoids
        integer, intent(in) :: ivf
        integer, intent(in) :: idfde
        real(kind=8), intent(in) :: geom(3,nno)
        character(len=8), intent(in) :: typmod(*)
        character(len=16), intent(in) :: option
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor(*)
        integer, intent(in) :: lgpg
        real(kind=8), intent(in) :: crit(*)
        real(kind=8), intent(in) :: instam
        real(kind=8), intent(in) :: instap
        real(kind=8), intent(in) :: deplm(1:3, 1:nno)
        real(kind=8), intent(in) :: deplp(1:3, 1:nno)
        real(kind=8), intent(in) :: angmas(*)
        real(kind=8), intent(in) :: sigm(18,npg)
        real(kind=8), intent(in) :: vim(lgpg,npg)
        aster_logical, intent(in) :: matsym
        real(kind=8), intent(out) :: sigp(18,npg)
        real(kind=8), intent(out) :: vip(lgpg,npg)
        real(kind=8), intent(out) :: matuu(*)
        real(kind=8), intent(out) :: vectu(3,nno)
        integer, intent(out) :: codret
    end subroutine nmssgr
end interface
