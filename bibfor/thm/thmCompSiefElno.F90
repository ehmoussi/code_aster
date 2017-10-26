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
subroutine thmCompSiefElno()
!
use THM_type
use THM_module
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/thmGetGeneDime.h"
#include "asterfort/jevech.h"
#include "asterfort/posthm.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetGene.h"
#include "asterfort/thmGetElemIntegration.h"

!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! SIEF_ELNO
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: option
    character(len=8) :: elrefe, elref2
    integer :: jv_sigm, jv_sigmelno, nvim, jv_gano
    integer :: dimdep, dimdef, dimcon
    aster_logical :: l_axi, l_vf, l_steady
    character(len=3) :: inte_type
    integer :: ndim
    integer :: mecani(5), press1(7), press2(7), tempe(5)
!
! --------------------------------------------------------------------------------------------------
!
    option = 'SIEF_ELNO'
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
    nvim   = mecani(5)
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
    call elrefe_info(elrefe=elrefe, fami='RIGI', ndim=ndim, jgano=jv_gano)
!
! - Get dimensions of generalized vectors
!
    call thmGetGeneDime(ndim  ,&
                        mecani, press1, press2, tempe,&
                        dimdep, dimdef, dimcon)
!
! - Compute
!
    call jevech('PCONTRR', 'L', jv_sigm)
    call jevech('PSIEFNOR', 'E', jv_sigmelno)
    call posthm(option, inte_type, jv_gano, dimcon, nvim,&
                zr(jv_sigm), zr(jv_sigmelno))
!
end subroutine
