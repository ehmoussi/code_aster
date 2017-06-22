! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine nmnume(model     , mesh    , result, compor, list_load, &
                  ds_contact, nume_dof, sdnume)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmprof.h"
#include "asterfort/nuendo.h"
#include "asterfort/nunuco.h"
#include "asterfort/nunuco_l.h"
#include "asterfort/nurota.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=24), intent(in) :: model
    character(len=8), intent(in) :: result
    character(len=24), intent(in) :: compor
    character(len=19), intent(in) :: list_load
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=24), intent(out) :: nume_dof
    character(len=19), intent(in) :: sdnume
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm - Initializations
!
! Create information about numbering
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model datastructure
! In  result           : name of result datastructure (EVOL_NOLI)
! In  compor           : name of <CARTE> COMPOR
! In  list_load        : list of loads
! In  ds_contact       : datastructure for contact management
! Out nume_dof         : name of numbering object (NUME_DDL)
! In  sdnume           : name of dof positions datastructure
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdnuro, sdnuen, sdnuco
!
! --------------------------------------------------------------------------------------------------
!

!
! - Create numbering 
!
    call nmprof(model               , result, list_load, nume_dof,&
                ds_contact%iden_rela)
!
! - Get position of large rotation dof
!
    sdnuro = sdnume(1:19)//'.NDRO'
    call nurota(model, nume_dof, compor, sdnuro)
!
! - Get position of damaged dof 
!
    sdnuen = sdnume(1:19)//'.ENDO'
    call nuendo(model, nume_dof, sdnuen)
!
! - Get position of contact dof 
!
    sdnuco = sdnume(1:19)//'.NUCO'
    if (ds_contact%l_form_cont) then
        call nunuco(nume_dof, sdnuco)
    endif
!
! - Get position of contact dof 
!
    sdnuco = sdnume(1:19)//'.NUCO'
    if (ds_contact%l_form_lac) then
        call nunuco(nume_dof, sdnuco)
        call nunuco_l(mesh, ds_contact, nume_dof, sdnume)
    endif  
!
end subroutine
