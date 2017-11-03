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
! aslint: disable=W1504,W1306
!
subroutine epsthm(l_axi    , ndim     ,&
                  addeme   , addep1   , addep2  , addete   ,&
                  nno      , nnos     ,&
                  dimuel   , dimdef   , nddls   , nddlm    ,&
                  nddl_meca, nddl_p1  , nddl_p2 ,&
                  npi      , elem_coor, disp    ,&
                  jv_poids , jv_poids2,&
                  jv_func  , jv_func2 , jv_dfunc, jv_dfunc2,&
                  epsm)
!
use THM_type
use THM_module
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/cabthm.h"
#include "asterfort/assert.h"
!
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
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute mechanical strains at Gauss points on current element
!
! --------------------------------------------------------------------------------------------------
!
! In  l_axi        : flag is axisymmetric model
! In  ndim         : dimension of element (2 ou 3)
! In  addeme       : adress of mechanic dof in vector and matrix (generalized quantities)
! In  addep1       : adress of first hydraulic dof in vector and matrix (generalized quantities)
! In  addep2       : adress of second hydraulic dof in vector and matrix (generalized quantities)
! In  addete       : adress of thermic dof in vector and matrix (generalized quantities)
! In  nno          : number of nodes (all)
! In  nnos         : number of nodes (not middle ones)
! In  dimuel       : number of dof for element
! In  dimdef       : number of generalized strains
! In  nddls        : number of dof at nodes (not middle ones)
! In  nddlm        : number of dof at nodes (middle ones)
! In  nddl_meca    : number of dof for mechanical quantity
! In  nddl_p1      : number of dof for first hydraulic quantity
! In  nddl_p2      : number of dof for second hydraulic quantity
! In  npi          : number of Gauss points
! In  elem_coor    : coordinates of nodes for current element
! In  disp         : displacement at nodes for current element
! In  jv_poids     : JEVEUX adress for weight of Gauss points (linear shape functions)
! In  jv_poids2    : JEVEUX adress for weight of Gauss points (quadratic shape functions)
! In  jv_func      : JEVEUX adress for shape functions (linear shape functions)
! In  jv_func2     : JEVEUX adress for shape functions (quadratic shape functions)
! In  jv_dfunc     : JEVEUX adress for derivative of shape functions (linear shape functions)
! In  jv_dfunc2    : JEVEUX adress for derivative of shape functions (quadratic shape functions)
! Out epsm         : mechanical strains at Gauss points on current element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kpi, i_cmp, i_dim
    real(kind=8) :: dfdi(20, 3), dfdi2(20, 3)
    real(kind=8) :: poids, poids2
    real(kind=8) :: b(dimdef, dimuel)
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(nno  .le. 20)
    ASSERT(ndim .le. 3)
    ASSERT(npi  .le. 27)
!
! - Compute strains
!
    do kpi = 1 , npi
! ----- Compute [B] matrix for generalized strains
        call cabthm(l_axi    , ndim     ,&
                    nddls    , nddlm    ,&
                    nddl_meca, nddl_p1  , nddl_p2,&
                    nno      , nnos     ,&
                    dimuel   , dimdef   , kpi    ,&
                    addeme   , addete   , addep1 , addep2,&
                    elem_coor,&
                    jv_poids , jv_poids2,&
                    jv_func  , jv_func2 ,&
                    jv_dfunc , jv_dfunc2,&
                    dfdi     , dfdi2    ,&
                    poids    , poids2   ,&
                    b        )
! ----- Compute strains
        if (ds_thm%ds_elem%l_dof_meca) then
            do i_cmp = 1 , 6
                epsm(i_cmp, kpi) = 0.d0
                do i_dim = 1, dimuel
                    epsm(i_cmp, kpi) = epsm(i_cmp,kpi)+b(i_cmp+ndim,i_dim)*disp(i_dim)
                end do
            end do
        endif
    end do
!
end subroutine
