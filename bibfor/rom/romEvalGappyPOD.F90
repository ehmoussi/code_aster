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
subroutine romEvalGappyPOD(ds_para    , result, nb_store, v_matr_phi,&
                           v_coor_redu, ind_dual)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/rsexch.h"
#include "asterfort/utmess.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "blas/dgemm.h"
#include "blas/dgesv.h"
!
type(ROM_DS_ParaRRC), intent(in) :: ds_para
character(len=8), intent(in) :: result
integer, intent(in) :: nb_store
real(kind=8), pointer, intent(in) :: v_matr_phi(:)
real(kind=8), pointer, intent(out) :: v_coor_redu(:)
integer, intent(in) :: ind_dual
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Compute reduced coordinates with Gappy-POD
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_empi          : datastructure for empiric modes (on RID)
! In  result           : name of results datastructur
! In  nb_store         : number if times stored in results datastructures
! In  v_matr_phi       : pointer to [PHI] matrix
! In  ind_dual         : index to distinguish the base primal or dual
! Out v_coor_redu      : pointer to reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_Empi):: ds_empi
    integer :: ifm, niv
    integer :: nb_equa_rom, nb_mode, nb_equa_ridi = 0
    integer :: i_store, i_mode, nume_store, iret, i_ord
    integer(kind=4) :: info
    real(kind=8), pointer    :: v_matr(:) => null()
    real(kind=8), pointer    :: v_vect(:) => null()
    integer(kind=4), pointer :: IPIV(:) => null()
    character(len=24) :: field_rom
    real(kind=8), pointer    :: v_field_rom(:) => null()
    real(kind=8), pointer    :: v_field_rid(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    if (ind_dual .eq. 0) then
        ds_empi = ds_para%ds_empi_prim
    else
        ds_empi = ds_para%ds_empi_dual
    endif
    nb_mode = ds_empi%nb_mode
    if (niv .ge. 2) then
        call utmess('I', 'ROM6_31')
    endif
!
! - Allocate reduced coordinates matrix
!
    AS_ALLOCATE(vr = v_coor_redu, size = nb_mode*(nb_store-1))
!
! - Compute Gappy POD
!
    AS_ALLOCATE(vr = v_matr, size = nb_mode*nb_mode)
    AS_ALLOCATE(vr = v_vect, size = nb_mode)
    AS_ALLOCATE(vi4 = IPIV, size = nb_mode)
    if (ind_dual .eq. 0) then
        do i_store = 1, nb_store-1
            nume_store = i_store
            call rsexch(' ', result, ds_empi%field_name,&
                        nume_store, field_rom, iret)
            ASSERT(iret .eq. 0)
            call jeveuo(field_rom(1:19)//'.VALE', 'L', vr = v_field_rom)
            call jelira(field_rom(1:19)//'.VALE', 'LONMAX', nb_equa_rom)
            call dgemm('T', 'N', nb_mode, 1, nb_equa_rom, 1.d0,&
                       v_matr_phi, nb_equa_rom, v_field_rom, nb_equa_rom, 0.d0, v_vect, nb_mode)
            call dgemm('T', 'N', nb_mode, nb_mode, nb_equa_rom, 1.d0,&
                       v_matr_phi, nb_equa_rom, v_matr_phi, nb_equa_rom, 0.d0, v_matr, nb_mode)
            call dgesv(nb_mode, 1, v_matr, nb_mode, IPIV, v_vect, nb_mode, info)
            if (info .ne. 0) then
                call utmess('F', 'ROM6_32')
            endif
            do i_mode = 1, nb_mode
                v_coor_redu(i_mode+nb_mode*(i_store-1)) = v_vect(i_mode)
            enddo
        enddo
    else
        nb_equa_ridi =  ds_para%nb_equa_ridi
        do i_store = 1, nb_store-1
            nume_store = i_store
            call rsexch(' ', result, ds_empi%field_name,&
                        nume_store, field_rom, iret)
            ASSERT(iret .eq. 0)
            call jeveuo(field_rom(1:19)//'.VALE', 'L', vr = v_field_rom)
            AS_ALLOCATE(vr = v_field_rid, size = nb_equa_ridi)
            do i_ord = 1, ds_para%nb_equa_ridd
                if (ds_para%v_equa_ridi(i_ord) .ne. 0) then
                    v_field_rid(ds_para%v_equa_ridi(i_ord)) = v_field_rom(i_ord)
                endif
            enddo
            call dgemm('T', 'N', nb_mode, 1, nb_equa_ridi, 1.d0,&
                       v_matr_phi, nb_equa_ridi, v_field_rid, nb_equa_ridi, 0.d0, v_vect, nb_mode)
            call dgemm('T', 'N', nb_mode, nb_mode, nb_equa_ridi, 1.d0,&
                       v_matr_phi, nb_equa_ridi, v_matr_phi, nb_equa_ridi, 0.d0, v_matr, nb_mode)
            call dgesv(nb_mode, 1, v_matr, nb_mode, IPIV, v_vect, nb_mode, info)
            if (info .ne. 0) then
                call utmess('F', 'ROM6_32')
            endif
            do i_mode = 1, nb_mode
                v_coor_redu(i_mode+nb_mode*(i_store-1)) = v_vect(i_mode)
            enddo
            AS_DEALLOCATE(vr = v_field_rid)
        enddo
    endif
!
! - Clean
!
    AS_DEALLOCATE(vr = v_matr)
    AS_DEALLOCATE(vr = v_vect)
    AS_DEALLOCATE(vi4 = IPIV)
!
end subroutine
