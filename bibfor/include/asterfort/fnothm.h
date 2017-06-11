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
! aslint: disable=W1504
!
interface
    subroutine fnothm(jv_mater , ndim     , l_axi    , l_steady , fnoevo ,&
                      mecani   , press1   , press2   , tempe    ,&
                      nno      , nnos     , nnom     , npi      , npg    ,&
                      elem_coor, deltat   , dimdef   , dimcon   , dimuel ,&
                      jv_poids , jv_poids2,&
                      jv_func  , jv_func2 , jv_dfunc , jv_dfunc2,&
                      nddls    , nddlm    , nddl_meca, nddl_p1  , nddl_p2,&
                      congem   , b        , r        , vectu )
        integer, intent(in) :: jv_mater
        integer, intent(in) :: ndim
        aster_logical, intent(in) :: l_axi
        aster_logical, intent(in) :: l_steady
        aster_logical, intent(in) :: fnoevo
        integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
        integer, intent(in) :: nno, nnos, nnom
        integer, intent(in) :: npi, npg
        real(kind=8) :: elem_coor(ndim, nno)
        real(kind=8), intent(in) :: deltat
        integer, intent(in) :: dimuel, dimdef, dimcon
        integer, intent(in) :: jv_poids, jv_poids2
        integer, intent(in) :: jv_func, jv_func2, jv_dfunc, jv_dfunc2
        integer, intent(in) :: nddls, nddlm
        integer, intent(in) :: nddl_meca, nddl_p1, nddl_p2
        real(kind=8), intent(inout) :: congem(1:npi*dimcon)
        real(kind=8), intent(inout) :: b(dimdef, dimuel)
        real(kind=8), intent(inout) :: r(1:dimdef+1)
        real(kind=8), intent(out) :: vectu(dimuel)
    end subroutine fnothm
end interface
