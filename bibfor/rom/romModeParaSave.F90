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
subroutine romModeParaSave(base , i_mode    ,&
                           model, field_name, mode_freq, nume_slice, nb_snap)
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
character(len=8), intent(in)  :: model
character(len=24), intent(in) :: field_name
integer, intent(in)           :: nume_slice
real(kind=8), intent(in)      :: mode_freq
integer, intent(in)           :: nb_snap
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save parameters for empiric mode
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! In  i_mode           : index of empiric modes
! In  model            : name of model
! In  field_name       : name of field where empiric modes have been constructed (NOM_CHAM)
! In  nume_slice       : index of slices (for lineic bases)
! In  mode_freq        : singular value for empiric mode
! In  nb_snap          : number of snapshots used to construct empiric base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jv_para
!
! --------------------------------------------------------------------------------------------------
!
    call rsadpa(base, 'E', 1, 'NUME_MODE', i_mode, 0, sjv=jv_para)
    zi(jv_para)   = i_mode
    call rsadpa(base, 'E', 1, 'NUME_PLAN', i_mode, 0, sjv=jv_para)
    zi(jv_para)   = nume_slice
    call rsadpa(base, 'E', 1, 'FREQ', i_mode, 0, sjv=jv_para)
    zr(jv_para)   = mode_freq
    call rsadpa(base, 'E', 1, 'NB_SNAP', i_mode, 0, sjv=jv_para)
    zi(jv_para)   = nb_snap
    call rsadpa(base, 'E', 1, 'MODELE', i_mode, 0, sjv=jv_para)
    zk8(jv_para)  = model
    call rsadpa(base, 'E', 1, 'NOM_CHAM', i_mode, 0, sjv=jv_para)
    zk24(jv_para) = field_name
!
end subroutine
