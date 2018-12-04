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
subroutine mmmcpt(mesh, ds_measure, ds_contact, cnsinr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfl.h"
#include "asterfort/mminfm.h"
#include "asterfort/nmrvai.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: cnsinr
type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Post-treatment
!
! Count contact status
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_contact       : datastructure for contact management
! In  cnsinr           : nodal field (CHAM_NO_S) for CONT_NOEU 
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_poin, i_zone, i_elem_slav, i_poin_elem
    integer :: nb_poin_elem, nb_elem_slav, nb_cont_zone, nb_node_mesh
    integer :: ztabf, zresu
    integer :: node_slav_nume
    integer :: elem_slav_indx
    integer :: jdecme
    integer :: node_status
    character(len=24) :: sdcont_tabfin
    real(kind=8), pointer :: v_sdcont_tabfin(:) => null()
    real(kind=8), pointer :: v_cnsinr_cnsv(:) => null()
    integer, pointer :: v_work(:) => null()
    aster_logical :: lveri
    integer :: nbliac, nbliaf
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initialisations
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
    nbliac = 0
    nbliaf = 0
!
! - Working vector
!
    call dismoi('NB_NO_MAILLA', mesh, 'MAILLAGE', repi=nb_node_mesh)
    AS_ALLOCATE(vi = v_work, size = nb_node_mesh)
!
! - Acces to contact objects
!
    ztabf = cfmmvd('ZTABF')
    zresu = cfmmvd('ZRESU')
    sdcont_tabfin = ds_contact%sdcont_solv(1:14)//'.TABFIN'
    call jeveuo(sdcont_tabfin, 'L', vr = v_sdcont_tabfin)
    call jeveuo(cnsinr(1:19)//'.CNSV', 'L', vr = v_cnsinr_cnsv)
!
! - Loop on contact zones
!
    i_poin = 1
    do i_zone = 1, nb_cont_zone
! ----- Get parameters on current zone
        lveri        = mminfl(ds_contact%sdcont_defi, 'VERIF' , i_zone)
        nb_elem_slav = mminfi(ds_contact%sdcont_defi, 'NBMAE' , i_zone)
        jdecme       = mminfi(ds_contact%sdcont_defi, 'JDECME', i_zone)
! ----- No computation
        if (lveri) then
            cycle
        endif
        do i_elem_slav = 1, nb_elem_slav
! --------- Get current slave element
            elem_slav_indx = jdecme + i_elem_slav
! --------- Number of contact (integration) points on current slave element
            call mminfm(elem_slav_indx, ds_contact%sdcont_defi, 'NPTM', nb_poin_elem)
! --------- Loop on contact (integration) points
            do i_poin_elem = 1, nb_poin_elem
                node_slav_nume = nint(v_sdcont_tabfin(ztabf*(i_poin-1)+25))
                if (node_slav_nume .gt. 0) then
                    if (v_work(node_slav_nume) .eq. 0) then
                        node_status = nint(v_cnsinr_cnsv(zresu*(node_slav_nume-1)+1))
                        if (node_status .ge. 1) then
                            nbliac = nbliac + 1
                            if (node_status .eq. 1) then
                                nbliaf = nbliaf + 1
                            endif
                        endif
                        v_work(node_slav_nume) = 1
                    endif
                endif
! ------------- Next point
                i_poin = i_poin + 1
            end do
        end do

    end do
!
    AS_DEALLOCATE(vi = v_work)
    call nmrvai(ds_measure, 'Cont_NCont', input_count = nbliac)
    call nmrvai(ds_measure, 'Cont_NFric', input_count = nbliaf)
!
    call jedema()
end subroutine
