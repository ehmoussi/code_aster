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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romAlgoNLCorrEFMecaResidual(v_fint, v_fext, ds_algorom, l_cine, v_ccid, resi)
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
real(kind=8), pointer :: v_fint(:)
real(kind=8), pointer :: v_fext(:)
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
aster_logical, intent(in) :: l_cine
integer, pointer :: v_ccid(:)
real(kind=8), intent(out) :: resi
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem MECHANICS
!
! Evaluate residuals in applying HYPER-REDUCTION for EF corrections.
!
! --------------------------------------------------------------------------------------------------
!
! In  v_fint           : pointer to internal forces
! In  v_fint           : pointer to external forces
! In  ds_algorom       : datastructure for ROM parameters
! In  l_cine           . .true. if AFFE_CHAR_CINE
! In  v_ccid           : pointer to CCID object (AFFE_CHAR_CINE)
! Out resi             : value for residual
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_hrom
    character(len=8) :: base
    character(len=24) :: field_name
    integer :: i_equa, nb_equa, nb_mode
    real(kind=8), pointer :: v_resi(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resi = 0.d0
!
! - Get parameters
!
    l_hrom     = ds_algorom%l_hrom
    base       = ds_algorom%ds_empi%base
    nb_equa    = ds_algorom%ds_empi%ds_mode%nb_equa
    nb_mode    = ds_algorom%ds_empi%nb_mode
    field_name = ds_algorom%ds_empi%ds_mode%field_name
!
! - Compute equilibrium residual
!
    AS_ALLOCATE(vr=v_resi, size=nb_equa)
    do i_equa = 1, nb_equa
        if (l_cine) then
            if (v_ccid(i_equa) .ne. 1) then
                v_resi(i_equa) = v_fint(i_equa) - v_fext(i_equa)
            endif
        endif
    enddo
!
! - Truncation of residual
!
    if (l_hrom) then
        do i_equa = 1, nb_equa
            if (ds_algorom%v_equa_sub(i_equa) .eq. 1) then
                v_resi(i_equa) = 0.d0
            endif
        enddo
    endif
!
! - Find the residual
!
    do i_equa = 1, nb_equa
        resi = max (resi, abs(v_resi(i_equa)))
    enddo
!
! - Cleaning
!
    AS_DEALLOCATE(vr=v_resi)
!
end subroutine
