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

subroutine op0089()
    implicit none
!     COMMANDE:  DEPL_INTERNE
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterfort/chpver.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/pjxxpr.h"
#include "asterfort/ssdein.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: ul, ug, mail, nocas
    character(len=16) :: kbi1, kbi2, corres, tysd
    character(len=8) :: ouiri, ouima, affick(2)
!
    integer :: isma,   ie, n1, lref
    character(len=8) :: noma, macrel, promes, modlms, noca
    character(len=19) :: method
    character(len=24) :: vref
    character(len=8), pointer :: nomacr(:) => null()
    character(len=8), pointer :: refm(:) => null()
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
!
    call infmaj()
    call getres(ul, kbi1, kbi2)
    call getvid(' ', 'DEPL_GLOBAL', scal=ug, nbret=n1)
    call getvtx(' ', 'SUPER_MAILLE', scal=mail, nbret=n1)
!
    call gettco(ug, tysd)
    if (tysd(1:4) .ne. 'CHAM') then
!       UG DE TYPE RESULTAT (POUR MODIF STRUCTURALE)
        call dismoi('NOM_MAILLA', ug, 'RESULTAT', repk=noma)
        call jeveuo(noma//'.NOMACR', 'L', vk8=nomacr)
!
        call jenonu(jexnom(noma//'.SUPMAIL', mail), isma)
!
        affick(1) = mail
        affick(2) = noma
        if (isma .le. 0) then
            call utmess('F', 'SOUSTRUC_26', nk=2, valk=affick)
        endif
!
        macrel= nomacr(isma)
!
        call dismoi('NOM_PROJ_MESU', macrel, 'MACR_ELEM_STAT', repk=promes)
        if (promes .eq. ' ') then
            call utmess('F', 'SOUSTRUC_79')
        endif
!
        vref = macrel//'.PROJM    .PJMRF'
        call jeveuo(vref, 'L', lref)
        kbi1=zk16(lref-1 +1)
        modlms=kbi1(1:8)
!
!       VERIFIER SI LES MATRICES MASSE ET RAIDEUR CONDENSEES
!       ONT ETE CALCULEES
        call jeveuo(macrel//'.REFM', 'L', vk8=refm)
!
        ouiri = refm(6)
        if (ouiri .ne. 'OUI_RIGI') then
            call utmess('F', 'SOUSTRUC_80')
        endif
!
        ouima = refm(7)
        if (ouima .ne. 'OUI_MASS') then
            call utmess('F', 'SOUSTRUC_81')
        endif
!
        corres = ' '
        noca = ' '
        method = ' '
        call pjxxpr(ug, ul, noma, modlms, corres,&
                    'G', noca, method)
!
    else
!       UG DE TYPE CHAM_NO
        call chpver('F', ug, 'NOEU', 'DEPL_R', ie)
        call dismoi('NOM_MAILLA', ug, 'CHAM_NO', repk=noma)
        call getvtx(' ', 'NOM_CAS', scal=nocas, nbret=n1)
        call ssdein(ul, ug, mail, nocas)
    endif
!
!
!     -- CREATION DE L'OBJET .REFD SI NECESSAIRE:
!     -------------------------------------------
!   call ajrefd(ug, ul, 'ZERO')
!
!
    call jedema()
!
end subroutine
