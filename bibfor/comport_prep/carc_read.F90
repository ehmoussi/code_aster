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
subroutine carc_read(ds_compor_para, model_, l_implex_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/getExternalBehaviourPara.h"
#include "asterfort/dismoi.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterc/lcalgo.h"
#include "asterc/lctest.h"
#include "asterc/lcsymm.h"
#include "asterfort/jeveuo.h"
#include "asterc/lcdiscard.h"
#include "asterc/umat_get_function.h"
#include "asterc/mfront_get_pointers.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/comp_meca_rkit.h"
#include "asterfort/comp_meca_code.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/deprecated_algom.h"
!
type(NL_DS_ComporParaPrep), intent(inout) :: ds_compor_para
character(len=8), intent(in), optional :: model_
aster_logical, intent(in), optional :: l_implex_
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Read informations from command file
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_compor_para   : datastructure to prepare parameters for constitutive laws
! In  model            : name of model
! In  l_implex         : .true. if IMPLEX method
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywordfact=' ', answer
    integer :: i_comp=0, iret=0, nb_comp=0
    integer :: cptr_nbvarext=0, cptr_namevarext=0, cptr_fct_ldc=0
    integer :: cptr_matprop=0, cptr_nbprop=0
    character(len=16) :: type_matr_tang=' ', method=' ', post_iter=' ', post_incr=' '
    real(kind=8) :: parm_theta=0.d0, vale_pert_rela=0.d0
    real(kind=8) :: resi_deborst_max=0.d0
    real(kind=8) :: parm_alpha=0.d0, resi_radi_rela=0.d0
    integer :: type_matr_t=0, iter_inte_pas=0, iter_deborst_max=0
    integer :: ipostiter=0, ipostincr=0, iveriborne=0
    character(len=8) :: mesh = ' '
    character(len=16) :: rela_code_py=' ', defo_code_py=' ', meca_code_py=' '
    character(len=16) :: veri_borne=' '
    character(len=16) :: kit_comp(4) = (/'VIDE','VIDE','VIDE','VIDE'/)
    character(len=16) :: defo_comp=' ',  rela_comp=' '
    character(len=16) :: thmc_comp=' ', hydr_comp=' ', ther_comp=' ', meca_comp=' '
    aster_logical :: l_kit_thm=.false._1, l_mfront_proto=.false._1, l_kit_ddi = .false._1
    aster_logical :: l_mfront_offi=.false._1, l_umat=.false._1, l_kit = .false._1, l_matr_unsymm
    aster_logical :: l_implex, l_comp_external
    character(len=16) :: texte(3)=(/ ' ',' ',' '/), model_mfront=' '
    character(len=255) :: libr_name=' ', subr_name=' '
    integer, pointer :: v_model_elem(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact = 'COMPORTEMENT'
    nb_comp     = ds_compor_para%nb_comp
    mesh        = ' '
    l_implex    = .false.
    if (present(l_implex_)) then
        l_implex = l_implex_
    endif
!
! - Pointer to list of elements in model
!
    if ( present(model_) ) then
        call jeveuo(model_//'.MAILLE', 'L', vi = v_model_elem)
        call dismoi('NOM_MAILLA', model_, 'MODELE', repk=mesh)
    endif
!
! - Read informations
!
    do i_comp = 1, nb_comp
!
! ----- Get parameters
!
        call getvtx(keywordfact, 'RELATION'   , iocc = i_comp, scal = rela_comp)
        call getvtx(keywordfact, 'DEFORMATION', iocc = i_comp, scal = defo_comp)
!
! ----- Detection of specific cases
!
        call comp_meca_l(rela_comp, 'KIT'    , l_kit)
        call comp_meca_l(rela_comp, 'KIT_THM', l_kit_thm)
        call comp_meca_l(rela_comp, 'KIT_DDI', l_kit_ddi)
!
! ----- For KIT
!
        if (l_kit) then
            call comp_meca_rkit(keywordfact, i_comp, rela_comp, kit_comp)
        endif
!
! ----- Get mechanics part
!
        if (l_kit_thm) then
            thmc_comp = kit_comp(1)
            ther_comp = kit_comp(2)
            hydr_comp = kit_comp(3)
            meca_comp = kit_comp(4)
        elseif (l_kit_ddi) then
            meca_comp = kit_comp(1)
        else
            meca_comp = rela_comp
        endif
!
! ----- Coding comportment (Python)
!
        call comp_meca_code(rela_comp_    = rela_comp   ,&
                            defo_comp_    = defo_comp   ,&
                            meca_comp_    = meca_comp   ,&
                            rela_code_py_ = rela_code_py,&
                            defo_code_py_ = defo_code_py,&
                            meca_code_py_ = meca_code_py)
!
! ----- Symmetric or not ?
!
        l_matr_unsymm = .false.
        call lcsymm(rela_code_py, answer)
        l_matr_unsymm = l_matr_unsymm .or. answer .eq. 'No'
        call lcsymm(meca_code_py, answer)
        l_matr_unsymm = l_matr_unsymm .or. answer .eq. 'No'
        call lcsymm(defo_code_py, answer)
        l_matr_unsymm = l_matr_unsymm .or. answer .eq. 'No'
        call getvtx(keywordfact, 'SYME_MATR_TANG', iocc = i_comp, scal = answer, nbret = iret)
        if (iret .ne. 0) then
            l_matr_unsymm = l_matr_unsymm .or. answer .eq. 'NON'
        endif
!
! ----- Get ITER_INTE_PAS
!
        call getvis(keywordfact, 'ITER_INTE_PAS', iocc = i_comp, scal=iter_inte_pas, nbret=iret)
        if (iret .eq. 0) then
            iter_inte_pas = 0
        endif
!
! ----- Get ITER_CPLAN_MAXI/RESI_CPLAN_MAXI/RESI_CPLAN_RELA (Deborst method)
!
        resi_deborst_max = 1.d-6
        iter_deborst_max = 1
        call getvis(keywordfact, 'ITER_CPLAN_MAXI', iocc = i_comp, scal = iter_deborst_max)
        call getvr8(keywordfact, 'RESI_CPLAN_MAXI', iocc = i_comp, scal = resi_deborst_max,&
                    nbret = iret)
        if (iret .ne. 0) then
            resi_deborst_max = -resi_deborst_max
        else
            call getvr8(keywordfact, 'RESI_CPLAN_RELA', iocc = i_comp, scal = resi_deborst_max)
        endif
!
! ----- Get TYPE_MATR_TANG/VALE_PERT_RELA
!
        vale_pert_rela = 0.d0
        type_matr_t = 0
        type_matr_tang = ' '
        call getvtx(keywordfact, 'TYPE_MATR_TANG', iocc = i_comp, scal = type_matr_tang,&
                    nbret = iret)
        if (iret .eq. 0) then
            type_matr_t = 0
        else
            if (type_matr_tang .eq. 'PERTURBATION') then
                type_matr_t = 1
                call getvr8(keywordfact, 'VALE_PERT_RELA', iocc = i_comp, scal = vale_pert_rela)
            else if (type_matr_tang .eq. 'VERIFICATION') then
                type_matr_t = 2
                call getvr8(keywordfact, 'VALE_PERT_RELA', iocc = i_comp, scal = vale_pert_rela)
            else
                ASSERT(.false.)
            endif
            call lctest(rela_code_py, 'TYPE_MATR_TANG', type_matr_tang, iret)
            if (iret .eq. 0) then
                texte(1) = type_matr_tang
                texte(2) = rela_comp
                call utmess('F', 'COMPOR1_46', nk = 2, valk = texte)
            endif
        endif
!
! ----- Get TYPE_MATR_TANG/VALE_PERT_RELA - <IMPLEX>
!
        if (l_implex) then
            method = 'IMPLEX'
            if ((type_matr_t.ne.0) .and. (rela_comp.ne.'SANS')) then
                texte(1) = type_matr_tang
                texte(2) = method
                call utmess('F', 'COMPOR1_46', nk = 2, valk = texte)
            else
                type_matr_t = 9
            endif
            call lctest(rela_code_py, 'TYPE_MATR_TANG', method, iret)
            if ((iret.eq.0) .and. (rela_comp.ne.'SANS')) then
                texte(1) = type_matr_tang
                texte(2) = method
                call utmess('F', 'COMPOR1_46', nk = 2, valk = texte)
            endif
        endif
!
! ----- Get PARM_THETA/PARM_ALPHA
!
        parm_theta = 1.d0
        parm_alpha = 1.d0
        call getvr8(keywordfact, 'PARM_THETA', iocc = i_comp, scal = parm_theta)
        call getvr8(keywordfact, 'PARM_ALPHA', iocc = i_comp, scal = parm_alpha)
!
! ----- Get RESI_RADI_RELA
!
        if (type_matr_t .eq. 0) then
            call getvr8(keywordfact, 'RESI_RADI_RELA', iocc = i_comp, scal = resi_radi_rela,&
                        nbret = iret)
            if (iret .eq. 0) then
                resi_radi_rela = -10.d0
            endif
        endif
!
! ----- Get POST_ITER
!
        ipostiter = 0
        if (getexm(keywordfact,'POST_ITER') .eq. 1) then
            post_iter = ' '
            if (type_matr_t .eq. 0) then
                call getvtx(keywordfact, 'POST_ITER', iocc = i_comp, scal = post_iter, nbret = iret)
                if (iret .eq. 1) then
                    if (post_iter .eq. 'CRIT_RUPT') then
                        ipostiter = 1
                    endif
                endif
            endif
        endif
!
! ----- Get POST_INCR
!
        ipostincr = 0
        if (getexm(keywordfact,'POST_INCR') .eq. 1) then
            post_incr = ' '
            call getvtx(keywordfact, 'POST_INCR', iocc = i_comp, scal = post_incr, nbret = iret)
            if (iret .eq. 1) then
               if (post_incr .eq. 'REST_ECRO') then
                    ipostincr = 1
               endif
            endif
        endif
!
! ----- Get VERI_BORNE
!
        iveriborne = 0
        if (getexm(keywordfact,'VERI_BORNE') .eq. 1) then
            call getvtx(keywordfact, 'VERI_BORNE', iocc = i_comp, scal = veri_borne, nbret = iret )
            if (iret .eq. 0) then
                iveriborne = 2
            else
                if ( veri_borne .eq. 'ARRET' ) then
                    iveriborne = 2
                elseif ( veri_borne .eq. 'MESSAGE' ) then
                    iveriborne = 1
                else
                    iveriborne = 0
                endif
            endif
        endif
!
! ----- Get parameters for external programs (MFRONT/UMAT)
!
        call getExternalBehaviourPara(mesh           , v_model_elem, rela_comp, kit_comp,&
                                      l_comp_external, ds_compor_para%v_para(i_comp)%comp_exte,&
                                      keywordfact    , i_comp)
!
! ----- Get function pointers for external programs (MFRONT/UMAT)
!
        l_mfront_offi   = ds_compor_para%v_para(i_comp)%comp_exte%l_mfront_offi
        l_mfront_proto  = ds_compor_para%v_para(i_comp)%comp_exte%l_mfront_proto
        l_umat          = ds_compor_para%v_para(i_comp)%comp_exte%l_umat
        libr_name       = ds_compor_para%v_para(i_comp)%comp_exte%libr_name 
        subr_name       = ds_compor_para%v_para(i_comp)%comp_exte%subr_name
        model_mfront    = ds_compor_para%v_para(i_comp)%comp_exte%model_mfront
        cptr_nbvarext   = 0
        cptr_namevarext = 0
        cptr_fct_ldc    = 0
        if ( l_mfront_offi .or. l_mfront_proto) then
            call mfront_get_pointers(libr_name, subr_name, model_mfront,&
                                     cptr_nbvarext, cptr_namevarext,&
                                     cptr_fct_ldc,&
                                     cptr_matprop, cptr_nbprop)
        elseif ( l_umat ) then
            call umat_get_function(libr_name, subr_name, cptr_fct_ldc)
        endif
!
! ----- Ban if RELATION = MFRONT and ITER_INTE_PAS negative
!
        if (iter_inte_pas .lt. 0.d0) then
            if ( l_mfront_offi .or. l_mfront_proto) then
                call utmess('F', 'COMPOR1_95')
            end if
        end if
!
! ----- Discard
!
        call lcdiscard(meca_code_py)
        call lcdiscard(rela_code_py)
        call lcdiscard(defo_code_py)
!
! ----- Save options in list
!
        ds_compor_para%v_para(i_comp)%l_comp_external          = l_comp_external
        ds_compor_para%v_para(i_comp)%type_matr_t              = type_matr_t
        ds_compor_para%v_para(i_comp)%parm_alpha               = parm_alpha
        ds_compor_para%v_para(i_comp)%parm_theta               = parm_theta
        ds_compor_para%v_para(i_comp)%iter_inte_pas            = iter_inte_pas
        ds_compor_para%v_para(i_comp)%vale_pert_rela           = vale_pert_rela
        ds_compor_para%v_para(i_comp)%resi_deborst_max         = resi_deborst_max
        ds_compor_para%v_para(i_comp)%iter_deborst_max         = iter_deborst_max
        ds_compor_para%v_para(i_comp)%resi_radi_rela           = resi_radi_rela
        ds_compor_para%v_para(i_comp)%ipostiter                = ipostiter
        ds_compor_para%v_para(i_comp)%ipostincr                = ipostincr
        ds_compor_para%v_para(i_comp)%iveriborne               = iveriborne
        ds_compor_para%v_para(i_comp)%c_pointer%nbvarext       = cptr_nbvarext
        ds_compor_para%v_para(i_comp)%c_pointer%namevarext     = cptr_namevarext
        ds_compor_para%v_para(i_comp)%c_pointer%fct_ldc        = cptr_fct_ldc
        ds_compor_para%v_para(i_comp)%c_pointer%matprop        = cptr_matprop
        ds_compor_para%v_para(i_comp)%c_pointer%nbprop         = cptr_nbprop
        ds_compor_para%v_para(i_comp)%rela_comp                = rela_comp
        ds_compor_para%v_para(i_comp)%meca_comp                = meca_comp
        ds_compor_para%v_para(i_comp)%l_matr_unsymm            = l_matr_unsymm
    end do
!
end subroutine
