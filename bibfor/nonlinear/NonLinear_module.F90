! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
module NonLinear_module
! ==================================================================================================
use NonLin_Datastructure_type
use Rom_Datastructure_type
! ==================================================================================================
implicit none
! ==================================================================================================
private :: swapMatrToSecant, getMatrTypePred, getMatrTypeCorr,&
           getOptionPred, getOptionCorr,&
           isMatrUpdatePred, isMatrUpdateCorr,&
           isElasMatr
public  :: getMatrType, getOption,&
           isMatrUpdate,&
           isDampMatrCompute, isMassMatrCompute, isRigiMatrCompute, isInteVectCompute,&
           factorSystem,&
           setNodalValuesGDVARINO, &
           inteForceGetOption
! ==================================================================================================
private
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/NonLinear_type.h"
#include "asterfort/isfonc.h"
#include "asterfort/diinst.h"
#include "asterfort/utmess.h"
#include "asterfort/ndynlo.h"
#include "asterfort/cfdisl.h"
#include "asterfort/jeveuo.h"
#include "asterfort/dismoi.h"
#include "asterfort/mtdscr.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/preres.h"
#include "asterfort/romAlgoNLCorrEFMatrixModify.h"
#include "asterfort/infdbg.h"
! ==================================================================================================
contains
! ==================================================================================================
! --------------------------------------------------------------------------------------------------
!
! getOptionPred
!
! Get name of option for non-linear computation at prediction
!
! In  predMatrType     : type of matrix for prediction
! In  l_implex         : flag for IMPELX method
! Out option_nonlin    : name of option for non-linear computation
!
! --------------------------------------------------------------------------------------------------
subroutine getOptionPred(predMatrType, l_implex, option_nonlin)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=16), intent(in) :: predMatrType
    aster_logical, intent(in) :: l_implex
    character(len=16), intent(out) :: option_nonlin
!   ------------------------------------------------------------------------------------------------
    option_nonlin = ' '
!
    if (predMatrType .eq. 'TANGENTE') then
        option_nonlin = 'RIGI_MECA_TANG'
    else if (predMatrType .eq. 'SECANTE') then
        option_nonlin = 'RIGI_MECA_ELAS'
    else if (predMatrType .eq. 'ELASTIQUE') then
        option_nonlin = 'RIGI_MECA'
    else if (predMatrType .eq. 'DEPL_CALCULE') then
        option_nonlin = 'RIGI_MECA_TANG'
    else if (predMatrType .eq. 'EXTRAPOLE') then
        option_nonlin = 'RIGI_MECA_TANG'
    else
        ASSERT(ASTER_FALSE)
    endif
    if (l_implex) then
        option_nonlin = 'RIGI_MECA_IMPLEX'
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getOptionCorr
!
! Get name of option for non-linear computation at correction
!
! In  corrMatrType     : type of matrix for correction
! In  l_update_matr    : flag to update matrix
! Out option_nonlin    : name of option for non-linear computation
!
! --------------------------------------------------------------------------------------------------
subroutine getOptionCorr(corrMatrType, l_update_matr, option_nonlin)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=16), intent(in) :: corrMatrType
    aster_logical, intent(in) :: l_update_matr
    character(len=16), intent(out) :: option_nonlin
!   ------------------------------------------------------------------------------------------------
    option_nonlin = ' '
!
    if (l_update_matr) then
        if (corrMatrType .eq. 'TANGENTE') then
            option_nonlin = 'FULL_MECA'
        elseif (corrMatrType .eq. 'ELASTIQUE') then
            option_nonlin = 'FULL_MECA_ELAS'
        elseif (corrMatrType .eq. 'SECANTE') then
            option_nonlin = 'FULL_MECA_ELAS'
        else
            ASSERT(ASTER_FALSE)
        endif
    else
        option_nonlin = 'RAPH_MECA'
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getOption
!
! Get name of option for non-linear computation
!
! In  phaseType        : name of current phase (prediction/correction/internal forces)
! In  list_func_acti   : list of active functionnalities
! In  matrType         : type of matrix
! Out option_nonlin    : name of option for non-linear computation
! In  l_update_matr    : flag to update matrix
!
! --------------------------------------------------------------------------------------------------
subroutine getOption(phaseType, list_func_acti, matrType, option_nonlin, l_update_matr_)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: phaseType, list_func_acti(*)
    character(len=16), intent(in) :: matrType
    character(len=16), intent(out) :: option_nonlin
    aster_logical, optional, intent(in) :: l_update_matr_
! - Local
    aster_logical :: l_implex
!   ------------------------------------------------------------------------------------------------
    option_nonlin = ' '
    if (phaseType .eq. PRED_EULER) then
        l_implex = isfonc(list_func_acti, 'IMPLEX')
        call getOptionPred(matrType, l_implex, option_nonlin)
    else if (phaseType .eq. CORR_NEWTON) then
        call getOptionCorr(matrType, l_update_matr_, option_nonlin)
    else
        ASSERT(ASTER_FALSE)
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getMatrType
!
! Get type of matrix
!
! In  phaseType        : name of current phase (prediction/correction/internal forces)
! In  list_func_acti   : list of active functionnalities
! In  sddisc           : datastructure for discretization
! In  nume_inst        : index of current time step
! In  ds_algopara      : datastructure for algorithm parameters
! Out matrType         : type of matrix
! Out reac_iter        : frequency to update matrix (Newton iteration)
! Out reac_incr        : frequency to update matrix (time step)
!
! --------------------------------------------------------------------------------------------------
subroutine getMatrType(phaseType, list_func_acti, sddisc    , nume_inst, ds_algopara,&
                       matrType , reac_iter_    , reac_incr_)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: phaseType, list_func_acti(*)
    character(len=19), intent(in) :: sddisc
    integer, intent(in) :: nume_inst
    type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    character(len=16), intent(out) :: matrType
    integer, optional, intent(out) :: reac_iter_, reac_incr_
! - Local
    aster_logical :: l_dischoc
!   ------------------------------------------------------------------------------------------------
    matrType = ' '
    if (phaseType .eq. PRED_EULER) then
        call getMatrTypePred(sddisc, nume_inst, ds_algopara, matrType, reac_incr_)
    else if (phaseType .eq. CORR_NEWTON) then
        l_dischoc = isfonc(list_func_acti,'DIS_CHOC')
        call getMatrTypeCorr(l_dischoc, sddisc, nume_inst, ds_algopara, matrType, reac_iter_)
    else
        ASSERT(ASTER_FALSE)
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getMatrTypePred
!
! Get type of matrix for prediction
!
! In  sddisc           : datastructure for discretization
! In  nume_inst        : index of current time step
! In  ds_algopara      : datastructure for algorithm parameters
! Out matrType         : type of matrix
! Out reac_incr        : frequency to update matrix (time step)
!
! --------------------------------------------------------------------------------------------------
subroutine getMatrTypePred(sddisc, nume_inst, ds_algopara, matrType, reac_incr)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=19), intent(in) :: sddisc
    integer, intent(in) :: nume_inst
    type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    character(len=16), intent(out) :: matrType
    integer, intent(out) :: reac_incr
! - Local
    aster_logical :: l_swap
!   ------------------------------------------------------------------------------------------------
    matrType  = ds_algopara%matrix_pred
    reac_incr = ds_algopara%reac_incr
!
! - Swap matrix to secant ?
!
    call swapMatrToSecant(sddisc, nume_inst, ds_algopara, l_swap)
    if (l_swap) then
        matrType  = 'SECANTE'
        reac_incr = 1
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getMatrTypeCorr
!
! Get type of matrix for correction
!
! In  l_dischoc        : flag if DIS_CHOC elements are present
! In  sddisc           : datastructure for discretization
! In  nume_inst        : index of current time step
! In  ds_algopara      : datastructure for algorithm parameters
! Out matrType         : type of matrix
! Out reac_iter        : frequency to update matrix (Newton iteration)
!
! --------------------------------------------------------------------------------------------------
subroutine getMatrTypeCorr(l_dischoc, sddisc, nume_inst, ds_algopara, matrType, reac_iter)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    aster_logical, intent(in) :: l_dischoc
    character(len=19), intent(in) :: sddisc
    integer, intent(in) :: nume_inst
    type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    character(len=16), intent(out) :: matrType
    integer, intent(out) :: reac_iter
! - Local
    aster_logical :: l_swap
!   ------------------------------------------------------------------------------------------------
    matrType  = ds_algopara%matrix_corr
    reac_iter = ds_algopara%reac_iter
!
! - Swap matrix to secant ?
!
    call swapMatrToSecant(sddisc, nume_inst, ds_algopara, l_swap)
    if (l_swap) then
        matrType  = 'SECANTE'
        reac_iter = ds_algopara%reac_iter_elas
    endif
!
! - Change matrix if DIS_CHOC
!
    if (l_dischoc) then
        matrType = 'TANGENTE'
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! swapMatrToSecant
!
! Swap matrix to secant
!
! In  sddisc           : datastructure for discretization
! In  nume_inst        : index of current time step
! In  ds_algopara      : datastructure for algorithm parameters
! Out l_swap           : flag to swap matrix to secant
!
! --------------------------------------------------------------------------------------------------
subroutine swapMatrToSecant(sddisc, nume_inst, ds_algopara, l_swap)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=19), intent(in) :: sddisc
    integer, intent(in) :: nume_inst
    type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    aster_logical, intent(out) :: l_swap
! - Local
    real(kind=8) :: pas_mini_elas, time_incr, time_prev, time_curr
!   ------------------------------------------------------------------------------------------------
    l_swap = ASTER_FALSE
!
    pas_mini_elas = ds_algopara%pas_mini_elas
    time_prev     = diinst(sddisc, nume_inst-1)
    time_curr     = diinst(sddisc, nume_inst )
    time_incr     = time_curr-time_prev
!
! - Elastic matrix for time_incr < PAS_MINI_ELAS
!
    if (pas_mini_elas .ge. 0.d0) then
        if (abs(time_incr) .lt. pas_mini_elas) then
            l_swap = ASTER_TRUE
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isMatrUpdate
!
! Update global matrix ?
!
! In  phaseType        : name of current phase (prediction/correction/internal forces)
! In  matrType         : type of matrix
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : name of dynamic parameters datastructure
! In  ds_system        : datastructure for non-linear system management
! Out l_update_matr    : flag to update matrix
! In  nume_inst        : index of current time step
! In  iter_newt        : index of current Newton iteration
! In  reac_iter        : frequency to update matrix (Newton iteration)
! In  reac_incr        : frequency to update matrix (time step)
!
! --------------------------------------------------------------------------------------------------
subroutine isMatrUpdate(phaseType    , matrType  , list_func_acti,&
                        sddyna       , ds_system ,&
                        l_update_matr,&
                        nume_inst_   , iter_newt_,&
                        reac_iter_   , reac_incr_)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: phaseType
    character(len=16), intent(in) :: matrType
    integer, intent(in) :: list_func_acti(*)
    character(len=19), intent(in) :: sddyna
    type(NL_DS_System), intent(in) :: ds_system
    aster_logical, intent(out) :: l_update_matr
    integer, optional, intent(in) :: nume_inst_, iter_newt_
    integer, optional, intent(in) :: reac_iter_, reac_incr_
! - Local
    aster_logical :: l_matr_elas
    aster_logical :: l_cont_elem, l_dyna
    aster_logical :: l_damp, l_dischoc, l_varc, l_elas_fo
!   ------------------------------------------------------------------------------------------------
    l_update_matr  = ASTER_FALSE
!
! - Active functionnalities
!
    l_dyna       = ndynlo(sddyna, 'DYNAMIQUE')
    l_damp       = ndynlo(sddyna, 'MAT_AMORT')
    l_cont_elem  = isfonc(list_func_acti, 'ELT_CONTACT')
    l_dischoc    = isfonc(list_func_acti, 'DIS_CHOC')
    l_varc       = isfonc(list_func_acti, 'EXI_VARC' )
    l_elas_fo    = isfonc(list_func_acti, 'ELAS_FO' )
!
! - Is matrix is elastic
!
    call isElasMatr(matrType, l_matr_elas)
!
! - Update matrix ?
!
    if (phaseType .eq. PRED_EULER) then
        call isMatrUpdatePred(l_dyna       , l_damp    , l_matr_elas,&
                              l_varc       , l_elas_fo ,&
                              reac_incr_   , nume_inst_,&
                              l_update_matr)
    else if (phaseType .eq. CORR_NEWTON) then
        call isMatrUpdateCorr(matrType, iter_newt_, reac_iter_, l_update_matr)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Update matrix if elementary contact (CONTINUE/XFEM/LAC)
!
    if (l_cont_elem) then
        if (.not.l_update_matr) then
            if (matrType .ne. 'ELASTIQUE') then
                call utmess('A', 'MECANONLINE5_4')
            endif
            l_update_matr = ASTER_TRUE
        endif
    endif
!
! - Update matrix if DIS_CHOC elements
!
    if (l_dischoc) then
        if (.not.l_update_matr) then
            call utmess('A', 'MECANONLINE5_5')
            l_update_matr = ASTER_TRUE
        endif
    endif
!
! - Update if contact matrix in global matrix
!
    if (ds_system%l_matr_cont) then
        if (.not.l_update_matr) then
            call utmess('A', 'MECANONLINE5_5')
            l_update_matr = ASTER_TRUE
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isMatrUpdatePred
!
! Update global matrix at prediction ?
!
! In  l_dyna           : flag for dynamic
! In  l_damp           : flag for damping (Rayleigh)
! In  l_matr_elas      : flag if matrix is elastic
! In  l_varc           : flag for external state variables (AFFE_VARC)
! In  l_elas_fo        : flag if elasticity parameters are functions
! In  reac_incr        : frequency of matrix update for time step
! In  nume_inst        : index of current time step
! Out l_update_matr    : flag to update matrix
!
! --------------------------------------------------------------------------------------------------
subroutine isMatrUpdatePred(l_dyna       , l_damp   , l_matr_elas,&
                            l_varc       , l_elas_fo,&
                            reac_incr    , nume_inst,&
                            l_update_matr)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    aster_logical, intent(in) :: l_dyna, l_damp, l_matr_elas, l_varc, l_elas_fo
    integer, intent(in) :: reac_incr, nume_inst
    aster_logical, intent(out) :: l_update_matr
! - Local
    aster_logical :: l_first_step
!   ------------------------------------------------------------------------------------------------
    l_update_matr  = ASTER_FALSE
!
! - First step ?
!
    l_first_step = nume_inst .le. 1
!
    if ((reac_incr.eq.0) .and. (nume_inst.ne.1)) then
        l_update_matr = ASTER_FALSE
    endif
    if (nume_inst .eq. 1) then
        l_update_matr = ASTER_TRUE
    endif
    if ((reac_incr.ne.0) .and. (nume_inst.ne.1)) then
        l_update_matr = mod(nume_inst-1,reac_incr) .eq. 0
    endif
!
! - Update matrix if Rayleigh damping
!
    if (l_dyna .and. l_damp .and. l_first_step) then
        l_update_matr = ASTER_TRUE
    endif
!
! - Update matrix if command variables and elastic function
!
    if (l_matr_elas .and. l_varc .and. l_elas_fo) then
        l_update_matr = ASTER_TRUE
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isMatrUpdateCorr
!
! Update global matrix at correction ?
!
! In  matrType         : type of matrix
! In  iter_newt        : index of current Newton iteration
! In  reac_iter        : frequency of matrix update for Newton
! Out l_update_matr    : flag to update matrix
!
! --------------------------------------------------------------------------------------------------
subroutine isMatrUpdateCorr(matrType, iter_newt, reac_iter, l_update_matr)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=16), intent(in) :: matrType
    integer, intent(in) :: iter_newt, reac_iter
    aster_logical, intent(out) :: l_update_matr
!   ------------------------------------------------------------------------------------------------
    l_update_matr  = ASTER_FALSE
!
    if ((matrType.eq.'TANGENTE') .or. (matrType.eq.'SECANTE')) then
        l_update_matr = ASTER_FALSE
        if (reac_iter .ne. 0) then
            l_update_matr = mod(iter_newt+1, reac_iter) .eq. 0
        endif
    else
        l_update_matr = ASTER_FALSE
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isElasMatr
!
! Is matrix is elastic ?
!
! In  matrType         : type of matrix
! Out l_matr_elas      : flag if matrix is elastic
!
! --------------------------------------------------------------------------------------------------
subroutine isElasMatr(matrType, l_matr_elas)
! - Parameters
    character(len=16), intent(in) :: matrType
    aster_logical, intent(out) :: l_matr_elas
!   ------------------------------------------------------------------------------------------------
    l_matr_elas = ASTER_FALSE
    if (matrType.eq.'ELASTIQUE') then
        l_matr_elas = ASTER_TRUE
    else
        l_matr_elas = ASTER_FALSE
    endif
!   -----------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isDampMatrCompute
!
! Do the damping matrices have to be calculated ?
!
! In  sddyna           : name of dynamic parameters datastructure
! In  l_renumber       : flag to renumbering
! Out l_comp_damp      : flag if damp elementary matrices have to be calculated
!
! --------------------------------------------------------------------------------------------------
subroutine isDampMatrCompute(sddyna, l_renumber, l_comp_damp)
! - Parameters
    character(len=19), intent(in) :: sddyna
    aster_logical, intent(in) :: l_renumber
    aster_logical, intent(out) :: l_comp_damp
!   ------------------------------------------------------------------------------------------------
! - Local
    aster_logical :: l_ktan, l_damp
!   ------------------------------------------------------------------------------------------------
    l_comp_damp = ASTER_FALSE
!
! - Active functionnalities
!
    l_damp = ndynlo(sddyna, 'MAT_AMORT')
    l_ktan = ndynlo(sddyna, 'RAYLEIGH_KTAN')
!
    if (l_damp) then
        if (l_renumber .or. l_ktan) then
            l_comp_damp = ASTER_TRUE
        endif
    endif
!   -----------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isMassMatrCompute
!
! Do the mass matrices have to be calculated ?
!
! In  sddyna           : name of dynamic parameters datastructure
! In  l_update_matr    : flag to update matrix
! Out l_comp_mass      : flag if mass elementary matrices have to be calculated
!
! --------------------------------------------------------------------------------------------------
subroutine isMassMatrCompute(sddyna, l_update_matr, l_comp_mass)
! - Parameters
    character(len=19), intent(in) :: sddyna
    aster_logical, intent(in) :: l_update_matr
    aster_logical, intent(out) :: l_comp_mass
! - Local
    aster_logical :: l_dyna
!   ------------------------------------------------------------------------------------------------
!
    l_comp_mass = ASTER_FALSE
!
! - Active functionnalities
!
    l_dyna      = ndynlo(sddyna, 'DYNAMIQUE')
!
! - Mass matrices have to be calculated ?
!
    if (l_dyna .and. l_update_matr) then
        l_comp_mass = ASTER_TRUE
    endif
!   -----------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isRigiMatrCompute
!
! Do the rigidity matrices have to be calculated/assembled ?
!
! In  phaseType        : name of current phase (prediction/correction/internal forces)
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : name of dynamic parameters datastructure
! In  nume_inst        : index of current time step
! In  l_update_matr    : flag to update matrix
! In  l_comp_damp      : flag if damp elementary matrices have to be calculated
! Out l_comp_rigi      : flag if rigidity elementary matrices have to be calculated
! Out l_asse_rigi      : flag if rigidity elementary matrices have to be assembled
!
! --------------------------------------------------------------------------------------------------
subroutine isRigiMatrCompute(phaseType    , list_func_acti,&
                             sddyna       , nume_inst     ,&
                             l_update_matr, l_comp_damp   ,&
                             l_comp_rigi  , l_asse_rigi)
! - Parameters
    integer, intent(in) :: phaseType, list_func_acti(*)
    character(len=19), intent(in) :: sddyna
    integer, intent(in) :: nume_inst
    aster_logical, intent(in) :: l_update_matr, l_comp_damp
    aster_logical, intent(out) :: l_comp_rigi, l_asse_rigi
!   ------------------------------------------------------------------------------------------------
! - Local
    aster_logical :: l_first_step, l_hho, l_shift_mass
!   ------------------------------------------------------------------------------------------------
    l_comp_rigi = ASTER_FALSE
    l_asse_rigi = ASTER_FALSE
!
! - First step ?
!
    l_first_step = nume_inst .le. 1
!
! - Active functionnalities
!
    l_hho         = isfonc(list_func_acti, 'HHO')
    l_shift_mass  = ndynlo(sddyna, 'COEF_MASS_SHIFT')
!
! - Rigidity matrices have to be calculated ?
!
    if (phaseType .eq. PRED_EULER) then
        l_comp_rigi = l_update_matr
    endif
!
! - Rayleigh: need update of rigidity matrices
!
    if (l_comp_damp) then
        l_comp_rigi = ASTER_TRUE
    endif
!
! - For COEF_MASS_SHIFT
!
    if (l_shift_mass .and. l_first_step) then
        l_comp_rigi = ASTER_TRUE
    endif
!
! - Rigidity matrices have to be assembled ?
!
    if (l_shift_mass .and. l_first_step) then
        l_asse_rigi = ASTER_TRUE
    endif
    if (l_update_matr) then
        l_asse_rigi = ASTER_TRUE
    endif
    if (l_hho) then
        l_asse_rigi = ASTER_FALSE
    endif
!   -----------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! isInteVectCompute
!
! Do the internal forces vectors have to be calculated ?
!
! In  phaseType        : name of current phase (prediction/correction/internal forces)
! In  list_func_acti   : list of active functionnalities
! In  option_nonlin    : name of option for non-linear computation
! In  iter_newt        : index of current Newton iteration
! In  l_comp_rigi      : flag if rigidity elementary matrices have to be calculated
! Out l_comp_fint      : flag if internal forces elementary vectors have to be calculated
!
! --------------------------------------------------------------------------------------------------
subroutine isInteVectCompute(phaseType    , list_func_acti,&
                             option_nonlin, iter_newt     ,&
                             l_comp_rigi  , l_comp_fint)
! - Parameters
    integer, intent(in) :: phaseType, list_func_acti(*)
    character(len=16), intent(in) :: option_nonlin
    integer, intent(in) :: iter_newt
    aster_logical, intent(in) :: l_comp_rigi
    aster_logical, intent(out) :: l_comp_fint
!   ------------------------------------------------------------------------------------------------
! - Local
    aster_logical :: l_unil, l_cont_disc, l_line_search
!   ------------------------------------------------------------------------------------------------
    l_comp_fint = ASTER_FALSE
!
! - Active functionnalities
!
    l_unil        = isfonc(list_func_acti, 'LIAISON_UNILATER')
    l_cont_disc   = isfonc(list_func_acti, 'CONT_DISCRET')
    l_line_search = isfonc(list_func_acti, 'RECH_LINE')
!
! - Is internal forces elementary vectors have to be calculated ?
!
    if (phaseType .eq. PRED_EULER) then
        if (option_nonlin(1:9) .eq. 'FULL_MECA') then
            l_comp_fint = ASTER_TRUE
        else if (option_nonlin(1:10) .eq. 'RIGI_MECA ') then
            l_comp_fint = ASTER_FALSE
        else if (option_nonlin(1:10) .eq. 'RIGI_MECA_') then
            l_comp_fint = ASTER_FALSE
        else if (option_nonlin(1:9) .eq. 'RAPH_MECA') then
            l_comp_fint = ASTER_TRUE
        else
            ASSERT(ASTER_FALSE)
        endif
    else if (phaseType .eq. CORR_NEWTON) then
        l_comp_fint = l_comp_rigi
    else if (phaseType .eq. INTE_FORCE) then
        if (.not.l_line_search .or. iter_newt .eq. 0) then
            l_comp_fint = ASTER_TRUE
        else
            if (option_nonlin .eq. 'FULL_MECA') then
                l_comp_fint = ASTER_TRUE
            else
                l_comp_fint = ASTER_FALSE
            endif
        endif
        if (l_cont_disc .or. l_unil) then
            l_comp_fint = ASTER_TRUE
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!   -----------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! factorSystem
!
! Factorization of linear system
!
! In  list_func_acti   : list of active functionnalities
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_algorom       : datastructure for ROM parameters
! In  nume_dof         : name of nume_dof object (numbering equation)
! In  solveu           : name of datastructure for solver
! In  ds_system        : datastructure for non-linear system management
! In  maprec           : matrix for pre-conditionning
! In  matass           : matrix of linear system
! Out faccvg           : error from factorization
!
! --------------------------------------------------------------------------------------------------
subroutine factorSystem(list_func_acti, ds_measure, ds_algorom,&
                        nume_dof      , solveu    , maprec    , matass,&
                        faccvg)
! - Parameters
    integer, intent(in) :: list_func_acti(*)
    type(NL_DS_Measure), intent(inout) :: ds_measure
    type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
    character(len=19), intent(in) :: maprec, matass, solveu
    character(len=24), intent(in) :: nume_dof
    integer, intent(out) :: faccvg
!   ------------------------------------------------------------------------------------------------
! - Local
    aster_logical :: l_rom
    integer :: npvneg, ifm, niv
!   ------------------------------------------------------------------------------------------------
    call infdbg('MECANONLINE', ifm, niv)
    l_rom  = isfonc(list_func_acti, 'ROM')
    faccvg = 0
!
    call nmtime(ds_measure, 'Init'  , 'Factor')
    call nmtime(ds_measure, 'Launch', 'Factor')
    if (l_rom .and. ds_algorom%phase .eq. 'HROM') then
        call mtdscr(matass)
    elseif (l_rom .and. ds_algorom%phase .eq. 'CORR_EF') then
        call mtdscr(matass)
        call romAlgoNLCorrEFMatrixModify(nume_dof, matass, ds_algorom)
        call preres(solveu, 'V', faccvg, maprec, matass, npvneg, -9999)
        if (niv .ge. 2) then
            call utmess('I', 'MECANONLINE13_42')
        endif
    else
        call preres(solveu, 'V', faccvg, maprec, matass, npvneg, -9999)
        if (niv .ge. 2) then
            call utmess('I', 'MECANONLINE13_42')
        endif
    endif
    call nmtime(ds_measure, 'Stop'  , 'Factor')
    call nmrinc(ds_measure, 'Factor')
!   -----------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! setNodalValuesGDVARINO
!
! Set damage nodal values to positive value in nodal force vector
!
! In  sdnume           : datastructure for dof positions
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  cnforc           : nodal force vector
!
! --------------------------------------------------------------------------------------------------
subroutine setNodalValuesGDVARINO(nume_dof, sdnume, cnforc)
! - Parameters
    character(len=24), intent(in) :: nume_dof
    character(len=19), intent(in) :: sdnume, cnforc
!   ------------------------------------------------------------------------------------------------
! - Local
    integer :: nb_equa, i_equa
    real(kind=8), pointer :: v_cnforc(:) => null()
    integer, pointer :: v_endo(:) => null()
!   ------------------------------------------------------------------------------------------------
    call jeveuo(sdnume(1:19)//'.ENDO', 'L', vi = v_endo)
    call jeveuo(cnforc(1:19)//'.VALE', 'E', vr = v_cnforc)
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=nb_equa)
    do i_equa = 1, nb_equa
        if (v_endo(i_equa) .eq. 2) then
            if (v_cnforc(i_equa) .ge. 0.d0) then
                v_cnforc(i_equa) = 0.d0
            endif
        endif
    end do
!   -----------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! inteForceGetOption
!
! Get options to compute internal forces
!
! In  phaseType        : name of current phase (prediction/correction/internal forces)
! In  list_func_acti   : list of active functionnalities
! In  ds_algorom       : datastructure for ROM parameters
! Out lNodeComp        : compute internal forces without integration (FORC_NODA)
! Out lInteComp        : compute internal forces with integration (RAPH_NODA, RIGI_MECA_TANG)
! Out typeAsse         : type of assembly for internal forces
!
! --------------------------------------------------------------------------------------------------
subroutine inteForceGetOption(phaseType, list_func_acti, ds_algorom,&
                              lNodeComp, lInteComp     , typeAsse)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: phaseType, list_func_acti(*)
    aster_logical, intent(out) :: lNodeComp, lInteComp
    integer, intent(out) :: typeAsse
    type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
! - Local
    aster_logical :: lDyna, lHHO, lRomCorr
!   ------------------------------------------------------------------------------------------------
    lNodeComp = ASTER_FALSE
    lInteComp = ASTER_FALSE
    typeAsse  = INTE_FORCE_NONE
! - Active functionnalites
    lDyna    = isfonc(list_func_acti, 'DYNAMIQUE')
    lHHO     = isfonc(list_func_acti, 'HHO')
    lRomCorr = ASTER_FALSE
    if (ds_algorom%l_rom) then
        lRomCorr = ds_algorom%phase .eq. 'CORR_EF'
    endif
! - Options to compute internal forces
    if (phaseType .eq. PRED_EULER) then
        lNodeComp = .not. lHHO
        lInteComp = (lDyna .or. lRomCorr)
    elseif (phaseType .eq. CORR_NEWTON) then
        lNodeComp = ASTER_FALSE
        lInteComp = ASTER_TRUE
    else
        ASSERT(ASTER_FALSE)
    endif
! - For HHO: internal forces are NOT independent from tangent matrix evaluation
    if (lHHO) then
        lInteComp = ASTER_FALSE
    endif
! - Which second member ?
    if (phaseType .eq. PRED_EULER) then
        typeAsse = INTE_FORCE_FNOD
        if (lDyna .or. lRomCorr) then
            typeAsse = INTE_FORCE_INTE
        endif
    elseif (phaseType .eq. CORR_NEWTON) then
        typeAsse = INTE_FORCE_INTE
    else
        ASSERT(ASTER_FALSE)
    endif
! - For HHO: internal forces are NOT independent from tangent matrix evaluation
    if (lHHO) then
        typeAsse = INTE_FORCE_NONE
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
!
end module NonLinear_module
