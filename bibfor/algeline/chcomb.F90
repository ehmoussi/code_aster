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

subroutine chcomb(tablez, nomaou)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/tbexp2.h"
#include "asterfort/tbliva.h"
#include "asterfort/utmess.h"
    character(len=8) :: nomaou
    character(len=*) :: tablez
!.======================================================================
!
!      CHCOMB -- IL S'AGIT DE CHANGER LES VALEURS DES COORDONNEES
!                DES NOEUDS DU MAILLAGE DE NOM NOMAOU QUI SONT EXPRIMEES
!                DANS LE REPERE PRINCIPAL D'INERTIE AVEC POUR ORIGINE
!                LE CENTRE DE GRAVITE DE LA SECTION EN LEURS VALEURS
!                EXPRIMEES DANS UN REPERE AYANT LES MEMES DIRECTIONS
!                MAIS DONT L'ORIGINE EST SITUEE AU CENTRE DE
!                CISAILLEMENT-TORSION.
!                CE CHANGEMENT DE COORDONNEES EST NECESSAIRE
!                POUR CALCULER L'INERTIE DE GAUCHISSEMENT D'UNE POUTRE
!                DONT LA SECTION EST REPRESENTEE PAR LE MAILLAGE
!                NOMAOU QUI EST CONSTITUE D'ELEMENTS MASSIFS 2D.
!
!
!   ARGUMENT        E/S  TYPE         ROLE
!    TABLEZ         IN    K*      NOM D'UNE TABLE DE TYPE TABL_CARA_GEOM
!                                 ISSUE DE LA COMMANDE POST_ELEM.
!                                 CETTE TABLE CONTIENT LES COORDONNEES
!                                 DU CENTRE DE CISAILLEMENT-TORSION.
!    NOMAOU         IN    K*      NOM DU MAILLAGE REPRESENTANT LA
!                                 SECTION DE LA POUTRE MAILLEE AVEC
!                                 DES ELEMENTS MASSIFS 2D, LES
!                                 COORDONNEES DES NOEUDS ETANT DEFINIES
!                                 DANS LE REPERE PRINCIPAL D'INERTIE
!                                 DONT L'ORIGINE EST LE CENTRE DE
!                                 GRAVITE DE LA SECTION EN ENTREE
!                                 DE LA ROUTINE ET DANS CE MEME REPERE
!                                 DONT L'ORIGINE EST SITUEE AU CENTRE
!                                 DE CISAILLEMENT-TORSION EN SORTIE.
!.========================= DEBUT DES DECLARATIONS ====================
! -----  VARIABLES LOCALES
    integer :: ibid, iret, idcode, dimcoo, nbno, jcoor, idcoor, ino
    real(kind=8) :: r8b, xt, yt
    complex(kind=8) :: c16b
    character(len=8) :: k8b, noma
    character(len=19) :: table
    character(len=24) :: cooval, coodes
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
    call jemarq()
!
! --- INITIALISATIONS :
!     ---------------
    table = tablez
    cooval = nomaou//'.COORDO    .VALE'
    coodes = nomaou//'.COORDO    .DESC'
!
! --- VERIFICATION DES PARAMETRES DE LA TABLE
!     ---------------------------------------
    call tbexp2(table, 'MAILLAGE')
    call tbexp2(table, 'LIEU')
    call tbexp2(table, 'EY')
    call tbexp2(table, 'EZ')
!
! --- RECUPERATION DANS LA TABLE DES COORDONNEES DU CENTRE DE
! --- DE CISAILLEMENT-TORSION :
!     -----------------------
    call tbliva(table, 0, k8b, [ibid], [r8b],&
                [c16b], k8b, k8b, [r8b], 'MAILLAGE',&
                k8b, ibid, r8b, c16b, noma,&
                iret)
    call tbliva(table, 1, 'LIEU', [ibid], [r8b],&
                [c16b], noma, k8b, [r8b], 'EY',&
                k8b, ibid, xt, c16b, k8b,&
                iret)
    if (iret .ne. 0) then
        call utmess('F', 'MODELISA2_89')
    endif
    call tbliva(table, 1, 'LIEU', [ibid], [r8b],&
                [c16b], noma, k8b, [r8b], 'EZ',&
                k8b, ibid, yt, c16b, k8b,&
                iret)
    if (iret .ne. 0) then
        call utmess('F', 'MODELISA2_89')
    endif
!
! --- RECUPERATION DE LA DIMENSION DU MAILLAGE :
!     ----------------------------------------
    call jeveuo(coodes, 'L', idcode)
    dimcoo = -zi(idcode+2-1)
!
! --- NOMBRE DE NOEUDS DU MAILLAGE :
!     ----------------------------
    call dismoi('NB_NO_MAILLA', nomaou, 'MAILLAGE', repi=nbno)
!
! --- RECUPERATION DES COORDONNEES DES NOEUDS DU MAILLAGE :
!     ---------------------------------------------------
    call jeveuo(cooval, 'E', jcoor)
!
! --- CHANGEMENT D'ORIGINE DES COORDONNEES :
!     ------------------------------------
    do ino = 1, nbno
!
        idcoor = jcoor-1+dimcoo*(ino-1)
        zr(idcoor+1) = zr(idcoor+1) + xt
        zr(idcoor+2) = zr(idcoor+2) + yt
    end do
!
    call jedema()
!.============================ FIN DE LA ROUTINE ======================
end subroutine
