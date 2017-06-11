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

subroutine fnothm(jv_mater , ndim     , l_axi    , l_steady , fnoevo ,&
                  mecani   , press1   , press2   , tempe    ,&
                  nno      , nnos     , nnom     , npi      , npg    ,&
                  elem_coor, deltat   , dimdef   , dimcon   , dimuel ,&
                  jv_poids , jv_poids2,&
                  jv_func  , jv_func2 , jv_dfunc , jv_dfunc2,&
                  nddls    , nddlm    , nddl_meca, nddl_p1  , nddl_p2,&
                  congem   , b        , r        , vectu )
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cabthm.h"
#include "asterfort/fonoda.h"
!
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504
!
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
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute nodal force vector (FORC_NODA)
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater     : coded material address
! In  ndim         : dimension of element (2 ou 3)
! In  l_axi        : flag is axisymmetric model
! In  l_steady     : .true. for steady state
! In  fnoevo       : .true. if compute in non-linear operator (transient terms)
! In  mecani       : parameters for mechanic
! In  press1       : parameters for hydraulic (first pressure)
! In  press1       : parameters for hydraulic (second pressure)
! In  tempe        : parameters for thermic
! In  nno          : number of nodes (all)
! In  nnos         : number of nodes (not middle ones)
! In  nnom         : number of nodes (middle ones)
! In  npi          : number of Gauss points for linear 
! In  npg          : number of Gauss points
! In  elem_coor    : coordinates of nodes for current element
! In  deltat       : time increment
! In  dimdef       : number of generalized strains
! In  dimcon       : dimension of generalized stresses vector
! In  dimuel       : number of dof for element
! In  jv_poids     : JEVEUX adress for weight of Gauss points (linear shape functions)
! In  jv_poids2    : JEVEUX adress for weight of Gauss points (quadratic shape functions)
! In  jv_func      : JEVEUX adress for shape functions (linear shape functions)
! In  jv_func2     : JEVEUX adress for shape functions (quadratic shape functions)
! In  jv_dfunc     : JEVEUX adress for derivative of shape functions (linear shape functions)
! In  jv_dfunc2    : JEVEUX adress for derivative of shape functions (quadratic shape functions)
! In  nddls        : number of dof at nodes (not middle ones)
! In  nddlm        : number of dof at nodes (middle ones)
! In  nddl_meca    : number of dof for mechanical quantity
! In  nddl_p1      : number of dof for first hydraulic quantity
! In  nddl_p2      : number of dof for second hydraulic quantity
! IO  congem       : generalized stresses at the beginning of time step
!                    => output sqrt(2) on SIG_XY, SIG_XZ, SIG_YZ
! IO  b            : [B] matrix for generalized strains
! IO  r            : stress vector
! Out vectu        : nodal force vector (FORC_NODA)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kpi, i, n
    real(kind=8) :: dt
    real(kind=8) :: dfdi(20, 3), dfdi2(20, 3), poids, poids2
    integer :: yamec, yate, yap1, yap2
    integer :: addeme, addete, addep1, addep2
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(nno  .le. 20)
    ASSERT(ndim .le. 3)
    ASSERT(npi  .le. 27)
    vectu(1:dimuel) = 0.d0
!
! - Get active physics
!
    yamec  = mecani(1)
    yap1   = press1(1)
    yap2   = press2(1)
    yate   = tempe(1)
!
! - Get adresses in generalized vectors
!
    addeme = mecani(2)
    addep1 = press1(3)
    addep2 = press2(3)
    addete = tempe(2)
!
! - Time step
!
    if (l_steady) then
        dt = 1.d0
    else
        dt = deltat
    endif
!
! - Loop on Gauss points
!
    do kpi = 1, npg
        r(1:dimdef+1) = 0.d0
! ----- Compute [B] matrix for generalized strains
        call cabthm(nddls, nddlm, nno, nnos, nnom,&
                    dimuel, dimdef, ndim, kpi,&
                    jv_poids, jv_poids2,&
                    jv_func, jv_func2, jv_dfunc, jv_dfunc2,&
                    dfdi, dfdi2, elem_coor, poids, poids2,&
                    b, nddl_meca, yamec, addeme, yap1,&
                    addep1, yap2, addep2, yate, addete,&
                    nddl_p1, nddl_p2, l_axi)
! ----- Compute stress vector {R} 
        call fonoda(jv_mater, ndim  , l_steady, fnoevo,&
                    mecani  , press1, press2  , tempe,&
                    dimdef  , dimcon, dt      , congem((kpi-1)*dimcon+1),&
                    r)
! ----- Compute residual = [B]^T.{R} 
        do i = 1, dimuel
            do n = 1, dimdef
                vectu(i)=vectu(i)+b(n,i)*r(n)*poids
            end do
        end do
    end do
!
end subroutine
