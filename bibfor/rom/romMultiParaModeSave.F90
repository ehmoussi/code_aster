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
subroutine romMultiParaModeSave(ds_multipara, ds_empi,&
                                iMode       , mode   )
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
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
type(ROM_DS_Empi), intent(inout) :: ds_empi
integer, intent(in) :: iMode
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
! In  iMode            : index of empiric mode
! In  mode             : empiric mode to save
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8), pointer :: v_modec(:) => null()
    real(kind=8), pointer :: v_moder(:) => null()
    complex(kind=8) :: normc
    real(kind=8) :: normr
    character(len=8) :: base, model
    integer :: nbEqua
    character(len=24) :: fieldName, fieldRefe, fieldIden 
    character(len=1) :: syst_type
    character(len=4) :: fieldSupp
!
! --------------------------------------------------------------------------------------------------
!
    base      = ds_empi%base
    model     = ds_empi%ds_mode%model
    nbEqua    = ds_empi%ds_mode%nbEqua
    fieldName = ds_empi%ds_mode%fieldName
    fieldRefe = ds_empi%ds_mode%fieldRefe
    fieldSupp = ds_empi%ds_mode%fieldSupp
    syst_type = ds_multipara%syst_type
    fieldIden = 'DEPL'
    ASSERT(fieldSupp .eq. 'NOEU')
!
! - Save mode
!
    if (syst_type .eq. 'C') then
        call jeveuo(mode(1:19)//'.VALE', 'E', vc = v_modec)
        normc = zdotc(nbEqua, v_modec, 1, v_modec, 1)
        v_modec(:) = v_modec(:)/sqrt(normc)
        call romModeSave(base     , iMode    , model ,&
                         fieldName, fieldIden,&
                         fieldRefe, fieldSupp, nbEqua,&
                         mode_vectc_ = v_modec)
    elseif (syst_type .eq. 'R') then
        call jeveuo(mode(1:19)//'.VALE', 'E', vr = v_moder)
        normr = ddot(nbEqua, v_moder, 1, v_moder, 1)
        v_moder(:) = v_moder(:)/sqrt(normr) 
        call romModeSave(base     , iMode    , model ,&
                         fieldName, fieldIden,&
                         fieldRefe, fieldSupp, nbEqua,&
                         mode_vectr_ = v_moder)
    else
        ASSERT(ASTER_FALSE)
    endif
!
    ds_empi%nb_mode = ds_empi%nb_mode + 1
!
end subroutine
