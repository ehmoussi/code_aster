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

subroutine caveis(chargz)
    implicit none
!
!       CAVEIS -- TRAITEMENT DU MOT CLE FORCE_SOL
!
!      TRAITEMENT DU MOT CLE FORCE_SOL DE AFFE_CHAR_MECA
!
! -------------------------------------------------------
!  CHARGE        - IN    - K8   - : NOM DE LA SD CHARGE
!                - JXVAR -      -   LA  CHARGE STOCKE DANS L'OBJET
!                                   CHAR//'CHME.VEISS'
! -------------------------------------------------------
!
!.========================= DEBUT DES DECLARATIONS ====================
!
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/codent.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=*) :: chargz
! ------ VARIABLES LOCALES
    character(len=8) :: charge, maille
    character(len=24) :: obj, gnintf
    character(len=16) :: typbin
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
!-----------------------------------------------------------------------
    integer :: idveis, iffor, ifmis, n1, ng, nm, nv, npasm, ibin
!
!-----------------------------------------------------------------------
    call jemarq()
!
    call getfac('FORCE_SOL', nv)
!
    if (nv .eq. 0) goto 999
!
!
    charge = chargz
    obj = charge//'.CHME.VEISS'
!
    call wkvect(obj, 'G V K24', 8, idveis)
    ifmis=0
    call getvis('FORCE_SOL', 'UNITE_RESU_RIGI', iocc=1, scal=ifmis, nbret=n1)
    call codent(ifmis, 'D', zk24(idveis))
    ifmis=0
    call getvis('FORCE_SOL', 'UNITE_RESU_MASS', iocc=1, scal=ifmis, nbret=n1)
    call codent(ifmis, 'D', zk24(idveis+1))
    ifmis=0
    call getvis('FORCE_SOL', 'UNITE_RESU_AMOR', iocc=1, scal=ifmis, nbret=n1)
    call codent(ifmis, 'D', zk24(idveis+2))
    iffor=0
    call getvis('FORCE_SOL', 'UNITE_RESU_FORC', iocc=1, scal=iffor, nbret=n1)
    call codent(iffor, 'D', zk24(idveis+3))
    gnintf = ' '
    call getvtx('FORCE_SOL', 'GROUP_NO_INTERF', iocc=1, scal=gnintf, nbret=ng)
    zk24(idveis+4) = gnintf
    maille = ' '
    call getvtx('FORCE_SOL', 'SUPER_MAILLE', iocc=1, scal=maille, nbret=nm)
    zk24(idveis+5) = maille
    call getvis('FORCE_SOL', 'NB_PAS_TRONCATURE', iocc=1, scal=npasm, nbret=n1)
    call codent(npasm, 'D', zk24(idveis+6))
    call getvtx('FORCE_SOL', 'TYPE', iocc=1, scal=typbin, nbret=nm)
    ibin = 1
    if (typbin .ne. 'BINAIRE') then
        ibin = 0
    endif
    call codent(ibin, 'D', zk24(idveis+7))
!
999 continue
!
    call jedema()
!.============================ FIN DE LA ROUTINE ======================
end subroutine
