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

subroutine foninf(resu, typfon)
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=8) :: resu, typfon
!
!
!       ---------------------------------------------------------------
!       STOCKAGE D'INFOS UTILES DANS LA SD EN SORTIE DE DEFI_FOND_FISS
!       ---------------------------------------------------------------
!
! IN/OUT
!       RESU   : NOM DE LA SD EN SORTIE DE DEFI_FOND_FISS
!       TYPFON : TYPE DE FOND DE FISSURE
!
!
    integer ::  ibid, jinfo
    character(len=8) :: syme, confin
!
!     -----------------------------------------------------------------
!
    call jemarq()
!
!     RECUPERATION DU MOT-CLE SYME
    call getvtx(' ', 'SYME', scal=syme, nbret=ibid)
    ASSERT(syme.eq.'OUI'.or.syme.eq.'NON')
!
!     RECUPERATION DU MOT-CLE CONFIG_INIT
    call getvtx(' ', 'CONFIG_INIT', scal=confin, nbret=ibid)
    ASSERT(confin.eq.'DECOLLEE'.or.confin.eq.'COLLEE')
!
!     CREATION DE L'OBJET .INFO DANS LA SD FOND_FISS
    call wkvect(resu//'.INFO', 'G V K8', 3, jinfo)
!
!     STOCKAGE DU MOT-CLE SYME
    zk8(jinfo-1+1) = syme
!
!     STOCKAGE DU MOT-CLE CONFIG_INIT
    zk8(jinfo-1+2) = confin
!
!     STOCKAGE DU MOT-CLE TYPE_FOND
    zk8(jinfo-1+3) = typfon
!
    call jedema()
end subroutine
