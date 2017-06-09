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

subroutine lrmmdi(fid, nomamd, typgeo, nomtyp, nnotyp,&
                  nmatyp, nbnoeu, nbmail, nbnoma, descfi,&
                  adapma)
! person_in_charge: nicolas.sellenet at edf.fr
!-----------------------------------------------------------------------
!     LECTURE DU MAILLAGE -  FORMAT MED - LES DIMENSIONS
!     -    -     -                  -         --
!-----------------------------------------------------------------------
!     LECTURE DU FICHIER MAILLAGE AU FORMAT MED
!               PHASE 0 : LA DESCRIPTION
!     ENTREES :
!       FID    : IDENTIFIANT DU FICHIER MED
!       NOMAMD : NOM MED DU MAILLAGE A LIRE
!       TYPGEO : TYPE MED POUR CHAQUE MAILLE
!       NOMTYP : NOM DES TYPES POUR CHAQUE MAILLE
!       NNOTYP : NOMBRE DE NOEUDS POUR CHAQUE TYPE DE MAILLES
!       DESCFI : DESCRIPTION DU FICHIER
!     SORTIES:
!       NMATYP : NOMBRE DE MAILLES PAR TYPE
!       NBNOEU : NOMBRE DE NOEUDS DU MAILLAGE
!       NBMAIL : NOMBRE DE MAILLES DU MAILLAGE
!       NBNOMA : NOMBRE CUMULE DE NOEUDS PAR MAILLE
!       ADAPMA : REPERAGE DU NUMERO D'ADAPTATION EVENTUEL
!-----------------------------------------------------------------------
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/as_mmhnme.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: fid
    integer :: nbnoeu, nbmail, nbnoma
    integer :: typgeo(*), nmatyp(*), nnotyp(*)
!
    character(len=8) :: nomtyp(*)
    character(len=*) :: nomamd
    character(len=*) :: adapma
    character(len=*) :: descfi
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
!
    integer :: ntymax
    parameter (ntymax = 69)
    integer :: edcoor
    parameter (edcoor=0)
    integer :: ednoeu
    parameter (ednoeu=3)
    integer :: typnoe
    parameter (typnoe=0)
    integer :: edconn
    parameter (edconn=1)
    integer :: edmail
    parameter (edmail=0)
    integer :: ednoda
    parameter (ednoda=0)
!
    integer :: codret
    integer :: iaux, jaux, ityp
!
    character(len=8) :: saux08
!
!
!     ------------------------------------------------------------------
    call jemarq()
!
!====
! 1. DIVERS NOMBRES
!====
!
! 1.1. ==> NOMBRE DE NOEUDS
!
    call as_mmhnme(fid, nomamd, edcoor, ednoeu, typnoe,&
                   iaux, nbnoeu, codret)
    if (codret .ne. 0) then
        call codent(codret, 'G', saux08)
        call utmess('F', 'MED_12', sk=saux08)
    endif
    if (nbnoeu .eq. 0) then
        call utmess('F', 'MED_21')
    endif
!
! 1.2. ==> NOMBRE DE MAILLES PAR TYPE ET LONGUEUR TOTALE DU TABLEAU
!          DE CONNECTIVITE NODALE
!
    nbmail = 0
    nbnoma = 0
!
    do 12 , ityp = 1 , ntymax
!
    if (typgeo(ityp) .ne. 0) then
!
        call as_mmhnme(fid, nomamd, edconn, edmail, typgeo(ityp),&
                       ednoda, nmatyp(ityp), codret)
        if (codret .ne. 0) then
            call utmess('A', 'MED_23', sk=nomtyp(ityp))
            call codent(codret, 'G', saux08)
            call utmess('F', 'MED_12', sk=saux08)
        endif
!
        nbmail = nbmail + nmatyp(ityp)
        nbnoma = nbnoma + nmatyp(ityp) * nnotyp(ityp)
!
    else
!
        nmatyp(ityp) = 0
!
    endif
!
    12 end do
!
    if (nbmail .eq. 0) then
        call utmess('F', 'MED_29')
    endif
!
!====
! 2. NUMERO D'ITERATION POUR L'ADAPTATION DE MAILLAGE
!    IL VAUT ZERO SAUF SI LE FICHIER A ETE ECRIT PAR HOMARD. ON TROUVE
!    ALORS LE NUMERO DANS LA DESCRIPTION DU FICHIER SOUS LA FORME :
!    DESCFI = 'HOMARD VN.P   NITER '
!              123456789012345678901
!====
!
    iaux = lxlgut(descfi)
    if (iaux .ge. 20) then
        if (descfi(1:6) .eq. 'HOMARD') then
            read ( descfi(17:21) , fmt='(I5)' ) jaux
        else
            jaux = 0
        endif
    else
        jaux = 0
    endif
!
    call wkvect(adapma, 'G V I', 1, iaux)
    zi(iaux) = jaux
!
!====
! 3. LA FIN
!====
!
    call jedema()
!
end subroutine
