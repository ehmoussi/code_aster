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

subroutine verigd(nomgdz, lcmp, ncmp, iret)
! person_in_charge: jacques.pellet at edf.fr
! A_UTIL
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/kndoub.h"
#include "asterfort/knincl.h"
#include "asterfort/lxliis.h"
#include "asterfort/utmess.h"
!
    integer :: ncmp, iret
    character(len=*) :: nomgdz, lcmp(ncmp)
! ---------------------------------------------------------------------
! BUT: VERIFIER LA COHERENCE D'UNE LISTE DE CMPS D'UNE GRANDEUR.
! ---------------------------------------------------------------------
!     ARGUMENTS:
! LCMP   IN   V(K8) : LISTE DES CMPS A VERIFIER
! NCMP   IN   I     : LONGUEUR DE LA LISTE LCMP
! IRET   OUT  I     : CODE RETOUR :
!                     /0 : OK
!                     /1 : NOMGDZ N'EST PAS UNE GRANDEUR.
!                     /2 : UNE CMP (AU MOINS) EST EN DOUBLE DANS LCMP
!                     /3 : UNE CMP (AU MOINS) DE LCMP N'EST PAS UNE
!                          CMP DE NOMGDZ
!
!  SI IRET>0 : ON EMET SYSTEMATIQUEMENT UNE ALARME.
!              C'EST A L'APPELANT D'ARRETER LE CODE SI NECESSAIRE.
!----------------------------------------------------------------------
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
    integer :: gd, jcmpgd, ncmpmx, i1, k, ibid
    character(len=8) :: lcmp2(3000), nomgd
! DEB
    call jemarq()
    iret = 0
    nomgd = nomgdz
!
!
!     1. NOMGD EST BIEN LE NOM D'UNE GRANDEUR :
!     -----------------------------------------
    call jenonu(jexnom('&CATA.GD.NOMGD', nomgd), gd)
    if (gd .eq. 0) then
        call utmess('A', 'POSTRELE_57', sk=nomgd)
        iret = 1
        goto 30
    endif
    call jeveuo(jexnum('&CATA.GD.NOMCMP', gd), 'L', jcmpgd)
    call jelira(jexnum('&CATA.GD.NOMCMP', gd), 'LONMAX', ncmpmx)
!
!
!     2. ON RECOPIE LCMP DANS LCMP2 (K8) :
!     -------------------------------------------
    if (ncmp .gt. 3000) then
        call utmess('F', 'POSTRELE_13')
    endif
    do 10,k = 1,ncmp
    lcmp2(k) = lcmp(k)
    10 end do
!
!
!     3. LCMP2 N'A PAS DE DOUBLONS :
!     -----------------------------
    call kndoub(8, lcmp2, ncmp, i1)
    if (i1 .gt. 0) then
        call utmess('A', 'POSTRELE_55', sk=lcmp2(i1))
        iret = 2
        goto 30
    endif
!
!
!     3. LCMP2 EST INCLUSE DANS LA LISTE DES CMPS DE LA GRANDEUR :
!     -----------------------------------------------------------
    if (nomgd(1:5) .ne. 'VARI_') then
        call knincl(8, lcmp2, ncmp, zk8(jcmpgd), ncmpmx,&
                    i1)
        if (i1 .gt. 0) then
            valk(1) = lcmp2(i1)
            valk(2) = nomgd
            call utmess('A', 'POSTRELE_56', nk=2, valk=valk)
            iret = 3
            goto 30
        endif
    else
!       -- POUR NOMGD=VARI_* : CMP='V1','V2',..,'V999'
        do 20,k = 1,ncmp
        call lxliis(lcmp2(k) (2:8), ibid, i1)
        if ((lcmp2(k) (1:1).ne.'V') .or. (i1.gt.0)) then
            valk(1) = lcmp2(k)
            valk(2) = nomgd
            call utmess('A', 'POSTRELE_56', nk=2, valk=valk)
            iret = 3
            goto 30
        endif
20      continue
    endif
!
!
30  continue
    call jedema()
!
end subroutine
