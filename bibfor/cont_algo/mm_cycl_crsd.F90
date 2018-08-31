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

subroutine mm_cycl_crsd(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/cfdisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Creating data structures
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cont_poin, nb_cont_zone
    character(len=24) :: sdcont_cyclis
    integer, pointer :: p_sdcont_cyclis(:) => null()
    character(len=24) :: sdcont_cycnbr
    integer, pointer :: p_sdcont_cycnbr(:) => null()
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    character(len=24) :: sdcont_cychis
    real(kind=8), pointer :: p_sdcont_cychis(:) => null()
    character(len=24) :: sdcont_cyccoe
    real(kind=8), pointer :: p_sdcont_cyccoe(:) => null()
    integer               :: n_cychis
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    n_cychis = ds_contact%n_cychis
    nb_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC' )
    nb_cont_zone  = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
!
! - Status saving (coded integer)
!
    sdcont_cyclis = ds_contact%sdcont_solv(1:14)//'.CYCLIS'
!
! - Cycling length
!
    sdcont_cycnbr = ds_contact%sdcont_solv(1:14)//'.CYCNBR'
!
! - Cycling state
!
    sdcont_cyceta = ds_contact%sdcont_solv(1:14)//'.CYCETA'
!
! - Cycling history
!
    sdcont_cychis = ds_contact%sdcont_solv(1:14)//'.CYCHIS'
!
! - Informations about ratios
!
    sdcont_cyccoe = ds_contact%sdcont_solv(1:14)//'.CYCCOE'
!
! - Creating cycling objects
!
    call wkvect(sdcont_cyclis, 'V V I', 4*nb_cont_poin, vi = p_sdcont_cyclis)
    call wkvect(sdcont_cycnbr, 'V V I', 4*nb_cont_poin, vi = p_sdcont_cycnbr)
    call wkvect(sdcont_cyceta, 'V V I', 4*nb_cont_poin, vi = p_sdcont_cyceta)
    call wkvect(sdcont_cychis, 'V V R', n_cychis*nb_cont_poin, vr = p_sdcont_cychis)
    call wkvect(sdcont_cyccoe, 'V V R', 6*nb_cont_zone, vr = p_sdcont_cyccoe)
!
    call jedema()
end subroutine
