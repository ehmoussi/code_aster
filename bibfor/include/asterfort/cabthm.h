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
    subroutine cabthm(l_axi    , ndim     ,&
                      nddls    , nddlm    ,&
                      nddl_meca, nddl_p1  , nddl_p2,&
                      nno      , nnos     , nnom   ,&
                      dimuel   , dimdef   , kpi    ,&
                      addeme   , addete   , addep1 , addep2,&
                      elem_coor,&
                      jv_poids , jv_poids2,&
                      jv_func  , jv_func2 ,&
                      jv_dfunc , jv_dfunc2,&
                      dfdi     , dfdi2    ,&
                      poids    , poids2   ,&
                      b        )
        aster_logical, intent(in) :: l_axi
        integer, intent(in) :: ndim, nddls, nddlm
        integer, intent(in) :: nddl_meca, nddl_p1, nddl_p2
        integer, intent(in) :: nno, nnos, nnom
        integer, intent(in) :: dimuel, dimdef, kpi
        integer, intent(in) :: addeme, addete, addep1, addep2
        real(kind=8), intent(in) :: elem_coor(ndim, nno)
        integer, intent(in) :: jv_poids, jv_poids2
        integer, intent(in) :: jv_func, jv_func2
        integer, intent(in) :: jv_dfunc, jv_dfunc2
        real(kind=8), intent(out) :: dfdi(nno, 3), dfdi2(nnos, 3)
        real(kind=8), intent(out) :: poids, poids2
        real(kind=8), intent(out) :: b(dimdef, dimuel)
    end subroutine cabthm
end interface
