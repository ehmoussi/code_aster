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

subroutine gmardm(nomgrm, modele, ier)
    implicit none

#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/getvtx.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexnom.h"
#include "asterfort/lteatt.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"

    integer, intent(out) :: ier
    character(len=8), intent(in) :: modele
    character(len=24), intent(in) :: nomgrm


!
! --------------------------------------------------------------------------------------------------
!
! Detecter s'il existe des elements de structure dans un group_ma dans un modele
!
! --------------------------------------------------------------------------------------------------
!
! In  nomgrm         : name of group_ma
! In  modele         : name of modele
! out  ier           : code retour (1 -> oui, 0 -> non)

    integer :: nma, kma, ibid, jma, ima
    character(len=24) :: karg, nomte
    integer, pointer :: v_model_elem(:) => null()
    character(len=8) :: noma

    call jemarq()
    ier = 0
    karg = nomgrm

    call dismoi('NOM_MAILLA', modele, 'MODELE', repk=noma)
    call jeveuo(modele//'.MAILLE', 'L', vi = v_model_elem)

    ! nombre de mailles dans le groupe : nma
    call jelira(jexnom(noma//'.GROUPEMA', karg), 'LONUTI', nma)
    
    ! -- UNE VERIFICATION PENDANT LE CHANTIER "GROUPES VIDES" :
    call jelira(jexnom(noma//'.GROUPEMA', karg), 'LONMAX', ibid)
    if (ibid .eq. 1) then
        ASSERT(nma.le.1)
    else
        ASSERT(nma.eq.ibid)
    endif

    ! verifier chaque maille 
    call jeveuo(jexnom(noma//'.GROUPEMA', karg), 'L', kma)
    do jma = 1, nma
        ima = zi(kma-1+jma)
        if (v_model_elem(ima) .ne. 0) then
            call jenuno(jexnum('&CATA.TE.NOMTE', v_model_elem(ima)), nomte)
            if (lteatt('COQUE','OUI', typel=nomte)) ier = 1
            if (lteatt('POUTRE','OUI', typel=nomte)) ier = 1
            if (lteatt('DISCRET','OUI', typel=nomte)) ier = 1
            if (ier == 1) exit
        endif
    end do
    call jedema()

end subroutine
