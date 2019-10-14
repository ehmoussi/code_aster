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
! aslint: disable=W1306,W1501
!
module Behaviour_module
! ==================================================================================================
use Behaviour_type
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_
! ==================================================================================================
implicit none
! ==================================================================================================
private :: varcIsGEOM, relaIsExte,&
           initElem, initElga, initESVA, initExte,&
           prepEltSize1, prepGradVelo, prepEltSize2, prepHygrometry,&
           getESVA, computeStrainESVA, computeStrainMeca,&
           getListUserESVA, getESVAPtot
public  :: behaviourInit, behaviourInitPoint,&
           behaviourPrepESVAElem, prepCoorGauss, behaviourPrepESVAGauss,&
           behaviourPrepStrain, behaviourRestoreStrain,&
           behaviourPrepESVA, behaviourPrepESVAExte
! ==================================================================================================
private
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
#include "asterc/mfront_get_external_state_variable.h"
#include "asterfort/get_elas_id.h"
#include "asterc/r8nnem.h"
#include "asterc/indik8.h"
#include "asterc/r8vide.h"
#include "asterfort/isdeco.h"
#include "asterfort/assert.h"
#include "asterfort/matinv.h"
#include "asterfort/nmgeom.h"
#include "asterfort/mgauss.h"
#include "asterfort/pmat.h"
#include "asterfort/utmess.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/verift.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
! ==================================================================================================
contains
! ==================================================================================================
! --------------------------------------------------------------------------------------------------
!
! behaviourInit
!
! Initialisation of behaviour datastructure
!
! Out BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourInit(BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    type(Behaviour_Integ), intent(out) :: BEHinteg
!   ------------------------------------------------------------------------------------------------
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG> Initialization of datastructures'
    endif
    call varcIsGEOM(BEHinteg%l_varext_geom)
    BEHinteg%tabcod    = 0
    BEHinteg%time_curr = r8nnem()
    call initElem(BEHinteg%elem)
    call initElga(BEHinteg%elga)
    call initESVA(BEHinteg%esva)
    call initExte(BEHinteg%exte)
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! initElem
!
! Initialisation of parameters on element
!
! Out BEHelem          : parameters on element
!
! --------------------------------------------------------------------------------------------------
subroutine initElem(BEHelem)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    type(Behaviour_Elem), intent(out) :: BEHelem
!   ------------------------------------------------------------------------------------------------
    BEHelem%coor_elga = r8nnem()
    BEHelem%eltsize1  = r8nnem()
    BEHelem%eltsize2  = r8nnem()
    BEHelem%gradvelo  = r8nnem()
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! initElga
!
! Initialisation of parameters on Gauss points
!
! Out BEHelga          : parameters on Gauss points
!
! --------------------------------------------------------------------------------------------------
subroutine initElga(BEHelga)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    type(Behaviour_Elga), intent(out) :: BEHelga
!   ------------------------------------------------------------------------------------------------
    BEHelga%rotpg   = r8nnem()
    BEHelga%tenscab = r8nnem()
    BEHelga%curvcab = r8nnem()
    BEHelga%nonloc  = r8nnem()
    BEHelga%r       = r8nnem()
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! initESVA
!
! Initialization of parameters for external state variables
!
! Out BEHesva          : parameters for external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine initESVA(BEHesva)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    type(Behaviour_ESVA), intent(out) :: BEHesva
!   ------------------------------------------------------------------------------------------------
    BEHesva%l_anel    = ASTER_FALSE
    BEHesva%anel_prev = r8nnem()
    BEHesva%anel_curr = r8nnem()
    BEHesva%l_temp    = ASTER_FALSE
    BEHesva%temp_prev = r8nnem()
    BEHesva%temp_curr = r8nnem()
    BEHesva%temp_incr = r8nnem()
    BEHesva%temp_refe = r8nnem()
    BEHesva%l_sech    = ASTER_FALSE
    BEHesva%sech_prev = r8nnem()
    BEHesva%sech_curr = r8nnem()
    BEHesva%sech_refe = r8nnem()
    BEHesva%sech_incr = r8nnem()
    BEHesva%l_hydr    = ASTER_FALSE
    BEHesva%hydr_prev = r8nnem()
    BEHesva%hydr_curr = r8nnem()
    BEHesva%hydr_incr = r8nnem()
    BEHesva%l_hygr    = ASTER_FALSE
    BEHesva%hygr_prev = r8nnem()
    BEHesva%hygr_curr = r8nnem()
    BEHesva%hygr_incr = r8nnem()
    BEHesva%l_ptot    = ASTER_FALSE
    BEHesva%ptot_prev = r8nnem()
    BEHesva%ptot_curr = r8nnem()
    BEHesva%ptot_incr = r8nnem()
    BEHesva%depsi_varc = r8nnem()
    BEHesva%epsi_varc  = r8nnem()
    BEHesva%epsthm     = r8nnem()
    BEHesva%epsth_anism = r8nnem()
    BEHesva%epsth_metam = r8nnem()
    BEHesva%epsthp      = r8nnem()
    BEHesva%epsth_anisp = r8nnem()
    BEHesva%epsth_metap = r8nnem()
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! initExte
!
! Initialisation of parameters for external solver
!
! Out BEHexte          : parameters for external solver
!
! --------------------------------------------------------------------------------------------------
subroutine initExte(BEHexte)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    type(Behaviour_Exte), intent(out) :: BEHexte
!   ------------------------------------------------------------------------------------------------
    BEHexte%nb_pred = 0
    BEHexte%predef  = r8nnem()
    BEHexte%dpred   = r8nnem()
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourInitPoint
!
! Initialisation of behaviour datastructure - Special for SIMU_POINT_MAT
!
! In  carcri           : parameters for comportment
! In  defo_ldc         : model for non-mechanical strains
! In  imate            : coded material address
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  neps             : number of components of strains
! In  time_curr        : current time
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourInitPoint(carcri, defo_ldc , imate   ,&
                              fami  , kpg      , ksp     ,&
                              neps  , time_curr, BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=16), intent(in) :: defo_ldc
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate, neps
    real(kind=8), intent(in) :: time_curr
    type(Behaviour_Integ), intent(inout) :: BEHinteg
!   ------------------------------------------------------------------------------------------------
    BEHinteg%elem%gradvelo  = 0.d0
!
! - Get list of external state variables from user (AFFE_VARC)
!
    call getListUserESVA(carcri, BEHinteg%tabcod)
!
! - Don't use some external state variables for SIMU_POINT_MAT
!
    if ((BEHinteg%tabcod(ELTSIZE1) .eq. 1) .or. &
        (BEHinteg%tabcod(ELTSIZE2) .eq. 1) .or. &
        (BEHinteg%tabcod(GRADVELO) .eq. 1)) then
        call utmess('A', 'COMPOR2_12')
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getListUserESVA
!
! Get list of external state variables from user (AFFE_VARC)
!
! In  carcri           : parameters for comportment
! Out tabcod           : list of integers to detect external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine getListUserESVA(carcri, tabcod)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    integer, intent(out) :: tabcod(60)
! - Local
    integer :: jvariext1, jvariext2, variextecode(2)
!   ------------------------------------------------------------------------------------------------
    jvariext1 = nint(carcri(IVARIEXT1))
    jvariext2 = nint(carcri(IVARIEXT2))
    tabcod(:) = 0
    variextecode(1) = jvariext1
    variextecode(2) = jvariext2
    call isdeco(variextecode, tabcod, 60)
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepESVAElem
!
! Prepare external state variables - For element
!
! In  carcri           : parameters for comportment
! In  typmod           : type of modelisation
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  geom             : initial coordinates of nodes
! IO  BEHinteg         : parameters for integration of behaviour
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepESVAElem(carcri  , typmod  ,&
                                 nno     , npg     , ndim    ,&
                                 jv_poids, jv_func , jv_dfunc,&
                                 geom    , BEHinteg,&
                                 deplm_  , ddepl_)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=8), intent(in) :: typmod(2)
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_poids, jv_func, jv_dfunc
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Integ), intent(inout) :: BEHinteg
    real(kind=8), optional, intent(in) :: deplm_(ndim, nno), ddepl_(ndim, nno)
!   ------------------------------------------------------------------------------------------------
!
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG> Preparation of external state variable for each element'
    endif
    call getListUserESVA(carcri, BEHinteg%tabcod)
!
! - Element size 1
!
    if (BEHinteg%tabcod(ELTSIZE1) .eq. 1) then
        call prepEltSize1(nno     , npg    , ndim         ,&
                          jv_poids, jv_func, jv_dfunc     ,&
                          geom    , typmod , BEHinteg%elem)
    endif
!
! - Element size 2
!
    if (BEHinteg%tabcod(ELTSIZE2) .eq. 1) then
        call prepEltSize2(nno     , npg   , ndim,&
                          jv_dfunc,&
                          geom    , typmod, BEHinteg%elem)
    endif
!
! - Gradient of velocity
!
    if (BEHinteg%tabcod(GRADVELO) .eq. 1) then
        if (.not.present(deplm_) .or. .not.present(ddepl_)) then
            call utmess('F', 'COMPOR2_26')
        endif
        call prepGradVelo(nno          , npg    , ndim    ,&
                          jv_poids     , jv_func, jv_dfunc,&
                          geom         , deplm_ , ddepl_  ,&
                          BEHinteg%elem)
    endif
!
! - Coordinates of Gauss points
!
    call prepCoorGauss(nno    , npg , ndim    ,&
                       jv_func, geom, BEHinteg%elem)
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepESVAGauss
!
! Prepare external state variables at Gauss point
!
! In  carcri           : parameters for comportment
! In  defo_ldc         : model for non-mechanical strains
! In  imate            : coded material address
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  neps             : number of components of strains
! In  time_curr        : current time
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepESVAGauss(carcri, defo_ldc , imate   ,&
                                  fami  , kpg      , ksp     ,&
                                  neps  , time_curr, BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=16), intent(in) :: defo_ldc
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate, neps
    type(Behaviour_Integ), intent(inout) :: BEHinteg
    real(kind=8), intent(in) :: time_curr
! - Local
    aster_logical :: l_mfront, l_umat
!   ------------------------------------------------------------------------------------------------
!
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG> Preparation of external state variable for each Gauss point'
    endif
!
! - Flags for external solvers
!
    call relaIsExte(carcri, l_mfront, l_umat)
    BEHinteg%l_mfront  = l_mfront
    BEHinteg%l_umat    = l_umat
    if (LDC_PREP_DEBUG .eq. 1) then
        if (l_mfront) then
            WRITE(6,*) '<DEBUG>  External solver: MFront'
        endif
        if (l_umat) then
            WRITE(6,*) '<DEBUG>  External solver: UMAT'
        endif
    endif
!
! - Current time
!
    BEHinteg%time_curr = time_curr
!
! - Prepare hygrometry
!
    if (BEHinteg%tabcod(HYGR) .eq. 1) then
        call prepHygrometry(fami, kpg, ksp, imate, BEHinteg%esva)
    endif
!
! - Prepare external state variables (intrinsic)
!
    call behaviourPrepESVA(defo_ldc     , imate   ,&
                           fami         , kpg     , ksp   ,&
                           neps         , l_mfront, l_umat,&
                           BEHinteg%esva)
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepESVAExte
!
! Prepare external state variables for external solvers (UMAT/MFRONT)
!
! In  carcri           : parameters for comportment
! In  defo_ldc         : model for non-mechanical strains
! In  imate            : coded material address
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  neps             : number of components of strains
! In  time_curr        : current time
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepESVAExte(carcri, fami, kpg, ksp, BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
    integer, parameter :: umat_nbvarc = 8
    character(len=8), parameter :: umat_lvarc(umat_nbvarc) =(/'SECH    ','HYDR    ','IRRA    ',&
                                                              'NEUT1   ','NEUT2   ','CORR    ',&
                                                              'ALPHPUR ','ALPHBETA'/)
    character(len=8)   :: list_varc(EXTE_ESVA_NBMAXI), varc_name
    integer            :: i_varc, iret, nb_varc
    real(kind=8)       :: varc_prev, varc_curr

!   ------------------------------------------------------------------------------------------------
!
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG> Preparation of external state variable for external solvers'
    endif
    nb_varc = 0
    BEHinteg%exte%predef(1:EXTE_ESVA_NBMAXI) = 0.d0
    BEHinteg%exte%dpred(1:EXTE_ESVA_NBMAXI)  = 0.d0
!
! - List of external state variables in external solvers
!
    if (BEHinteg%l_mfront) then
        call mfront_get_external_state_variable(int(carcri(EXTE_ESVA_NB))      ,&
                                                int(carcri(EXTE_ESVA_PTR_NAME)),&
                                                list_varc      , nb_varc)

    elseif (BEHinteg%l_umat) then
        list_varc = umat_lvarc
        nb_varc   = umat_nbvarc
    endif
    ASSERT(nb_varc .le. EXTE_ESVA_NBMAXI)
    if (LDC_PREP_DEBUG .eq. 1) then
        if (nb_varc .eq. 0) then
            WRITE(6,*) '<DEBUG>  No external state variables defined in MFront'
        else
            WRITE(6,*) '<DEBUG>  Number and names:',nb_varc,list_varc(1:nb_varc)
        endif
    endif
!
! - Set values of ExternalStateVariables
!
    do i_varc = 1, nb_varc
        varc_name = list_varc(i_varc)
        if (varc_name .eq. 'TEMP') then
            if (BEHinteg%esva%l_temp) then
! ------------- Nothing to do
            else
                call utmess('F', 'COMPOR4_23', sk = varc_name)
            endif
        elseif (varc_name .eq. 'SECH') then
            if (BEHinteg%esva%l_sech) then
                BEHinteg%exte%predef(i_varc) = BEHinteg%esva%sech_prev
                BEHinteg%exte%dpred(i_varc)  = BEHinteg%esva%sech_incr
            else
                if (.not. BEHinteg%l_umat) then
                    call utmess('F', 'COMPOR4_23', sk = varc_name)
                endif
            endif
        elseif (varc_name .eq. 'HYDR') then
            if (BEHinteg%esva%l_hydr) then
                BEHinteg%exte%predef(i_varc) = BEHinteg%esva%hydr_prev
                BEHinteg%exte%dpred(i_varc)  = BEHinteg%esva%hydr_incr
            else
                if (BEHinteg%esva%l_hygr) then
                    BEHinteg%exte%predef(i_varc) = 0.d0
                    BEHinteg%exte%dpred(i_varc)  = 0.d0
                else
                    if (.not. BEHinteg%l_umat) then
                        call utmess('F', 'COMPOR4_23', sk = varc_name)
                    endif
                endif
            endif
        elseif (varc_name .eq. 'HYGR') then
            if (BEHinteg%esva%l_hygr) then
                BEHinteg%exte%predef(i_varc) = BEHinteg%esva%hygr_prev
                BEHinteg%exte%dpred(i_varc)  = BEHinteg%esva%hygr_incr
            else
                if (.not. BEHinteg%l_umat) then
                    call utmess('F', 'COMPOR4_23', sk = varc_name)
                endif
            endif
        elseif (varc_name .eq. 'TIME') then
            BEHinteg%exte%predef(i_varc) = BEHinteg%time_curr
        elseif (varc_name .eq. 'ELTSIZE1') then
            BEHinteg%exte%predef(i_varc) = BEHinteg%elem%eltsize1
        elseif (varc_name .eq. 'ELTSIZE2') then
            call utmess('F', 'COMPOR4_25', sk = varc_name)
        elseif (varc_name .eq. 'GRADVELO') then
            call utmess('F', 'COMPOR4_25', sk = varc_name)
        else
            call rcvarc(' ', varc_name, '-', fami, kpg, ksp, varc_prev, iret)
            if (iret .eq. 0) then
                call rcvarc('F', varc_name, '+', fami, kpg, ksp, varc_curr, iret)
                BEHinteg%exte%predef(i_varc) = varc_prev
                BEHinteg%exte%dpred(i_varc)  = varc_curr - varc_prev
            else
                if (.not. BEHinteg%l_umat) then
                    call utmess('F', 'COMPOR4_23', sk = varc_name)
                endif
            endif
        endif
    enddo
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getESVAPtot
!
! Get external state variable PTOT (specific)
!
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  imate            : coded material address
! IO  BEHesva          : parameters for external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine getESVAPtot(fami, kpg, ksp, imate, neps, BEHesva)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate, neps
    type(Behaviour_ESVA), intent(inout) :: BEHesva
! - Local
    integer :: iret
!   ------------------------------------------------------------------------------------------------
!
    call rcvarc(' ', 'PTOT', '-', fami, kpg, ksp, BEHesva%ptot_prev, iret)
    if (iret .eq. 0) then
        call rcvarc('F', 'PTOT', '+', fami, kpg, ksp, BEHesva%ptot_curr, iret)
        BEHesva%ptot_incr = BEHesva%ptot_curr - BEHesva%ptot_prev
        BEHesva%l_ptot    = ASTER_TRUE
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getESVA
!
! Get external state variables
!
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  imate            : coded material address
! IO  BEHesva          : parameters for external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine getESVA(fami, kpg, ksp, imate, neps, BEHesva)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate, neps
    type(Behaviour_ESVA), intent(inout) :: BEHesva
! - Local
    integer :: iret, k
    character(len=6), parameter :: epsa(6) = (/'EPSAXX','EPSAYY','EPSAZZ',&
                                               'EPSAXY','EPSAXZ','EPSAYZ'/)
!   ------------------------------------------------------------------------------------------------
!
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Get external state variables'
    endif
!
! - TEMP
!
    iret = 0
    call verift(fami, kpg, ksp, '-', imate,&
                epsth_      = BEHesva%epsthm,&
                epsth_anis_ = BEHesva%epsth_anism,&
                epsth_meta_ = BEHesva%epsth_metam,&
                temp_prev_  = BEHesva%temp_prev,&
                temp_refe_  = BEHesva%temp_refe,&
                iret_       = iret)
    if (iret .ne. 0) then
        BEHesva%temp_prev = 0.d0
    endif
    call verift(fami, kpg, ksp, '+', imate,&
                epsth_      = BEHesva%epsthp,&
                epsth_anis_ = BEHesva%epsth_anisp,&
                epsth_meta_ = BEHesva%epsth_metap,&
                temp_curr_  = BEHesva%temp_curr,&
                iret_       = iret)
    if (iret .eq. 0) then
        BEHesva%temp_incr = BEHesva%temp_curr - BEHesva%temp_prev
        BEHesva%l_temp    = ASTER_TRUE
    else
        BEHesva%temp_curr = 0.d0
    endif
!
! - SECH
!
    call rcvarc(' ', 'SECH', '-', fami, kpg, ksp, BEHesva%sech_prev, iret)
    if (iret .eq. 0) then
        call rcvarc('F', 'SECH', '+'  , fami, kpg, ksp, BEHesva%sech_curr, iret)
        BEHesva%sech_incr = BEHesva%sech_curr - BEHesva%sech_prev
        BEHesva%l_sech    = ASTER_TRUE
    endif
    call rcvarc(' ', 'SECH', 'REF', fami, kpg, ksp, BEHesva%sech_refe, iret)
    if (iret .ne. 0) then
        BEHesva%sech_refe = 0.d0
    endif
!
! - HYDR
!
    call rcvarc(' ', 'HYDR', '-', fami, kpg, ksp, BEHesva%hydr_prev, iret)
    if (iret .eq. 0) then
        call rcvarc('F', 'HYDR', '+', fami, kpg, ksp, BEHesva%hydr_curr, iret)
        BEHesva%hydr_incr = BEHesva%hydr_curr - BEHesva%hydr_prev
        BEHesva%l_hydr    = ASTER_TRUE
    endif
!
! - EPSA
!
    do k = 1, neps
        call rcvarc(' ', epsa(k), '-', fami, kpg, ksp, BEHesva%anel_prev(k), iret)
        if (iret .eq. 0) then
            BEHesva%anel_prev(k) = 0.d0
        endif
        call rcvarc(' ', epsa(k), '+', fami, kpg, ksp, BEHesva%anel_curr(k), iret)
        if (iret .eq. 0) then
            BEHesva%anel_curr(k) = 0.d0
            BEHesva%anel_incr(k) = BEHesva%anel_curr(k) - BEHesva%anel_prev(k)
            BEHesva%l_anel       = ASTER_TRUE
        endif
    enddo
!
! - Debug
!
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Values of external state variables given by AFFE_VARC'
        if (BEHesva%l_temp) then
            WRITE(6,*) '<DEBUG>  TEMP: ',BEHesva%temp_curr, BEHesva%temp_prev, BEHesva%temp_refe,&
                                         BEHesva%temp_incr
        endif
        if (BEHesva%l_sech) then
            WRITE(6,*) '<DEBUG>  SECH: ',BEHesva%sech_curr, BEHesva%sech_prev, BEHesva%sech_refe
        endif
        if (BEHesva%l_hydr) then
            WRITE(6,*) '<DEBUG>  HYDR: ',BEHesva%hydr_curr, BEHesva%hydr_prev
        endif
        if (BEHesva%l_anel) then
            WRITE(6,*) '<DEBUG>  EPSA: ',BEHesva%anel_curr, BEHesva%anel_prev
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepESVA
!
! Prepare external state variables (from user / AFFE_VARC)
!
! In  defo_ldc         : model for non-mechanical strains
! In  imate            : coded material address
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  neps             : number of components of strains
! In  l_mfront         : logical for mfront behaviour
! In  l_umat           : logical for umat behaviour
! IO  BEHesva          : parameters for external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepESVA(defo_ldc, imate   ,&
                             fami    , kpg     , ksp   ,&
                             neps    , l_mfront, l_umat,&
                             BEHesva)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=16), intent(in) :: defo_ldc
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate, neps
    aster_logical, intent(in) :: l_mfront, l_umat
    type(Behaviour_ESVA), intent(inout) :: BEHesva
!   ------------------------------------------------------------------------------------------------
! 
! - Get external state variables
!
    if (ca_nbcvrc_ .ne. 0) then
        call getESVAPtot(fami, kpg, ksp, imate, neps, BEHesva)
        if (l_mfront .or. l_umat .or. defo_ldc .eq. 'MECANIQUE') then
            call getESVA(fami, kpg, ksp, imate, neps, BEHesva)
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepStrain
!
! Prepare input strains for the behaviour law
!    -> If defo_ldc = 'MECANIQUE', prepare mechanical strain
!    -> If defo_ldc = 'TOTALE' or 'OLD', keep total strain
!
! In  l_pred           : flag if prediction
! In  l_czm            : flag for CZM models
! In  l_large          : flag for large strain models
! In  l_defo_meca      : flag for defo_ldc .eq. 'MECANIQUE'
! In  imate            : coded material address
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  neps             : number of components of strains
! IO  epsm             : In : total strains at beginning of current step time
!                        Out : mechanical strains at beginning of current step time
! IO  deps             : In : increment of total strains during current step time
!                        Out : increment of mechanical strains during current step time
! IO  BEHesva          : parameters for external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepStrain(l_pred, l_czm  , l_large, l_defo_meca,&
                               imate , fami   , kpg    , ksp        ,&
                               neps  , BEHesva, epsm   , deps)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    aster_logical, intent(in) :: l_pred, l_czm, l_large, l_defo_meca
    integer, intent(in) :: imate
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp
    integer, intent(in) :: neps
    type(Behaviour_ESVA), intent(inout) :: BEHesva
    real(kind=8), intent(inout) :: epsm(neps), deps(neps)
! - Local
!   ------------------------------------------------------------------------------------------------
    if (ca_nbcvrc_ .ne. 0) then
        if ((l_defo_meca) .and. (.not. l_large) .or. BEHesva%l_ptot) then
! --------- Compute "thermic" strains for some external state variables
            call computeStrainESVA(fami, kpg, ksp, imate, neps, BEHesva)
! --------- Subtract to get mechanical strain epsm and deps become mechanical strains
            call computeStrainMeca(l_pred, l_czm, neps, BEHesva, epsm, deps)
        endif
    endif
    if (LDC_PREP_DEBUG .eq. 1) then
        if (BEHesva%l_ptot) then
            WRITE(6,*) '<DEBUG>  PTOT: ',BEHesva%ptot_curr, BEHesva%ptot_prev
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourRestoreStrain
!
! Restore strains
!
! In  l_large          : flag for large strain models
! In  l_defo_meca      : flag for defo_ldc .eq. 'MECANIQUE'
! In  l_czm            : flag for CZM models
! In  neps             : number of components of strains
! IO  BEHesva          : parameters for external state variables
! IO  epsm             : In : total strains at beginning of current step time
!                        Out : mechanical strains at beginning of current step time
! IO  deps             : In : increment of total strains during current step time
!                        Out : increment of mechanical strains during current step time
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourRestoreStrain(l_czm, l_large, l_defo_meca,&
                                  neps , BEHesva, epsm   , deps)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    aster_logical, intent(in) :: l_czm, l_large, l_defo_meca
    integer, intent(in) :: neps
    type(Behaviour_ESVA), intent(in) :: BEHesva
    real(kind=8), intent(inout) :: epsm(neps), deps(neps)
! - Local
    real(kind=8) :: epsmtot(9), depstot(9)
!   ------------------------------------------------------------------------------------------------
    if (ca_nbcvrc_ .ne. 0) then
        if ((l_defo_meca) .and. (.not. l_large)) then
            depstot(1:neps) = 0.d0
            epsmtot(1:neps) = 0.d0
            if ((neps .eq. 6) .or. (neps .eq. 4)) then
                call dcopy(neps, deps, 1, depstot, 1)
                call daxpy(neps, 1.d0, BEHesva%depsi_varc, 1, depstot,1)
                call dcopy(neps, epsm, 1, epsmtot, 1)
                call daxpy(neps, 1.d0, BEHesva%epsi_varc, 1, epsmtot, 1)
            else if ((neps .eq. 3) .and. l_czm) then
! No thermic strains for cohesive elements
                call dcopy(neps, deps, 1, depstot, 1)
                call dcopy(neps, epsm, 1, epsmtot, 1)
            else
                ASSERT(ASTER_FALSE)
            endif
! epsm and deps become total strains again
            call dcopy(neps, epsmtot, 1, epsm, 1)
            call dcopy(neps, depstot, 1, deps, 1)
        endif
        if (LDC_PREP_DEBUG .eq. 1) then
            WRITE(6,*) '<DEBUG>  Restore total strains:',&
                     neps,epsm(1:neps),deps(1:neps)
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepEltSize1
!
! Compute intrinsic external state variables - Size of element (ELTSIZE1)
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  typmod           : type of modelization (TYPMOD2)
! In  geom             : initial coordinates of nodes
! IO  BEHelem          : parameters on element
!
! --------------------------------------------------------------------------------------------------
subroutine prepEltSize1(nno     , npg    , ndim    ,&
                        jv_poids, jv_func, jv_dfunc,&
                        geom    , typmod , BEHelem)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_poids, jv_func, jv_dfunc
    character(len=8), intent(in) :: typmod(2)
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Elem), intent(inout) :: BEHelem
! - Local
    aster_logical :: l_axi
    integer :: kpg, k, i
    real(kind=8) :: lc, dfdx(27), dfdy(27), dfdz(27), poids, r
    real(kind=8) :: volume, surfac
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!   ------------------------------------------------------------------------------------------------
    l_axi = typmod(1) .eq. 'AXIS'
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Compute ELTSIZE1'
    endif
!
    if (typmod(1)(1:2) .eq. '3D') then
        volume = 0.d0
        do kpg = 1, npg
            call dfdm3d(nno, kpg, jv_poids, jv_dfunc, geom,&
                        poids, dfdx, dfdy, dfdz)
            volume = volume + poids
        end do
        if (npg .ge. 9) then
            lc = volume ** 0.33333333333333d0
        else
            lc = rac2 * volume ** 0.33333333333333d0
        endif
    elseif (typmod(1)(1:6).eq.'D_PLAN' .or. typmod(1)(1:4).eq.'AXIS') then
        surfac = 0.d0
        do kpg = 1, npg
            k = (kpg-1)*nno
            call dfdm2d(nno, kpg, jv_poids, jv_dfunc, geom,&
                        poids, dfdx, dfdy)
            if (l_axi) then
                r = 0.d0
                do i = 1, nno
                    r = r + geom(1,i)*zr(jv_func+i+k-1)
                end do
                poids = poids*r
            endif
            surfac = surfac + poids
        end do
!
        if (npg .ge. 5) then
            lc = surfac ** 0.5d0
        else
            lc = rac2 * surfac ** 0.5d0
        endif
!
    elseif (typmod(1)(1:6).eq.'C_PLAN') then
        lc = r8vide()
    else
        ASSERT(ASTER_FALSE)
    endif
!
    BEHelem%eltsize1 = lc
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepEltSize2
!
! Compute intrinsic external state variables - Size of element (ELTSIZE2)
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points
! In  ndim             : dimension of problem (2 or 3)
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  typmod2          : type of modelization (TYPMOD2)
! In  geom             : initial coordinates of nodes
! IO  BEHelem          : parameters on element
!
! --------------------------------------------------------------------------------------------------
subroutine prepEltSize2(nno     , npg , ndim  ,&
                        jv_dfunc, geom, typmod,&
                        BEHelem)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_dfunc
    character(len=8), intent(in) :: typmod(2)
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Elem), intent(inout) :: BEHelem
! - Local
    integer :: kpg, i, j, k, jj, iret
    real(kind=8) :: l(3, 3)
    real(kind=8) :: inv(3, 3), det, de, dn, dk
!   ------------------------------------------------------------------------------------------------
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Compute ELTSIZE2'
    endif
    if (typmod(1)(1:2) .eq. '3D') then
        do kpg = 1, npg
            do i = 1, 3
                l(1,i) = 0.d0
                l(2,i) = 0.d0
                l(3,i) = 0.d0
                do  j = 1, nno
                    k = 3*nno*(kpg-1)
                    jj = 3*(j-1)
                    de = zr(jv_dfunc-1+k+jj+1)
                    dn = zr(jv_dfunc-1+k+jj+2)
                    dk = zr(jv_dfunc-1+k+jj+3)
                    l(1,i) = l(1,i) + de*geom(i,j)
                    l(2,i) = l(2,i) + dn*geom(i,j)
                    l(3,i) = l(3,i) + dk*geom(i,j)
                end do
            end do
! --------- inversion de la matrice l
            iret = 0
            det  = 0.d0
            inv  = 0.d0
            do i = 1, 3
                inv(i,i) = 1.d0
            end do
            call mgauss('NCVP', l, inv, 3, 3,&
                        3, det, iret)
            do i = 1, 3
                do j = 1, 3
                    BEHelem%eltsize2(3*(i-1)+j)=inv(i,j)
                end do
            end do
        end do
    else
        BEHelem%eltsize2 = r8vide()
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepGradVelo
!
! Compute intrinsic external state variables - Gradient of velocity (GRADVELO)
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  geom             : initial coordinates of nodes
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
! IO  BEHelem          : parameters on element
!
! --------------------------------------------------------------------------------------------------
subroutine prepGradVelo(nno     , npg    , ndim    ,&
                        jv_poids, jv_func, jv_dfunc,&
                        geom    , deplm  , ddepl   ,&
                        BEHelem)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_poids, jv_func, jv_dfunc
    real(kind=8), intent(in) :: geom(ndim, nno)
    real(kind=8), intent(in) :: deplm(ndim, nno), ddepl(ndim, nno)
    type(Behaviour_Elem), intent(inout) :: BEHelem
! - Local
    integer :: nddl, kpg, i, j
    real(kind=8) :: l(3, 3), fmm(3, 3), df(3, 3), f(3, 3), r8bid, r
    real(kind=8) :: deplp(3, 27), geomm(3, 27), epsbid(6)
    real(kind=8) :: dfdi(nno, 3)
    real(kind=8), parameter :: id(9) =(/1.d0,0.d0,0.d0, 0.d0,1.d0,0.d0, 0.d0,0.d0,1.d0/)
!   ------------------------------------------------------------------------------------------------
    nddl = ndim*nno
    BEHelem%gradvelo = 0.d0
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Compute GRADVELO'
    endif
!
    call dcopy(nddl, geom, 1, geomm, 1)
    call daxpy(nddl, 1.d0, deplm, 1, geomm, 1)
    call dcopy(nddl, deplm, 1, deplp, 1)
    call daxpy(nddl, 1.d0, ddepl, 1, deplp, 1)
    do kpg = 1, npg
        call nmgeom(ndim, nno, .false._1, .true._1, geom,&
                    kpg, jv_poids, jv_func, jv_dfunc, deplp,&
                    .true._1, r8bid, dfdi, f, epsbid,&
                    r)
        call nmgeom(ndim, nno, .false._1, .true._1, geomm,&
                    kpg, jv_poids, jv_func, jv_dfunc, ddepl,&
                    .true._1, r8bid, dfdi, df, epsbid,&
                    r)
        call daxpy(9, -1.d0, id, 1, df, 1)
        call matinv('S', 3, f, fmm, r8bid)
        call pmat(3, df, fmm, l)
        do i = 1, 3
            do j = 1, 3
                BEHelem%gradvelo(3*(i-1)+j) = l(i,j)
            end do
        end do
    end do
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepCoorGauss
!
! Compute intrinsic external state variables - Coordinates of Gauss points
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_func          : JEVEUX adress for shape functions
! In  geom             : initial coordinates of nodes
! IO  BEHelem          : parameters on element
!
! --------------------------------------------------------------------------------------------------
subroutine prepCoorGauss(nno    , npg , ndim   ,&
                         jv_func, geom, BEHelem)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_func
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Elem), intent(inout) :: BEHelem
! - Local
    integer :: i, k, kpg
!   ------------------------------------------------------------------------------------------------
    BEHelem%coor_elga = 0.d0
    ASSERT(npg .le. 27)
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Compute coordinates of Gauss points'
    endif
!
    do kpg = 1, npg
        do i = 1, ndim
            do k = 1, nno
                BEHelem%coor_elga(kpg, i) = BEHelem%coor_elga(kpg, i) +&
                                            geom(i,k)*zr(jv_func-1+nno*(kpg-1)+k)
            end do
        end do
    end do
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepHygrometry
!
! Compute intrinsic external state variables - Hygrometry
!
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  imate            : coded material address
! IO  BEHesva          : parameters for external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine prepHygrometry(fami, kpg, ksp, imate, BEHesva)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate
    type(Behaviour_ESVA), intent(inout) :: BEHesva
! - Local
    integer           :: codret(1)
    real(kind=8)      :: valres(1)
    character(len=16) :: nomres(1)
!   ------------------------------------------------------------------------------------------------
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Compute hygrometry'
    endif
    nomres(1) = 'FONC_DESORP'
    call rcvalb(fami, kpg, ksp, '-', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nomres, valres, codret, 0)
    if (codret(1) .eq. 0) then
        BEHesva%hygr_prev = valres(1)
    else
        call utmess('F', 'COMPOR2_94')
    endif
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nomres, valres, codret, 0)
    if (codret(1) .eq. 0) then
        BEHesva%hygr_curr = valres(1)
        BEHesva%l_hygr    = ASTER_TRUE
        BEHesva%hygr_incr = BEHesva%hygr_curr - BEHesva%hygr_prev
    else
        call utmess('F', 'COMPOR2_94')
    endif
    if (LDC_PREP_DEBUG .eq. 1) then
        if (BEHesva%l_hygr) then
            WRITE(6,*) '<DEBUG>  Value of HYGR: ',BEHesva%hygr_prev,BEHesva%hygr_curr
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! computeStrainESVA
!
! Precompute strains from external state variables
!

! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  imate            : coded material address
! In  neps             : number of components of strains
! IO  BEHesva          : parameters for external state variables
!
! --------------------------------------------------------------------------------------------------
subroutine computeStrainESVA(fami, kpg, ksp, imate, neps, BEHesva)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: neps
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate
    type(Behaviour_ESVA), intent(inout) :: BEHesva
! - Local
    integer           :: elas_id, codret(3), i_dim, k
    character(len=16) :: elas_keyword
    real(kind=8)      :: valres(3)
    character(len=16) :: nomres(3)
    real(kind=8)      :: epsbp, epsbm, bendom, kdessm, bendop, kdessp
    real(kind=8)      :: biotp, biotm, em, ep, num, nup, troikm, troikp
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!   ------------------------------------------------------------------------------------------------
    BEHesva%depsi_varc(1:6) = 0.d0
    BEHesva%epsi_varc(1:6)  = 0.d0
!
! - Compute thermic strains
!
    if (BEHesva%l_temp) then
        call get_elas_id(imate, elas_id, elas_keyword)
        if (elas_keyword .eq. 'ELAS_META') then
            do i_dim = 1, 3
                BEHesva%depsi_varc(i_dim) = BEHesva%epsth_metap - BEHesva%epsth_metam
                BEHesva%epsi_varc(i_dim)  = BEHesva%epsth_metam
            enddo
        else
            if (elas_id .eq. 1) then
                do i_dim = 1, 3
                    BEHesva%depsi_varc(i_dim) = BEHesva%epsthp - BEHesva%epsthm
                    BEHesva%epsi_varc(i_dim)  = BEHesva%epsthm
                enddo
            else
                do i_dim = 1, 3
                    BEHesva%depsi_varc(i_dim) = BEHesva%epsth_anisp(i_dim) -&
                                                BEHesva%epsth_anism(i_dim)
                    BEHesva%epsi_varc(i_dim)  = BEHesva%epsth_anism(i_dim)
                enddo
            endif
        endif
    endif
!
! - SECH
!
    if (BEHesva%l_sech) then
        nomres(1) = 'K_DESSIC'
        call rcvalb(fami  , kpg   , ksp   ,&
                    '-'   , imate , ' '   , 'ELAS',&
                    0     , ' '   , [0.d0],&
                    1     , nomres, valres,&
                    codret, 1)
        kdessm = valres(1)
        call rcvalb(fami  , kpg   , ksp   ,&
                    '+'   , imate , ' '   , 'ELAS',&
                    0     , ' '   , [0.d0],&
                    1     , nomres, valres,&
                    codret, 1)
        kdessp = valres(1)
        epsbm  = -kdessm*(BEHesva%sech_refe-BEHesva%sech_prev)
        epsbp  = -kdessp*(BEHesva%sech_refe-BEHesva%sech_curr)
        do i_dim = 1, 3
           BEHesva%epsi_varc(i_dim)  = BEHesva%epsi_varc(i_dim) + epsbm
           BEHesva%depsi_varc(i_dim) = BEHesva%depsi_varc(i_dim) + epsbp - epsbm
        enddo
    endif
!
! - HYDR
!
    if (BEHesva%l_hydr) then
        nomres(1) = 'B_ENDOGE'
        call rcvalb(fami  , kpg   , ksp   ,&
                    '-'   , imate , ' '   , 'ELAS',&
                    0     , ' '   , [0.d0],&
                    1     , nomres, valres,&
                    codret, 1)
        bendom = valres(1)
        call rcvalb(fami  , kpg   , ksp   ,&
                    '+'  , imate , ' '   , 'ELAS',&
                    0     , ' '   , [0.d0],&
                    1     , nomres, valres,&
                    codret, 1)
        bendop = valres(1)
        epsbm  = -bendom*BEHesva%hydr_prev
        epsbp  = -bendop*BEHesva%hydr_curr
        do i_dim = 1, 3
           BEHesva%epsi_varc(i_dim)  = BEHesva%epsi_varc(i_dim) + epsbm
           BEHesva%depsi_varc(i_dim) = BEHesva%depsi_varc(i_dim) + epsbp - epsbm
        enddo
    endif
!
! - EPSA
!
    if (BEHesva%l_anel) then
        ASSERT(neps .le. 6)
        do k = 1, 3
            BEHesva%epsi_varc(k)  = BEHesva%epsi_varc(k)  + BEHesva%anel_prev(k)
            BEHesva%depsi_varc(k) = BEHesva%depsi_varc(k) + BEHesva%anel_curr(k) -&
                                    BEHesva%anel_prev(k)
        enddo
! ----- Nondiagonal terms of EPSA are rescaled with rac2
        do k = 4, neps
            BEHesva%epsi_varc(k)  = BEHesva%epsi_varc(k)  + BEHesva%anel_prev(k)*rac2
            BEHesva%depsi_varc(k) = BEHesva%depsi_varc(k) + (BEHesva%anel_curr(k)-&
                                    BEHesva%anel_prev(k))*rac2
        enddo
    endif
!
! - PTOT
!
    if (BEHesva%l_ptot) then
        nomres(1) = 'BIOT_COEF'
        call rcvalb(fami     , kpg      , ksp      ,&
                    '-'      , imate    , ' '      , 'THM_DIFFU',&
                    0        , ' '      , [0.d0]   ,&
                    1        , nomres(1), valres(1),&
                    codret(1), 1)
        if (codret(1) .ne. 0) then
            valres(1) = 0.d0
        endif
        biotm = valres(1)
        call rcvalb(fami     , kpg      , ksp      ,&
                    '+'      , imate    , ' '      , 'THM_DIFFU',&
                    0        , ' '      , [0.d0]   ,&
                    1        , nomres(1), valres(1),&
                    codret(1), 1)
        if (codret(1) .ne. 0) then
            valres(1) = 0.d0
        endif
        biotp = valres(1)
        nomres(1) = 'E'
        nomres(2) = 'NU'
        call rcvalb(fami  , kpg   , ksp   ,&
                    '-'   , imate , ' '   , 'ELAS',&
                    0     , ' '   , [0.d0],&
                    2     , nomres, valres,&
                    codret, 1)
        if (codret(1) .ne. 0) then
            valres(1) = 0.d0
        endif
        if (codret(2) .ne. 0) then
            valres(2) = 0.d0
        endif
        em  = valres(1)
        num = valres(2)
        call rcvalb(fami  , kpg   , ksp   ,&
                    '+'   , imate , ' '   , 'ELAS',&
                    0     , ' '   , [0.d0],&
                    2     , nomres, valres,&
                    codret, 1)
        if (codret(1) .ne. 0) then
            valres(1) = 0.d0
        endif
        if (codret(2) .ne. 0) then
            valres(2) = 0.d0
        endif
        ep  = valres(1)
        nup = valres(2)
        troikp = ep/(1.d0-2.d0*nup)
        troikm = em/(1.d0-2.d0*num)
        do i_dim = 1, 3
           BEHesva%epsi_varc(i_dim)  = BEHesva%epsi_varc(i_dim) + biotm/troikm*BEHesva%ptot_prev
           BEHesva%depsi_varc(i_dim) = BEHesva%depsi_varc(i_dim) + biotp/troikp*BEHesva%ptot_curr-&
                                       biotm/troikm*BEHesva%ptot_prev
        enddo
    endif
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Prepare strains from external state variables: ',&
                     BEHesva%epsi_varc(1:3),BEHesva%depsi_varc(1:3)
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! computeStrainMeca
!
! Prepare strains (substracting "thermic" strains to total strains to get mechanical part)
!
! In  l_pred           : flag if prediction
! In  l_czm            : flag for CZM models
! In  neps             : number of components of strains
! In  BEHesva           : parameters for external state variables
! IO  epsm             : In : total strains at beginning of current step time
!                        Out : mechanical strains at beginning of current step time
! IO  deps             : In : increment of total strains during current step time
!                        Out : increment of mechanical strains during current step time
!
! --------------------------------------------------------------------------------------------------
subroutine computeStrainMeca(l_pred, l_czm, neps, BEHesva, epsm, deps)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    aster_logical, intent(in) :: l_pred, l_czm
    integer, intent(in) :: neps
    type(Behaviour_ESVA), intent(in) :: BEHesva
    real(kind=8), intent(inout) :: epsm(neps), deps(neps)
! - Local
    real(kind=8) :: stran(12), dstran(12)
    integer :: k
!   ------------------------------------------------------------------------------------------------
    dstran(1:neps) = 0.d0
    stran(1:neps)  = 0.d0
    if ((neps .eq. 6) .or. (neps .eq. 4)) then
        if (l_pred) then
            dstran(1:6) = 0.d0
        else
            call dcopy(neps, deps, 1, dstran, 1)
            call daxpy(neps, -1.d0, BEHesva%depsi_varc, 1, dstran,1)
        endif
        call dcopy(neps, epsm, 1, stran, 1)
        call daxpy(neps, -1.d0, BEHesva%epsi_varc, 1, stran, 1)
    else if ((neps .eq. 3) .and. l_czm) then
! No thermic strains for cohesive elements
        if (l_pred) then
            dstran(1:3) = 0.d0
        else
            call dcopy(neps, deps, 1, dstran, 1)
        endif
        call dcopy(neps, epsm, 1, stran, 1)
    else if ((neps .eq. 12) .and. .not. BEHesva%l_anel) then
! For ENDO_HETEROGENE
        if (l_pred) then
            dstran(1:6) = 0.d0
        else
            call dcopy(neps, deps, 1, dstran, 1)
            do k = 1, 3
                dstran(k) = dstran(k) - BEHesva%depsi_varc(k)
            end do
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - epsm and deps become mechanical strains
!
    call dcopy(neps, stran, 1, epsm, 1)
    call dcopy(neps, dstran, 1, deps, 1)
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG>  Prepare strains for integration: ',&
                     neps,epsm(1:neps),deps(1:neps)
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! varcIsGEOM
!
! Detect 'GEOM' in external state variables
!
! Out l_varext_geom    : flag for GEOM in external state variables (AFFE_VARC)
!
! --------------------------------------------------------------------------------------------------
subroutine varcIsGEOM(l_varext_geom)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    aster_logical, intent(inout) :: l_varext_geom
! - Local
    character(len=8), parameter :: varc_geom = 'X'
    integer :: varc_indx
!   ------------------------------------------------------------------------------------------------
    l_varext_geom = ASTER_FALSE
!
! - Detect 'GEOM' external state variables
    if (ca_nbcvrc_ .eq. 0) then
        l_varext_geom = ASTER_FALSE
    else
        varc_indx = indik8(zk8(ca_jvcnom_), varc_geom, 1, ca_nbcvrc_)
        l_varext_geom = varc_indx .ne. 0
    endif
!
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG> Detect GEOM in external state variables: ',l_varext_geom
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! relaIsExte
!
! Detect if external solver (MFront, UMAT) is used
!
! In  carcri           : parameters for comportment
! Out l_mfront         : logical for mfront behaviour
! Out l_umat           : logical for umat behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine relaIsExte(carcri, l_mfront, l_umat)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    aster_logical, intent(out) :: l_mfront, l_umat
!   ------------------------------------------------------------------------------------------------
    l_mfront = ASTER_FALSE
    l_umat   = ASTER_FALSE
    if (nint(carcri(EXTE_PTR)) .ne. 0) then
        if (nint(carcri(EXTE_ESVA_PTR_NAME)) .ne. 0) then
            l_mfront = ASTER_TRUE
        else
            l_umat = ASTER_TRUE
        endif
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
!
end module Behaviour_module
