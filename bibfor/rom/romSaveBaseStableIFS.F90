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
subroutine romSaveBaseStableIFS(l_ortho_base, ds_multipara, ds_algoGreedy, ds_empi, i_mode)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/jeveuo.h"
#include "asterfort/copisd.h"
#include "asterfort/romNormalize.h"
#include "asterfort/romGreedyModeSave.h"
#include "asterfort/romOrthoBasis.h"
!
aster_logical, intent(in) :: l_ortho_base
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
type(ROM_DS_AlgoGreedy), intent(in) :: ds_algoGreedy
type(ROM_DS_Empi), intent(inout) :: ds_empi
integer, intent(in) :: i_mode
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE       : Save basis stabilised for IFS transient problem
!
! --------------------------------------------------------------------------------------------------
!
! In  l_ortho_base        : flag to orthogonalize basis
! In  ds_multipara        : datastructure for multiparametric problems
! In  ds_algoGreedy       : datastructure for Greedy algorithm
! IO  ds_empi             : datastructure for empiric modes
! In  i_mode              : .true. if first basis
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19)  :: base_1, base_2, base_3
    complex(kind=8), pointer :: vc_base_1(:) => null()
    complex(kind=8), pointer :: vc_base_2(:) => null()
    complex(kind=8), pointer :: vc_base_3(:) => null()
    complex(kind=8), pointer :: vc_syst_solu(:) => null()
    real(kind=8), pointer :: vr_base_1(:) => null()
    real(kind=8), pointer :: vr_base_2(:) => null()
    real(kind=8), pointer :: vr_base_3(:) => null()
    real(kind=8), pointer :: vr_syst_solu(:) => null()
    character(len=1)  :: syst_type
    integer :: i_equa, nb_equa, nume_pres, nume_phi
    type(ROM_DS_Field) :: field
    type(ROM_DS_Solve) :: ds_solve
!
! --------------------------------------------------------------------------------------------------
!
    field     = ds_multipara%field
    ds_solve  = ds_algoGreedy%solveDOM
    nume_pres = ds_algoGreedy%nume_pres
    nume_phi  = ds_algoGreedy%nume_phi
!    
! - Prepre 3 champs noeuds pour la base
!
    base_1   = '&&&OP0053.BASE_U'
    base_2   = '&&&OP0053.BASE_P'
    base_3   = '&&&OP0053.BASE_PHI'
    call copisd('CHAMP_GD', 'V', ds_solve%vect_zero, base_1)
    call copisd('CHAMP_GD', 'V', ds_solve%vect_zero, base_2)
    call copisd('CHAMP_GD', 'V', ds_solve%vect_zero, base_3)
!    
! - Remplir les .VALE
!
    syst_type = ds_solve%syst_type
    nb_equa   = ds_solve%syst_size
    if (syst_type .eq. 'R') then 
        call jeveuo(ds_solve%syst_solu//'.VALE', 'L', vr = vr_syst_solu) 
        call jeveuo(base_1(1:19)//'.VALE',       'E', vr = vr_base_1) 
        call jeveuo(base_2(1:19)//'.VALE',       'E', vr = vr_base_2) 
        call jeveuo(base_3(1:19)//'.VALE',       'E', vr = vr_base_3)
        vr_base_1(:) = 0.d0 
        vr_base_2(:) = 0.d0 
        vr_base_3(:) = 0.d0
        do i_equa = 1, nb_equa
            if (field%v_equa_type(i_equa) .eq. nume_pres) then
                vr_base_2(i_equa) = vr_syst_solu(i_equa)
            elseif (field%v_equa_type(i_equa) .eq. nume_phi) then
                vr_base_3(i_equa) = vr_syst_solu(i_equa)
            elseif (field%v_equa_type(i_equa) .gt. 0) then
                vr_base_1(i_equa) = vr_syst_solu(i_equa)
            else
                ASSERT(ASTER_FALSE)
            endif
        end do 
    else if (syst_type .eq. 'C') then 
        call jeveuo(ds_solve%syst_solu//'.VALE', 'L', vc = vc_syst_solu) 
        call jeveuo(base_1(1:19)//'.VALE',       'E', vc = vc_base_1) 
        call jeveuo(base_2(1:19)//'.VALE',       'E', vc = vc_base_2) 
        call jeveuo(base_3(1:19)//'.VALE',       'E', vc = vc_base_3)
        vc_base_1(:) = dcmplx(0.d0,0.d0)
        vc_base_2(:) = dcmplx(0.d0,0.d0)
        vc_base_3(:) = dcmplx(0.d0,0.d0)
        do i_equa = 1, nb_equa
            if (field%v_equa_type(i_equa) .eq. nume_pres) then
                vc_base_2(i_equa) = vc_syst_solu(i_equa)
            elseif (field%v_equa_type(i_equa) .eq. nume_phi) then
                vc_base_3(i_equa) = vc_syst_solu(i_equa)
            elseif (field%v_equa_type(i_equa) .gt. 0) then
                vc_base_1(i_equa) = vc_syst_solu(i_equa)
            else
                ASSERT(ASTER_FALSE)
            endif
        end do 
    else 
        ASSERT(ASTER_FALSE)
    end if
!
! - Normalization of basis
!
    call romNormalize(syst_type, base_1, nb_equa)
    call romNormalize(syst_type, base_2, nb_equa)
    call romNormalize(syst_type, base_3, nb_equa)
!
! - Orthogonalization of basis
!
    if (l_ortho_base) then
        call romOrthoBasis(ds_multipara, ds_empi, base_1)
        call romOrthoBasis(ds_multipara, ds_empi, base_2)
        call romOrthoBasis(ds_multipara, ds_empi, base_3)
    end if
!
! - Save basis
!
    call romGreedyModeSave(ds_multipara, ds_empi, 3*(i_mode-1)+1, base_1)
    call romGreedyModeSave(ds_multipara, ds_empi, 3*(i_mode-1)+2, base_2)
    call romGreedyModeSave(ds_multipara, ds_empi, 3*(i_mode-1)+3, base_3)
!
end subroutine
