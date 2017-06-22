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

subroutine cfverl(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cfdisl.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES)
!
! VERIFICATION FACETTISATION
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
!
! ----------------------------------------------------------------------
!
    character(len=8) :: nomnoe
    integer :: nnoeu, ier
    integer :: ino, nbno
    real(kind=8) :: angle
    character(len=19) :: sdappa
    character(len=24) :: apverk, apvera
    integer :: jlistn, jlista
    aster_logical :: lliss
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    call jeexin(sdappa(1:19)//'.VERK', ier)
    lliss = cfdisl(ds_contact%sdcont_defi,'LISSAGE')
!
! --- SD VERIFICATION FACETTISATION
!
    apverk = sdappa(1:19)//'.VERK'
    apvera = sdappa(1:19)//'.VERA'
    call jeveuo(apverk, 'L', jlistn)
    call jeveuo(apvera, 'L', jlista)
    call jelira(apverk, 'LONUTI', ival=nnoeu)
    call jelira(apverk, 'LONMAX', ival=nbno)
    if ((nnoeu.eq.0) .or. (lliss)) goto 999
!
    call utmess('I', 'CONTACT3_19', si=nnoeu)
!
    do ino = 1, nbno
        nomnoe = zk8(jlistn+ino-1)
        angle = zr(jlista+ino-1)
        if (nomnoe .ne. ' ') then
            write(6,100) nomnoe,angle
        endif
    end do
!
100 format (a8,3x,f8.2)
!
999 continue
!
    call jedema()
end subroutine
