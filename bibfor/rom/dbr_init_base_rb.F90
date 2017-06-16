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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_init_base_rb(base, ds_para_rb, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/rscrsd.h"
!
character(len=8), intent(in) :: base
type(ROM_DS_ParaDBR_RB), intent(in) :: ds_para_rb
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Prepare datastructure for empiric modes - For RB methods
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! In  ds_para_rb       : datastructure for parameters (RB)
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_equa = 0, nb_node = 0, nb_mode = 0
    character(len=8)  :: model = ' ', mesh = ' ', matr_name = ' '
    character(len=24) :: field_refe
    character(len=24) :: field_name = ' '
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_28')
    endif
!
! - Get "representative" matrix
!
    nb_mode   = ds_para_rb%nb_mode_maxi
    matr_name = ds_para_rb%multipara%matr_name(1)
!
! - Get information about model
!
    call dismoi('NOM_MODELE', matr_name, 'MATR_ASSE', repk = model)
!
! - Get informations about fields
!
    call dismoi('NB_EQUA'     , matr_name, 'MATR_ASSE', repi = nb_equa) 
    call dismoi('NOM_MAILLA'  , model    , 'MODELE'   , repk = mesh)
    call dismoi('NB_NO_MAILLA', mesh     , 'MAILLAGE' , repi = nb_node)
    field_name = 'DEPL'
    field_refe = ds_para_rb%solveDOM%syst_solu
!
! - Save in empiric base
!
    ds_empi%base         = base
    ds_empi%field_name   = field_name
    ds_empi%field_refe   = field_refe
    ds_empi%mesh         = mesh
    ds_empi%model        = model
    ds_empi%base_type    = ' '
    ds_empi%axe_line     = ' '
    ds_empi%surf_num     = ' '
    ds_empi%nb_node      = nb_node
    ds_empi%nb_mode      = 0
    ds_empi%nb_equa      = nb_equa
    ds_empi%nb_cmp       = nb_equa/nb_node
!
! - Create output datastructure
!
    call rscrsd('G', base, 'MODE_EMPI', nb_mode)
!
end subroutine
