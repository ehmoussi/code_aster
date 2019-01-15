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
! aslint: disable=W1003
!
subroutine pmdorc(compor, carcri, nb_vari, type_comp, mult_comp)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/carc_info.h"
#include "asterfort/carc_chck.h"
#include "asterfort/carc_read.h"
#include "asterfort/comp_meca_cvar.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/comp_meca_info.h"
#include "asterfort/comp_meca_pvar.h"
#include "asterfort/comp_meca_read.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/imvari.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
#include "asterfort/setBehaviourTypeValue.h"
#include "asterfort/setMFrontPara.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(out) :: compor(*)
real(kind=8), intent(out) :: carcri(*)
integer, intent(out) :: nb_vari
character(len=16), intent(out) :: type_comp, mult_comp
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics) for SIMU_POINT_MAT
!
! Prepare objects COMPOR <CARTE> and CARCRI <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! Out compor           : name of <CARTE> COMPOR
! Out carcri           : name of <CARTE> CARCRI
! Out nb_vari          : number of internal variables
! Out type_comp        : type of comportment (INCR/ELAS)
! Out mult_comp        : multi-comportment (DEFI_COMPOR for PMF)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: compor_info
    integer :: nbocc1, nbocc2, nbocc3
    character(len=16) :: keywordfact,rela_comp
    aster_logical :: l_etat_init, l_implex, l_kit_thm
    type(Behaviour_PrepPara) :: ds_compor_prep
    type(Behaviour_PrepCrit) :: ds_compor_para
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    nb_vari               = 0
    type_comp             = ' '
    compor_info           = '&&PMDORC.LIST_VARI'
    keywordfact           = 'COMPORTEMENT'
    compor(1:COMPOR_SIZE) = 'VIDE'
    l_implex              = ASTER_FALSE
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
! - Some properties
!
    nb_vari   = ds_compor_prep%v_comp(1)%nb_vari
    rela_comp = ds_compor_prep%v_comp(1)%rela_comp
    type_comp = ds_compor_prep%v_comp(1)%type_comp
    mult_comp = ds_compor_prep%v_comp(1)%mult_comp
!
! - Detection of specific cases
!
    call comp_meca_l(rela_comp, 'KIT_THM'     , l_kit_thm)
    if (l_kit_thm) then
        call utmess('F', 'COMPOR2_7')
    endif
!  
! - Save informations in the field <COMPOR>
!
    call setBehaviourTypeValue(ds_compor_prep%v_comp, l_compor_ = compor(1:COMPOR_SIZE))
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
! - Some checks
!
    call carc_chck(ds_compor_para)
!
! - Don't use external state variables for SIMU_POINT_MAT
!
    if (ds_compor_para%v_para(1)%jvariext1 .ne. 0) then
        call utmess('A', 'COMPOR2_12')
        ds_compor_para%v_para(1)%jvariext1 = 0
    endif
!  
! - Save in list
!
    carcri(1:CARCRI_SIZE) = 0.d0
    carcri(1)              = ds_compor_para%v_para(1)%iter_inte_maxi
    carcri(2)              = ds_compor_para%v_para(1)%type_matr_t
    carcri(3)              = ds_compor_para%v_para(1)%resi_inte_rela
    carcri(4)              = ds_compor_para%v_para(1)%parm_theta
    carcri(5)              = ds_compor_para%v_para(1)%iter_inte_pas
    carcri(6)              = ds_compor_para%v_para(1)%algo_inte_r
    carcri(7)              = ds_compor_para%v_para(1)%vale_pert_rela
    carcri(8)              = ds_compor_para%v_para(1)%resi_deborst_max
    carcri(9)              = ds_compor_para%v_para(1)%iter_deborst_max
    carcri(10)             = ds_compor_para%v_para(1)%resi_radi_rela
    carcri(IVARIEXT1)      = ds_compor_para%v_para(1)%jvariext1
    carcri(PARM_THETA_THM) = ds_compor_para%parm_theta_thm
    carcri(13)             = ds_compor_para%v_para(1)%ipostiter
    carcri(14)             = ds_compor_para%v_para(1)%cptr_nbvarext
    carcri(15)             = ds_compor_para%v_para(1)%cptr_namevarext
    carcri(16)             = ds_compor_para%v_para(1)%cptr_fct_ldc
    if (ds_compor_para%v_para(1)%l_matr_unsymm) then
        carcri(17) = 1
    else
        carcri(17) = 0
    endif
    carcri(PARM_ALPHA_THM) = ds_compor_para%parm_alpha_thm
    carcri(19)             = ds_compor_para%v_para(1)%cptr_nameprop
    carcri(20)             = ds_compor_para%v_para(1)%cptr_nbprop
    carcri(21)             = ds_compor_para%v_para(1)%ipostincr
    carcri(ISTRAINEXTE)    = ds_compor_para%v_para(1)%jstrainexte
!
! - Set values for MFRONT
!
    call setMFrontPara(ds_compor_para%v_para(1)%comp_exte,&
                       ds_compor_para%v_para(1)%iter_inte_maxi,&
                       ds_compor_para%v_para(1)%resi_inte_rela,&
                       ds_compor_para%v_para(1)%iveriborne)
!
! - Cleaning
!
    deallocate(ds_compor_prep%v_comp)
    deallocate(ds_compor_para%v_para)
!
    call jedema()
!
end subroutine
