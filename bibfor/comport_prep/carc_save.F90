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
subroutine carc_save(mesh, carcri, nb_cmp, ds_compor_para)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lcdiscard.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/comp_read_mesh.h"
#include "asterfort/comp_meca_code.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/exicp.h"
#include "asterfort/getBehaviourAlgo.h"
#include "asterfort/getBehaviourPara.h"
#include "asterfort/getExternalBehaviourPntr.h"
#include "asterfort/setMFrontPara.h"
#include "asterfort/getExternalStateVariable.h"
#include "asterfort/getExternalStrainModel.h"
!
character(len=8), intent(in) :: mesh
character(len=19), intent(in) :: carcri
integer, intent(in) :: nb_cmp
type(Behaviour_PrepCrit), intent(in) :: ds_compor_para
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Save informations in <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  carcri           : name of <CARTE> CARCRI
! In  nb_cmp           : number of components in <CARTE> CARCRI
! In  ds_compor_para   : datastructure to prepare parameters for constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: list_elem_affe
    aster_logical :: l_affe_all, l_matr_unsymm
    integer :: nb_elem_affe
    integer, pointer :: v_elem_affe(:) => null()
    character(len=16) :: keywordfact
    integer :: i_comp, nb_comp, iveriborne
    real(kind=8), pointer :: p_carc_valv(:) => null()
    real(kind=8) :: iter_inte_maxi, resi_inte_rela, parm_theta, vale_pert_rela, algo_inte_r
    real(kind=8) :: resi_deborst_max, resi_radi_rela
    real(kind=8) :: post_iter, post_incr
    real(kind=8) :: parm_theta_thm, parm_alpha_thm
    integer :: type_matr_t, iter_inte_pas, iter_deborst_max
    integer :: cptr_nbvarext=0, cptr_namevarext=0, cptr_fct_ldc=0
    integer :: cptr_nameprop=0, cptr_nbprop=0
    integer :: jvariext1 = 0, jstrainexte = 0
    type(Behaviour_External) :: comp_exte
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact    = 'COMPORTEMENT'
    nb_comp        = ds_compor_para%nb_comp
    list_elem_affe = '&&CARCSAVE.LIST'
!
! - Access to <CARTE>
!
    call jeveuo(carcri//'.VALV', 'E', vr = p_carc_valv)
!
! - Get SCHEMA_THM
!
    parm_theta_thm = ds_compor_para%parm_theta_thm
    parm_alpha_thm = ds_compor_para%parm_alpha_thm
!
! - Loop on occurrences of COMPORTEMENT
!
    do i_comp = 1, nb_comp
!
! ----- Get infos
!
        type_matr_t      = ds_compor_para%v_para(i_comp)%type_matr_t
        parm_theta       = ds_compor_para%v_para(i_comp)%parm_theta
        iter_inte_pas    = ds_compor_para%v_para(i_comp)%iter_inte_pas
        vale_pert_rela   = ds_compor_para%v_para(i_comp)%vale_pert_rela
        resi_deborst_max = ds_compor_para%v_para(i_comp)%resi_deborst_max
        iter_deborst_max = ds_compor_para%v_para(i_comp)%iter_deborst_max
        resi_radi_rela   = ds_compor_para%v_para(i_comp)%resi_radi_rela
        post_iter        = ds_compor_para%v_para(i_comp)%ipostiter
        post_incr        = ds_compor_para%v_para(i_comp)%ipostincr
        iveriborne       = ds_compor_para%v_para(i_comp)%iveriborne
        l_matr_unsymm    = ds_compor_para%v_para(i_comp)%l_matr_unsymm
        algo_inte_r      = ds_compor_para%v_para(i_comp)%algo_inte_r
        resi_inte_rela   = ds_compor_para%v_para(i_comp)%resi_inte_rela
        iter_inte_maxi   = ds_compor_para%v_para(i_comp)%iter_inte_maxi
        cptr_fct_ldc     = ds_compor_para%v_para(i_comp)%cptr_fct_ldc
        cptr_nbvarext    = ds_compor_para%v_para(i_comp)%cptr_nbvarext
        cptr_namevarext  = ds_compor_para%v_para(i_comp)%cptr_namevarext
        cptr_nbprop      = ds_compor_para%v_para(i_comp)%cptr_nbprop
        cptr_nameprop    = ds_compor_para%v_para(i_comp)%cptr_nameprop
        jvariext1        = ds_compor_para%v_para(i_comp)%jvariext1
        jstrainexte      = ds_compor_para%v_para(i_comp)%jstrainexte
        comp_exte        = ds_compor_para%v_para(i_comp)%comp_exte
!
! ----- Get list of elements where comportment is defined
!
        call comp_read_mesh(mesh          , keywordfact, i_comp      ,&
                            list_elem_affe, l_affe_all , nb_elem_affe)
!
! ----- Set values for MFRONT
!
        call setMFrontPara(comp_exte, iter_inte_maxi, resi_inte_rela, iveriborne)
!
! ----- Set in <CARTE>
!
        p_carc_valv(1)              = iter_inte_maxi
        p_carc_valv(2)              = type_matr_t
        p_carc_valv(3)              = resi_inte_rela
        p_carc_valv(4)              = parm_theta
        p_carc_valv(5)              = iter_inte_pas
        p_carc_valv(6)              = algo_inte_r
        p_carc_valv(7)              = vale_pert_rela
        p_carc_valv(8)              = resi_deborst_max
        p_carc_valv(9)              = iter_deborst_max
        p_carc_valv(10)             = resi_radi_rela
        p_carc_valv(IVARIEXT1)      = jvariext1
        p_carc_valv(PARM_THETA_THM) = parm_theta_thm
        p_carc_valv(13)             = post_iter
        p_carc_valv(14)             = cptr_nbvarext
        p_carc_valv(15)             = cptr_namevarext
        p_carc_valv(16)             = cptr_fct_ldc
        if (l_matr_unsymm) then
            p_carc_valv(17) = 1
        else
            p_carc_valv(17) = 0
        endif
        p_carc_valv(PARM_ALPHA_THM) = parm_alpha_thm
        p_carc_valv(19)             = cptr_nameprop
        p_carc_valv(20)             = cptr_nbprop
        p_carc_valv(21)             = post_incr
        p_carc_valv(ISTRAINEXTE)    = jstrainexte
!
! ----- Affect in <CARTE>
!
        if (l_affe_all) then
            call nocart(carcri, 1, nb_cmp)
        else
            call jeveuo(list_elem_affe, 'L', vi = v_elem_affe)
            call nocart(carcri, 3, nb_cmp, mode = 'NUM', nma = nb_elem_affe,&
                        limanu = v_elem_affe)
            call jedetr(list_elem_affe)
        endif

    enddo
!
    call jedetr(carcri//'.NCMP')
!
end subroutine
