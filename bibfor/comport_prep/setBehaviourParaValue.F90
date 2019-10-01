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
subroutine setBehaviourParaValue(v_para , ds_compor_para, &
                                 i_comp_, l_carcri_     , v_carcri_)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/setMFrontPara.h"
!
type(Behaviour_PrepCrit), intent(in) :: ds_compor_para
type(Behaviour_Criteria), pointer :: v_para(:)
integer, optional, intent(in) :: i_comp_
real(kind=8), intent(out), optional :: l_carcri_(:)
real(kind=8), pointer, optional :: v_carcri_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Save informations in the field <CARCRI>
!
! --------------------------------------------------------------------------------------------------
!
! In  v_para           : list of informations to save
! In  i_comp           : index in previous list
! In  l_carcri         : liste of components for <CARTE> CARCRI - (SIMU_POIN_MAT)
! In  v_carcri         : liste of components for <CARTE> CARCRI - (*_NON_LINE)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_comp
!
! --------------------------------------------------------------------------------------------------
!
    i_comp = 1
    if (present(i_comp_)) then
        i_comp = i_comp_
    endif
!
    if (present(v_carcri_)) then
        v_carcri_(1)              = v_para(i_comp)%iter_inte_maxi
        v_carcri_(2)              = v_para(i_comp)%type_matr_t
        v_carcri_(3)              = v_para(i_comp)%resi_inte_rela
        v_carcri_(4)              = v_para(i_comp)%parm_theta
        v_carcri_(5)              = v_para(i_comp)%iter_inte_pas
        v_carcri_(6)              = v_para(i_comp)%algo_inte_r
        v_carcri_(7)              = v_para(i_comp)%vale_pert_rela
        v_carcri_(8)              = v_para(i_comp)%resi_deborst_max
        v_carcri_(9)              = v_para(i_comp)%iter_deborst_max
        v_carcri_(10)             = v_para(i_comp)%resi_radi_rela
        v_carcri_(IVARIEXT1)      = v_para(i_comp)%jvariext1
        v_carcri_(IVARIEXT2)      = v_para(i_comp)%jvariext2
        v_carcri_(PARM_THETA_THM) = ds_compor_para%parm_theta_thm
        v_carcri_(13)             = v_para(i_comp)%ipostiter
        v_carcri_(14)             = v_para(i_comp)%cptr_nbvarext
        v_carcri_(15)             = v_para(i_comp)%cptr_namevarext
        v_carcri_(16)             = v_para(i_comp)%cptr_fct_ldc
        if (v_para(i_comp)%l_matr_unsymm) then
            v_carcri_(17) = 1
        else
            v_carcri_(17) = 0
        endif
        v_carcri_(PARM_ALPHA_THM) = ds_compor_para%parm_alpha_thm
        v_carcri_(19)             = v_para(i_comp)%cptr_nameprop
        v_carcri_(20)             = v_para(i_comp)%cptr_nbprop
        v_carcri_(21)             = v_para(i_comp)%ipostincr
        v_carcri_(ISTRAINEXTE)    = v_para(i_comp)%jstrainexte
        v_carcri_(HHO_COEF)       = ds_compor_para%hho_coef_stab
        v_carcri_(HHO_STAB)       = ds_compor_para%hho_type_stab
        v_carcri_(HHO_CALC)       = ds_compor_para%hho_type_calc
    endif
    if (present(l_carcri_)) then
        l_carcri_(1)              = v_para(i_comp)%iter_inte_maxi
        l_carcri_(2)              = v_para(i_comp)%type_matr_t
        l_carcri_(3)              = v_para(i_comp)%resi_inte_rela
        l_carcri_(4)              = v_para(i_comp)%parm_theta
        l_carcri_(5)              = v_para(i_comp)%iter_inte_pas
        l_carcri_(6)              = v_para(i_comp)%algo_inte_r
        l_carcri_(7)              = v_para(i_comp)%vale_pert_rela
        l_carcri_(8)              = v_para(i_comp)%resi_deborst_max
        l_carcri_(9)              = v_para(i_comp)%iter_deborst_max
        l_carcri_(10)             = v_para(i_comp)%resi_radi_rela
        l_carcri_(IVARIEXT1)      = v_para(i_comp)%jvariext1
        l_carcri_(IVARIEXT2)      = v_para(i_comp)%jvariext2
        l_carcri_(PARM_THETA_THM) = ds_compor_para%parm_theta_thm
        l_carcri_(13)             = v_para(i_comp)%ipostiter
        l_carcri_(14)             = v_para(i_comp)%cptr_nbvarext
        l_carcri_(15)             = v_para(i_comp)%cptr_namevarext
        l_carcri_(16)             = v_para(i_comp)%cptr_fct_ldc
        if (v_para(i_comp)%l_matr_unsymm) then
            l_carcri_(17) = 1
        else
            l_carcri_(17) = 0
        endif
        l_carcri_(PARM_ALPHA_THM) = ds_compor_para%parm_alpha_thm
        l_carcri_(19)             = v_para(i_comp)%cptr_nameprop
        l_carcri_(20)             = v_para(i_comp)%cptr_nbprop
        l_carcri_(21)             = v_para(i_comp)%ipostincr
        l_carcri_(ISTRAINEXTE)    = v_para(i_comp)%jstrainexte
        l_carcri_(HHO_COEF)       = ds_compor_para%hho_coef_stab
        l_carcri_(HHO_STAB)       = ds_compor_para%hho_type_stab
        l_carcri_(HHO_CALC)       = ds_compor_para%hho_type_calc
    endif
!
! - Set values for MFRONT
!
    call setMFrontPara(v_para, i_comp)
!
end subroutine
