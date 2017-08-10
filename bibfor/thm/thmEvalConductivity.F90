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
subroutine thmEvalConductivity(angl_naut, ndim  , j_mater,&
                               satur    , phi   , &
                               lambs    , dlambs, lambp , dlambp,&
                               tlambt   , tlamct, tdlamt)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/THM_type.h"
#include "asterfort/tdlamb.h"
#include "asterfort/telamb.h"
#include "asterfort/tlambc.h"
!
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: ndim
real(kind=8), intent(in) :: satur, phi
real(kind=8), intent(out) :: lambs, dlambs
real(kind=8), intent(out) :: lambp, dlambp
real(kind=8), intent(out) :: tlambt(ndim, ndim)
real(kind=8), intent(out) :: tlamct(ndim, ndim)
real(kind=8), intent(out) :: tdlamt(ndim, ndim)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Evaluate thermal conductivity
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater          : coded material address
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  ndim             : dimension of space
! In  satur            : saturation
! In  phi              : porosity
! Out lambs            : thermal conductivity depending on saturation
! Out dlambs           : derivative of thermal conductivity depending on saturation
! Out lambp            : thermal conductivity depending on porosity
! Out dlambp           : derivative of thermal conductivity depending on porosity
! Out tlambt           : tensor of thermal conductivity
! Out tlamct           : tensor of thermal conductivity (constant part)
! Out tdlamt           : tensor of derivatives for thermal conductivity
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para = 2
    real(kind=8) :: para_vale(nb_para)
    character(len=4), parameter :: para_name(nb_para)  = (/'SAT ', 'PORO'/)
    integer, parameter :: nb_resu = 4
    real(kind=8) :: resu_vale(nb_resu)
    character(len=16), parameter :: resu_name(nb_resu) = (/'LAMB_S  ', 'D_LB_S  ',&
                                                           'LAMB_PHI', 'D_LB_PHI'/)
    integer :: icodre(nb_resu)
!
! --------------------------------------------------------------------------------------------------
!
    lambs        = 1.d0
    dlambs       = 0.d0
    lambp        = 1.d0
    dlambp       = 0.d0
    resu_vale(:) = 0.d0
    resu_vale(1) = 1.d0
    resu_vale(3) = 1.d0
!
! - Get parameters depending on porosity and saturation
!
    para_vale(1) = satur
    para_vale(2) = phi
    call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                nb_para, para_name, para_vale  ,&
                nb_resu, resu_name, resu_vale  ,&
                icodre , 0        , nan='NON')
    lambs     = resu_vale(1)
    dlambs    = resu_vale(2)
    lambp     = resu_vale(3)
    dlambp    = resu_vale(4)
!
! - Compute tensor of thermal conductivity
!
    call telamb(angl_naut, ndim, tlambt)
!
! - Compute tensor of thermal conductivity (constant part)
!
    call tlambc(angl_naut, ndim, tlamct)
!
! - Compute tensor of derivatives (by temperature) for thermal conductivity
!
    call tdlamb(angl_naut, ndim, tdlamt)
!
end subroutine
