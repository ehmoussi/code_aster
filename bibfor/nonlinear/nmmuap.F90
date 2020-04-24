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
subroutine nmmuap(sddyna)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynkk.h"
#include "asterfort/wkvect.h"
#include "asterfort/utmess.h"
!
character(len=19), intent(in) :: sddyna
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Initializations
!
! Read parameters for dynamic: seismic method
!
! --------------------------------------------------------------------------------------------------
!
! In  sddyna           : datastructure for dynamic
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: k8bid, rep, multSuppMode
    character(len=24) :: matrix
    integer :: nbmd, nbEqua, na, nd, nbexci, nf, nv, iExci
    character(len=19) :: mafdep, mafvit, mafacc, mamula, mapsid
    integer :: jnodep, jnovit, jnoacc, jmltap, jpsdel
    aster_logical :: lMultAppui
    character(len=24) :: dynaNOSD
    character(len=24), pointer :: vDynaNOSD(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to dynamic datastructure
!
    dynaNOSD = sddyna(1:15)//'.NOM_SD'
    call jeveuo(dynaNOSD, 'E', vk24 = vDynaNOSD)
!
! - Get modes
!
    call getvid(' ', 'MODE_STAT', scal=multSuppMode, nbret=nbmd)
    ASSERT(nbmd .eq. 1)
    vDynaNOSD(6) = multSuppMode
    call dismoi('REF_RIGI_PREM', multSuppMode, 'RESU_DYNA', repk=matrix)
    call dismoi('NB_EQUA', matrix, 'MATR_ASSE', repi=nbEqua)
!
! - LECTURE EFFORTS MULTI-APPUIS
!
    nbexci = ndynin(sddyna,'NBRE_EXCIT')
    call ndynkk(sddyna, 'MUAP_MAFDEP', mafdep)
    call ndynkk(sddyna, 'MUAP_MAFVIT', mafvit)
    call ndynkk(sddyna, 'MUAP_MAFACC', mafacc)
    call ndynkk(sddyna, 'MUAP_MAMULA', mamula)
    call ndynkk(sddyna, 'MUAP_MAPSID', mapsid)
    call wkvect(mafdep, 'V V K8', nbexci, jnodep)
    call wkvect(mafvit, 'V V K8', nbexci, jnovit)
    call wkvect(mafacc, 'V V K8', nbexci, jnoacc)
    call wkvect(mamula, 'V V I', nbexci, jmltap)
    call wkvect(mapsid, 'V V R8', nbexci*nbEqua, jpsdel)
    lMultAppui = ASTER_FALSE
!
    do iExci = 1, nbexci
        call getvtx('EXCIT', 'MULT_APPUI', iocc=iExci, scal=rep, nbret=nd)
        if (rep(1:3) .eq. 'OUI') then
            lMultAppui = ASTER_TRUE
            zi(jmltap+iExci-1) = 1
! --------- Get accelerations
            call getvid('EXCIT', 'ACCE', iocc=iExci, scal=k8bid, nbret=na)
            if (na .ne. 0) then
                call getvid('EXCIT', 'ACCE', iocc=iExci, scal=zk8(jnoacc+iExci-1), nbret=na)
            endif
            call getvid('EXCIT', 'FONC_MULT', iocc=iExci, scal=k8bid, nbret=nf)
            if (nf .ne. 0) then
                call getvid('EXCIT', 'FONC_MULT', iocc=iExci, scal=zk8(jnoacc+iExci- 1), nbret=nf)
            endif
! --------- Get speeds
            call getvid('EXCIT', 'VITE', iocc=iExci, scal=zk8(jnovit+iExci-1), nbret=nv)
! --------- Get displacements
            call getvid('EXCIT', 'DEPL', iocc=iExci, scal=zk8(jnodep+iExci-1), nbret=nd)
        endif
    end do
!
    call jedema()
end subroutine
