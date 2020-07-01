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
    subroutine nmpl2d(fami  , nno      , npg   ,&
                      ipoids, ivf      , idfde ,&
                      geom  , typmod   , option, imate ,&
                      compor, mult_comp, lgpg  , carcri,&
                      instam, instap   ,&
                      dispPrev , dispIncr    ,&
                      angmas, sigmPrev     , vim   ,&
                      matsym, sigmCurr     , vip   ,&
                      matuu , vectu    , codret)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: nno, npg
        integer, intent(in) :: ipoids, ivf, idfde
        real(kind=8), intent(in) :: geom(2, nno)
        character(len=8), intent(in) :: typmod(*)
        character(len=16), intent(in) :: option
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor(*), mult_comp
        real(kind=8), intent(in) :: carcri(*)
        integer, intent(in) :: lgpg
        real(kind=8), intent(in) :: instam, instap
        real(kind=8), intent(inout) :: dispPrev(2, nno), dispIncr(2, nno)
        real(kind=8), intent(in) :: angmas(*)
        real(kind=8), intent(inout) :: sigmPrev(4, npg), vim(lgpg, npg)
        aster_logical, intent(in) :: matsym
        real(kind=8), intent(inout) :: sigmCurr(4, npg), vip(lgpg, npg)
        real(kind=8), intent(inout) :: matuu(*), vectu(2, nno)
        integer, intent(inout) :: codret
    end subroutine nmpl2d
end interface
