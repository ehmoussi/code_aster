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

subroutine utch19(cham19, nomma, nomail, nonoeu, nupo,&
                  nusp, ivari, nocmp, typres, valr,&
                  valc, vali, ier)
    implicit none
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utchdl.h"
#include "asterfort/utmess.h"
    integer :: nupo, ivari, ier, nusp, vali
    real(kind=8) :: valr
    complex(kind=8) :: valc
    character(len=*) :: cham19, nomma, nomail, nonoeu, nocmp, typres
!     EXTRAIRE UNE VALEUR DANS UN CHAM_ELEM.
! ----------------------------------------------------------------------
! IN  : CHAM19 : NOM DU CHAM_ELEM DONT ON DESIRE EXTRAIRE 1 COMPOSANTE
! IN  : NOMMA  : NOM DU MAILLAGE
! IN  : NOMAIL : NOM DE LA MAILLE A EXTRAIRE
! IN  : NONOEU : NOM D'UN NOEUD (POUR LES CHAM_ELEM "AUX NOEUDS").
!                  (SI CE NOM EST BLANC : ON UTILISE NUPO)
! IN  : NUPO   : NUMERO DU POINT A EXTRAIRE SUR LA MAILLE NOMAIL
! IN  : NUSP   : NUMERO DU SOUS_POINT A TESTER SUR LA MAILLE NOMAIL
!                (SI NUSP=0 : IL N'Y A PAS DE SOUS-POINT)
! IN  : IVARI  : NUMERO DE LA CMP (POUR VARI_R)
! IN  : NOCMP : NOM DE LA CMP A EXTRAIRE SUR LE POINT NUPO
! IN  : TYPRES : TYPE DU CHAMP ET DU RESULTAT (R/C).
! OUT : VALR   : VALEUR EXTRAITE (SI REEL)
! OUT : VALC   : VALEUR EXTRAITE (SI COMPLEXE)
! OUT : VALI   : VALEUR EXTRAITE (SI ENTIER)
! OUT : IER    : CODE RETOUR.
! ----------------------------------------------------------------------
!
    integer :: icmp, jcelv
    real(kind=8) :: r1, r2
    character(len=1) :: typrez
    character(len=4) :: type, kmpic
    character(len=19) :: chm19z
!     ------------------------------------------------------------------
!
    call jemarq()
    ier = 0
!
    chm19z = cham19(1:19)
    typrez = typres(1:1)
    call jelira(chm19z//'.CELV', 'TYPE', cval=type)
!
    ASSERT(type.eq.typrez)
    call dismoi('MPI_COMPLET', cham19, 'CHAM_ELEM', repk=kmpic)
    ASSERT(kmpic.eq.'OUI'.or.kmpic.eq.'NON')
!
    if (type .ne. 'R' .and. type .ne. 'C' .and. type .ne. 'I') then
        call utmess('E', 'UTILITAI5_29', sk=type)
    endif
!
    call utchdl(cham19, nomma, nomail, nonoeu, nupo,&
                nusp, ivari, nocmp, icmp)
!
!     SI TEST_RESU, ICMP PEUT ETRE = 0 :
    if (icmp .eq. 0) then
        ier=1
        valr=r8vide()
        valc=dcmplx(r8vide(),r8vide())
        goto 10
    endif
!
    call jeveuo(chm19z//'.CELV', 'L', jcelv)
    if (typrez .eq. 'R') then
        valr = zr(jcelv-1+icmp)
    else if (typrez.eq.'C') then
        valc = zc(jcelv-1+icmp)
    else if (typrez.eq.'I') then
        vali = zi(jcelv-1+icmp)
    endif
!
!     -- SI LE CHAMP N'EST PAS MPI_COMPLET, IL FAUT COMMUNIQUER
!        LA VALEUR EXTRAITE :
    if (kmpic .eq. 'NON') then
        if (typrez .eq. 'R') then
            call asmpi_comm_vect('MPI_SUM', 'R', scr=valr)
        else if (typrez.eq.'C') then
            r1=dble(valc)
            r2=dimag(valc)
            call asmpi_comm_vect('MPI_SUM', 'R', scr=r1)
            call asmpi_comm_vect('MPI_SUM', 'R', scr=r2)
            valc=dcmplx(r1,r2)
        endif
    endif
!
 10 continue
    call jedema()
end subroutine
