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

subroutine ernozz(modele, sigma, chmat, signo, chvarc,&
                  option, ligrel, iordr, resuco, resuc1,&
                  champ)
    implicit none
#include "asterfort/erglob.h"
#include "asterfort/zzloca.h"
    integer :: iordr
    character(len=*) :: modele, sigma, chmat, signo, option, ligrel
    character(len=*) :: champ, resuco
    character(len=19) :: resuc1, chvarc
!
!     BUT:
!         CALCULER LES ESTIMATEURS LOCAUX A PARTIR DES
!         CONTRAINTES.
!         CALCULER LES ESTIMATEURS GLOBAUX A PARTIR DES ESTIMATEURS
!         LOCAUX CONTENUS DANS CHAMP.
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   MODELE :  NOM DU MODELE
! IN   SIGMA  :  CONTRAINTES AUX POINTS DE GAUSS
! IN   CHMAT  :  NOM DU CHAMP DE MATERIAU
! IN   SIGNO  :  CONTRAINTES AUX NOEUDS
! IN   OPTION :  'ERZ1_ELEM' OU 'ERZ2_ELEM'
! IN   LIGREL :  NOM D'UN LIGREL SUR LEQUEL ON FERA LE CALCUL
! IN   IORDR  :  NUMERO D'ORDRE
! IN   RESUCO :  NOM DE CONCEPT ENTRANT
! IN   RESUC1 :  NOM DE CONCEPT RESULTAT
!
!      SORTIE :
!-------------
! OUT  CHAMP  :  CONTRAINTES AUX NOEUDS
!
! ======================================================================
!
!    CALCUL DE L'ESTIMATEUR D'ERREUR
!
    call zzloca(modele, ligrel, chmat, sigma, signo,&
                chvarc, champ)
    call erglob(champ, .false._1, .false._1, option, iordr,&
                resuco, resuc1)
!
end subroutine
