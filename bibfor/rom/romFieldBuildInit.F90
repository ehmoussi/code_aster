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
subroutine romFieldBuildInit(mesh         , nbNodeMesh , listNode       ,&
                             nbFieldResult, resultField, resultFieldNume,&
                             resultRom    , modelRom   , tablReduCoor   ,&
                             fieldBuild)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/romBaseCreateMatrix.h"
#include "asterfort/romFieldBuildMatrPhiTruncate.h"
#include "asterfort/romFieldBuildOnDom.h"
#include "asterfort/romFieldBuildPrepCoorRedu.h"
#include "asterfort/romFieldBuildPrepNume.h"
#include "asterfort/romFieldGetRefe.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
integer, intent(in) :: nbNodeMesh
integer, pointer  :: listNode(:)
integer, intent(in)  :: nbFieldResult
character(len=16), pointer :: resultField(:)
integer, pointer :: resultFieldNume(:)
type(ROM_DS_Result), intent(in) :: resultRom
character(len=8), intent(in) :: modelRom
type(ROM_DS_TablReduCoor), intent(in) :: tablReduCoor
type(ROM_DS_FieldBuild), intent(inout) :: fieldBuild
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Field build
!
! Initializations
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : mesh
! In  nbNodeMesh       : number of nodes in mesh
! Ptr listNode         : pointer to list of nodes in mesh for selection
! In  nbFieldResult    : number of _active_ fields type in results datastructure
! Ptr resultField      : pointer to type of active fields in results datastructure
! Ptr resultFieldNume  : pointer to a storing index which is valid for active field
! In  resultRom        : reduced results
! In  modelRom         : model for redeuced results
! In  tablReduCoor     : table for reduced coordinates
! IO  fieldBuild       : field to reconstruct
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: fieldName
    type(ROM_DS_Empi) :: base
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    base      = fieldBuild%base
    fieldName = fieldBuild%fieldDom%fieldName
!
! - Debug print
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM17_1', sk = fieldName)
    endif
!
! - Get representative field on reduced domain: from results datastructure !
!
    call romFieldGetRefe(resultRom%resultName, modelRom           ,&
                         nbFieldResult       , resultField        , resultFieldNume,&
                         fieldName           , fieldBuild%fieldRom)
!
! - Prepare link between numbering
!
    call romFieldBuildPrepNume(mesh      , nbNodeMesh, listNode,&
                               fieldBuild)
!
! - Create [PHI] matrix
!
    call romBaseCreateMatrix(base, fieldBuild%matrPhi)
!
! - Truncation of [PHI] matrix
!
    if (fieldBuild%operation .eq. 'GAPPY_POD') then
        call romFieldBuildMatrPhiTruncate(fieldBuild)
    endif
!
! - Prepare reduced coordinates (or copy from results !)
!
    call romFieldBuildPrepCoorRedu(resultRom, tablReduCoor, fieldBuild)
!
! - Construct field on complete domain and all storing index
!
    call romFieldBuildOnDom(resultRom, fieldBuild)
!
end subroutine
