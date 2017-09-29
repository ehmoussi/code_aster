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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504
!
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
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
!
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
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! Compute [B] matrix for generalized strains
!
! --------------------------------------------------------------------------------------------------
!
!                     Not MIDDLE           |    MIDDLE
!           u v p t u v p t u v p t u v p t u v u v u v u v
!          ------------------------------------------------
!        u|                                |               |
!        v|         Shape function         |               |
!        E|              P2                |       P2      |
!          ------------------------------------------------
!        P|                                |               |
!       DP|              P1                |       0       |
!        T|                                |               |
!       DT|                                |               |
!          ------------------------------------------------
!
! In  l_axi            : flag is axisymmetric model
! In  ndim             : dimension of element (2 ou 3)
! In  nddls            : number of dof at nodes (not middle ones)
! In  nddlm            : number of dof at nodes (middle ones)
! In  nddl_meca        : number of dof for mechanical quantity
! In  nddl_p1          : number of dof for first hydraulic quantity
! In  nddl_p2          : number of dof for second hydraulic quantity
! In  nno              : number of nodes (all)
! In  nnos             : number of nodes (not middle ones)
! In  nnom             : number of nodes (middle ones)
! In  dimuel           : number of dof for element
! In  dimdef           : number of generalized strains
! In  kpi              : current Gauss point
! In  addeme           : adress of mechanic components in generalized strains vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  addep2           : adress of gaz pressure in generalized strains vector
! In  elem_coor        : coordinates of node for current element
! In  jv_poids         : JEVEUX adress for weight of Gauss points (linear functions)
! In  jv_poids2        : JEVEUX adress for weight of Gauss points (quadratic functions)
! In  jv_func          : JEVEUX adress for shape functions (linear functions)
! In  jv_func2         : JEVEUX adress for shape functions (quadratic functions)
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions (linear functions)
! In  jv_dfunc2        : JEVEUX adress for derivative of shape functions (quadratic functions)
! Out dfdi             : value of derivative shape function at current node (linear functions)
! Out dfdi2            : value of derivative shape function at current node (quadratic functions)
! Out poids            : weight of current Gauss point (linear functions)
! Out poids2           : weight of current Gauss point (quadratic functions)
! Out b                : [B] matrix for generalized strains
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: rac = sqrt(2.d0)
    real(kind=8) :: r, rmax
    integer :: i_dim, i_node, kk
!
! --------------------------------------------------------------------------------------------------
!
    b(:,:)     = 0.d0
    dfdi(:,:)  = 0.d0
    dfdi2(:,:) = 0.d0
!
! - Get derivatives of shape function
!
    if (ndim .eq. 3) then
        call dfdm3d(nno, kpi, jv_poids, jv_dfunc, elem_coor,&
                    poids, dfdi(1, 1), dfdi(1, 2), dfdi(1, 3))
        call dfdm3d(nnos, kpi, jv_poids2, jv_dfunc2, elem_coor,&
                    poids2, dfdi2(1, 1), dfdi2(1, 2), dfdi2(1, 3))
    elseif (ndim .eq. 2) then
        call dfdm2d(nno, kpi, jv_poids, jv_dfunc, elem_coor,&
                    poids, dfdi(1, 1), dfdi(1, 2))
        call dfdm2d(nnos, kpi, jv_poids2, jv_dfunc2, elem_coor,&
                    poids2, dfdi2(1, 1), dfdi2(1, 2))
        dfdi2(1:nnos,3) = 0.d0
        dfdi(1:nno,3)   = 0.d0
    else
        ASSERT(.false.)
    endif
!
! - Update weight for axisymmetric case
!
    if (l_axi) then
        kk = (kpi-1)*nno
        r  = 0.d0
        do i_node = 1, nno
            r = r + zr(jv_func + i_node + kk - 1)*elem_coor(1,i_node)
        end do
        if (r .eq. 0.d0) then
            rmax=elem_coor(1,1)
            do i_node = 2, nno
                rmax=max(elem_coor(1,i_node),rmax)
            end do
            poids = poids*1.d-03*rmax
        else
            poids = poids*r
        endif
    endif
!
! - Compute left part of [B] operator
!
    do i_node = 1, nnos
! ----- Mechanic terms
        if (ds_thm%ds_elem%l_dof_meca) then
! --------- EPSX, EPSY, EPSZ
            do i_dim = 1, ndim
                b(addeme-1+i_dim,(i_node-1)*nddls+i_dim) = &
                    b(addeme-1+i_dim,(i_node-1)*nddls+i_dim)+zr(jv_func+i_node+(kpi-1)*nno-1)
            end do
! --------- DEPSX, DEPSY, DEPSZ
            do i_dim = 1, ndim
                b(addeme+ndim-1+i_dim,(i_node-1)*nddls+i_dim) =&
                    b(addeme+ndim-1+i_dim,(i_node-1)*nddls+i_dim)+dfdi(i_node,i_dim)
            end do
! --------- U/R for EPSZ (axisymmetric)
            if (l_axi) then
                if (r .eq. 0.d0) then
                    b(addeme+4,(i_node-1)*nddls+1) =&
                        dfdi(i_node,1)
                else
                    kk=(kpi-1)*nno
                    b(addeme+4,(i_node-1)*nddls+1) =&
                        zr(jv_func+i_node+kk-1)/r
                endif
            endif
! --------- EPSXY 
            b(addeme+ndim+3,(i_node-1)*nddls+1) = &
                b(addeme+ndim+3,(i_node-1)*nddls+1)+dfdi(i_node,2)/rac
            b(addeme+ndim+3,(i_node-1)*nddls+2) =&
                b(addeme+ndim+3,(i_node-1)*nddls+2)+dfdi(i_node,1)/rac
! --------- EPSXZ, EPSYZ
            if (ndim .eq. 3) then
                b(addeme+ndim+4,(i_node-1)*nddls+1)= &
                    b(addeme+ndim+4,(i_node-1)*nddls+1)+dfdi(i_node,3)/rac
                b(addeme+ndim+4,(i_node-1)*nddls+3)= &
                    b(addeme+ndim+4,(i_node-1)*nddls+3)+dfdi(i_node,1)/rac
                b(addeme+ndim+5,(i_node-1)*nddls+2)= &
                    b(addeme+ndim+5,(i_node-1)*nddls+2)+dfdi(i_node,3)/rac
                b(addeme+ndim+5,(i_node-1)*nddls+3)= &
                    b(addeme+ndim+5,(i_node-1)*nddls+3)+dfdi(i_node,2)/rac
            endif
        endif
! ----- Hydraulic terms (PRESS1)
        if (ds_thm%ds_elem%l_dof_pre1) then
            b(addep1,(i_node-1)*nddls+nddl_meca+1) = &
                b(addep1,(i_node-1)*nddls+nddl_meca+1)+zr(jv_func2+i_node+(kpi-1)*nnos-1)
            do i_dim = 1, ndim
                b(addep1+i_dim,(i_node-1)*nddls+nddl_meca+1) = &
                    b(addep1+i_dim,(i_node-1)*nddls+nddl_meca+1)+dfdi2(i_node,i_dim)
            end do
        endif
! ----- Hydraulic terms (PRESS2)
        if (ds_thm%ds_elem%l_dof_pre2) then
            b(addep2,(i_node-1)*nddls+nddl_meca+nddl_p1+1) = &
                b(addep2,(i_node-1)*nddls+nddl_meca+nddl_p1+1)+zr(jv_func2+i_node+(kpi-1)*nnos-1)
            do i_dim = 1, ndim
                b(addep2+i_dim,(i_node-1)*nddls+nddl_meca+nddl_p1+1) = &
                    b(addep2+i_dim,(i_node-1)*nddls+nddl_meca+nddl_p1+1)+dfdi2(i_node,i_dim)
            end do
        endif
! ----- Thermic terms
        if (ds_thm%ds_elem%l_dof_ther) then
            b(addete,(i_node-1)*nddls+nddl_meca+nddl_p1+nddl_p2+1) = &
                b(addete,(i_node-1)*nddls+nddl_meca+nddl_p1+nddl_p2+1) +&
                zr(jv_func2+i_node+(kpi-1)*nnos-1)
            do i_dim = 1, ndim
                b(addete+i_dim,(i_node-1)*nddls+nddl_meca+nddl_p1+nddl_p2+1)= &
                    b(addete+i_dim,(i_node-1)*nddls+nddl_meca+nddl_p1+nddl_p2+1)+&
                    dfdi2(i_node,i_dim)
            end do
        endif
    end do
!
! - Compute right part of [B] operator (only P2 for mechanic)
!
    if (ds_thm%ds_elem%l_dof_meca) then
        do i_node = 1, nnom
            do i_dim = 1, ndim
                b(addeme-1+i_dim,nnos*nddls+(i_node-1)*nddlm+i_dim)=&
                    b(addeme-1+i_dim,nnos*nddls+(i_node-1)*nddlm+i_dim) +&
                    zr(jv_func+i_node+nnos+(kpi-1)*nno-1)
            end do
! --------- EPSX, EPSY, EPSZ
            do i_dim = 1, ndim
                b(addeme+ndim-1+i_dim,nnos*nddls+(i_node-1)*nddlm+i_dim)=&
                    b(addeme+ndim-1+i_dim,nnos*nddls+(i_node-1)*nddlm+i_dim) +&
                    dfdi(i_node+nnos,i_dim)
            end do
! --------- U/R for EPSZ (axisymmetric)
            if (l_axi) then
                if (r .eq. 0.d0) then
                    b(addeme+4,nnos*nddls+(i_node-1)*nddlm+1)=&
                        dfdi(i_node+nnos,1)
                else
                    kk=(kpi-1)*nno
                    b(addeme+4,nnos*nddls+(i_node-1)*nddlm+1)=&
                        zr(jv_func+i_node+nnos+kk-1)/r
                endif
            endif
! --------- EPSXY
            b(addeme+ndim+3,nnos*nddls+(i_node-1)*nddlm+1)= &
                b(addeme+ndim+3,nnos*nddls+(i_node-1)*nddlm+1)+dfdi(i_node+nnos,2)/rac
            b(addeme+ndim+3,nnos*nddls+(i_node-1)*nddlm+2)= &
                b(addeme+ndim+3,nnos*nddls+(i_node-1)*nddlm+2)+dfdi(i_node+nnos,1)/rac
! --------- EPSXZ, EPSYZ
            if (ndim .eq. 3) then
                b(addeme+ndim+4,nnos*nddls+(i_node-1)*nddlm+1)= &
                    b(addeme+ndim+4,nnos*nddls+(i_node-1)*nddlm+1) + dfdi(i_node+nnos,3)/rac
                b(addeme+ndim+4,nnos*nddls+(i_node-1)*nddlm+3)= &
                    b(addeme+ndim+4,nnos*nddls+(i_node-1)*nddlm+3) +dfdi(i_node+nnos,1)/rac
                b(addeme+ndim+5,nnos*nddls+(i_node-1)*nddlm+2)= &
                    b(addeme+ndim+5,nnos*nddls+(i_node-1)*nddlm+2) +dfdi(i_node+nnos,3)/rac
                b(addeme+ndim+5,nnos*nddls+(i_node-1)*nddlm+3)= &
                    b(addeme+ndim+5,nnos*nddls+(i_node-1)*nddlm+3) +dfdi(i_node+nnos,2)/rac
            endif
        end do
    endif
!
end subroutine
