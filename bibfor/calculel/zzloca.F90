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

subroutine zzloca(modele, ligrel, matez, sigma, signo,&
                  chvarc, resu)
    implicit none
#include "asterfort/calcul.h"
#include "asterfort/megeom.h"
#include "asterfort/utmess.h"
    character(len=*) :: modele, ligrel, matez, sigma, signo, chvarc, resu
!
!     BUT:
!         CALCUL DE L'ESTIMATEUR D'ERREUR SUR LES CONTRAINTES
!
!                 OPTION : 'CALC_ESTI_ERRE'
!
!     ENTREES:
!
!     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
!     MODELE : NOM DU MODELE
!     MATEZ  : NOM DU CONCEPT MATERIAU
!     SIGMA  : NOM DU CHAMP DE CONTRAINTES CALCULEES (CHAM_ELEM_SIEF_R)
!     SIGNO  : NOM DU CHAMP DE CONTRAINTES LISSEES
!     CHVARC : NOM DU CHAMP DE VARIABLE DE COMMANDE
!
!     SORTIE :
!
!      RESU   : NOM DU CHAM_ELEM_ERREUR PRODUIT
!               SI RESU EXISTE DEJA, ON LE DETRUIT.
! ......................................................................
!
    character(len=8) :: lpain(5), lpaout(1)
    character(len=16) :: option
    character(len=24) :: lchin(5), lchout(1), chgeom, mate
!
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    mate = matez
    call megeom(modele, chgeom)
!
    if (mate .eq. ' ') then
        call utmess('F', 'CALCULEL4_66')
    endif
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpain(2) = 'PMATERC'
    lchin(2) = mate
    lpain(3) = 'PSIEF_R'
    lchin(3) = sigma
    lpain(4) = 'PVARCPR'
    lchin(4) = chvarc
    lpain(5) = 'PSIGMA'
    lchin(5) = signo
!
    lpaout(1) = 'PERREUR'
    lchout(1) = resu
    option = 'CALC_ESTI_ERRE'
    call calcul('S', option, ligrel, 5, lchin,&
                lpain, 1, lchout, lpaout, 'G',&
                'OUI')
!
end subroutine
