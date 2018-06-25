! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine dbr_calcpod_q(ds_empi, ds_snap, q)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/rsexch.h"
#include "asterfort/jelibe.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Empi), intent(in) :: ds_empi
    type(ROM_DS_Snap), intent(in) :: ds_snap
    real(kind=8), pointer :: q(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Create snapshots matrix [Q]
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! In  ds_snap          : datastructure for snapshot selection
! Out q                : pointer to [Q] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_snap, i_equa, i_node, i_cmp, i_pl, i_2d
    integer :: nb_snap, nb_slice, nb_cmp, n_2d, nb_equa
    integer :: nume_inst, iret
    character(len=8)  :: base_type, result
    character(len=24) :: field_name, list_snap
    integer, pointer :: v_list_snap(:) => null()
    type(ROM_DS_LineicNumb) :: ds_line
    real(kind=8), pointer :: v_field_resu(:) => null()
    character(len=24) :: field_resu = '&&ROM_FIELDRESU'
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_1')
    endif
!
! - Get parameters
!
    result       = ds_snap%result
    nb_snap      = ds_snap%nb_snap
    list_snap    = ds_snap%list_snap
    ds_line      = ds_empi%ds_lineic
    nb_equa      = ds_empi%nb_equa
    nb_cmp       = ds_empi%nb_cmp
    base_type    = ds_empi%base_type
    field_name   = ds_empi%field_name
    ASSERT(nb_snap .gt. 0)
    ASSERT(nb_equa .gt. 0)
!
! - Get list of snapshots
!
    call jeveuo(list_snap, 'L', vi = v_list_snap)
!
! - Prepare snapshots matrix
!
    AS_ALLOCATE(vr = q, size = nb_equa * nb_snap)
!
! - Save the [Q] matrix depend on which type of reduced base
!    
    if (base_type .eq. 'LINEIQUE') then
        nb_slice  =  ds_line%nb_slice
        do i_snap = 1, nb_snap
            nume_inst = v_list_snap(i_snap)
            call rsexch(' '  , result, field_name, nume_inst, field_resu, iret)
            ASSERT(iret .eq. 0)
            call jeveuo(field_resu(1:19)//'.VALE', 'L', vr = v_field_resu)
            do i_equa = 1, nb_equa
                i_node = (i_equa - 1)/nb_cmp + 1
                i_cmp  = i_equa - (i_node - 1)*nb_cmp
                i_pl   = ds_line%v_nume_pl(i_node)
                n_2d   = ds_line%v_nume_sf(i_node)
                i_2d   = (n_2d - 1)*nb_cmp + i_cmp
                q(i_2d + nb_equa*(i_pl - 1)/nb_slice + nb_equa*(i_snap - 1))= v_field_resu(i_equa)
            enddo
            call jelibe(field_resu(1:19)//'.VALE')
        enddo
    else
        do i_snap = 1, nb_snap
            nume_inst = v_list_snap(i_snap)
            call rsexch(' '  , result, field_name, nume_inst, field_resu, iret)
            ASSERT(iret .eq. 0)
            call jeveuo(field_resu(1:19)//'.VALE', 'L', vr = v_field_resu)
            do i_equa = 1, nb_equa
                q(i_equa + nb_equa*(i_snap - 1)) = v_field_resu(i_equa)
            end do
            call jelibe(field_resu(1:19)//'.VALE')
        enddo
    endif
!
end subroutine
