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

subroutine thmCompRefeForcNoda(l_axi , inte_type, l_vf   , type_vf, l_steady, ndim ,&
                               mecani, press1   , press2 , tempe)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/refthm.h"
#include "asterfort/jevech.h"
#include "asterfort/thmGetGeneDime.h"
#include "asterfort/thmGetElemDime.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/thmGetElemInfo.h"
!
!
    aster_logical, intent(in) :: l_axi, l_vf, l_steady
    integer, intent(in) :: type_vf
    character(len=3), intent(in) :: inte_type
    integer, intent(in) :: ndim
    integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! REFE_FORC_NODA
!
! --------------------------------------------------------------------------------------------------
!
! In  l_axi        : flag is axisymmetric model
! In  inte_type    : type of integration - classical, lumped (D), reduced (R)
! In  l_vf         : flag for finite volume
! In  type_vf      : type for finite volume
! In  l_steady     : .true. for steady state
! In  ndim         : dimension of element (2 ou 3)
! In  mecani       : parameters for mechanic
! In  press1       : parameters for hydraulic (first pressure)
! In  press1       : parameters for hydraulic (second pressure)
! In  tempe        : parameters for thermic
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefe, elref2
    aster_logical :: fnoevo
    real(kind=8) :: dt
    integer :: jv_mater, jv_geom, jv_vectu
    real(kind=8) :: b(21, 120), r(22)
    integer :: nno, nnos, nnom, nface
    integer :: npi, npi2, npg
    integer :: jv_poids, jv_poids2
    integer :: jv_func, jv_func2, jv_dfunc, jv_dfunc2, jv_gano
    integer :: nddls, nddlm, nddlk, nddlfa
    integer :: nddl_meca, nddl_p1, nddl_p2
    integer :: dimdep, dimdef, dimcon, dimuel
!
! --------------------------------------------------------------------------------------------------
!
    dt     = 1.0d0
    fnoevo = .true.
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
!
! - Get informations about element
!
    call thmGetElemInfo(l_vf, type_vf, inte_type, elrefe, elref2,&
                        nno, nnos, nnom, &
                        npi, npi2, npg,&
                        jv_gano, jv_poids, jv_poids2,&
                        jv_func, jv_func2, jv_dfunc, jv_dfunc2)
    ASSERT(npi .le. 27)
    ASSERT(nno .le. 20)
!
! - Get dimensions of generalized vectors
!
    call thmGetGeneDime(ndim  ,&
                        mecani, press1, press2, tempe,&
                        dimdep, dimdef, dimcon)
!
! - Get dimensions about element
!
    call thmGetElemDime(l_vf     , type_vf,&
                        ndim     , nnos   , nnom   , nface,&
                        mecani   , press1 , press2 , tempe ,&
                        nddls    , nddlm  , nddlk  , nddlfa,&
                        nddl_meca, nddl_p1, nddl_p2,&
                        dimdep   , dimdef , dimcon , dimuel)
!
! - Intput/output fields
!
    call jevech('PGEOMER', 'L', jv_geom)
    call jevech('PMATERC', 'L', jv_mater)
    call jevech('PVECTUR', 'E', jv_vectu)
!
! - Compute REFE_FORC_NODA
!
    call refthm(zi(jv_mater), ndim     , l_axi    , l_steady , fnoevo ,&
                mecani     , press1   , press2   , tempe    ,&
                nno        , nnos     , nnom     , npi      , npg    ,&
                zr(jv_geom), dt       , dimdef   , dimcon   , dimuel ,&
                jv_poids   , jv_poids2,&
                jv_func    , jv_func2 , jv_dfunc , jv_dfunc2,&
                nddls      , nddlm    , nddl_meca, nddl_p1  , nddl_p2,&
                b          , r        , zr( jv_vectu))
!
end subroutine
