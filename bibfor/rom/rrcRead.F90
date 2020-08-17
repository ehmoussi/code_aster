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
! aslint: disable=W1003
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rrcRead(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infniv.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/romFieldDSCopy.h"
#include "asterfort/romResultGetInfo.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/romTableParaRead.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaRRC), intent(inout) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Initializations
!
! Read parameters
!
! --------------------------------------------------------------------------------------------------
!
! IO  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16), parameter :: keywFact = 'CHAM_GD'
    integer :: iFieldBuild, nbFieldBuild, nbret
    character(len=8)  :: modelDom, modelRom, mesh
    character(len=16) :: k16bid, resultType, operation
    character(len=24) :: grNodeInterf, fieldName
    aster_logical :: lLinearSolve, lRIDTrunc
    character(len=8)  :: resultDomName, resultRomName
    type(ROM_DS_Result) :: resultDom, resultRom
    character(len=8)  :: baseName
    type(ROM_DS_Empi) :: base
    type(ROM_DS_FieldBuild) :: fieldBuild
    type(ROM_DS_Field) :: fieldDom, fieldRom
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM16_1')
    endif
!
! - Initializations
!
    resultDomName = ' '
    resultRomName = ' '
    modelDom      = ' '
    modelRom      = ' '
    k16bid        = ' '
!
! - Get input results datastructures (reduced)
!
    call getvid(' ', 'RESULTAT_REDUIT', scal = resultRomName)
!
! - Construct datastructure for result (reduced)
!
    call romResultGetInfo(resultRomName, resultRom)
!
! - Get output datastructure (high fidelity)
!
    call getres(resultDomName, resultType, k16bid)
!
! - Construct datastructure for result (high fidelity)
!
    resultDom%resultType    = resultType
    resultDom%resultName    = resultDomName
    resultDom%nbStore       = resultRom%nbStore
    resultDom%lTablFromResu = ASTER_FALSE
!
! - Get reduced coordinates table (from user ? )
!
    call romTableParaRead(cmdPara%tablReduCoor)
    call romTableCreate(resultRom%resultName, cmdPara%tablReduCoor%tablResu)
!
! - Get model from reduced results
!
    call dismoi('MODELE', resultRom%resultName, 'RESULTAT', repk = modelRom)
!
! - Get model for high fidelity model
!
    call getvid(' ', 'MODELE', scal = modelDom)
!
! - Select mesh
!
    call dismoi('NOM_MAILLA', modelDom, 'MODELE', repk = mesh)
!
! - Save parameters in datastructure
!
    cmdPara%mesh      = mesh
    cmdPara%resultDom = resultDom
    cmdPara%resultRom = resultRom
    cmdPara%modelDom  = modelDom
    cmdPara%modelRom  = modelRom
!
! - Get options to reconstruct fields
!
    call getfac(keywFact, nbFieldBuild)
    ASSERT(nbFieldBuild .ge. 1)
    cmdPara%nbFieldBuild = nbFieldBuild
!
! - Allocate list of reconstructed fields
!
    allocate(cmdPara%fieldName(nbFieldBuild))
    allocate(cmdPara%fieldBuild(nbFieldBuild))
!
! - Read parameters
!
    do iFieldBuild = 1, nbFieldBuild
! ----- Get base
        call getvid(keywFact, 'BASE', iocc = iFieldBuild, scal = baseName, nbret = nbret)
        ASSERT(nbret .eq. 1)
        call romBaseGetInfo(baseName, base)

! ----- Get field type
        call getvtx(keywFact, 'NOM_CHAM', iocc = iFieldBuild, scal = fieldName, nbret = nbret)
        ASSERT(nbret .eq. 1)

! ----- Get operation
        call getvtx(keywFact, 'OPERATION', iocc = iFieldBuild, scal = operation, nbret = nbret)
        ASSERT(nbret .eq. 1)

! ----- Get other parameters
        lRIDTrunc    = ASTER_FALSE
        grNodeInterf = ' '
        call getvtx(keywFact, 'GROUP_NO_INTERF', iocc = iFieldBuild, scal = grNodeInterf,&
                    nbret = nbret)
        lRIDTrunc = nbret .ne. 0

! ----- Get reference field for complete domain from base
        call romFieldDSCopy(base%mode, fieldDom)

! ----- Is come from linear solving ?
        lLinearSolve = ASTER_FALSE
        lLinearSolve = fieldName .eq. 'TEMP' .or. fieldName .eq. 'DEPL'

! ----- Construct datastructure
        fieldBuild%operation          = operation
        fieldBuild%lLinearSolve       = lLinearSolve
        fieldBuild%lRIDTrunc          = lRIDTrunc
        fieldBuild%grNodeRIDInterface = grNodeInterf
        fieldBuild%base               = base
        fieldBuild%fieldDom           = fieldDom
        fieldBuild%fieldRom           = fieldRom

! ----- Save datastructure
        cmdPara%fieldName(iFieldBuild)  = fieldName
        cmdPara%fieldBuild(iFieldBuild) = fieldBuild

    end do
!
end subroutine
