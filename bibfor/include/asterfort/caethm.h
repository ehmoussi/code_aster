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
    subroutine caethm(l_axi, l_steady, l_vf, type_vf,&
                      type_elem, inte_type, mecani, press1, press2,&
                      tempe, dimdep, dimdef, dimcon, nddl_meca,&
                      nddl_p1, nddl_p2, ndim, nno, nnos,&
                      nnom, nface, npi, npg, nddls,&
                      nddlm, nddlfa, nddlk, dimuel, jv_poids,&
                      jv_func, jv_dfunc, jv_poids2, jv_func2, jv_dfunc2,&
                      npi2, jv_gano)
        aster_logical, intent(out) :: l_axi, l_steady, l_vf
        integer, intent(out) :: ndim
        integer, intent(out) :: mecani(5), press1(7), press2(7), tempe(5)
        integer, intent(out) :: type_vf
        character(len=3), intent(out) :: inte_type
        integer, intent(out) :: dimdep, dimdef, dimcon, dimuel
        integer, intent(out) :: nddl_meca, nddl_p1, nddl_p2
        integer, intent(out) :: nno, nnos, nnom, nface
        integer, intent(out) :: npi, npi2, npg
        integer, intent(out) :: nddls, nddlm, nddlfa, nddlk
        integer, intent(out) :: jv_poids, jv_poids2
        integer, intent(out) :: jv_func, jv_dfunc, jv_func2, jv_dfunc2
        integer, intent(out) :: jv_gano
        character(len=8), intent(out) :: type_elem(2)
    end subroutine caethm
end interface
