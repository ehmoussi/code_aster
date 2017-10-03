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
subroutine thmCompEpsiElga()
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/thmGetElemInfo.h"
#include "asterfort/thmGetElemDime.h"
#include "asterfort/epsthm.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetGene.h"
#include "asterfort/thmGetElemIntegration.h"
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! EPSI_ELGA
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefe, elref2
    integer :: addeme, addep1, addep2, addete
    integer :: ipg, i_cmp
    integer :: jv_geom, jv_disp, jv_strain
    real(kind=8) :: epsm(6, 27)
    integer :: nno, nnos, nnom, nface
    integer :: npi, npi2, npg
    integer :: jv_poids, jv_poids2
    integer :: jv_func, jv_func2, jv_dfunc, jv_dfunc2, jv_gano
    integer :: nddls, nddlm, nddlk, nddlfa
    integer :: nddl_meca, nddl_p1, nddl_p2
    integer :: dimdep, dimdef, dimcon, dimuel
    aster_logical :: l_axi, l_vf, l_steady
    character(len=3) :: inte_type
    integer :: ndim
    integer :: mecani(5), press1(7), press2(7), tempe(5)
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get model of finite element
!
    call thmGetElemModel(l_axi, l_vf, l_steady, ndim)
!
! - Get type of integration
!
    call thmGetElemIntegration(l_vf, inte_type)
!
! - Get generalized coordinates
!
    call thmGetGene(l_steady, l_vf  , ndim  ,&
                    mecani  , press1, press2, tempe)
!
! - Cannot compute for finite volume
!
    ASSERT(.not.l_vf)
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
!
! - Get informations about element
!
    call thmGetElemInfo(l_vf, elrefe, elref2,&
                        nno, nnos, nnom, &
                        jv_gano, jv_poids, jv_poids2,&
                        jv_func, jv_func2, jv_dfunc, jv_dfunc2,&
                        inte_type, npi   , npi2    , npg)
    ASSERT(npi .le. 27)
    ASSERT(nno .le. 20)
!
! - Address in generalized strains vector
!
    addeme = mecani(2)
    addete = tempe(2)
    addep1 = press1(3)
    addep2 = press2(3)
!
! - Get dimensions about element
!
    call thmGetElemDime(l_vf     ,&
                        ndim     , nnos   , nnom   , nface,&
                        mecani   , press1 , press2 , tempe ,&
                        nddls    , nddlm  , nddlk  , nddlfa,&
                        nddl_meca, nddl_p1, nddl_p2,&
                        dimdep   , dimdef , dimcon , dimuel)
!
! - Input fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PDEPLAR', 'L', jv_disp)
!
! - Compute strains
!
    call epsthm(l_axi    , ndim       ,&
                addeme   , addep1     , addep2  , addete   ,&
                nno      , nnos       , nnom    , &
                dimuel   , dimdef     , nddls   , nddlm    ,&
                nddl_meca, nddl_p1    , nddl_p2 ,&
                npi      , zr(jv_geom), zr(jv_disp),&
                jv_poids , jv_poids2  ,&
                jv_func  , jv_func2   , jv_dfunc, jv_dfunc2,&
                epsm)
!
! - Output field
!
    call jevech('PDEFOPG', 'E', jv_strain)
    do ipg = 1, npg
        do i_cmp = 1, 6
            zr(jv_strain+6*(ipg-1)+i_cmp-1) = epsm(i_cmp, ipg)
        end do
    end do
!
end subroutine
