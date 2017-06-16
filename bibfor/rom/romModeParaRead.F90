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
subroutine romModeParaRead(base  , i_mode     ,&
                           model_, field_name_, mode_freq_, nume_slice_, nb_snap_)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
!
character(len=8), intent(in) :: base
integer, intent(in) :: i_mode
character(len=8), optional, intent(out)  :: model_
character(len=24), optional, intent(out) :: field_name_
integer, optional, intent(out)           :: nume_slice_
real(kind=8), optional, intent(out)      :: mode_freq_
integer, optional, intent(out)           :: nb_snap_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Read parameters for empiric mode
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! In  i_mode           : index of empiric modes
! Out model            : name of model
! Out field_name       : name of field where empiric modes have been constructed (NOM_CHAM)
! Out nume_slice       : index of slices (for lineic bases)
! Out mode_freq        : singular value for empiric mode
! Out nb_snap          : number of snapshots used to construct empiric base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_para
    integer :: nume_slice, nb_snap
    character(len=24) :: field_name
    real(kind=8) :: mode_freq
    character(len=8) :: model
!
! --------------------------------------------------------------------------------------------------
!
    call rsadpa(base, 'L', 1, 'NUME_PLAN', i_mode, 0, sjv=jv_para)
    nume_slice = zi(jv_para)
    call rsadpa(base, 'L', 1, 'FREQ', i_mode, 0, sjv=jv_para)
    mode_freq  = zr(jv_para)
    call rsadpa(base, 'L', 1, 'NB_SNAP', i_mode, 0, sjv=jv_para)
    nb_snap    = zi(jv_para)
    call rsadpa(base, 'L', 1, 'MODELE', i_mode, 0, sjv=jv_para)
    model      = zk8(jv_para)
    call rsadpa(base, 'L', 1, 'NOM_CHAM', i_mode, 0, sjv=jv_para)
    field_name = zk24(jv_para)
!
    if (present(nume_slice_)) then
        nume_slice_ = nume_slice
    endif
    if (present(mode_freq_)) then
        mode_freq_ = mode_freq
    endif
    if (present(nb_snap_)) then
        nb_snap_ = nb_snap
    endif
    if (present(model_)) then
        model_ = model
    endif
    if (present(field_name_)) then
        field_name_ = field_name
    endif
!
end subroutine
