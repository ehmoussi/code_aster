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

function xcalc_heav(id_no, hea_se, iflag)
!
!-----------------------------------------------------------------------
! BUT : CALCULER LA FONCTION HEAVISIDE : 2 | 0
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - ID_NO  : IDENTIFIANT <ENTIER> DU DOMAINE DE LA FONCTION HEAVISIDE
!   - HEA_SE : IDENTIFIANT <ENTIER> DU DOMAINE AUQUEL APPARTIENT LE SOUS-ELEMENT/SOUS-FACETTE
!   - IFLAG  : ENTIER UTILE POUR MODIFIER L ENICHISSIMENT MONO-HEAVISIDE EN -2|0
!               => CE FLAG DOIT ETRE NETTOYER UNE FOIS QUE LA DEFINITION TOPOLOGIQUE MONO/MULTI
!                  SERA UNIFORMISEE
!-----------------------------------------------------------------------
    implicit none
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/assert.h"
!-----------------------------------------------------------------------
    integer :: id_no, hea_se
    integer :: iflag
    real(kind=8) :: xcalc_heav
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!
    if ( id_no.eq.hea_se) then
      xcalc_heav=2.d0
    else
      xcalc_heav=0.d0
    endif
!  ASTUCE POUR OBTENIR UN SAUT DE DEPLACEMENT = (+2) * H1X POUR UNE  FISSURE
!    REMARQUE: ON RAJOUTE CETTE CONVENTION PARCE QUE LA DEFINITION DE LA 
!        TOPOLOGIE SIGNE HEAVISIDE PAR FACETTE EST DIFFERENTE DU SIMPLE AU MULTI HEAVISIDE       
!    * NFISS=1 : ON A SIGNE(ESCLAVE)=-1, AVEC L ENRICHISSEMENT STANDARD XFEM
!                => MAIS CETTE INFORMATION INDIPENSABLE POUR CALCULER LE SAUT DE DEPLACEMENT,
!                   N EST PAS CONSTRUITE EXPLICITEMENT,
!                   DU COUP, L INFO EST REDEFINIE A CHAQUE FOIS DANS LE CODE ...
!                   => ON FIXE LE SAUT A +2 POUR NE PAS GERER DIRECTEMENT CE PROBLEME
!    * NFISS>1 : LA TOPOLOGIE EST CONSTRUITE EXPLICITEMENT ET STOCKEE DANS TOPOFAC.HEA
!                => CETTE INFO EST CODEE ENSUITE DANS TOPONO.HFA 
!                   => ET TRANSPORTEE DE MANIERE TRANSPARENTE
     if (iflag.eq.-999) xcalc_heav=1.d0*xcalc_heav      
     if (iflag.eq.999) xcalc_heav=-1.d0*xcalc_heav      
!
end function
