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

subroutine comp_comp_save(mesh, compor, nb_cmp, v_info_valk, v_info_vali)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/comp_read_mesh.h"
#include "asterfort/Behaviour_type.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=19), intent(in) :: compor
    integer, intent(in) :: nb_cmp
    character(len=16), intent(in) :: v_info_valk(:)
    integer          , intent(in) :: v_info_vali(:)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (AFFE_MATERIAU)
!
! Save informations in COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  compor           : name of <CARTE> COMPOR
! In  nb_cmp           : number of components in <CARTE> COMPOR
! In  v_info_valk      : comportment informations (character)
! In  v_info_vali      : comportment informations (integer)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: list_elem_affe
    aster_logical :: l_affe_all
    integer :: nb_elem_affe
    integer :: iocc, nocc
    character(len=16) :: rela_comp, defo_comp, type_comp, type_cpla, mult_comp, kit_comp(4)
    character(len=16) :: post_iter
    integer :: nb_vari, nume_comp(4), nb_vari_exte, unit_comp, nb_vari_comp(4)
    character(len=16) :: keywordfact
    character(len=16), pointer :: v_compor_valv(:) => null()
    integer, pointer :: v_elem_affe(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    list_elem_affe = '&&COMPCOMPSAVE.LIST'
    keywordfact    = 'AFFE_COMPOR'
    call getfac(keywordfact, nocc)
!
! - Access to COMPOR <CARTE>
!
    call jeveuo(compor//'.VALV', 'E', vk16=v_compor_valv)
!
! - Read list
!
    do iocc = 1, nocc
!
! ----- Get options
!
        nume_comp(:)    = 0
        nb_vari_comp(:) = 0
        nb_vari_exte = v_info_vali(4*(iocc-1)+ 1)
        unit_comp    = v_info_vali(4*(iocc-1)+ 2)
        nb_vari      = v_info_vali(4*(iocc-1)+ 3)
        nume_comp(1) = v_info_vali(4*(iocc-1)+ 4)
        rela_comp    = v_info_valk(16*(iocc-1)+ 1)
        defo_comp    = v_info_valk(16*(iocc-1)+ 2)
        type_comp    = v_info_valk(16*(iocc-1)+ 3)
        type_cpla    = v_info_valk(16*(iocc-1)+ 4)
        kit_comp(1)  = v_info_valk(16*(iocc-1)+ 5)
        kit_comp(2)  = v_info_valk(16*(iocc-1)+ 6)
        kit_comp(3)  = v_info_valk(16*(iocc-1)+ 7)
        kit_comp(4)  = v_info_valk(16*(iocc-1)+ 8)
        mult_comp    = v_info_valk(16*(iocc-1)+ 14) 
        post_iter    = v_info_valk(16*(iocc-1)+ 16)
!
! ----- Set options in COMPOR <CARTE>
!
        v_compor_valv(NAME) = rela_comp
        write (v_compor_valv(NVAR),'(I16)') nb_vari
        v_compor_valv(DEFO) = defo_comp
        v_compor_valv(INCRELAS) = type_comp
        v_compor_valv(PLANESTRESS) = type_cpla
        write (v_compor_valv(NUME),'(I16)') nume_comp(1)
        v_compor_valv(MULTCOMP) = mult_comp
        v_compor_valv(KIT1_NAME) = kit_comp(1)
        v_compor_valv(KIT2_NAME) = kit_comp(2)
        v_compor_valv(KIT3_NAME) = kit_comp(3)
        v_compor_valv(KIT4_NAME) = kit_comp(4)
        v_compor_valv(POSTITER) = post_iter
        write (v_compor_valv(KIT1_NUME),'(I16)') nume_comp(2)
        write (v_compor_valv(KIT2_NUME),'(I16)') nume_comp(3)
        write (v_compor_valv(KIT1_NVAR),'(I16)') nb_vari_comp(1)
        write (v_compor_valv(KIT2_NVAR),'(I16)') nb_vari_comp(2)
        write (v_compor_valv(KIT3_NVAR),'(I16)') nb_vari_comp(3)
        write (v_compor_valv(KIT4_NVAR),'(I16)') nb_vari_comp(4)
!
! ----- Get list of elements where comportment is defined
!
        call comp_read_mesh(mesh          , keywordfact, iocc        ,&
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
