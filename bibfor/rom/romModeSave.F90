! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine romModeSave(base       , iMode    , model    ,&
                       fieldName  , fieldIden, fieldRefe,&
                       fieldSupp  , nbEqua   ,&
                       mode_vectr_,&
                       mode_vectc_,&
                       mode_freq_ ,&
                       nume_slice_,&
                       nb_snap_)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsagsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/romModeParaSave.h"
!
character(len=8), intent(in) :: base
integer, intent(in) :: iMode
character(len=8), intent(in) :: model
character(len=24), intent(in) :: fieldName, fieldIden, fieldRefe
character(len=4), intent(in) :: fieldSupp
integer, intent(in) :: nbEqua
real(kind=8), optional, intent(in) :: mode_vectr_(nbEqua)
complex(kind=8), optional, intent(in) :: mode_vectc_(nbEqua)
integer, optional, intent(in)     :: nume_slice_
real(kind=8), optional, intent(in) :: mode_freq_
integer, optional, intent(in)     :: nb_snap_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save empiric mode
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! In  iMode            : index of empiric modes
! In  model            : name of model
! In  fieldName        : name of field where empiric modes have been constructed (NOM_CHAM)
! In  fieldIden        : identificator of field (name in results datastructure)
! In  fieldRefe        : name of a reference field if necessary
! In  fieldSupp        : cell support of field (NOEU, ELNO, ELEM, ...)
! In  nbEqua           : length of empiric mode
! In  mode_vectr       : singular vector for empiric mode (real)
! In  mode_vectc       : singular vector for empiric mode (complex)
! In  nume_slice       : index of slices (for lineic bases)
! In  mode_freq        : singular value for empiric mode
! In  nb_snap          : number of snapshots used to construct empiric base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nume_slice, nb_snap
    character(len=24) :: field
    real(kind=8) :: mode_freq
    real(kind=8), pointer :: v_field_r(:) => null()
    complex(kind=8), pointer :: v_field_c(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nume_slice = 0
    if (present(nume_slice_)) then
        nume_slice = nume_slice_
    endif
    mode_freq = 0.d0
    if (present(mode_freq_)) then
        mode_freq = mode_freq_
    endif
    nb_snap = 0
    if (present(nb_snap_)) then
        nb_snap = nb_snap_
    endif
!
! - Get current mode
!
    call rsexch(' ', base, fieldIden, iMode, field, iret)
    ASSERT(iret .eq. 100 .or. iret.eq.0 .or. iret .eq. 110)
    if (iret .eq. 110) then
        call rsagsd(base, 0)
        call rsexch(' ', base, fieldIden, iMode, field, iret)
        ASSERT(iret .eq. 100 .or. iret.eq.0)
    endif
    if (iret .eq. 100) then
        call copisd('CHAMP_GD', 'G', fieldRefe, field)
    endif
!
! - Access to current mode
!
    if (fieldSupp .eq. 'NOEU') then
        if (present(mode_vectc_)) then
            call jeveuo(field(1:19)//'.VALE', 'E', vc = v_field_c)
        else
            call jeveuo(field(1:19)//'.VALE', 'E', vr = v_field_r)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Save mode
!
    if (present(mode_vectc_)) then
        v_field_c(:) = mode_vectc_(1:nbEqua)
    else
        v_field_r(:) = mode_vectr_(1:nbEqua)
    endif
    call rsnoch(base, fieldIden, iMode)
!
! - Save parameters
!
    call romModeParaSave(base , iMode    ,&
                         model, fieldName, mode_freq, nume_slice, nb_snap)
!
end subroutine
