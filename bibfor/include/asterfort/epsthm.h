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
    subroutine epsthm(l_axi    , ndim     ,&
                      addeme   , addep1   , addep2  , addete   ,&
                      nno      , nnos     ,&
                      dimuel   , dimdef   , nddls   , nddlm    ,&
                      nddl_meca, nddl_p1  , nddl_p2 ,&
                      npi      , elem_coor, disp    ,&
                      jv_poids , jv_poids2,&
                      jv_func  , jv_func2 , jv_dfunc, jv_dfunc2,&
                      epsm)
        aster_logical, intent(in) :: l_axi
        integer, intent(in) :: ndim
        integer, intent(in) :: addeme, addep1, addep2, addete
        integer, intent(in) :: nno, nnos
        integer, intent(in) :: dimuel, dimdef
        integer, intent(in) :: nddls, nddlm
        integer, intent(in) :: nddl_meca, nddl_p1, nddl_p2
        integer, intent(in) :: npi
        real(kind=8), intent(in) :: elem_coor(ndim, nno)
        real(kind=8), intent(in) :: disp(*)
        integer, intent(in) :: jv_poids, jv_poids2
        integer, intent(in) :: jv_func, jv_func2, jv_dfunc, jv_dfunc2
        real(kind=8), intent(out) :: epsm(6,27)
    end subroutine epsthm
end interface
