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

subroutine romMultiParaModeSave(ds_multipara, ds_empi,&
                                i_mode      , mode   )
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "blas/zdotc.h"
#include "blas/ddot.h"
#include "asterfort/jeveuo.h"
#include "asterfort/romModeSave.h"
#include "asterfort/romModeProd.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_MultiPara), intent(in) :: ds_multipara
    type(ROM_DS_Empi), intent(inout) :: ds_empi
    integer, intent(in) :: i_mode
    character(len=19), intent(in) :: mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save mode
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! IO  ds_empi          : datastructure for empiric modes
! In  i_mode           : index of empiric mode
! In  mode             : empiric mode to save
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8), pointer :: v_modec(:) => null()
    real(kind=8), pointer :: v_moder(:) => null()
    complex(kind=8) :: normc
    real(kind=8) :: normr
    character(len=8) :: base, model
    integer :: nb_equa
    character(len=24) :: field_name, field_refe, field_iden 
    character(len=1) :: syst_type
!
! --------------------------------------------------------------------------------------------------
!
    base           = ds_empi%base
    model          = ds_empi%model
    nb_equa        = ds_empi%nb_equa
    field_name     = ds_empi%field_name
    field_refe     = ds_empi%field_refe
    syst_type      = ds_multipara%syst_type
    field_iden     = 'DEPL'
!
! - Save mode
!
    if (syst_type .eq. 'C') then
        call jeveuo(mode(1:19)//'.VALE', 'E', vc = v_modec)
        normc = zdotc(nb_equa, v_modec, 1, v_modec, 1)
        v_modec(:) = v_modec(:)/sqrt(normc)
        call romModeSave(base       , i_mode    , model, &
                         field_name , field_iden, field_refe, nb_equa,&
                         mode_vectc_ = v_modec)
    elseif (syst_type .eq. 'R') then
        call jeveuo(mode(1:19)//'.VALE', 'E', vr = v_moder)
        normr = ddot(nb_equa, v_moder, 1, v_moder, 1)
        v_moder(:) = v_moder(:)/sqrt(normr) 
        call romModeSave(base       , i_mode    , model, &
                         field_name , field_iden, field_refe, nb_equa,&
                         mode_vectr_ = v_moder)
    else
        ASSERT(.false.)
    endif
!
    ds_empi%nb_mode = ds_empi%nb_mode + 1
!
end subroutine
