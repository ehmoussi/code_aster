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
! aslint: disable=W1003
! person_in_charge: mickael.abbas at edf.fr
!
subroutine pmdorc(compor, carcri, nb_vari, incela, mult_comp)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterc/lcdiscard.h"
#include "asterfort/assert.h"
#include "asterfort/carc_info.h"
#include "asterfort/carc_read.h"
#include "asterfort/comp_meca_code.h"
#include "asterfort/comp_meca_cvar.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/comp_meca_info.h"
#include "asterfort/comp_meca_pvar.h"
#include "asterfort/comp_meca_read.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/getBehaviourAlgo.h"
#include "asterfort/getBehaviourPara.h"
#include "asterfort/getExternalStateVariable.h"
#include "asterfort/getExternalBehaviourPntr.h"
#include "asterfort/imvari.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
#include "asterfort/setBehaviourValue.h"
#include "asterfort/setMFrontPara.h"
!
character(len=16), intent(out) :: compor(20)
real(kind=8), intent(out) :: carcri(21)
integer, intent(out) :: nb_vari
integer, intent(out) :: incela
character(len=16), intent(out) :: mult_comp
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics) for SIMU_POINT_MAT
!
! Prepare objects COMPOR <CARTE> and CARCRI <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! OUT COMPOR  : OBJET COMPOR DECRIVANT LE TYPE DE COMPORTEMENT
! OUT CARCRI  : OBJET CARCRI CRITERES DE CONVERGENCE LOCAUX
! OUT NBVARI  : NOMBRE DE VARIABLE INTERNES
! OUT incela  : =1 si COMP_INCR, =2 si COMP_ELAS
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: compor_info
    integer :: i_comp, nume_comp(4), nb_vari_comp(4)
    integer :: nbocc1, nbocc2, nbocc3
    character(len=16) :: keywordfact
    character(len=16) :: rela_comp, algo_inte, defo_comp, type_comp, meca_comp
    character(len=16) :: kit_comp(4), type_cpla, post_iter
    aster_logical :: l_etat_init, l_implex, plane_stress, l_comp_external
    aster_logical :: l_kit_thm, l_mfront_proto, l_mfront_offi
    real(kind=8) :: algo_inte_r, iter_inte_maxi, resi_inte_rela
    integer :: iveriborne, jvariexte
    type(NL_DS_ComporPrep) :: ds_compor_prep
    type(NL_DS_ComporParaPrep) :: ds_compor_para
    integer :: cptr_nbvarext=0, cptr_namevarext=0, cptr_fct_ldc=0
    integer :: cptr_nameprop=0, cptr_nbprop=0
    character(len=16) :: rela_code_py=' ', defo_code_py=' ', meca_code_py=' ', comp_code_py=' '
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    compor_info  = '&&PMDORC.LIST_VARI'
    keywordfact  = 'COMPORTEMENT'
    compor(1:20) = 'VIDE'
    l_implex     = .false.
!
! - Initial state
!
    call getfac('SIGM_INIT', nbocc1)
    call getfac('EPSI_INIT', nbocc2)
    call getfac('VARI_INIT', nbocc3)
    l_etat_init = (nbocc1+nbocc2+nbocc3) > 0
!
! - Create datastructure to prepare comportement
!
    call comp_meca_info(l_implex, ds_compor_prep)
    if (ds_compor_prep%nb_comp .eq. 0) then
        call utmess('F', 'COMPOR4_63')
    endif
!
! - Read informations from command file
!
    call comp_meca_read(l_etat_init, ds_compor_prep)
!
! - Count internal variables
!
    call comp_meca_cvar(ds_compor_prep)
!
! - Save it
!
    i_comp = 1
    nb_vari         = ds_compor_prep%v_comp(i_comp)%nb_vari
    nb_vari_comp(:) = ds_compor_prep%v_comp(i_comp)%nb_vari_comp(:)
    nume_comp(:)    = ds_compor_prep%v_comp(i_comp)%nume_comp(:)
    rela_comp       = ds_compor_prep%v_comp(i_comp)%rela_comp
    defo_comp       = ds_compor_prep%v_comp(i_comp)%defo_comp
    type_comp       = ds_compor_prep%v_comp(i_comp)%type_comp
    type_cpla       = ds_compor_prep%v_comp(i_comp)%type_cpla
    kit_comp(:)     = ds_compor_prep%v_comp(i_comp)%kit_comp(:)
    mult_comp       = ds_compor_prep%v_comp(i_comp)%mult_comp
    post_iter       = ds_compor_prep%v_comp(i_comp)%post_iter
!
! - Detection of specific cases
!
    call comp_meca_l(rela_comp, 'KIT_THM'     , l_kit_thm)
    call comp_meca_l(rela_comp, 'MFRONT_PROTO', l_mfront_proto)
    call comp_meca_l(rela_comp, 'MFRONT_OFFI' , l_mfront_offi)
    if (l_kit_thm) then
        call utmess('F', 'COMPOR2_7')
    endif
    if (type_comp .eq. 'COMP_ELAS') then
        incela = 2
    else if (type_comp.eq.'COMP_INCR') then
        incela = 1
    else
        ASSERT(.false.)
    endif
!  
! - Save in list
!
    call setBehaviourValue(rela_comp, defo_comp   , type_comp, type_cpla,&
                           mult_comp, post_iter   , kit_comp ,&
                           nb_vari  , nb_vari_comp, nume_comp,&
                           l_compor_ = compor)
!
! - Prepare informations about internal variables
!
    call comp_meca_pvar(compor_list_ = compor, compor_info = compor_info)
!
! - Print informations about internal variables
!
    call imvari(compor_info)
!
! - Create carcri informations objects
!
    call carc_info(ds_compor_para)
!
! - Read informations from command file
!
    call carc_read(ds_compor_para, l_implex_ = l_implex)
!
! - Coding comportment (Python)
!    
    i_comp = 1
    meca_comp = ds_compor_para%v_para(i_comp)%meca_comp
    call comp_meca_code(rela_comp_    = rela_comp   ,&
                        defo_comp_    = defo_comp   ,&
                        kit_comp_     = kit_comp    ,&
                        meca_comp_    = meca_comp   ,&
                        comp_code_py_ = comp_code_py,&
                        rela_code_py_ = rela_code_py,&
                        defo_code_py_ = defo_code_py,&
                        meca_code_py_ = meca_code_py)
!
! - Get ALGO_INTE
!
    i_comp = 1
    plane_stress = .false.
    call getBehaviourAlgo(plane_stress, rela_comp   ,&
                          rela_code_py, meca_code_py,&
                          keywordfact , i_comp      ,&
                          algo_inte   , algo_inte_r)
!
! - Get RESI_INTE_RELA/ITER_INTE_MAXI
!
    i_comp = 1
    call getBehaviourPara(l_mfront_offi , l_mfront_proto, l_kit_thm,&
                          keywordfact   , i_comp        , algo_inte,&
                          iter_inte_maxi, resi_inte_rela)
!
! - Get function pointers for external programs (MFRONT/UMAT)
!
    i_comp = 1
    l_comp_external = ds_compor_para%v_para(i_comp)%l_comp_external
    if (l_comp_external) then
        call getExternalBehaviourPntr(ds_compor_para%v_para(i_comp)%comp_exte,&
                                      cptr_fct_ldc ,&
                                      cptr_nbvarext, cptr_namevarext,&
                                      cptr_nbprop  , cptr_nameprop)
    endif
!
! - Set values for MFRONT
!
    i_comp = 1
    iveriborne = ds_compor_para%v_para(i_comp)%iveriborne
    call setMFrontPara(ds_compor_para%v_para(i_comp)%comp_exte,&
                       iter_inte_maxi, resi_inte_rela, iveriborne)
!
! - Get external state variables
!
    call getExternalStateVariable(rela_comp    , comp_code_py   ,&
                                  l_mfront_offi, l_mfront_proto ,&
                                  cptr_nbvarext, cptr_namevarext,&
                                  jvariexte)
    if (jvariexte .ne. 0) then
        call utmess('A', 'COMPOR2_12')
        jvariexte = 0
    endif
!  
! - Save in list
!
    carcri(1)  = iter_inte_maxi
    carcri(2)  = ds_compor_para%v_para(i_comp)%type_matr_t
    carcri(3)  = resi_inte_rela
    carcri(4)  = ds_compor_para%v_para(i_comp)%parm_theta
    carcri(5)  = ds_compor_para%v_para(i_comp)%iter_inte_pas
    carcri(6)  = algo_inte_r
    carcri(7)  = ds_compor_para%v_para(i_comp)%vale_pert_rela
    carcri(8)  = ds_compor_para%v_para(i_comp)%resi_deborst_max
    carcri(9)  = ds_compor_para%v_para(i_comp)%iter_deborst_max
    carcri(10) = ds_compor_para%v_para(i_comp)%resi_radi_rela
    carcri(IVARIEXTE) = jvariexte
    carcri(13) = ds_compor_para%v_para(i_comp)%ipostiter
    carcri(14) = cptr_nbvarext
    carcri(15) = cptr_namevarext
    carcri(16) = cptr_fct_ldc
    carcri(19) = cptr_nameprop
    carcri(20) = cptr_nbprop
    if (ds_compor_para%v_para(i_comp)%l_matr_unsymm) then
        carcri(17) = 1
    else
        carcri(17) = 0
    endif
    carcri(18) = 0
    carcri(21) = ds_compor_para%v_para(i_comp)%ipostincr
!
! - Discard
!
    call lcdiscard(comp_code_py)
    call lcdiscard(meca_code_py)
    call lcdiscard(rela_code_py)
    call lcdiscard(defo_code_py)
!
! - Cleaning
!
    deallocate(ds_compor_prep%v_comp)
    deallocate(ds_compor_para%v_para)
!
    call jedema()
!
end subroutine
