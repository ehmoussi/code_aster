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
    subroutine nmgr3d(option   , typmod    ,&
                      fami     , imate     ,&
                      nno      , npg       , lgpg     ,&
                      ipoids   , ivf       , vff      , idfde,&
                      compor   , carcri    , mult_comp,&
                      instam   , instap    ,&
                      geom_init, disp_prev , disp_incr,&
                      sigm     , sigp      ,&
                      vim      , vip       ,&
                      matsym   , matuu     , vectu    ,&
                      codret)
        character(len=16), intent(in) :: option
        character(len=8), intent(in) :: typmod(*)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: imate
        integer, intent(in) :: nno, npg, lgpg
        integer, intent(in) :: ipoids, ivf, idfde
        real(kind=8), intent(in) :: vff(*)
        character(len=16), intent(in) :: compor(*)        
        real(kind=8), intent(in) :: carcri(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8), intent(in) :: instam, instap
        real(kind=8), intent(in) :: geom_init(3, nno)
        real(kind=8), intent(inout) :: disp_prev(3*nno),  disp_incr(3*nno)
        real(kind=8), intent(inout) :: sigm(6, npg), sigp(6, npg)
        real(kind=8), intent(inout) :: vim(lgpg, npg), vip(lgpg, npg)
        aster_logical, intent(in) :: matsym
        real(kind=8), intent(inout) :: matuu(*)
        real(kind=8), intent(inout) :: vectu(3, nno)
        integer, intent(inout) :: codret
    end subroutine nmgr3d
end interface
