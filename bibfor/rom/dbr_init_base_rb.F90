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
subroutine dbr_init_base_rb(resultName, paraRb, base)
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
type(ROM_DS_ParaDBR_RB), intent(in) :: paraRb
type(ROM_DS_Empi), intent(inout) :: base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Prepare datastructure for modes - For RB
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure to save base
! In  paraRb           : datastructure for RB parameters
! IO  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbEqua, nb_mode_maxi
    character(len=8)  :: model, mesh, matr_name
    character(len=24) :: fieldRefe, fieldName
    character(len=4) :: fieldSupp
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_28')
    endif
!
! - Initializations
!
    model         = ' '
    mesh          = ' '
    matr_name     = ' '
    fieldName     = ' '
    nbEqua        = 0
    nb_mode_maxi  = 0
!
! - Get "representative" matrix
!
    matr_name    = paraRb%multipara%matr_name(1)
!
! - Get information about model
!
    call dismoi('NOM_MODELE', matr_name, 'MATR_ASSE', repk = model)
!
! - Get informations about fields
!
    call dismoi('NB_EQUA'     , matr_name, 'MATR_ASSE', repi = nbEqua)
    call dismoi('NOM_MAILLA'  , model    , 'MODELE'   , repk = mesh)
!
! - For greedy algorithm: only displacements
!
    fieldName = 'DEPL'
    fieldSupp = 'NOEU'
    fieldRefe = paraRb%algoGreedy%solveDOM%syst_solu
!
! - Nomber of mode maxi given by user
!
    nb_mode_maxi = paraRb%nb_mode_maxi
!
! - For FSI: three basis
!
    if (paraRb%l_stab_fsi) then
        nb_mode_maxi = 3*nb_mode_maxi
    end if
!
! - Save in base
!
    base%resultName     = resultName
    base%baseType       = ' '
    base%lineicAxis     = ' '
    base%lineicSect     = ' '
    base%nbMode         = 0
    base%nbModeMaxi     = nb_mode_maxi
    base%mode%fieldName = fieldName
    base%mode%fieldRefe = fieldRefe
    base%mode%fieldSupp = fieldSupp
    base%mode%mesh      = mesh
    base%mode%model     = model
    base%mode%nbEqua    = nbEqua
!
! - Create output datastructure
!
    call romBaseCreate(base, nb_mode_maxi)
!
end subroutine
