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
subroutine rrcChck(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/romFieldGetInfo.h"
#include "asterfort/romModeChck.h"
#include "asterfort/romTableChck.h"
#include "asterfort/rsGetAllFieldType.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: meshRefe, meshRom
    character(len=8) :: modelRom, modelDom, modelRefe
    character(len=8) :: resultRomName
    character(len=24) :: fieldName, fieldResultName
    type(ROM_DS_Field) :: mode
    integer :: nbMode, nbStore
    integer :: iFieldResult, iFieldBuild
    integer :: nbFieldResult, nbFieldBuild
    character(len=16), pointer :: resultField(:) => null()
    integer, pointer :: resultFieldNume(:) => null()
    aster_logical :: lInResult, lLinearSolve, lTablFromResu, lBuild
!
! --------------------------------------------------------------------------------------------------
!
    modelRom      = cmdPara%modelRom
    modelDom      = cmdPara%modelDom
    resultRomName = cmdPara%resultRom%resultName
    nbFieldBuild  = cmdPara%nbFieldBuild
!
! - Check mesh and model
!
    meshRefe = cmdPara%mesh
    call dismoi('NOM_MAILLA', modelRom, 'MODELE', repk = meshRom)
    if (meshRefe .ne. meshRom) then
        call utmess('F', 'ROM16_25')
    endif
    if (modelRom .eq. modelDom) then
        call utmess('A', 'ROM16_23')
    endif
!
! - Check bases
!
    mode = cmdPara%fieldBuild(1)%base%mode
    call romModeChck(mode)
    ASSERT(mode%fieldSupp .eq. 'NOEU')
    if (modelDom .ne. mode%model) then
        call utmess('F', 'ROM16_22') 
    endif
    modelRefe = mode%model
    do iFieldBuild = 2, nbFieldBuild
        mode = cmdPara%fieldBuild(iFieldBuild)%base%mode
        call romModeChck(mode)
        ASSERT(mode%fieldSupp .eq. 'NOEU')
        if (meshRefe .ne. mode%mesh) then
            call utmess('F', 'ROM16_20')
        endif
        if (modelRefe .ne. mode%model) then
            call utmess('F', 'ROM16_21')
        endif
        if (modelDom .ne. mode%model) then
            call utmess('F', 'ROM16_22')
        endif
    end do
!
! - Get list of type of fields in a results datastructure (at least for ONE storing index)
!
    call rsGetAllFieldType(resultRomName, nbFieldResult, resultField, resultFieldNume)
!
! - Checks consistency between list of fields in result and list of fields to reconstruct
!
    do iFieldBuild = 1, nbFieldBuild
        lInResult = ASTER_FALSE
        fieldName = cmdPara%fieldName(iFieldBuild)
        do iFieldResult = 1, nbFieldResult
            if (fieldName .eq. resultField(iFieldResult)) then
                lInResult = ASTER_TRUE
                exit
            endif
        end do
        if (.not. lInResult) then
            call utmess('F', 'ROM16_24', sk = fieldName)
        endif
    end do
!
! - Checks which fields should been reconstructed
!
    call utmess('I', 'ROM16_30')
    do iFieldResult = 1, nbFieldResult
        fieldResultName = resultField(iFieldResult)
        lBuild          = ASTER_FALSE
        do iFieldBuild = 1, nbFieldBuild
            fieldName = cmdPara%fieldName(iFieldBuild)
            if (fieldName .eq. fieldResultName) then
                lBuild = ASTER_TRUE
            endif
        end do
        if (lBuild) then
            call utmess('I', 'ROM16_31', sk = fieldResultName)
        else
            call utmess('I', 'ROM16_32', sk = fieldResultName)
        endif
    end do
!
! - Check if COOR_REDUIT is OK (NB: no initial state => nbStore = nbStore - 1)
!
    lTablFromResu = cmdPara%resultRom%lTablFromResu
    nbStore       = cmdPara%resultRom%nbStore - 1
    do iFieldBuild = 1, nbFieldBuild
        lLinearSolve = cmdPara%fieldBuild(iFieldBuild)%lLinearSolve
        if (lLinearSolve) then
            nbMode        = cmdPara%fieldBuild(iFieldBuild)%base%nbMode
            call romTableChck(cmdPara%tablReduCoor, lTablFromResu, nbMode, nbStoreIn_ = nbStore)
        endif
    end do
!
! - Clean
!
    AS_DEALLOCATE(vk16 = resultField)
    AS_DEALLOCATE(vi = resultFieldNume)
!
end subroutine
