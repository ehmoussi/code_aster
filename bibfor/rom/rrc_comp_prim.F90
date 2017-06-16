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
subroutine rrc_comp_prim(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/rsexch.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rssepa.h"
#include "asterfort/rslesd.h"
#include "asterfort/copisd.h"
#include "asterfort/rsnoch.h"
#include "blas/dgemm.h"
#include "asterfort/romBaseCreateMatrix.h"
!
type(ROM_DS_ParaRRC), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Compute
!
! Compute primal field
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret, jv_para
    integer :: nb_mode, nb_equa, nb_store
    integer :: i_equa, i_store
    integer :: nume_store
    character(len=8) :: result_rom, result_dom
    real(kind=8), pointer :: v_prim(:) => null()
    real(kind=8), pointer :: v_cohr(:) => null()
    real(kind=8), pointer :: v_depl(:) => null()
    character(len=24) :: field_save
    real(kind=8), pointer :: v_field_save(:) => null()
    character(len=19) :: list_load
    character(len=24) :: materi, cara_elem, model_dom
    real(kind=8) :: time
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_21')
    endif
!
! - Get parameters
!
    nb_store   = ds_para%nb_store
    nb_mode    = ds_para%ds_empi_prim%nb_mode
    nb_equa    = ds_para%ds_empi_prim%nb_equa
    result_rom = ds_para%result_rom
    result_dom = ds_para%result_dom
    model_dom  = ds_para%model_dom
    call jeveuo(ds_para%coor_redu, 'L', vr = v_cohr)
!
! - Create [PHI] matrix for primal base
!
    call romBaseCreateMatrix(ds_para%ds_empi_prim, v_prim)
!
! - Initial state
!
    nume_store = 0
    call rsexch(' ', result_dom, ds_para%ds_empi_prim%field_name,&
                nume_store, field_save, iret)
    ASSERT(iret .eq. 100)
    call copisd('CHAMP_GD', 'G', ds_para%ds_empi_prim%field_refe, field_save)
    call jeveuo(field_save(1:19)//'.VALE', 'E', vr = v_field_save)
    v_field_save(1:nb_equa) = 0.d0
    call rsnoch(result_dom, ds_para%ds_empi_prim%field_name,&
                nume_store)
!
! - Compute new fields
!
    AS_ALLOCATE(vr = v_depl, size = nb_equa*(nb_store-1))
    call dgemm('N', 'N', nb_equa, nb_store-1, nb_mode, 1.d0,&
                v_prim, nb_equa, v_cohr, nb_mode, 0.d0, v_depl, nb_equa)
!
! - Compute new field
!
    do i_store = 1, nb_store-1
        nume_store = i_store
        call rsexch(' ', result_dom, ds_para%ds_empi_prim%field_name,&
                    nume_store, field_save, iret)
        ASSERT(iret .eq. 100)
        call copisd('CHAMP_GD', 'G', ds_para%ds_empi_prim%field_refe, field_save)
        call jeveuo(field_save(1:19)//'.VALE', 'E', vr = v_field_save)
        do i_equa = 1, nb_equa
            v_field_save(i_equa) = v_depl(i_equa+nb_equa*(nume_store-1))
        enddo
! ----- Get parameters
        call rslesd(result_rom , nume_store-1,&
                    materi_    = materi    ,&
                    cara_elem_ = cara_elem ,&
                    list_load_ = list_load )
        call rsadpa(result_rom, 'L', 1, 'INST', nume_store, 0, sjv=jv_para)
        time = zr(jv_para)
! ----- Save parameters
        call rssepa(result_dom, nume_store, model_dom, materi, cara_elem,&
                    list_load)
        call rsadpa(result_dom, 'E', 1, 'INST', nume_store, 0, sjv=jv_para)
        zr(jv_para) = time
        call rsnoch(result_dom, ds_para%ds_empi_prim%field_name,&
                    nume_store)
    end do
!
! - Clean
!
    AS_DEALLOCATE(vr = v_prim)
    AS_DEALLOCATE(vr = v_depl)
!
end subroutine
