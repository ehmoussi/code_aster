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
    subroutine cabthm(nddls, nddlm, nno, nnos, nnom,&
                      dimuel, dimdef, ndim, kpi,&
                      jv_poids, jv_poids2,&
                      jv_func, jv_func2, jv_dfunc, jv_dfunc2,&
                      dfdi, dfdi2, node_coor, poids, poids2,&
                      b, nddl_meca, yamec, addeme, yap1,&
                      addep1, yap2, addep2, yate, addete,&
                      nddl_p1, nddl_p2, l_axi)
        integer, intent(in) :: nddls, nddlm
        integer, intent(in) :: nno, nnos, nnom
        integer, intent(in) :: dimuel, dimdef
        integer, intent(in) :: ndim
        integer, intent(in) :: kpi
        integer, intent(in) :: jv_poids, jv_poids2
        integer, intent(in) :: jv_func, jv_func2, jv_dfunc, jv_dfunc2
        real(kind=8), intent(out) :: dfdi(nno, 3), dfdi2(nnos, 3)
        real(kind=8), intent(in) :: node_coor(ndim, nno)
        real(kind=8), intent(out) :: poids, poids2
        real(kind=8), intent(out) :: b(dimdef, dimuel)
        integer, intent(in) :: nddl_meca, yamec,addeme
        integer, intent(in) :: yap1, addep1
        integer, intent(in) :: yap2, addep2
        integer, intent(in) :: yate, addete
        integer, intent(in) :: nddl_p1, nddl_p2
        aster_logical, intent(in) :: l_axi
    end subroutine cabthm
end interface
