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

subroutine apvepa(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/apinfi.h"
#include "asterfort/cfdisi.h"
#include "asterfort/mminfi.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
     type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Check pairing
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: sdappa
    integer :: nb_cont_zone, nt_poin, nb_poin
    integer :: pair_type
    integer :: i_zone, i_poin, i_poin_zone
    integer :: nb_poin_none
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('APPARIEMENT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<Pairing> . Check pairing'
    endif
!
! - Pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
!
! - Initializations
!
    i_poin       = 1
    nb_poin_none = 1
!
! - Get parameters
!
    nt_poin      = cfdisi(ds_contact%sdcont_defi,'NTPT'  )
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
!
! - Loop on contact zones
!
    do i_zone = 1, nb_cont_zone
!
! ----- Parameters on current zone
!
        nb_poin = mminfi(ds_contact%sdcont_defi, 'NBPT' , i_zone)
!
! ----- Loop on points
!
        do i_poin_zone = 1, nb_poin
            call apinfi(sdappa, 'APPARI_TYPE', i_poin, pair_type)
            if (pair_type .le. 0) then
                nb_poin_none = nb_poin_none + 1
            endif
            i_poin = i_poin + 1
        end do
    end do
!
! - If all points are not paired
!
    if (nb_poin_none .eq. i_poin) then
        call utmess('A', 'APPARIEMENT_1')
    endif
!
end subroutine
