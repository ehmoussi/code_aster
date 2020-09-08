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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine comp_meca_chck(model, mesh, fullElemField, lInitialState, behaviourPrep)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lccree.h"
#include "asterc/lcdiscard.h"
#include "asterc/lctest.h"
#include "asterfort/assert.h"
#include "asterfort/compMecaChckModel.h"
#include "asterfort/compMecaChckStrain.h"
#include "asterfort/comp_meca_full.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/compMecaSelectPlaneStressAlgo.h"
#include "asterfort/comp_read_mesh.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
!
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_info.h"
!
character(len=8), intent(in) :: model, mesh
character(len=19), intent(in) :: fullElemField
aster_logical, intent(in) :: lInitialState
type(Behaviour_PrepPara), intent(inout) :: behaviourPrep
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of behaviour (mechanics)
!
! Check with Comportement.py
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  fullElemField    : <CHELEM_S> of FULL_MECA option
! In  lInitialState    : .true. if initial state is defined
! IO  behaviourPrep    : datastructure to prepare behaviour
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16), parameter :: keywordfact = 'COMPORTEMENT'
    character(len=24), parameter :: cellAffe = '&&COMPMECASAVE.LIST'
    aster_logical :: lAllCellAffe
    integer :: nbCellAffe
    character(len=16) :: defoComp, relaComp, typeCpla, typeComp, reguVisc
    character(len=16) :: relaCompPY, defoCompPY
    integer :: iComp, nbComp, exteDefo, lctestIret
    character(len=24) :: ligrmo
    character(len=8) :: partit
    mpi_int :: nbCPU, mpiCurr
    aster_logical :: lElasByDefault, lNeedDeborst, lMfront, lDistParallel
!
! --------------------------------------------------------------------------------------------------
!
    nbComp = behaviourPrep%nb_comp
    lNeedDeborst   = ASTER_FALSE
    lElasByDefault = ASTER_FALSE
    lDistParallel  = ASTER_FALSE
!
! - MPI initialisation
!
    call asmpi_comm('GET', mpiCurr)
    call asmpi_info(mpiCurr, size=nbCPU)
!
! - Distributed parallelism
!
    ligrmo = model//'.MODELE'
    call dismoi('PARTITION', ligrmo, 'LIGREL', repk=partit)
    lDistParallel = partit .ne. ' ' .and. nbCPU .gt. 1
!
! - Loop on occurrences of COMPORTEMENT
!
    do iComp = 1, nbComp

! ----- Get list of cells where behaviour is defined
        call comp_read_mesh(mesh    , keywordfact , iComp     ,&
                            cellAffe, lAllCellAffe, nbCellAffe)

! ----- Get main parameters for this behaviour
        relaComp = behaviourPrep%v_para(iComp)%rela_comp
        defoComp = behaviourPrep%v_para(iComp)%defo_comp
        typeComp = behaviourPrep%v_para(iComp)%type_comp
        reguVisc = behaviourPrep%v_para(iComp)%regu_visc
        lMfront  = behaviourPrep%v_paraExte(iComp)%l_mfront_offi .or.&
                   behaviourPrep%v_paraExte(iComp)%l_mfront_proto
        exteDefo = behaviourPrep%v_paraExte(iComp)%strain_model

! ----- Coding comportment (Python)
        call lccree(1, relaComp, relaCompPY)
        call lccree(1, defoComp, defoCompPY)

! ----- Checking the consistency of the modelization with the behaviour
        call compMecaChckModel(iComp       ,&
                               model       , fullElemField ,&
                               lAllCellAffe, cellAffe      , nbCellAffe  ,&
                               relaCompPY  , lElasByDefault, lNeedDeborst)

! ----- Select plane stress algorithm
        typeCpla = behaviourPrep%v_para(iComp)%type_cpla
        call compMecaSelectPlaneStressAlgo(lNeedDeborst, typeCpla)
        behaviourPrep%v_para(iComp)%type_cpla = typeCpla

! ----- Checking the consistency of the strain model with the behaviour
        call compMecaChckStrain(iComp,&
                                model       , fullElemField,&
                                lAllCellAffe, cellAffe     , nbCellAffe,&
                                lMfront     , exteDefo     ,&
                                defoComp    , defoCompPY   ,&
                                relaComp    , relaCompPY)

! ----- Checking REGU_VISC
        if (reguVisc .ne. 'VIDE') then
            call lctest(relaCompPY, 'REGU_VISC', reguVisc, lctestIret)
            if (lctestIret .eq. 0) then
                call utmess('F', 'COMPOR1_33', nk = 2, valk = [reguVisc, relaComp])
            endif
        endif

! ----- No Deborst allowed with large strains models
        if (lNeedDeborst .and. defoComp .eq. 'GDEF_LOG') then
            call utmess('F', 'COMPOR1_13')
        endif
        if (lNeedDeborst .and. defoComp .eq. 'SIMO_MIEHE') then
            call utmess('F', 'COMPOR1_13')
        endif

! ----- No ENDO_HETEROGENE whith distributed parallelism
        if (relaComp .eq. 'ENDO_HETEROGENE') then
            if (lDistParallel) then
                call utmess('F', 'COMPOR5_25')
            endif
         endif

! ----- Warning if ELASTIC comportment and initial state
        if (lInitialState .and. typeComp .eq. 'COMP_ELAS') then
            call utmess('A', 'COMPOR1_61')
        endif

! ----- Coding comportment (Python)
        call lcdiscard(relaCompPY)
        call lcdiscard(defoCompPY)

    end do
!
! - Some general informations
!
    if (lNeedDeborst) then
        call utmess('I', 'COMPOR5_20')
    endif
    if (lElasByDefault) then
        call utmess('I', 'COMPOR5_21')
    endif
!
end subroutine
