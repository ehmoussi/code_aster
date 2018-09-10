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
subroutine romBaseSave(ds_empi      , nb_mode, nb_snap, mode_type, field_iden,&
                       mode_vectr_  ,&
                       mode_vectc_  ,&
                       v_mode_freq_ ,&
                       v_nume_slice_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romModeSave.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
integer, intent(in) :: nb_mode
integer, intent(in) :: nb_snap
character(len=1), intent(in) :: mode_type
character(len=24), intent(in) :: field_iden
real(kind=8), optional, pointer :: mode_vectr_(:)
complex(kind=8), optional, pointer :: mode_vectc_(:)
real(kind=8), optional, pointer :: v_mode_freq_(:)
integer, optional, pointer      :: v_nume_slice_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save empiric base
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! In  nb_mode          : number of empiric modes
! In  nb_snap          : number of snapshots used to construct empiric base
! In  mode_type        : type of mode (real or complex, 'R' ou 'C')
! In  field_iden       : identificator of field (name in results datastructure)
! In  mode_vectr       : singular vectors (R)
! In  mode_vectc       : singular vectors (C)
! In  v_mode_freq      : singular values
! In  v_nume_slice     : index of slices (for lineic bases)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_mode
    integer :: nb_equa = 0, nume_slice
    real(kind=8) :: mode_freq
    character(len=8)  :: base = ' ', model = ' '
    character(len=24) :: field_refe = ' ', field_name = ' '
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_2', si = nb_mode)
    endif
!
! - Initializations
!
    nume_slice = 0
    mode_freq  = 0.d0
!
! - Get parameters
!
    base         = ds_empi%base
    nb_equa      = ds_empi%ds_mode%nb_equa
    field_name   = ds_empi%ds_mode%field_name
    field_refe   = ds_empi%ds_mode%field_refe
    model        = ds_empi%ds_mode%model
!
! - Save modes
!
    do i_mode = 1, nb_mode
        if (present(v_nume_slice_)) then
            nume_slice = v_nume_slice_(i_mode)
        endif
        if (present(v_mode_freq_)) then
            mode_freq  = v_mode_freq_(i_mode)
        endif
        if (mode_type.eq.'R') then
            call romModeSave(base                , i_mode    , model  ,&
                             field_name, field_iden, field_refe, nb_equa,&
                             mode_vectr_   = mode_vectr_(nb_equa*(i_mode-1)+1:),&
                             mode_freq_    = mode_freq   ,&
                             nume_slice_   = nume_slice  ,&
                             nb_snap_      = nb_snap)
        elseif (mode_type.eq.'C') then
            call romModeSave(base      , i_mode    , model     ,&
                             field_name, field_iden, field_refe, nb_equa,&
                             mode_vectc_ = mode_vectc_(nb_equa*(i_mode-1)+1:),&
                             mode_freq_    = mode_freq   ,&
                             nume_slice_   = nume_slice  ,&
                             nb_snap_      = nb_snap)
        else
            ASSERT(.false.)
        endif
    end do
!
end subroutine
