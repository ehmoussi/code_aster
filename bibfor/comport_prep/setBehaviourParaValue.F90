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
subroutine setBehaviourParaValue(v_crit       , parm_theta_thm, parm_alpha_thm,&
                                 hho_coef_stab, hho_type_stab , hho_type_calc ,&
                                 i_comp_      , l_carcri_     , v_carcri_)
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
type(Behaviour_Crit), pointer :: v_crit(:)
real(kind=8), intent(in) :: parm_theta_thm, parm_alpha_thm
real(kind=8), intent(in) :: hho_coef_stab, hho_type_stab, hho_type_calc
integer, optional, intent(in) :: i_comp_
real(kind=8), intent(out), optional :: l_carcri_(:)
real(kind=8), pointer, optional :: v_carcri_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of behaviour (mechanics)
!
! Save informations in the field <CARCRI>
!
! --------------------------------------------------------------------------------------------------
!
! In  v_crit           : list of informations to save
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
        v_carcri_(1)                  = v_crit(i_comp)%iter_inte_maxi
        v_carcri_(2)                  = v_crit(i_comp)%type_matr_t
        v_carcri_(3)                  = v_crit(i_comp)%resi_inte_rela
        v_carcri_(4)                  = v_crit(i_comp)%parm_theta
        v_carcri_(5)                  = v_crit(i_comp)%iter_inte_pas
        v_carcri_(6)                  = v_crit(i_comp)%algo_inte_r
        v_carcri_(7)                  = v_crit(i_comp)%vale_pert_rela
        v_carcri_(8)                  = v_crit(i_comp)%resi_deborst_max
        v_carcri_(9)                  = v_crit(i_comp)%iter_deborst_max
        v_carcri_(10)                 = v_crit(i_comp)%resi_radi_rela
        v_carcri_(IVARIEXT1)          = v_crit(i_comp)%jvariext1
        v_carcri_(IVARIEXT2)          = v_crit(i_comp)%jvariext2
        v_carcri_(PARM_THETA_THM)     = parm_theta_thm
        v_carcri_(PARM_ALPHA_THM)     = parm_alpha_thm
        v_carcri_(13)                 = v_crit(i_comp)%ipostiter
        if (v_crit(i_comp)%l_matr_unsymm) then
            v_carcri_(17) = 1
        else
            v_carcri_(17) = 0
        endif
        v_carcri_(21)                 = v_crit(i_comp)%ipostincr
! ----- For external solvers (UMAT / MFRONT)
        v_carcri_(EXTE_PTR)           = v_crit(i_comp)%cptr_fct_ldc
        v_carcri_(EXTE_STRAIN)        = v_crit(i_comp)%exte_strain
        v_carcri_(EXTE_ESVA_NB)       = v_crit(i_comp)%cptr_nbvarext
        v_carcri_(EXTE_ESVA_PTR_NAME) = v_crit(i_comp)%cptr_namevarext
        v_carcri_(EXTE_PROP_NB)       = v_crit(i_comp)%cptr_nameprop
        v_carcri_(EXTE_PROP_PTR_NAME) = v_crit(i_comp)%cptr_nbprop
! ----- For HHO
        v_carcri_(HHO_COEF)           = hho_coef_stab
        v_carcri_(HHO_STAB)           = hho_type_stab
        v_carcri_(HHO_CALC)           = hho_type_calc
    endif
    if (present(l_carcri_)) then
        l_carcri_(1)                  = v_crit(i_comp)%iter_inte_maxi
        l_carcri_(2)                  = v_crit(i_comp)%type_matr_t
        l_carcri_(3)                  = v_crit(i_comp)%resi_inte_rela
        l_carcri_(4)                  = v_crit(i_comp)%parm_theta
        l_carcri_(5)                  = v_crit(i_comp)%iter_inte_pas
        l_carcri_(6)                  = v_crit(i_comp)%algo_inte_r
        l_carcri_(7)                  = v_crit(i_comp)%vale_pert_rela
        l_carcri_(8)                  = v_crit(i_comp)%resi_deborst_max
        l_carcri_(9)                  = v_crit(i_comp)%iter_deborst_max
        l_carcri_(10)                 = v_crit(i_comp)%resi_radi_rela
        l_carcri_(IVARIEXT1)          = v_crit(i_comp)%jvariext1
        l_carcri_(IVARIEXT2)          = v_crit(i_comp)%jvariext2
        l_carcri_(PARM_THETA_THM)     = parm_theta_thm
        l_carcri_(PARM_ALPHA_THM)     = parm_alpha_thm
        l_carcri_(13)                 = v_crit(i_comp)%ipostiter
        if (v_crit(i_comp)%l_matr_unsymm) then
            l_carcri_(17) = 1
        else
            l_carcri_(17) = 0
        endif
        l_carcri_(21)                 = v_crit(i_comp)%ipostincr
! ----- For external solvers (UMAT / MFRONT)
        l_carcri_(EXTE_PTR)           = v_crit(i_comp)%cptr_fct_ldc
        l_carcri_(EXTE_STRAIN)        = v_crit(i_comp)%exte_strain
        l_carcri_(EXTE_ESVA_NB)       = v_crit(i_comp)%cptr_nbvarext
        l_carcri_(EXTE_ESVA_PTR_NAME) = v_crit(i_comp)%cptr_namevarext
        l_carcri_(EXTE_PROP_NB)       = v_crit(i_comp)%cptr_nameprop
        l_carcri_(EXTE_PROP_PTR_NAME) = v_crit(i_comp)%cptr_nbprop
! ----- For HHO
        l_carcri_(HHO_COEF)           = hho_coef_stab
        l_carcri_(HHO_STAB)           = hho_type_stab
        l_carcri_(HHO_CALC)           = hho_type_calc
    endif
!
! - Set values for MFRONT
!
    call setMFrontPara(v_crit, i_comp)
!
end subroutine
