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
subroutine thmGetElemPara(l_axi    , l_steady ,&
                          type_elem, inte_type, ndim     ,&
                          mecani   , press1   , press2   , tempe  ,&
                          dimdep   , dimdef   , dimcon   , dimuel ,&
                          nddls    , nddlm    , nddl_meca, nddl_p1, nddl_p2,&
                          nno      , nnos     ,&
                          npi      , npg      ,&
                          jv_poids , jv_func  , jv_dfunc ,&
                          jv_poids2, jv_func2 , jv_dfunc2,&
                          jv_gano)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetGene.h"
#include "asterfort/thmGetElemIntegration.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetElemDime.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/thmGetElemInfo.h"
!
aster_logical, intent(out) :: l_axi, l_steady
character(len=8), intent(out) :: type_elem(2)
character(len=3), intent(out) :: inte_type
integer, intent(out) :: ndim
integer, intent(out) :: mecani(5), press1(7), press2(7), tempe(5)
integer, intent(out) :: dimdep, dimdef, dimcon, dimuel
integer, intent(out) :: nddls, nddlm, nddl_meca, nddl_p1, nddl_p2
integer, intent(out) :: nno, nnos
integer, intent(out) :: npi, npg
integer, intent(out) :: jv_func, jv_dfunc, jv_poids
integer, intent(out) :: jv_func2, jv_dfunc2, jv_poids2
integer, intent(out) :: jv_gano 
!
! --------------------------------------------------------------------------------------------------
!
! THM - Initializations
!
! Get all parameters for current element
!
! --------------------------------------------------------------------------------------------------
!
! Out l_axi            : flag is axisymmetric model
! Out l_steady         : .true. for steady state
! Out type_elem        : type of element
! Out inte_type        : type of integration - classical, lumped (D), reduced (R)
! Out ndim             : dimension of element (2 ou 3)
! Out mecani           : parameters for mechanic
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Adress of first component in generalized strain vector
!                    (3) - Adress of first component in generalized stress vector
!                    (4) - Number of components for strains
!                    (5) - Number of components for stresses
! Out press1           : parameters for hydraulic (capillary pressure)
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Number of phases
!                    (3) - Adress of first component in generalized strain vector
!                    (4) - Adress of first component in vector of gen. stress for first phase 
!                    (5) - Adress of first component in vector of gen. stress for second phase
!                    (6) - Number of components for strains
!                    (7) - Number of components for stresses (for each phase)
! Out press2           : parameters for hydraulic (gaz pressure)
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Number of phases
!                    (3) - Adress of first component in generalized strain vector
!                    (4) - Adress of first component in vector of gen. stress for first phase 
!                    (5) - Adress of first component in vector of gen. stress for second phase
!                    (6) - Number of components for strains
!                    (7) - Number of components for stresses (for each phase)
! Out tempe            : parameters for thermic
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Adress of first component in generalized strain vector
!                    (3) - Adress of first component in generalized stress vector
!                    (4) - Number of components for strains
!                    (5) - Number of components for stresses
! Out dimdep           : dimension of generalized displacement vector
! Out dimdef           : dimension of generalized strains vector
! Out dimcon           : dimension of generalized stresses vector
! Out dimuel           : total number of dof for element
! Out nddls            : number of dof at nodes (not middle ones)
! Out nddlm            : number of dof at nodes (middle ones)
! Out nddl_meca        : number of dof for mechanical quantity
! Out nddl_p1          : number of dof for capillary pressure
! Out nddl_p2          : number of dof for gaz pressure
! Out nno              : number of nodes (all)
! Out nnos             : number of nodes (not middle ones)
! Out npi              : number of Gauss points for linear
! Out npg              : number of Gauss points
! Out jv_poids         : JEVEUX adress for weight of Gauss points (linear shape functions)
! Out jv_poids2        : JEVEUX adress for weight of Gauss points (quadratic shape functions)
! Out jv_func          : JEVEUX adress for shape functions (linear shape functions)
! Out jv_func2         : JEVEUX adress for shape functions (quadratic shape functions)
! Out jv_dfunc         : JEVEUX adress for derivative of shape functions (linear shape functions)
! Out jv_dfunc2        : JEVEUX adress for derivative of shape functions (quadratic shape functions)
! Out jv_gano          : JEVEUX adress for Gauss points to nodes functions (linear shape functions)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefe, elref2
    integer :: nnom, npi2
    aster_logical :: l_vf
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get model of finite element
!
    call thmGetElemModel(l_axi, l_vf, l_steady, ndim, type_elem)
    ASSERT(.not. l_vf)
!
! - Get type of integration
!
    call thmGetElemIntegration(l_vf, inte_type)     
!
! - Get generalized coordinates
!
    call thmGetGene(l_steady, l_vf, ndim,&
                    mecani  , press1, press2, tempe)
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
!
! - Get informations about element
!
    call thmGetElemInfo(l_vf     , elrefe  , elref2   ,&
                        nno      , nnos    , nnom     ,&
                        jv_gano  , jv_poids, jv_poids2,&
                        jv_func  , jv_func2, jv_dfunc , jv_dfunc2,&
                        inte_type, npi     , npi2     , npg)
!
! - For finite volume
!
!    if (l_vf) then
!        if (ndim .eq. 2) then
!            nface = nnos
!        else
!            if (elrefe .eq. 'H27') then
!                nface = 6
!            else if (elrefe .eq. 'T9') then
!                nface = 4
!            else
!                ASSERT(ASTER_FALSE)
!            endif
!        endif
!    else
!        nface = 0
!    endif
!
! - Get dimensions about element
!
    call thmGetElemDime(l_vf     ,&
                        ndim     , nnos   , nnom   ,&
                        mecani   , press1 , press2 , tempe ,&
                        nddls    , nddlm  ,&
                        nddl_meca, nddl_p1, nddl_p2,&
                        dimdep   , dimdef , dimcon , dimuel)
!
end subroutine
