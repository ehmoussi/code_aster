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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_calcpod_ql(ds_empi, &
                          result , field_name , nb_equa,&
                          nb_snap, v_list_snap,&
                          q)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rsexch.h"
#include "asterfort/jelibe.h"
#include "asterfort/jeveuo.h"
!
type(ROM_DS_Empi), intent(in) :: ds_empi
character(len=8), intent(in) :: result
character(len=24), intent(in) :: field_name
integer, intent(in) :: nb_equa, nb_snap
integer, intent(in) :: v_list_snap(:)
real(kind=8), intent(inout) :: q(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Create snapshots matrix [Q] for lineic model
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes
! In  result           : results datastructure for selection (EVOL_*)
! In  field_name       : name of field where empiric modes have been constructed (NOM_CHAM)
! In  nb_equa          : number of equations (length of empiric mode)
! In  nb_snap          : number of snapshots used to construct empiric base
! In  v_list_snap      : pointer to snap selected to construct empiric base
! IO  q                : pointer to [Q] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_snap, i_equa, i_node, i_cmp, i_pl, i_2d
    integer :: nb_slice, n_2d, nb_cmp
    integer :: nume_inst, iret
    type(ROM_DS_LineicNumb) :: ds_line
    real(kind=8), pointer :: v_field_resu(:) => null()
    character(len=24) :: field_resu = '&&ROM_FIELDRESU'
!
! --------------------------------------------------------------------------------------------------
!
    ds_line   = ds_empi%ds_lineic
    nb_slice  = ds_line%nb_slice
    nb_cmp    = ds_line%nb_cmp
    ASSERT(nb_snap .gt. 0)
    ASSERT(nb_equa .gt. 0)
    ASSERT(nb_cmp .gt. 0)
!
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
!
end subroutine
