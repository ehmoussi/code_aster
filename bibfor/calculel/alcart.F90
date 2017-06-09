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

subroutine alcart(base, chinz, maz, nomgdz)
    implicit none
#include "jeveux.h"
#include "asterfort/jecrec.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeimpa.h"
#include "asterfort/jeimpo.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexatr.h"
#include "asterfort/nbec.h"
#include "asterfort/scalai.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=19) :: chin
    character(len=*) :: chinz, maz, nomgdz
    character(len=8) :: ma, nomgd
    character(len=*) :: base
! ----------------------------------------------------------------------
!     ENTREES:
!       BASE : BASE DE CREATION POUR LA CARTE : G/V/L
!      CHINZ : NOM DE LA CARTE A CREER
!        MAZ : NOM DU MAILLAGE ASSOCIE
!     NOMGDZ : NOM DE LA GRANDEUR
!     NGDMX  : NOMBRE MAXIMUM DE COUPLES ( ENTITE,VALE) A STOCKER
!     NMAMX  : DIMEMSION MAXIMUM DE L'OBJET LIMA
!                  (I.E. SOMME DES NOMBRES DE MAILLES DES GROUPES
!                    TARDIFS DE MAILLES)
!
!     SORTIES:
!     ON ALLOUE CHIN.DESC , CHIN.VALE , CHIN.NOMA ,CHIN.NOLI
!     ET CHIN.LIMA
!
!      SUR LA VOLATILE CHIN.NOMCMP ET CHIN.VALV
!
! ----------------------------------------------------------------------
!
!     FONCTIONS EXTERNES:
!     -------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: nec, jdesc, gd, ncmpmx, ngdmx, nmamx
    character(len=8) :: scal
    character(len=1) :: bas2
    integer :: noma, jbid
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: j1
!-----------------------------------------------------------------------
    call jemarq()
!     NGDMX ET NMAMX : SERVENT A DIMENSIONNER LES OBJETS
!      CES OBJETS SERONT AGRANDIS SI NECESSAIRE PAR NOCART
!     LE PARAMETRE NGDMX EST DELIBEREMENT MIS A 1 CAR IL Y A UN PROBLEME
!     AVEC LES CARTES CONSTANTES DANS CALCUL SI CELLE-CI ONT UNE
!     DIMENSION SUPERIEURE A 1
    ngdmx=1
    nmamx=1
!
    chin = chinz
    ma = maz
    nomgd = nomgdz
!
    bas2 = base
!
!     STOCKAGE DE MA:
!
    call wkvect(chin//'.NOMA', bas2//' V K8', 1, noma)
    zk8(noma-1+1) = ma
!
!
    call jenonu(jexnom('&CATA.GD.NOMGD', nomgd), gd)
    if (gd .eq. 0) then
        call utmess('F', 'CALCULEL_3', sk=nomgd)
    endif
    nec = nbec(gd)
    call jelira(jexnum('&CATA.GD.NOMCMP', gd), 'LONMAX', ncmpmx)
    scal = scalai(gd)
!
!     ALLOCATION DE DESC:
!
    call wkvect(chin//'.DESC', bas2//' V I', 3+ngdmx*(2+nec), jdesc)
    call jeecra(chin//'.DESC', 'DOCU', cval='CART')
    zi(jdesc-1+1) = gd
    zi(jdesc-1+2) = ngdmx
    zi(jdesc-1+3) = 0
!
!     ALLOCATION DE VALE:
!
    call wkvect(chin//'.VALE', bas2//' V '//scal(1:4), ngdmx*ncmpmx, j1)
!
!     ALLOCATION DE NOLI
!
    call wkvect(chin//'.NOLI', bas2//' V K24', ngdmx, j1)
!
!
!     ALLOCATION DE LIMA :
!     --------------------
    call jecrec(chin//'.LIMA', bas2//' V I', 'NU', 'CONTIG', 'VARIABLE',&
                ngdmx)
! -- ON SURDIMENSIONNE A CAUSE DE JEVEUX : PAS D'OBJET DE LONGUEUR 0
    call jeecra(chin//'.LIMA', 'LONT', nmamx+ngdmx, ' ')
! -- ON FAIT MONTER LA COLLECTION EN MEMOIRE
    call jeveuo(chin//'.LIMA', 'E', jbid)
    call jeveuo(jexatr(chin//'.LIMA','LONCUM'), 'E',jbid)
    zi(jbid)=1
!
!     ALLOCATION DES OBJETS DE TRAVAIL NECESSAIRES A NOCART:
    call wkvect(chin//'.NCMP', 'V V K8', ncmpmx, j1)
    call wkvect(chin//'.VALV', 'V V '//scal(1:4), ncmpmx, j1)
    call jedema()
end subroutine
