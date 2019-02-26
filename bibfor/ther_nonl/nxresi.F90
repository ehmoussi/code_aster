! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nxresi(vec2nd   , cnvabt   , cnresi  , cn2mbr  ,&
                  resi_rela, resi_maxi, ieq_rela, ieq_maxi)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8gaem.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
!
character(len=24), intent(in) :: vec2nd, cnvabt, cnresi, cn2mbr
real(kind=8)     , intent(out):: resi_rela, resi_maxi
integer          , intent(out):: ieq_rela, ieq_maxi
!
! --------------------------------------------------------------------------------------------------
!
! THER_NON_LINE
!
! Evaluate residuals
!
! --------------------------------------------------------------------------------------------------
!
! In  vec2nd           : applied loads
! In  cnvabt           : BT.T LAMBDA for Dirichlet loads
! In  cnresi           : non-linear residual
! In  cn2mbr           : equilibrium residual (to evaluate convergence)
! Out resi_rela        : value for RESI_GLOB_RELA
! Out resi_maxi        : value for RESI_GLOB_MAXI
! Out ieq_rela         : number of equation where RESI_GLOB_RELA is maximum
! Out ieq_maxi         : number of equation where RESI_GLOB_MAXI is maximum
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: vnorm, value
    real(kind=8), pointer :: v_cn2mbr(:) => null()
    real(kind=8), pointer :: v_vec2nd(:) => null()
    real(kind=8), pointer :: v_cnvabt(:) => null()
    real(kind=8), pointer :: v_cnresi(:) => null()
    integer :: nb_equa, i_equa
!
! --------------------------------------------------------------------------------------------------
!
    resi_rela = 0.d0
    resi_maxi = -r8gaem()
    ieq_rela  = 0
    ieq_maxi  = 0
    vnorm     = 0.d0
!
! - Access to vectors
!
    call jeveuo(cn2mbr(1:19)//'.VALE', 'E', vr = v_cn2mbr)
    call jeveuo(vec2nd(1:19)//'.VALE', 'L', vr = v_vec2nd)
    call jeveuo(cnvabt(1:19)//'.VALE', 'L', vr = v_cnvabt)
    call jeveuo(cnresi(1:19)//'.VALE', 'L', vr = v_cnresi)
    call jelira(cn2mbr(1:19)//'.VALE', 'LONMAX', nb_equa)
!
! - Compute maximum
!
    do i_equa = 1, nb_equa
        v_cn2mbr(i_equa) = v_vec2nd(i_equa) - v_cnresi(i_equa) - v_cnvabt(i_equa)
        resi_rela        = resi_rela + ( v_cn2mbr(i_equa) )**2
        vnorm            = vnorm + ( v_vec2nd(i_equa) - v_cnvabt(i_equa) )**2
        value            = abs(v_cn2mbr(i_equa))
        if (value .ge. resi_maxi) then
            resi_maxi = value
            ieq_maxi  = i_equa
        endif
    end do
!
! - Compute relative
!
    ieq_rela = ieq_maxi
    if (vnorm .gt. 0.d0) then
        resi_rela = sqrt( resi_rela / vnorm )
    endif
!
end subroutine
