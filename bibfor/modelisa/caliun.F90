! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine caliun(charz, nomaz, nomoz)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit      none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/caraun.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/creaun.h"
#include "asterfort/elimun.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/listun.h"
#include "asterfort/surfun.h"
#include "asterfort/wkvect.h"
    character(len=*) :: charz
    character(len=*) :: nomaz
    character(len=*) :: nomoz
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT
!
! TRAITEMENT DE LIAISON_UNILATERALE DANS DEFI_CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
! IN  NOMA   : NOM DU MAILLAGE
! IN  NOMO   : NOM DU MODELE
!
!
!
!
    character(len=8) :: char, noma, nomo
    character(len=16) :: motfac
    integer :: iform
    integer :: nzocu, nnocu, ntcmp
    character(len=24) :: nolino, nopono
    character(len=24) :: lisnoe, poinoe
    character(len=24) :: nbgdcu, coefcu, compcu, multcu, penacu
    character(len=24) :: deficu, defico
    character(len=24) :: paraci, paracr, ndimcu
    integer :: jparci, jparcr, jdim
    integer :: zpari, zparr
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nomo = nomoz(1:8)
    char = charz
    noma = nomaz
    iform = 4
    motfac = 'ZONE'
    defico = char(1:8)//'.CONTACT'
    deficu = char(1:8)//'.UNILATE'
!
! --- RECUPERATION DU NOMBRE D'OCCURENCES
!
    call getfac(motfac, nzocu)
!
    if (nzocu .eq. 0) then
        goto 999
    endif
!
! --- CREATION SD PARAMETRES GENERAUX (NE DEPENDANT PAS DE LA ZONE)
!
    paraci = defico(1:16)//'.PARACI'
    zpari = cfmmvd('ZPARI')
    call wkvect(paraci, 'G V I', zpari, jparci)
    paracr = defico(1:16)//'.PARACR'
    zparr = cfmmvd('ZPARR')
    call wkvect(paracr, 'G V R', zparr, jparcr)
    zi(jparci+4-1) = iform
!
    ndimcu = deficu(1:16)//'.NDIMCU'
    call wkvect(ndimcu, 'G V I', 2, jdim)
!
! --- RECUPERATION CARACTERISTIQUES ELEMENTAIRES
!
    nbgdcu = '&&CALIUN.NBGDCU'
    compcu = '&&CARAUN.COMPCU'
    multcu = '&&CARAUN.MULTCU'
    coefcu = '&&CARAUN.COEFCU'
    penacu = '&&CARAUN.PENACU'
    call caraun(char, motfac, nzocu, nbgdcu, coefcu,&
                compcu, multcu, penacu, ntcmp)
!
! --- EXTRACTION DES NOEUDS
!
    nopono = '&&CALIUN.PONOEU'
    nolino = '&&CALIUN.LINOEU'
    call listun(noma, motfac, nzocu, nopono, nnocu,&
                nolino)
!
! --- ELIMINATION DES NOEUDS
!      SUPPRESSION DES DOUBLONS ENTRE MAILLE, GROUP_MA, NOEUD,GROUP_NO
!      SUPPRESSION DES NOEUDS DEFINIS DANS SANS_NOEUD ET SANS_GROUP_NO
!
    lisnoe = '&&CALIUN.LISNOE'
    poinoe = '&&CALIUN.POINOE'
    call elimun(noma, nomo, motfac, nzocu, nbgdcu,&
                compcu, nopono, nolino, lisnoe, poinoe,&
                nnocu)
!
! --- ELIMINATION DES COMPOSANTES ET CREATION FINALE DES SD
!
    call creaun(char, noma, nomo, nzocu, nnocu,&
                lisnoe, poinoe, nbgdcu, coefcu, compcu,&
                multcu, penacu)
!
! --- AFFICHAGE DES INFORMATIONS
!
    call surfun(char, noma)
!
! --- MENAGE
!
    call jedetr(nolino)
    call jedetr(nopono)
    call jedetr(lisnoe)
    call jedetr(poinoe)
    call jedetr(nbgdcu)
    call jedetr(coefcu)
    call jedetr(compcu)
    call jedetr(multcu)
    call jedetr(penacu)
!
999  continue
!
    call jedema()
!
end subroutine
