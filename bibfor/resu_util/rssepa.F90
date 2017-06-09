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

subroutine rssepa(result, nuordr, modele, mate, carele,&
                  excit)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rsadpa.h"
    integer :: nuordr
    character(len=8) :: result, modele, carele, mate
    character(len=19) :: excit
!----------------------------------------------------------------------
!     BUT: ECRIRE DANS LA SD RESULTAT LES PARAMETRES MODELE, MATE,
!          CARELE ET EXCIT POUR LE NUME_ORDRE NUORDR
!
!     IN      RESULT : NOM DE LA SD RESULTAT
!     IN      IORDR  : NUMERO D'ORDRE
!     IN      MODELE : NOM DU MODELE
!     IN      MATE   : NOM DU CHAMP MATERIAU
!     IN      CARELE : NOM DE LA CARACTERISTIQUE ELEMENTAIRE
!     IN      EXCIT  : NOM DE LA SD INFO_CHARGE
!
!
!     VARIABLES LOCALES
    integer :: jpara
    character(len=8) :: k8b
! ----------------------------------------------------------------------
!
    call jemarq()
!
!     ======================================================
! --- STOCKAGE DE NOMS DE CONCEPT A PARTIR DE LA SD RESULTAT
!     ======================================================
!
!     STOCKAGE DU NOM DU MODELE
!     -------------------------
    call rsadpa(result, 'E', 1, 'MODELE', nuordr,&
                0, sjv=jpara, styp=k8b)
    zk8(jpara)=modele
!
!     STOCKAGE DU NOM DU CHAMP MATERIAU
!     ---------------------------------
    call rsadpa(result, 'E', 1, 'CHAMPMAT', nuordr,&
                0, sjv=jpara, styp=k8b)
    zk8(jpara)=mate(1:8)
!
!     STOCKAGE DU NOM DE LA CARACTERISTIQUE ELEMENTAIRE
!     -------------------------------------------------
    call rsadpa(result, 'E', 1, 'CARAELEM', nuordr,&
                0, sjv=jpara, styp=k8b)
    zk8(jpara)=carele
!
!     STOCKAGE DU NOM DE LA SD INFO_CHARGE
!     ------------------------------------
    call rsadpa(result, 'E', 1, 'EXCIT', nuordr,&
                0, sjv=jpara, styp=k8b)
    zk24(jpara)=excit(1:19)
!
    call jedema()
end subroutine
