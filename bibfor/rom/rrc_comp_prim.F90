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
subroutine rrc_comp_prim(cmdPara)
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
#include "asterfort/romResultSetZero.h"
#include "asterfort/romEvalGappyPOD.h"
!
type(ROM_DS_ParaRRC), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Compute
!
! Compute primal field
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret, jv_para
    integer :: nb_mode, nbEqua, nb_store, nb_equa_ridp
    integer :: i_mode, i_equa, i_store
    integer :: nume_store, nume_equa
    character(len=8) :: result_rom, result_dom
    real(kind=8), pointer :: v_prim_rom(:) => null()
    real(kind=8), pointer :: v_prim(:) => null()
    real(kind=8), pointer :: v_cohr(:) => null()
    real(kind=8), pointer :: v_disp_dom(:) => null()
    character(len=24) :: field_save
    real(kind=8), pointer :: v_field_save(:) => null()
    character(len=24) :: disp_rid
    real(kind=8), pointer :: v_disp_rid(:) => null()
    character(len=19) :: list_load
    character(len=24) :: materi, cara_elem, model_dom
    real(kind=8) :: time
    aster_logical :: l_corr_ef
    type(ROM_DS_Field)      :: ds_mode
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
    nb_store     = cmdPara%nb_store
    ds_mode      = cmdPara%ds_empi_prim%ds_mode
    nb_mode      = cmdPara%ds_empi_prim%nb_mode
    nbEqua       = ds_mode%nbEqua
    nb_equa_ridp = cmdPara%nb_equa_ridp
    result_rom   = cmdPara%result_rom
    result_dom   = cmdPara%result_dom
    model_dom    = cmdPara%model_dom
    l_corr_ef    = cmdPara%l_corr_ef
    ASSERT(ds_mode%fieldSupp .eq. 'NOEU')
!
! - Create [PHI] matrix for primal base
!
    call romBaseCreateMatrix(cmdPara%ds_empi_prim, v_prim)
!
! - Reduce [PHI] matrix on RID
!
    if (l_corr_ef) then
        AS_ALLOCATE(vr = v_prim_rom, size = nb_equa_ridp*nb_mode)
        do i_mode = 1, nb_mode
            do i_equa = 1, nbEqua
                if (cmdPara%v_equa_ridp(i_equa) .ne. 0) then
                    v_prim_rom(cmdPara%v_equa_ridp(i_equa)+nb_equa_ridp*(i_mode-1)) = &
                               v_prim(i_equa+nbEqua*(i_mode-1))
                endif
            enddo
        enddo
    endif
!
! - Initial state
!
    nume_store = 0
    call romResultSetZero(result_dom, nume_store, ds_mode)
!
! - Reduced coordinates: Gappy POD if necessary
!
    if (l_corr_ef) then
        call romEvalGappyPOD(cmdPara, result_rom, nb_store, v_prim_rom,&
                             v_cohr , 0)
    else
        call jeveuo(cmdPara%coorRedu, 'L', vr = v_cohr)
    endif
!
! - Compute new fields
!
    AS_ALLOCATE(vr = v_disp_dom, size = nbEqua*(nb_store-1))
    call dgemm('N', 'N', nbEqua, nb_store-1, nb_mode, 1.d0,&
                v_prim, nbEqua, v_cohr, nb_mode, 0.d0, v_disp_dom, nbEqua)
!
! - Compute new field
!
    do i_store = 1, nb_store-1
        nume_store = i_store
! ----- Get field to save
        call rsexch(' ', result_dom, ds_mode%fieldName,&
                    nume_store, field_save, iret)
        ASSERT(iret .eq. 100)
        call copisd('CHAMP_GD', 'G', ds_mode%fieldRefe, field_save)
        call jeveuo(field_save(1:19)//'.VALE', 'E', vr = v_field_save)
! ----- Get field on RID
        call rsexch(' ', result_rom, ds_mode%fieldName,&
                    nume_store, disp_rid, iret)
        ASSERT(iret .eq. 0)
        call jeveuo(disp_rid(1:19)//'.VALE', 'L', vr = v_disp_rid)
! ----- Set field
        do i_equa = 1, nbEqua
            nume_equa = cmdPara%v_equa_ridp(i_equa)
            if (cmdPara%v_equa_ridp(i_equa).eq. 0) then
                v_field_save(i_equa) = v_disp_dom(i_equa+nbEqua*(nume_store-1))
            else
                v_field_save(i_equa) = v_disp_rid(nume_equa)
            endif
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
        call rsnoch(result_dom, ds_mode%fieldName,&
                    nume_store)
    end do
!
! - Clean
!
    if (l_corr_ef) then
        AS_DEALLOCATE(vr = v_prim_rom)
        AS_DEALLOCATE(vr = v_cohr)
    endif
    AS_DEALLOCATE(vr = v_prim)
    AS_DEALLOCATE(vr = v_disp_dom)
!
end subroutine
