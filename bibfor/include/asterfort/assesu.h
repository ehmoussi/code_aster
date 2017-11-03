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
    subroutine assesu(option   , j_mater  ,&
                      type_elem, &
                      ndim     , nbvari   ,&
                      nno      , nnos     , nface ,&
                      dimdef   , dimcon   , dimuel,&
                      mecani   , press1   , press2, tempe,&
                      compor   , carcri   ,&
                      elem_coor,&
                      dispm    , dispp    ,&
                      defgem   , defgep   ,& 
                      congem   , congep   ,&
                      vintm    , vintp    ,&
                      time_prev, time_curr,& 
                      matuu    , vectu)
        integer, parameter :: maxfa=6
        character(len=16), intent(in) :: option
        integer, intent(in) :: j_mater
        character(len=8), intent(in) :: type_elem(2)
        integer, intent(in) :: ndim, nbvari
        integer, intent(in) :: nno, nnos, nface
        integer, intent(in) :: dimdef, dimcon, dimuel
        integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
        character(len=16), intent(in)  :: compor(*)
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8), intent(in) :: elem_coor(ndim, nno)
        real(kind=8), intent(in) :: dispm(dimuel), dispp(dimuel)
        real(kind=8), intent(inout) :: defgem(dimdef), defgep(dimdef)
        real(kind=8), intent(in) :: congem(dimcon, maxfa+1)
        real(kind=8), intent(inout) :: congep(dimcon, maxfa+1)
        real(kind=8), intent(in) :: vintm(nbvari, maxfa+1)
        real(kind=8), intent(inout) :: vintp(nbvari, maxfa+1)
        real(kind=8), intent(in) :: time_curr, time_prev 
        real(kind=8), intent(inout) :: matuu(dimuel*dimuel)
        real(kind=8), intent(inout) :: vectu(dimuel)
    end subroutine assesu
end interface 
