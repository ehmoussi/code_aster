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
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface
    subroutine nmpl3d(fami  , nno  , npg   , ipoids, ivf   ,&
                      idfde , geom , typmod, option, imate ,&
                      compor, mult_comp, lgpg , carcri  , instam, instap,&
                      deplm , deplp, angmas, sigm  , vim   ,&
                      matsym, dfdi , def   , sigp  , vip   ,&
                      matuu , vectu, codret)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: nno
        integer, intent(in) :: npg
        integer, intent(in) :: ipoids
        integer, intent(in) :: ivf
        integer, intent(in) :: idfde
        real(kind=8), intent(in) :: geom(3, nno)
        character(len=8), intent(in) :: typmod(*)
        character(len=16), intent(in) :: option
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8), intent(in) :: carcri(*)
        integer, intent(in) :: lgpg
        real(kind=8), intent(in) :: instam
        real(kind=8), intent(in) :: instap
        real(kind=8), intent(inout) :: deplm(3, nno), deplp(3, nno)
        real(kind=8), intent(in) :: angmas(*)
        real(kind=8), intent(inout) :: sigm(6, npg)
        real(kind=8), intent(inout) :: vim(lgpg, npg)
        aster_logical, intent(in) :: matsym
        real(kind=8), intent(inout) :: dfdi(nno, 3)
        real(kind=8), intent(inout) :: def(6, nno, 3)
        real(kind=8), intent(inout) :: sigp(6, npg)
        real(kind=8), intent(inout) :: vip(lgpg, npg)
        real(kind=8), intent(inout) :: matuu(*)
        real(kind=8), intent(inout) :: vectu(3, nno)
        integer, intent(inout) :: codret
    end subroutine nmpl3d
end interface
