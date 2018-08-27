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
subroutine romMultiParaProdModeSave(ds_multipara, ds_empi   ,&
                                    i_mode      )
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/romModeSave.h"
#include "asterfort/jeveuo.h"
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
type(ROM_DS_Empi), intent(in) :: ds_empi
integer, intent(in) :: i_mode
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save products matrix x mode
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! In  ds_empi          : datastructure for empiric modes
! In  i_mode           : index of empiric mode
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: base, model
    integer :: nb_equa, nb_matr, i_matr
    character(len=24) :: field_name = ' ', field_iden_prod, field_refe
    character(len=1) :: syst_type, nume_prod, matr_type
    character(len=8) :: matr_name
    complex(kind=8), pointer :: v_prodc(:) => null()
    real(kind=8), pointer :: v_prodr(:) => null()
    integer :: jv_desc_matr
!
! --------------------------------------------------------------------------------------------------
!
    base           = ds_empi%base
    model          = ds_empi%ds_mode%model
    nb_equa        = ds_empi%ds_mode%nb_equa
    field_name     = ds_empi%ds_mode%field_name
    field_refe     = ds_empi%ds_mode%field_refe
    syst_type      = ds_multipara%syst_type
    nb_matr        = ds_multipara%nb_matr
!
! - Save them
!  
    do i_matr = 1, nb_matr
        matr_name = ds_multipara%matr_name(i_matr)
        matr_type = ds_multipara%matr_type(i_matr)
        call jeveuo(matr_name(1:8)//'           .&INT', 'L', jv_desc_matr)
        write(nume_prod,'(I1)') i_matr
        field_iden_prod = 'PROD_BASE_MATR_'//nume_prod
        if (matr_type .eq. 'C') then
            if (syst_type .eq. 'C') then
                call jeveuo(ds_multipara%prod_mode(i_matr)(1:19)//'.VALE', 'L',&
                            vc = v_prodc)
                call romModeSave(base      , i_mode         , model     ,&
                                 field_name, field_iden_prod, field_refe, nb_equa,&
                                 mode_vectc_ = v_prodc)
            elseif (syst_type .eq. 'R') then
                call jeveuo(ds_multipara%prod_mode(i_matr)(1:19)//'.VALE', 'L',&
                            vr = v_prodr)
                call romModeSave(base      , i_mode         , model     ,&
                                 field_name, field_iden_prod, field_refe, nb_equa,&
                                 mode_vectc_ = v_prodc)
            else
                ASSERT(.false.)
            endif
        elseif (matr_type .eq. 'R') then
            if (syst_type .eq. 'C') then
                call jeveuo(ds_multipara%prod_mode(i_matr)(1:19)//'.VALE', 'L',&
                            vc = v_prodc)
                call romModeSave(base      , i_mode         , model     ,&
                                 field_name, field_iden_prod, field_refe, nb_equa,&
                                 mode_vectc_ = v_prodc)
            elseif (syst_type .eq. 'R') then
                call jeveuo(ds_multipara%prod_mode(i_matr)(1:19)//'.VALE', 'L', vr =&
                            v_prodr)
                call romModeSave(base      , i_mode         , model     ,&
                                 field_name, field_iden_prod, field_refe, nb_equa,&
                                 mode_vectr_ = v_prodr)
            else
                ASSERT(.false.)
            endif
        endif
    end do
!
end subroutine
