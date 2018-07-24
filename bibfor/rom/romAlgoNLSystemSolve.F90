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
subroutine romAlgoNLSystemSolve(matr_asse, vect_2mbr, ds_algorom, vect_solu, l_update_redu_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/infniv.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mgauss.h"
#include "asterfort/mrmult.h"
#include "asterfort/jelira.h"
#include "asterfort/rsexch.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
#include "asterfort/utmess.h"
#include "blas/ddot.h"
!
character(len=24), intent(in) :: matr_asse
character(len=24), intent(in) :: vect_2mbr
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
character(len=19), intent(in) :: vect_solu
aster_logical, optional, intent(in) :: l_update_redu_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Solve reduced system
!
! --------------------------------------------------------------------------------------------------
!
! In  matr_asse        : matrix
! In  vect_2mbr        : second member
! In  ds_algorom       : datastructure for ROM parameters
! In  vect_solu        : solution
! In  l_update_redu    : flag for update reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=24) :: gamma = ' ', field_name = ' '
    real(kind=8), pointer :: v_gamma(:) => null()
    real(kind=8), pointer :: v_vect_2mbr(:) => null()
    integer :: nb_equa_2mbr, nb_equa_matr, nb_equa, nb_mode
    integer :: i_mode, j_mode, i_equa
    integer :: jv_matr, iret
    aster_logical :: l_hrom, l_rom, l_update_redu
    character(len=8) :: base
    character(len=19) :: mode
    real(kind=8) :: term1, term2, det, term
    real(kind=8), pointer :: v_matr_rom(:) => null()
    real(kind=8), pointer :: v_vect_rom(:) => null()
    real(kind=8), pointer :: v_mrmult(:) => null()
    real(kind=8), pointer :: v_mode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_40')
    endif
!
! - Get parameters
!
    l_rom       = ds_algorom%l_rom
    l_hrom      = ds_algorom%l_hrom
    gamma       = ds_algorom%gamma
    base        = ds_algorom%ds_empi%base
    nb_mode     = ds_algorom%ds_empi%nb_mode
    nb_equa     = ds_algorom%ds_empi%nb_equa
    field_name  = ds_algorom%ds_empi%field_name
    ASSERT(l_rom)
    l_update_redu = ASTER_TRUE
    if (present(l_update_redu_)) then
        l_update_redu = l_update_redu_
    endif
!
! - Access to reduced coordinates
!
    call jeveuo(gamma, 'E', vr = v_gamma)
!
! - Access to second member
!
    call jeveuo(vect_2mbr(1:19)//'.VALE', 'E'     , vr = v_vect_2mbr)
    call jelira(vect_2mbr(1:19)//'.VALE', 'LONMAX', nb_equa_2mbr)
    ASSERT(nb_equa .eq. nb_equa_2mbr)
!
! - Access to matrix
!
    call jeveuo(matr_asse(1:19)//'.&INT', 'L', jv_matr)
    call dismoi('NB_EQUA', matr_asse, 'MATR_ASSE', repi = nb_equa_matr)
    ASSERT(nb_equa .eq. nb_equa_matr)
!
! - Truncation of second member
!    
    if (l_hrom) then
        do i_equa = 1, nb_equa
            if (ds_algorom%v_equa_int(i_equa) .eq. 1) then
                v_vect_2mbr(i_equa) = 0.d0
            endif
        enddo
    endif
!
! - Allocate objects
!
    AS_ALLOCATE(vr = v_matr_rom, size = nb_mode*nb_mode)
    AS_ALLOCATE(vr = v_vect_rom, size = nb_mode)
    AS_ALLOCATE(vr = v_mrmult  , size = nb_equa)
!
! - Compute reduced objects
!
    do i_mode = 1, nb_mode
        call rsexch(' ', base, field_name, i_mode, mode, iret)
        call jeveuo(mode(1:19)//'.VALE', 'L', vr = v_mode)
        term1 = ddot(nb_equa, v_mode, 1, v_vect_2mbr, 1)
        v_vect_rom(i_mode) = term1
        call mrmult('ZERO', jv_matr, v_mode, v_mrmult, 1, .false._1)
        if (l_hrom) then
            do i_equa = 1, nb_equa
                if (ds_algorom%v_equa_int(i_equa) .eq. 1) then
                    v_mrmult(i_equa) = 0.d0
                endif
            end do
        endif
        do j_mode = 1, nb_mode
            call rsexch(' ', base, field_name, j_mode, mode, iret)
            call jeveuo(mode(1:19)//'.VALE', 'L', vr = v_mode)
            term2 = ddot(nb_equa, v_mode, 1, v_mrmult, 1)
            v_matr_rom(nb_mode*(i_mode-1)+j_mode) = term2
        end do 
    end do
!
! - Solve system
!    
    call mgauss('NFSP', v_matr_rom, v_vect_rom, nb_mode, nb_mode, 1, det, iret)
    if (l_update_redu) then
        v_gamma = v_gamma + v_vect_rom
    endif
!
! - Project in physical space
!    
    call vtzero(vect_solu)
    do i_mode = 1 , nb_mode
        term = v_vect_rom(i_mode)
        call rsexch(' ', base, field_name, i_mode, mode, iret)
        call vtaxpy(term, mode, vect_solu)
    enddo
!
! - Clean
!
    AS_DEALLOCATE(vr = v_matr_rom)
    AS_DEALLOCATE(vr = v_vect_rom)
    AS_DEALLOCATE(vr = v_mrmult  )
!
end subroutine
