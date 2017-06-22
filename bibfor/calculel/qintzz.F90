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

subroutine qintzz(modele, ligrel, matez, sigmap, sigmad,&
                  signop, signod, resu)
    implicit none
#include "asterfort/calcul.h"
#include "asterfort/mecact.h"
#include "asterfort/megeom.h"
#include "asterfort/utmess.h"
    character(len=*) :: modele, ligrel, matez, sigmap, sigmad
    character(len=*) :: signop, signod, resu
    character(len=6) :: chtemp
!
!     BUT:
!         CALCUL DE L'ESTIMATEUR D'ERREUR QUANTITE D'INTERET AVEC LA
!         METHODE DE ZHU-ZIENKIEWICZ.
!
!                 OPTION : 'ERRE_QIZZ'
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   MODELE : NOM DU MODELE
! IN   MATEZ  : NOM DU CONCEPT MATERIAU
! IN   CHTEMP : NOM DU CHAMP DE TEMPERATURE
! IN   SIGMAP : NOM DU CHAMP DE CONTRAINTES PB.PRIMAL (CHAM_ELEM_SIEF_R)
! IN   SIGMAD : NOM DU CHAMP DE CONTRAINTES PB.DUAL (CHAM_ELEM_SIEF_R)
! IN   SIGNOP : NOM DU CHAMP DE CONTRAINTES LISSEES POUR LE PB. PRIMAL
! IN   SIGNOD : NOM DU CHAMP DE CONTRAINTES LISSEES POUR LE PB. DUAL
!
!
!      SORTIE :
!-------------
! OUT  RESU   : NOM DU CHAM_ELEM_ERREUR PRODUIT
!               SI RESU EXISTE DEJA, ON LE DETRUIT.
!
! ......................................................................
!
    character(len=8) :: lpain(7), lpaout(1)
    character(len=16) :: option
    character(len=24) :: lchin(7), lchout(1), chgeom, mate
!
! DEB-------------------------------------------------------------------
!
    chtemp = '&&TEMP'
    call mecact('V', chtemp, 'LIGREL', ligrel, 'TEMP_R',&
                ncmp=1, nomcmp='TEMP', sr=0.0d0)
!
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
    lpain(3) = 'PSIEFP_R'
    lchin(3) = sigmap
    lpain(4) = 'PSIEFD_R'
    lchin(4) = sigmad
    lpain(5) = 'PTEMPER'
    lchin(5) = chtemp
    lpain(6) = 'PSIGMAP'
    lchin(6) = signop
    lpain(7) = 'PSIGMAD'
    lchin(7) = signod
!
    lpaout(1) = 'PERREUR'
    lchout(1) = resu
    option = 'ERRE_QIZZ'
    call calcul('S', option, ligrel, 7, lchin,&
                lpain, 1, lchout, lpaout, 'G',&
                'OUI')
!
end subroutine
