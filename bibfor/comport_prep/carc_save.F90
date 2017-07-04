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
subroutine carc_save(model, mesh, carcri, nb_cmp, ds_compor_para)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lcdiscard.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/comp_read_mesh.h"
#include "asterfort/comp_meca_code.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/exicp.h"
#include "asterfort/utmess.h"
#include "asterfort/getBehaviourAlgo.h"
#include "asterfort/getBehaviourPara.h"
#include "asterfort/getExternalBehaviourPntr.h"
#include "asterfort/setMFrontPara.h"
#include "asterfort/getExternalStateVariable.h"
!
character(len=8), intent(in) :: model
character(len=8), intent(in) :: mesh
character(len=19), intent(in) :: carcri
integer, intent(in) :: nb_cmp
type(NL_DS_ComporParaPrep), intent(in) :: ds_compor_para
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
! In  model            : name of model
! In  carcri           : name of <CARTE> CARCRI
! In  nb_cmp           : number of components in <CARTE> CARCRI
! In  ds_compor_para   : datastructure to prepare parameters for constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: list_elem_affe
    aster_logical :: l_affe_all, l_matr_unsymm, l_comp_external
    integer :: nb_elem_affe
    integer, pointer :: v_elem_affe(:) => null()
    character(len=16) :: keywordfact
    integer :: i_comp, nb_comp, iveriborne
    real(kind=8), pointer :: p_carc_valv(:) => null()
    character(len=16) :: algo_inte, rela_comp, meca_comp, defo_comp
    real(kind=8) :: iter_inte_maxi, resi_inte_rela, parm_theta, vale_pert_rela, algo_inte_r
    real(kind=8) :: resi_deborst_max, resi_radi_rela, parm_alpha
    real(kind=8) :: post_iter, post_incr
    integer :: type_matr_t, iter_inte_pas, iter_deborst_max
    aster_logical :: plane_stress, l_mfront_proto, l_mfront_offi, l_kit_thm
    integer :: cptr_nbvarext=0, cptr_namevarext=0, cptr_fct_ldc=0
    integer :: cptr_nameprop=0, cptr_nbprop=0
    character(len=16) :: kit_comp(4) = (/'VIDE','VIDE','VIDE','VIDE'/)
    character(len=16) :: rela_code_py=' ', defo_code_py=' ', meca_code_py=' ', comp_code_py=' '
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
        parm_alpha       = ds_compor_para%v_para(i_comp)%parm_alpha
        post_incr        = ds_compor_para%v_para(i_comp)%ipostincr
        iveriborne       = ds_compor_para%v_para(i_comp)%iveriborne
        rela_comp        = ds_compor_para%v_para(i_comp)%rela_comp
        meca_comp        = ds_compor_para%v_para(i_comp)%meca_comp
        defo_comp        = ds_compor_para%v_para(i_comp)%defo_comp
        kit_comp         = ds_compor_para%v_para(i_comp)%kit_comp
        l_matr_unsymm    = ds_compor_para%v_para(i_comp)%l_matr_unsymm
        l_comp_external  = ds_compor_para%v_para(i_comp)%l_comp_external
!
! ----- Detection of specific cases
!
        call comp_meca_l(rela_comp, 'KIT_THM'     , l_kit_thm)
        call comp_meca_l(rela_comp, 'MFRONT_PROTO', l_mfront_proto)
        call comp_meca_l(rela_comp, 'MFRONT_OFFI' , l_mfront_offi)
!
! ----- Coding comportment (Python)
!
        call comp_meca_code(rela_comp_    = rela_comp   ,&
                            defo_comp_    = defo_comp   ,&
                            kit_comp_     = kit_comp    ,&
                            meca_comp_    = meca_comp   ,&
                            comp_code_py_ = comp_code_py,&
                            rela_code_py_ = rela_code_py,&
                            defo_code_py_ = defo_code_py,&
                            meca_code_py_ = meca_code_py)
!
! ----- Ban if RELATION = MFRONT and ITER_INTE_PAS negative
!
        if (iter_inte_pas .lt. 0.d0) then
            if (l_mfront_offi .or. l_mfront_proto) then
                call utmess('F', 'COMPOR1_95')
            end if
        end if
!
! ----- Get list of elements where comportment is defined
!
        call comp_read_mesh(mesh          , keywordfact, i_comp      ,&
                            list_elem_affe, l_affe_all , nb_elem_affe)
        plane_stress = exicp(model, l_affe_all, list_elem_affe, nb_elem_affe)
!
! ----- Get ALGO_INTE
!
        call getBehaviourAlgo(plane_stress, rela_comp   ,&
                              rela_code_py, meca_code_py,&
                              keywordfact , i_comp      ,&
                              algo_inte   , algo_inte_r)
!
! ----- Get function pointers for external programs (MFRONT/UMAT)
!
        if (l_comp_external) then
            call getExternalBehaviourPntr(ds_compor_para%v_para(i_comp)%comp_exte,&
                                          cptr_fct_ldc ,&
                                          cptr_nbvarext, cptr_namevarext,&
                                          cptr_nbprop  , cptr_nameprop)
        endif
!
! ----- Get RESI_INTE_RELA/ITER_INTE_MAXI
!
        call getBehaviourPara(l_mfront_offi , l_mfront_proto, l_kit_thm,&
                              keywordfact   , i_comp        , algo_inte,&
                              iter_inte_maxi, resi_inte_rela)
!
! ----- Set values for MFRONT
!
        call setMFrontPara(ds_compor_para%v_para(i_comp)%comp_exte,&
                           iter_inte_maxi, resi_inte_rela, iveriborne)
!
! ----- Get external state variables
!
        call getExternalStateVariable(rela_comp    , comp_code_py   ,&
                                      l_mfront_offi, l_mfront_proto ,&
                                      cptr_nbvarext, cptr_namevarext)
!
! ----- Set in <CARTE>
!
        p_carc_valv(1)  = iter_inte_maxi
        p_carc_valv(2)  = type_matr_t
        p_carc_valv(3)  = resi_inte_rela
        p_carc_valv(4)  = parm_theta
        p_carc_valv(5)  = iter_inte_pas
        p_carc_valv(6)  = algo_inte_r
        p_carc_valv(7)  = vale_pert_rela
        p_carc_valv(8)  = resi_deborst_max
        p_carc_valv(9)  = iter_deborst_max
        p_carc_valv(10) = resi_radi_rela
        p_carc_valv(13) = post_iter
        p_carc_valv(21) = post_incr
!       exte_comp UMAT / MFRONT
        p_carc_valv(14) = cptr_nbvarext
        p_carc_valv(15) = cptr_namevarext
        p_carc_valv(16) = cptr_fct_ldc
        p_carc_valv(19) = cptr_nameprop
        p_carc_valv(20) = cptr_nbprop
!       cf. CALC_POINT_MAT / PMDORC
        if (l_matr_unsymm) then
            p_carc_valv(17) = 1
        else
            p_carc_valv(17) = 0
        endif
!       For THM
        p_carc_valv(18) = parm_alpha
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
!
! ----- Discard
!
        call lcdiscard(comp_code_py)
        call lcdiscard(meca_code_py)
        call lcdiscard(rela_code_py)
        call lcdiscard(defo_code_py)
    enddo
!
    call jedetr(carcri//'.NCMP')
!
end subroutine
