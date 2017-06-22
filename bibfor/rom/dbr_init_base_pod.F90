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

subroutine dbr_init_base_pod(base, ds_para_pod, nb_mode_maxi, l_reuse, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/rs_getfirst.h"
#include "asterfort/rsexch.h"
#include "asterfort/rscrsd.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: base
    type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
    integer, intent(in) :: nb_mode_maxi
    aster_logical, intent(in) :: l_reuse
    type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Prepare datastructure for empiric modes - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! In  ds_para_pod      : datastructure for parameters (POD)
! In  nb_mode_maxi     : maximum number of emprical modes
! In  l_reuse          : .true. if reuse
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret, nume_first
    integer :: nb_equa = 0, nb_node = 0, nb_mode_crea = 0
    character(len=8)  :: model = ' ', mesh = ' '
    character(len=16) :: field_name = ' '
    character(len=8)  :: axe_line = ' ', surf_num = ' ', base_type = ' ', result_in = ' '
    character(len=24) :: field_refe = '&&ROM_COMP.FIELD'
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_12')
    endif
!
! - Get informations from parameters
!
    result_in    = ds_para_pod%result_in
    field_name   = ds_para_pod%field_name(1:16)
    base_type    = ds_para_pod%base_type
    axe_line     = ds_para_pod%axe_line
    surf_num     = ds_para_pod%surf_num(1:8)
!
! - Get information about model
!
    call dismoi('NOM_MODELE', result_in, 'RESULTAT', repk = model)
!
! - Get informations about fields
!
    call rs_getfirst(result_in, nume_first)
    call rsexch(' ', result_in, field_name, nume_first, field_refe, iret)
    if (iret .ne. 0) then
        call utmess('F', 'ROM5_11', sk = field_name)
    endif
    call dismoi('NB_EQUA'     , field_refe, 'CHAM_NO' , repi = nb_equa) 
    call dismoi('NOM_MAILLA'  , field_refe, 'CHAM_NO' , repk = mesh)
    call dismoi('NB_NO_MAILLA', mesh      , 'MAILLAGE', repi = nb_node)
!
! - Create empiric base
!
    if (.not. l_reuse) then
        if (nb_mode_maxi .eq. 0) then
            nb_mode_crea = 10
        else
            nb_mode_crea = nb_mode_maxi
        endif
        if (niv .ge. 2) then
            call utmess('I', 'ROM7_11', si = nb_mode_crea)
        endif
        call rscrsd('G', base, 'MODE_EMPI', nb_mode_crea)
    endif
!
! - Save in empiric base
!
    ds_empi%base         = base
    ds_empi%field_name   = field_name
    ds_empi%field_refe   = field_refe
    ds_empi%mesh         = mesh
    ds_empi%model        = model
    ds_empi%base_type    = base_type
    ds_empi%axe_line     = axe_line
    ds_empi%surf_num     = surf_num
    ds_empi%nb_equa      = nb_equa
    ds_empi%nb_node      = nb_node
    ds_empi%nb_cmp       = nb_equa/nb_node
    ds_empi%nb_mode      = 0
!
end subroutine
