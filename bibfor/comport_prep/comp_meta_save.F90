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
subroutine comp_meta_save(mesh, compor, nb_cmp, ds_comporMeta)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/comp_read_mesh.h"
#include "asterfort/assert.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
!
character(len=8), intent(in) :: mesh
character(len=19), intent(in) :: compor
integer, intent(in) :: nb_cmp
type(META_PrepPara), intent(in) :: ds_comporMeta
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (metallurgy)
!
! Save informations in COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  compor           : name of <CARTE> COMPOR
! In  nb_cmp           : number of components in <CARTE> COMPOR
! In  ds_comporMeta    : datastructure to prepare comportement
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: list_elem_affe
    aster_logical :: l_affe_all
    integer :: nb_elem_affe
    integer :: i_comp, nb_comp
    integer :: nb_vari, nume_comp
    character(len=16) :: phase_type, loi_meta, keywordfact
    character(len=16), pointer :: v_compor_valv(:) => null()
    integer, pointer :: v_elem_affe(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact    = 'COMPORTEMENT'
    list_elem_affe = '&&COMPMETASAVE.LIST'
    nb_comp        = ds_comporMeta%nb_comp
!
! - Access to COMPOR <CARTE>
!
    call jeveuo(compor//'.VALV', 'E', vk16=v_compor_valv)
!
! - Read list
!
    do i_comp = 1, nb_comp
!
! ----- Get options
!
        phase_type = ds_comporMeta%v_comp(i_comp)%phase_type
        loi_meta   = ds_comporMeta%v_comp(i_comp)%loi_meta
        nb_vari    = ds_comporMeta%v_comp(i_comp)%nb_vari
        nume_comp  = ds_comporMeta%v_comp(i_comp)%nume_comp
!
! ----- Set options in COMPOR <CARTE>
!
        v_compor_valv(1) = phase_type
        write (v_compor_valv(2),'(I16)') nb_vari
        v_compor_valv(3) = loi_meta
        write (v_compor_valv(4),'(I16)') nume_comp
!
! ----- Get list of elements where comportment is defined
!
        call comp_read_mesh(mesh          , keywordfact, i_comp        ,&
                            list_elem_affe, l_affe_all , nb_elem_affe)
!
! ----- Affect in COMPOR <CARTE>
!
        if (l_affe_all) then
            call nocart(compor, 1, nb_cmp)
        else
            call jeveuo(list_elem_affe, 'L', vi = v_elem_affe)
            call nocart(compor, 3, nb_cmp, mode = 'NUM', nma = nb_elem_affe,&
                        limanu = v_elem_affe)
            call jedetr(list_elem_affe)
        endif
    end do
!
    call jedetr(compor//'.NCMP')
    call jedetr(compor//'.VALV')
!
end subroutine
