! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine romGreedyModeSave(ds_multipara, ds_empi,&
                             i_mode      , mode )
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/romMultiParaModeSave.h"
#include "asterfort/romMatrixProdMode.h"
#include "asterfort/romCalcVectReduit.h"
#include "asterfort/romCalcMatrReduit.h"
#include "asterfort/jeveuo.h"
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
type(ROM_DS_Empi), intent(inout)   :: ds_empi
integer, intent(in)                :: i_mode
character(len=19), intent(in)      :: mode
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Save empiric modes
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
    integer :: ifm, niv
    character(len=1) :: syst_type
    complex(kind=8), pointer :: vc_mode(:) => null()
    real(kind=8), pointer :: vr_mode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_64')
    endif
!
! - Save mode
!
    call romMultiParaModeSave(ds_multipara, ds_empi,&
                              i_mode      , mode)
!
! - Compute products
!
    syst_type = ds_multipara%syst_type
    if (syst_type .eq. 'R') then 
! ---- Get acess to mode
       call jeveuo(mode(1:19)//'.VALE', 'L', vr = vr_mode)
! ---- Compute Matrix x Mode
       call romMatrixProdMode(ds_multipara%nb_matr  ,&
                              ds_multipara%matr_name,&
                              ds_multipara%matr_type,&
                              ds_multipara%matr_mode_curr,&
                              ds_multipara%prod_matr_mode,&
                              i_mode,&
                              'R' , vr_mode = vr_mode)
! ---- Compute reduced vector
       call romCalcVectReduit(i_mode,&
                              ds_empi%ds_mode%nb_equa,&
                              ds_multipara%vect_name,&
                              ds_multipara%vect_type,&
                              ds_multipara%vect_redu,&
                              'R' , vr_mode = vr_mode)
! ---- Compute reduced matrix 
       call romCalcMatrReduit(i_mode,  &
                              ds_empi ,&
                              ds_multipara%nb_matr   ,&
                              ds_multipara%prod_matr_mode,&
                              ds_multipara%matr_redu,&
                              'R')
    else if (syst_type .eq. 'C') then
! ---- Get acess to mode
       call jeveuo(mode(1:19)//'.VALE', 'L', vc = vc_mode)
! ---- Compute Matrix x Mode
       call romMatrixProdMode(ds_multipara%nb_matr  ,&
                              ds_multipara%matr_name,&
                              ds_multipara%matr_type,&
                              ds_multipara%matr_mode_curr,&
                              ds_multipara%prod_matr_mode,&
                              i_mode,&
                              'C' , vc_mode = vc_mode)
! ---- Compute reduced vector
       call romCalcVectReduit(i_mode,&
                              ds_empi%ds_mode%nb_equa,&
                              ds_multipara%vect_name ,&
                              ds_multipara%vect_type ,&
                              ds_multipara%vect_redu,&
                              'C' , vc_mode = vc_mode)
! ---- Compute reduced matrix
       call romCalcMatrReduit(i_mode,  &
                              ds_empi ,&
                              ds_multipara%nb_matr   ,&
                              ds_multipara%prod_matr_mode,&
                              ds_multipara%matr_redu,&
                              'C') 
    else 
        ASSERT(ASTER_FALSE)
    end if 
!
end subroutine
