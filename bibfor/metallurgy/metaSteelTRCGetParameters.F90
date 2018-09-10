! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine metaSteelTRCGetParameters(jv_mater, metaSteelPara)
!
use Metallurgy_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/rcadma.h"
#include "asterfort/Metallurgy_type.h"
!
integer, intent(in) :: jv_mater
type(META_SteelParameters), intent(out) :: metaSteelPara
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Steel
!
! Get parameters for TRC curves
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater            : coded material address
! Out metaSteelPara       : material parameters for metallurgy of steel
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_pftrc
    integer :: nbcb1, nbcb2, nblexp
    integer :: icodre, nb_trc, nb_hist
    integer :: jftrc, jtrc
    integer :: iadexp, iadckm, iadtrc
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PFTRC', 'L', jv_pftrc)
    jftrc   = zi(jv_pftrc)
    jtrc    = zi(jv_pftrc+1)
    call rcadma(jv_mater, 'META_ACIER', 'TRC', iadtrc, icodre, 1)
    nbcb1   = nint(zr(iadtrc+1))
    nbcb2   = nint(zr(iadtrc+1+2+nbcb1))
    nb_hist = nint(zr(iadtrc+2))
    nbcb2   = nint(zr(iadtrc+1+2+nbcb1*nb_hist))
    nblexp  = nint(zr(iadtrc+1+2+nbcb1*nb_hist+1))
    nb_trc  = nint(zr(iadtrc+1+2+nbcb1*nb_hist+2+nbcb2*nblexp+1))
    iadexp  = 5 + nbcb1*nb_hist
    iadckm  = 7 + nbcb1*nb_hist + nbcb2*nblexp
    metaSteelPara%trc%jv_ftrc = jftrc
    metaSteelPara%trc%jv_trc  = jtrc
    metaSteelPara%trc%iadexp  = iadexp
    metaSteelPara%trc%iadckm  = iadckm
    metaSteelPara%trc%iadtrc  = iadtrc
    metaSteelPara%trc%nb_hist = nb_hist
    metaSteelPara%trc%nb_trc  = nb_trc
!
end subroutine
