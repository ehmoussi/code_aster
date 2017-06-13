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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romAlgoNLCorrEFTherResidual(ther_crit_i, ther_crit_r, vec2nd   , cnvabt, cnresi    ,&
                                       cn2mbr     , resi_rela  , resi_maxi, conver, ds_algorom)

!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jeveuo.h"
!
integer, intent(in) :: ther_crit_i(*)
real(kind=8), intent(in) :: ther_crit_r(*)
character(len=24), intent(in) :: vec2nd
character(len=24), intent(in) :: cnvabt
character(len=24), intent(in) :: cnresi
character(len=24), intent(in) :: cn2mbr
real(kind=8)     , intent(out):: resi_rela
real(kind=8)     , intent(out):: resi_maxi
aster_logical    , intent(out):: conver
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem THERMICS
!
! Evaluate residuals in applying HYPER-REDUCTION in CORR_EF phase
!
! --------------------------------------------------------------------------------------------------
!
! In  ther_crit_i      : criteria for algorithm (integer)
! In  ther_crit_r      : criteria for algorithm (real)
! In  vec2nd           : applied loads
! In  cnvabt           : BT.T LAMBDA for Dirichlet loads
! In  cnresi           : non-linear residual
! In  cn2mbr           : equilibrium residual (to evaluate convergence)
! Out resi_rela        : value for RESI_GLOB_RELA
! Out resi_maxi        : value for RESI_GLOB_MAXI
! Out conver           : .true. if convergence
! In  ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_Empi) :: ds_empi
    aster_logical :: l_hrom
    integer :: i_equa, nb_equa
    real(kind=8) :: vnorm
    real(kind=8), pointer :: v_cn2mbr(:) => null()
    real(kind=8), pointer :: v_cn2mbrr(:) => null()
    real(kind=8), pointer :: v_vec2nd(:) => null()
    real(kind=8), pointer :: v_cnvabt(:) => null()
    real(kind=8), pointer :: v_cnresi(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resi_rela = 0.d0
    resi_maxi = 0.d0
    vnorm     = 0.d0
    conver    = .false.
!
! - Get parameters
!
    l_hrom = ds_algorom%l_hrom
!
! - Get empirical basis
!
    if (l_hrom) then
        ds_empi = ds_algorom%ds_empi_rid
    else
        ds_empi = ds_algorom%ds_empi
    endif
    nb_equa    = ds_empi%nb_equa
!
! - Access to vectors
!
    call jeveuo(cn2mbr(1:19)//'.VALE', 'E', vr = v_cn2mbr)
    call jeveuo(vec2nd(1:19)//'.VALE', 'L', vr = v_vec2nd)
    call jeveuo(cnvabt(1:19)//'.VALE', 'L', vr = v_cnvabt)
    call jeveuo(cnresi(1:19)//'.VALE', 'L', vr = v_cnresi)
!
! - Create residual
!
    do i_equa = 1, nb_equa
        v_cn2mbr(i_equa)  = v_vec2nd(i_equa) - v_cnresi(i_equa) - v_cnvabt(i_equa)
    enddo
!
! - Truncation of residual
!
    if (l_hrom) then
        do i_equa = 1, nb_equa
            if (ds_algorom%v_equa_sub(i_equa) .eq. 1) then
                v_vec2nd(i_equa) = 0.d0
                v_cnvabt(i_equa) = 0.d0
                v_cnresi(i_equa) = 0.d0
            endif
        enddo
    endif
!
! - Product of modes by second member
!
    AS_ALLOCATE(vr=v_cn2mbrr, size=nb_equa)
!
! - Compute maximum
!
    do i_equa = 1, nb_equa
        v_cn2mbrr(i_equa) = v_vec2nd(i_equa) - v_cnresi(i_equa) - v_cnvabt(i_equa)
        resi_rela         = resi_rela + ( v_cn2mbrr(i_equa) )**2
        vnorm             = vnorm + ( v_vec2nd(i_equa) - v_cnvabt(i_equa) )**2
        resi_maxi         = max( resi_maxi,abs( v_cn2mbrr(i_equa) ) )
    end do
!
! - Compute relative
!
    if (vnorm .gt. 0.d0) then
        resi_rela = sqrt( resi_rela / vnorm )
    endif
!
! - Evaluate
!
    if (ther_crit_i(1) .ne. 0) then
        if (resi_maxi .lt. ther_crit_r(1)) then
            conver = .true.
        else
            conver = .false.
        endif
    else
        if (resi_rela .lt. ther_crit_r(2)) then
            conver = .true.
        else
            conver = .false.
        endif
    endif
!
! - Cleaning
!
    AS_DEALLOCATE(vr=v_cn2mbrr)
!
end subroutine
