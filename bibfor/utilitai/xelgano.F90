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

subroutine xelgano(modele,sigelga,sigseno)
!
!     routine utilitaire X-FEM
!
!     - FONCTION REALISEE : PASSAGE D'UN CHAMP DE CONTRAINTES AUX POINTS 
!                           DE GAUSS DES SOUS-ELEMENTS X-FEM A UN CHAMP
!                           DE CONTRAINTES AUX NOEUDS DES SOUS-ELEMENTS
!
!     - ARGUMENTS   :
!
! IN    modele  : modele
! IN    sigelga : champ de contraintes aux points de gauss des sous-elements
! OUT   sigseno : champ de contraintes aux noeuds des sous-elements
!
!----------------------------------------------------------------------
! CORPS DU PROGRAMME
!
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"

!
    character(len=8)  :: modele
    character(len=24) :: sigelga
    character(len=24) :: sigseno
!
!
! DECLARATION VARIABLES LOCALES
!
    character(len=16) :: option

    integer :: nchin, nchout
    parameter (nchin=2)
    parameter (nchout=1)
    character(len=8)  :: lpain(nchin), lpaout(nchout)
    character(len=24) :: lchin(nchin), lchout(nchout)
    character(len=24) :: ligrmo
!
    call jemarq()
!
!   Recuperation du LIGREL
    ligrmo = modele//'.MODELE'

!   Definition de l'option de calcul (anciennement SIEF_SEGA_SENO)
    option = 'SISE_ELNO'

!   liste des champs et parametres en entree/sortie de calcul
    lpain(1) = 'PCONTRR'
    lchin(1) = sigelga
    lpain(2) = 'PLONCHA'
    lchin(2) = modele//'.TOPOSE.LON'

    lpaout(1) = 'PCONTSER'
    lchout(1) = sigseno

    call calcul('S',option,ligrmo,nchin,lchin,lpain,nchout,lchout,lpaout,'V','OUI')

    call jedema()
end subroutine
