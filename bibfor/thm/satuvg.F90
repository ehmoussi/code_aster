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

subroutine satuvg(pc, satur, dsatur_)
!
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/pcapvg.h"
#include "asterfort/reguh1.h"
#include "asterfort/satfvg.h"
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), intent(in) :: pc
    real(kind=8), intent(out) :: satur 
    real(kind=8), optional, intent(out) :: dsatur_
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute saturation for VAN-GENUCHTEN model
!
! --------------------------------------------------------------------------------------------------
!
! In  pc           : capillary pressure
! Out satur        : saturation
! Out dsatur       : derivative of saturation (/pc)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: satuma, n, m, pr, smax, sr
    real(kind=8) :: s1max, pcmax, dpcmax
    real(kind=8) :: usn, usm, b1, c1, dsatur
!
! --------------------------------------------------------------------------------------------------
!
    n      = ds_thm%ds_material%hydr%n
    pr     = ds_thm%ds_material%hydr%pr
    sr     = ds_thm%ds_material%hydr%sr
    smax   = ds_thm%ds_material%hydr%smax
    satuma = ds_thm%ds_material%hydr%satuma
    m      = 1.d0-1.d0/n
    usn    = 1.d0/n
    usm    = 1.d0/m
    s1max  = (smax-sr)/(1.d0-sr)
!
! - Compute capillary pressure (and its derivative)
!
    call pcapvg(sr   , pr    , usm, usn, s1max,&
                pcmax, dpcmax)
!
! - Regularization by first order hyperbola
!
    call reguh1(pcmax, smax, 1.d0/dpcmax, b1, c1)
! 
! - Compute saturation (and its derivative)
!
    if ((pc .gt. pcmax)) then
        call satfvg(sr , pr, n, m, pc,&
                    satur, dsatur)
    else
        satur  = 1.d0-b1/(c1-pc)
        dsatur = -b1/((c1-pc)**2.d0)
    endif
!
! - Corrective factor
!
    satur = satur*satuma
!
    if (present(dsatur_)) then
        dsatur_ = dsatur
    endif
!
end subroutine
