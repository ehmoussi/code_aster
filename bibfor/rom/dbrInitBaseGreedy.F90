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
subroutine dbrInitBaseGreedy(resultName, paraGreedy, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/romBaseCreate.h"
!
character(len=8), intent(in) :: resultName
type(ROM_DS_ParaDBR_Greedy), intent(in) :: paraGreedy
type(ROM_DS_Empi), intent(inout) :: base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Initializations for base - For greedy method
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure to save base
! In  paraGreedy       : datastructure for parameters (Greedy)
! IO  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbEqua, nbModeMaxi
    character(len=8)  :: model, mesh, matrName
    character(len=24) :: fieldRefe, fieldName
    character(len=4) :: fieldSupp
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_15')
    endif
!
! - Initializations
!
    model      = ' '
    mesh       = ' '
    matrName   = ' '
    fieldName  = ' '
    nbEqua     = 0
    nbModeMaxi = 0
!
! - Get "representative" matrix
!
    matrName   = paraGreedy%multiPara%matr_name(1)
!
! - Get information about model
!
    call dismoi('NOM_MODELE', matrName, 'MATR_ASSE', repk = model)
!
! - Get informations about fields
!
    call dismoi('NB_EQUA'   , matrName, 'MATR_ASSE', repi = nbEqua)
    call dismoi('NOM_MAILLA', model   , 'MODELE'   , repk = mesh)
!
! - For greedy algorithm: only displacements
!
    fieldName = 'DEPL'
    fieldSupp = 'NOEU'
    fieldRefe = paraGreedy%algoGreedy%solveDOM%syst_solu
!
! - Nomber of mode maxi given by user
!
    nbModeMaxi = paraGreedy%nbModeMaxi
!
! - For FSI: three basis
!
    if (paraGreedy%lStabFSI) then
        nbModeMaxi = 3*nbModeMaxi
    end if
!
! - Save in base
!
    base%resultName     = resultName
    base%baseType       = ' '
    base%lineicAxis     = ' '
    base%lineicSect     = ' '
    base%nbMode         = 0
    base%nbModeMaxi     = nbModeMaxi
    base%mode%fieldName = fieldName
    base%mode%fieldRefe = fieldRefe
    base%mode%fieldSupp = fieldSupp
    base%mode%mesh      = mesh
    base%mode%model     = model
    base%mode%nbEqua    = nbEqua
!
! - Create output datastructure
!
    call romBaseCreate(base, nbModeMaxi)
!
end subroutine
