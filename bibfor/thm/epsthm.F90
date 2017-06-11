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

subroutine epsthm(l_axi    , ndim     ,& 
                  yamec    , yap1     , yap2    , yate     ,&
                  addeme   , addep1   , addep2  , addete   ,&
                  nno      , nnos     , nnom    , &
                  dimuel   , dimdef   , nddls   , nddlm    ,&
                  nddl_meca, nddl_p1  , nddl_p2 ,&
                  npi      , elem_coor, disp    ,&
                  jv_poids , jv_poids2,&
                  jv_func  , jv_func2 , jv_dfunc, jv_dfunc2,&
                  epsm)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/cabthm.h"
#include "asterfort/assert.h"
!
! aslint: disable=W1504
!
    aster_logical, intent(in) :: l_axi
    integer, intent(in) :: ndim
    integer, intent(in) :: yamec, yap1, yap2, yate
    integer, intent(in) :: addeme, addep1, addep2, addete
    integer, intent(in) :: nno, nnos, nnom
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
! In  yamec        : flag for mechanic (1 of dof exist)
! In  yap1         : flag for first hydraulic (1 of dof exist)
! In  yap2         : flag for second hydraulic (1 of dof exist)
! In  yate         : flag for thermic (1 of dof exist)
! In  addeme       : adress of mechanic dof in vector and matrix (generalized quantities)
! In  addep1       : adress of first hydraulic dof in vector and matrix (generalized quantities)
! In  addep2       : adress of second hydraulic dof in vector and matrix (generalized quantities)
! In  addete       : adress of thermic dof in vector and matrix (generalized quantities)
! In  nno          : number of nodes (all)
! In  nnos         : number of nodes (not middle ones)
! In  nnom         : number of nodes (middle ones)
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
        call cabthm(nddls, nddlm, nno, nnos, nnom,&
                    dimuel, dimdef, ndim, kpi,&
                    jv_poids, jv_poids2,&
                    jv_func, jv_func2, jv_dfunc, jv_dfunc2,&
                    dfdi, dfdi2, elem_coor, poids, poids2,&
                    b, nddl_meca, yamec, addeme, yap1,&
                    addep1, yap2, addep2, yate, addete,&
                    nddl_p1, nddl_p2, l_axi)
! ----- Compute strains
        if (yamec .eq. 1) then
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
