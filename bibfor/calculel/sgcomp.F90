! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine sgcomp(compor_curr, sigm, ligrel_currz, iret, &
                  type_stop)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/utmess.h"
#include "asterfort/cestas.h"
#include "asterfort/celces.h"
#include "asterfort/cesexi.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
!
    character(len=*), intent(in) :: compor_curr
    character(len=*), intent(in) :: sigm
    character(len=*), intent(in) :: ligrel_currz
    integer, intent(out) :: iret
    character(len=1), optional, intent(in) :: type_stop
!
! --------------------------------------------------------------------------------------------------
!
! Check the sous-points of the input stress field
!
! Is stress field is correct for the number of sous points ?
!
! --------------------------------------------------------------------------------------------------
!
! In  sigm          : stress field
! In  compor_curr   : current comportment
! In  ligrel_curr   : current LIGREL
! In  compor_prev   : previous comportment
!
! --------------------------------------------------------------------------------------------------
!
! ------------------------------------------------------------------
! routine simplifiée à partir de la routine vrcomp qui vérifie 
! les variables internes (composants, sous-points, etc.)
!-----------------------------------------------------------------------
!
    character(len=1) :: stop_erre
    character(len=19) :: sigm_r
    character(len=8) :: mesh_1, mesh_2
    aster_logical :: no_same_spg
    character(len=19) :: ligrel_curr, ligrel_prev
    character(len=19) :: dcel
    character(len=8), pointer :: dcelk(:) => null()
    character(len=8) :: mesh
    integer :: nb_elem
    integer, pointer :: cesd(:) => null()
    integer :: iad1, iad2
    integer :: i_elem, vali(3)
    aster_logical :: elem_in_curr, elem_in_prev
    integer :: nb_spg_prev
    integer :: nb_spg_curr
    character(len=8) :: name_elem
    integer, pointer :: repm(:) => null()
    integer, pointer :: repp(:) => null()
    integer :: jdceld, jdcell
    integer, pointer :: dcelv(:) => null()
    integer :: jce2d
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    no_same_spg = .false.
!
! - Error management
!
    iret = 0
    if (present(type_stop)) then
        stop_erre = type_stop
    else
        stop_erre = 'E'
    endif
!
! - Acces to reduced CARTE DCEL_I (see CESVAR) on current comportement
!
    dcel = compor_curr
    call jeveuo(dcel//'.CESD', 'L', vi=cesd)
    call jeveuo(dcel//'.CESK', 'L', vk8=dcelk)
    mesh = dcelk(1)
    nb_elem = cesd(1)
!
! - LIGREL
!
    ligrel_curr = ligrel_currz
    call dismoi('NOM_LIGREL', sigm, 'CHAM_ELEM', repk=ligrel_prev)
!
! - Chesk meshes
!
    call dismoi('NOM_MAILLA', compor_curr, 'CHAMP', repk=mesh_1)
    call dismoi('NOM_MAILLA', sigm, 'CHAMP', repk=mesh_2)
    if (mesh_1 .ne. mesh_2) then
        call utmess('F', 'COMPOR2_24')
    endif
!
! - Create reduced field for stress
!
    sigm_r        = '&&SGCOMP.SIGM_R'

    ! TRANSFORMER UN CHAM_ELEM (CELZ) EN CHAM_ELEM_S (CESZ)
    call celces(sigm, 'V', sigm_r)

    ! "TASSER" UN CHAM_ELEM_S
    call cestas(sigm_r)
!
! - Access to LIGREL
!
    call jeveuo(ligrel_curr//'.REPE', 'L', vi=repp)
    call jeveuo(ligrel_prev//'.REPE', 'L', vi=repm)
    call jeveuo(sigm_r//'.CESD', 'L', jce2d)
!
! - Acces to reduced CARTE DCEL_I (see CESVAR) on current comportement
!
    call jeveuo(dcel//'.CESD', 'L', jdceld)
    call jeveuo(dcel//'.CESV', 'L', vi=dcelv)
    call jeveuo(dcel//'.CESL', 'L', jdcell)

    do i_elem = 1, nb_elem
        elem_in_prev = repm(2*(i_elem-1)+1).gt.0
        elem_in_curr = repp(2*(i_elem-1)+1).gt.0
        call cesexi('C', jdceld, jdcell, i_elem, 1,&
                    1, 1, iad1)
        call cesexi('C', jdceld, jdcell, i_elem, 1,&
                    1, 2, iad2)
        if (iad1 .le. 0) then
            goto 40
        endif
!
! ----- Number of Gauss points/components
!
        ASSERT(iad2.gt.0)
        nb_spg_curr = dcelv(iad1)
        nb_spg_prev = zi(jce2d-1+5+4*(i_elem-1)+2)
!
! ----- Check number of Gauss sub-points
!
        if (nb_spg_curr .ne. 0 .and. nb_spg_prev .ne. 0) then
            if (nb_spg_curr .ne. nb_spg_prev) then
                call jenuno(jexnum(mesh//'.NOMMAI', i_elem), name_elem)
                vali(1) = nb_spg_prev
                vali(2) = nb_spg_curr
                call utmess('I', 'COMPOR2_52', sk=name_elem, ni=2, vali=vali)
                no_same_spg = .true.
                goto 40
            endif
        endif
 40     continue
    end do
!
    if (no_same_spg) then
        iret = 1
        call utmess(stop_erre, 'COMPOR2_54')
    endif

!
! - Clean
!
    call detrsd('CHAM_ELEM_S', sigm_r)
!
    call jedema()
!
end subroutine
