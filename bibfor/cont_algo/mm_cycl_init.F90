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

subroutine mm_cycl_init(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfl.h"
#include "asterfort/mminfm.h"
#include "asterfort/mminfr.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Initialization of data structures
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cychis
    real(kind=8), pointer :: p_sdcont_cychis(:) => null()
    character(len=24) :: sdcont_cyccoe
    real(kind=8), pointer :: p_sdcont_cyccoe(:) => null()
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    integer :: i_cont_poin
    integer :: i_cyc
    integer :: zone_index, nb_cont_zone
    integer :: slave_elt_index, slave_elt_nb, slave_elt_shift, slave_elt_num
    integer :: slave_pt_index, slave_pt_nb
    real(kind=8) :: coef_cont, coef_frot, coef_init
    aster_logical :: lveri
    integer               :: n_cychis
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
    n_cychis     = ds_contact%n_cychis
!
! - Access to cycling objects
!
    sdcont_cychis = ds_contact%sdcont_solv(1:14)//'.CYCHIS'
    sdcont_cyccoe = ds_contact%sdcont_solv(1:14)//'.CYCCOE'
    sdcont_cyceta = ds_contact%sdcont_solv(1:14)//'.CYCETA'
    call jeveuo(sdcont_cychis, 'E', vr = p_sdcont_cychis)
    call jeveuo(sdcont_cyccoe, 'E', vr = p_sdcont_cyccoe)
    call jeveuo(sdcont_cyceta, 'E', vi = p_sdcont_cyceta)
!
! - Init history
!
    i_cont_poin = 1
    do zone_index = 1, nb_cont_zone
        lveri = mminfl(ds_contact%sdcont_defi,'VERIF' ,zone_index)
        slave_elt_nb = mminfi(ds_contact%sdcont_defi,'NBMAE' ,zone_index)
        slave_elt_shift = mminfi(ds_contact%sdcont_defi,'JDECME',zone_index)
        coef_cont = mminfr(ds_contact%sdcont_defi,'COEF_AUGM_CONT',zone_index)
        coef_frot = mminfr(ds_contact%sdcont_defi,'COEF_AUGM_FROT',zone_index)
        p_sdcont_cyccoe(6*(zone_index-1)+1) = coef_cont
        p_sdcont_cyccoe(6*(zone_index-1)+2) = coef_frot
        p_sdcont_cyccoe(6*(zone_index-1)+3) = +1.d12
        p_sdcont_cyccoe(6*(zone_index-1)+4) = -1.d12
        p_sdcont_cyccoe(6*(zone_index-1)+5) = +1.d12
        p_sdcont_cyccoe(6*(zone_index-1)+6) = -1.d12
        if (lveri) goto 25
!
! ----- Loop on slave elements
!
        do slave_elt_index = 1, slave_elt_nb
!
! --------- Absolute number of slave element
!
            slave_elt_num = slave_elt_shift + slave_elt_index
!
! --------- Number of points on slave element
!
            call mminfm(slave_elt_num, ds_contact%sdcont_defi, 'NPTM', slave_pt_nb)
!
! --------- Loop on points
!
            do slave_pt_index = 1, slave_pt_nb
                do i_cyc =1,60 
                    p_sdcont_cychis(n_cychis*(i_cont_poin-1) + i_cyc) = 0
                enddo
                coef_init = p_sdcont_cyccoe(6*(zone_index-1)+1) 
                if (nint(ds_contact%update_init_coefficient) .eq. 1) &
                    coef_init = ds_contact%estimated_coefficient
                do i_cyc =1,4 
                    p_sdcont_cyceta(4*(i_cont_poin-1) + i_cyc) = -1
                enddo
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+2) = coef_init
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+6) = coef_frot
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+60) = zone_index
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+59) = 1.0
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+56) = 1.0
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = 1.0
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = 1.0
                p_sdcont_cychis(n_cychis*(i_cont_poin-1)+51) = 1.0
                i_cont_poin = i_cont_poin + 1
            end do
        end do
 25     continue
    end do
!
    call jedema()
end subroutine
