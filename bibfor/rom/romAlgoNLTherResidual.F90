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
subroutine romAlgoNLTherResidual(ther_crit_i, ther_crit_r, vec2nd   , cnvabt, cnresi    ,&
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
#include "asterfort/jelira.h"
#include "asterfort/rsexch.h"
#include "blas/ddot.h"
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
! Evaluate residuals in applying HYPER-REDUCTION
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
    aster_logical :: l_hrom
    character(len=8) :: base
    character(len=19) :: mode
    character(len=24) :: field_name
    integer :: i_equa, nb_equa, nb_mode, i_mode, iret
    real(kind=8) :: vnorm, resi
    real(kind=8), pointer :: v_mode(:)=> null()
    real(kind=8), pointer :: v_cn2mbr(:) => null()
    real(kind=8), pointer :: v_cn2mbrr(:) => null()
    real(kind=8), pointer :: v_vec2nd(:) => null()
    real(kind=8), pointer :: v_vec2ndr(:) => null()
    real(kind=8), pointer :: v_cnvabt(:) => null()
    real(kind=8), pointer :: v_cnvabtr(:) => null()
    real(kind=8), pointer :: v_cnresi(:) => null()
    real(kind=8), pointer :: v_cnresir(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resi_rela = 0.d0
    resi_maxi = 0.d0
    vnorm     = 0.d0
    resi      = 0.d0
    conver    = .false.
!
! - Get parameters
!
    l_hrom     = ds_algorom%l_hrom
    base       = ds_algorom%ds_empi%base
    nb_equa    = ds_algorom%ds_empi%nb_equa
    nb_mode    = ds_algorom%ds_empi%nb_mode
    field_name = ds_algorom%ds_empi%field_name
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
            if (ds_algorom%v_equa_int(i_equa) .eq. 1) then
                v_vec2nd(i_equa) = 0.d0
                v_cnvabt(i_equa) = 0.d0
                v_cnresi(i_equa) = 0.d0
            endif    
        enddo
    endif
!
! - Product of modes by second member
!
    AS_ALLOCATE(vr=v_cn2mbrr, size=nb_mode)
    AS_ALLOCATE(vr=v_vec2ndr, size=nb_mode)
    AS_ALLOCATE(vr=v_cnresir, size=nb_mode)
    AS_ALLOCATE(vr=v_cnvabtr, size=nb_mode)
    do i_mode = 1, nb_mode
        call rsexch(' ', base, field_name, i_mode, mode, iret)
        call jeveuo(mode(1:19)//'.VALE', 'E', vr = v_mode)
        v_vec2ndr(i_mode)= ddot(nb_equa, v_mode, 1, v_vec2nd, 1)
        v_cnvabtr(i_mode)= ddot(nb_equa, v_mode, 1, v_cnvabt, 1)
        v_cnresir(i_mode)= ddot(nb_equa, v_mode, 1, v_cnresi, 1)
    enddo
!
! - Compute maximum
!
    do i_mode = 1, nb_mode
        v_cn2mbrr(i_mode) = v_vec2ndr(i_mode) - v_cnresir(i_mode) - v_cnvabtr(i_mode)
        resi              = resi + ( v_cn2mbrr(i_mode) )**2
        vnorm             = vnorm + ( v_vec2ndr(i_mode) - v_cnvabtr(i_mode) )**2
        resi_maxi         = max( resi_maxi,abs( v_cn2mbrr(i_mode) ) )
    end do
!
! - Compute relative
!
    if (vnorm .gt. 0.d0) then
        resi_rela = sqrt( resi / vnorm )
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
    AS_DEALLOCATE(vr=v_vec2ndr)
    AS_DEALLOCATE(vr=v_cnresir)
    AS_DEALLOCATE(vr=v_cnvabtr)
!
end subroutine
