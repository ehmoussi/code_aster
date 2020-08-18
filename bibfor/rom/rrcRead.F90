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
    integer :: nbFieldBuild
    character(len=8)  :: modelDom, modelRom, mesh
    character(len=16) :: k16bid , answer, resultType
    character(len=24) :: grNodeInterf
    aster_logical :: lPrevDual, lCorrEF
    character(len=8)  :: resultDomName, resultRomName
    type(ROM_DS_Result) :: resultDom, resultRom
    character(len=8)  :: basePrimName, baseDualName
    type(ROM_DS_Empi) :: basePrim, baseDual
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
! ==================================================================================================
!
!  DEB - Provisoire en attendant RTA
!
! ==================================================================================================
!
    basePrimName  = ' '
    baseDualName  = ' '
    lCorrEF       = ASTER_FALSE
    lPrevDual     = ASTER_FALSE
    grNodeInterf  = ' '
!
! - Get primal base
!
    call getvid(' ', 'BASE_PRIMAL', scal = basePrimName)
    call romBaseGetInfo(basePrimName, basePrim)
!
! - Correction by finite element
!
    call getvtx(' ', 'CORR_COMPLET', scal = answer)
    lCorrEF = answer .eq. 'OUI'
!
! - Compute dual quantities ?
!
    call getvtx(' ', 'REST_DUAL', scal = answer)
    lPrevDual = answer .eq. 'OUI'
    if (lPrevDual) then
        call getvtx(' ', 'GROUP_NO_INTERF', scal = grNodeInterf)
    endif
!
! - Get dual base
!
    if (lPrevDual) then
        call getvid(' ', 'BASE_DUAL', scal = baseDualName)
        call romBaseGetInfo(baseDualName, baseDual)
    endif
!
! ==================================================================================================
!
!  FIN - Provisoire en attendant RTA
!
! ==================================================================================================
!
    nbFieldBuild  = 0
    nbFieldBuild  = nbFieldBuild + 1
    if (lPrevDual) then
        nbFieldBuild  = nbFieldBuild + 1
    endif
!
! - Construct list of reconstructed fields
!
    allocate(cmdPara%fieldBuild(nbFieldBuild))
!
! - For "primal"
!
    fieldBuild%lLinearSolve = ASTER_FALSE
    fieldBuild%lGappy       = ASTER_FALSE
    if (lCorrEF) then
        fieldBuild%lGappy    = ASTER_TRUE
        fieldBuild%lRIDTrunc = ASTER_FALSE
    endif
    fieldBuild%lLinearSolve = ASTER_TRUE
    fieldBuild%base         = basePrim
    call romFieldDSCopy(fieldBuild%base%mode, fieldDom)
    fieldBuild%fieldDom     = fieldDom
    fieldBuild%fieldRom     = fieldRom
    cmdPara%fieldBuild(1)   = fieldBuild
!
! - For "dual"

    if (lPrevDual) then
        fieldBuild%lLinearSolve          = ASTER_FALSE
        fieldBuild%lGappy                = ASTER_TRUE
        fieldBuild%lRIDTrunc             = ASTER_TRUE
        fieldBuild%grNodeRIDInterface    = grNodeInterf
        fieldBuild%base                  = baseDual
        call romFieldDSCopy(fieldBuild%base%mode, fieldDom)
        fieldBuild%fieldDom              = fieldDom
        fieldBuild%fieldRom              = fieldRom
        cmdPara%fieldBuild(2)            = fieldBuild
    endif
    cmdPara%nbFieldBuild = nbFieldBuild
!
end subroutine
