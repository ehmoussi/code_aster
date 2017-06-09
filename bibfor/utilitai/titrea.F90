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

subroutine titrea(niv, nomcon, nomcha, nomobj, st,&
                  motfac, iocc, base, formr, nomsym,&
                  iordr)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getltx.h"
#include "asterc/getres.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/titre1.h"
#include "asterfort/titred.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=1) :: niv, st, base
    character(len=*) :: nomcon, nomcha, nomobj, motfac, formr
    integer :: iocc
    character(len=*), optional, intent(in) :: nomsym
    integer, optional, intent(in) :: iordr
!     CREATION D'UN TITRE ATTACHE A UN CONCEPT
!     ------------------------------------------------------------------
! IN  NIV    : K1  : NIVEAU DU TITRE 'T': TITRE 'S': SOUS-TITRE
!                                    'E': EXCEPTION
! IN  NOMCON : K8  : NOM DU RESULTAT
! IN  NOMCHA : K19 : NOM DU CHAMP A TRAITER DANS LE CAS D'UN RESULTAT
! IN  NOMOBJ : K24 : NOM DE L'OBJET DE STOCKAGE
! IN  ST     : K1  : STATUT 'D': ECRASEMENT DU (SOUS-)TITRE PRECEDENT
!                           'C': CONCATENATION (SOUS-)TITRE PRECEDENT
! IN  MOTFAC : K16 : NOM DU MOT CLE FACTEUR SOUS LEQUEL EST LE TITRE
! IN  IOCC   : IS  : OCCURRENCE CONCERNEE SI L'ON A UN MOT CLE FACTEUR
! IN  BASE   : IS  : NOM DE LA BASE OU EST CREE L'OBJET
! IN  FORMR  : K*  : FORMAT DES REELS DANS LE TITRE
!     ------------------------------------------------------------------
!
    integer :: vali
    character(len=8) :: cres
    character(len=24) :: valk
    character(len=16) :: nomcmd, cbid, motcle
    character(len=8) :: nomres, concep
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: l, ldon, llon, nbocc, nbtitr
!-----------------------------------------------------------------------
    call jemarq()
    cbid = '  '
    if (motfac .ne. '  ') then
        call getfac(motfac, nbocc)
        if (iocc .gt. nbocc .or. iocc .lt. 1) then
            call getres(nomres, concep, nomcmd)
            vali = iocc
            valk = motfac
            call utmess('A', 'UTILITAI7_4', sk=valk, si=vali)
            goto 9999
        endif
    endif
!
    call getres(cres, cbid, cbid)
    if (niv .eq. 'T') then
        motcle = 'TITRE'
    else if (niv .eq. 'E') then
        motcle = 'SOUS_TITRE'
    else if (cres .eq. '  ') then
        motcle = 'SOUS_TITRE'
    else
        motcle = '   '
    endif
!
    if (motcle .ne. '   ') then
        call getvtx(motfac, motcle, iocc=iocc, nbval=0, nbret=nbtitr)
        nbtitr = - nbtitr
    else
        nbtitr = 0
    endif
!
    if (nbtitr .eq. 0) then
!        --- TITRE PAR DEFAUT  ---
        call titred(niv, nomcon, nomcha, nbtitr)
        call jeveuo('&&TITRE .TAMPON.ENTREE', 'E', ldon)
        call jeveuo('&&TITRE .LONGUEUR', 'E', llon)
    else
!        --- TITRE UTILISATEUR ---
        call wkvect('&&TITRE .TAMPON.ENTREE', 'V V K80', nbtitr, ldon)
        call wkvect('&&TITRE .LONGUEUR     ', 'V V I  ', nbtitr, llon)
        call getvtx(motfac, motcle, iocc=iocc, nbval=nbtitr, vect=zk80(ldon),&
                    nbret=l)
        call getltx(motfac, motcle, iocc, 80, nbtitr,&
                    zi(llon), l)
    endif
    call titre1(st, nomobj, base, nbtitr, zk80(ldon),&
                zi(llon), formr, nomsym, iordr)
    call jedetr('&&TITRE .TAMPON.ENTREE')
    call jedetr('&&TITRE .LONGUEUR     ')
9999  continue
    call jedema()
end subroutine
