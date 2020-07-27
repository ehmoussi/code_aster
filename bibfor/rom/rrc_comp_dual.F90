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
subroutine rrc_comp_dual(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/rsexch.h"
#include "asterfort/jeveuo.h"
#include "blas/dgemm.h"
#include "blas/dgesv.h"
#include "asterfort/rsnoch.h"
#include "asterfort/copisd.h"
#include "asterfort/romBaseCreateMatrix.h"
#include "asterfort/romResultSetZero.h"
#include "asterfort/romEvalGappyPOD.h"
!
type(ROM_DS_ParaRRC), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Compute
!
! Compute dual field
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_mode, nbEqua, nb_equa_ridi, nbStore
    integer :: iret, i_mode, i_equa, iStore, numeStore, i_ord, nume_equa
    character(len=8) :: result_rom, result_dom
    real(kind=8), pointer :: v_dual(:) => null()
    real(kind=8), pointer :: v_dual_rom(:) => null()
    real(kind=8), pointer :: v_sigm_dom(:) => null()
    real(kind=8), pointer :: v_sigm_rid(:) => null()
    real(kind=8), pointer :: v_sigm_rom(:) => null()
    real(kind=8), pointer :: v_cohr(:) => null()
    character(len=24) :: resultField, sigm_rid
    real(kind=8), pointer :: v_resultField(:) => null()
    type(ROM_DS_Field) :: ds_mode
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_22')
    endif
!
! - Get parameters
!
    nbStore      = ds_para%nb_store
    ds_mode      = ds_para%ds_empi_dual%ds_mode
    nb_mode      = ds_para%ds_empi_dual%nb_mode
    nbEqua       = ds_mode%nbEqua
    result_rom   = ds_para%result_rom
    result_dom   = ds_para%result_dom
    nb_equa_ridi = ds_para%nb_equa_ridi
    ASSERT(ds_mode%fieldSupp .eq. 'NOEU')
!
! - Create [PHI] matrix for dual base
!
    call romBaseCreateMatrix(ds_para%ds_empi_dual, v_dual)
!
! - Reduce [PHI] matrix on RID
!
    AS_ALLOCATE(vr = v_dual_rom, size = nb_equa_ridi*nb_mode)
    do i_mode = 1, nb_mode
        do i_equa = 1, nbEqua
            if (ds_para%v_equa_ridd(i_equa) .ne. 0) then
                v_dual_rom(ds_para%v_equa_ridd(i_equa)+nb_equa_ridi*(i_mode-1)) = &
                  v_dual(i_equa+nbEqua*(i_mode-1))
            endif 
        end do
    end do
!
! - Gappy POD 
!
    call romEvalGappyPOD(ds_para, result_rom, nbStore, v_dual_rom, v_cohr , 1)
!
! - Initial state
!
    numeStore = 0
    call romResultSetZero(result_dom, numeStore, ds_mode)
!
! - Compute new fields
!
    AS_ALLOCATE(vr = v_sigm_dom, size = nbEqua*(nbStore-1))
    call dgemm('N', 'N', nbEqua, nbStore-1, nb_mode, 1.d0, &
               v_dual, nbEqua, v_cohr, nb_mode, 0.d0, v_sigm_dom, nbEqua)
!
! - Compute new field
!
    do iStore = 1, nbStore-1
        numeStore = iStore
! ----- Get field to save
        call rsexch(' ', result_dom, ds_mode%fieldName,&
                    numeStore, resultField, iret)
        ASSERT(iret .eq. 100)
        call copisd('CHAMP_GD', 'G', ds_mode%fieldRefe, resultField)
        call jeveuo(resultField(1:19)//'.VALE', 'E', vr = v_resultField)
! ----- Get field on RID
        call rsexch(' ', result_rom, ds_mode%fieldName,&
                    numeStore, sigm_rid, iret)
        ASSERT(iret .eq. 0)
        call jeveuo(sigm_rid(1:19)//'.VALE', 'L', vr = v_sigm_rid)
! ----- Truncate the field
        AS_ALLOCATE(vr = v_sigm_rom, size = nb_equa_ridi)
        do i_ord = 1, ds_para%nb_equa_ridd
            if (ds_para%v_equa_ridi(i_ord) .ne. 0) then
                v_sigm_rom(ds_para%v_equa_ridi(i_ord)) = v_sigm_rid(i_ord)
            endif
        enddo
! ----- Set field
        do i_equa = 1, nbEqua
            nume_equa = ds_para%v_equa_ridd(i_equa)
            if (nume_equa .eq. 0) then
                v_resultField(i_equa) = v_sigm_dom(i_equa+nbEqua*(numeStore-1))
            else
                v_resultField(i_equa) = v_sigm_rom(nume_equa)
            endif
        enddo
        call rsnoch(result_dom, ds_mode%fieldName, numeStore)
        AS_DEALLOCATE(vr = v_sigm_rom)
    enddo
!
! - Clean
!
    AS_DEALLOCATE(vr  = v_dual)
    AS_DEALLOCATE(vr  = v_dual_rom)
    AS_DEALLOCATE(vr  = v_cohr)
    AS_DEALLOCATE(vr  = v_sigm_dom)
!
end subroutine
