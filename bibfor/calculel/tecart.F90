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

subroutine tecart(carte)
    implicit none
#include "asterfort/cmpcar.h"
#include "asterfort/expcar.h"
    character(len=*) :: carte
! ----------------------------------------------------------------------
!     IN : CARTE (K19) : NOM DE LA CARTE A MODIFIER
!
!     OUT: CARTE: LA CARTE EST MODIFIEE.
! ---------------------------------------------------------------------
!     BUT : CETTE ROUTINE  PERMET UNE SURCHARGE "FINE"
!           DES GRANDEURS AFFECTEES SUR UNE CARTE:
!
!         1) PAR DEFAUT (SI ON N'APPELLE PAS "TECART") UNE MAILLE SERA
!            AFFECTEE PAR LA DERNIERE GRANDEUR QU'ON LUI AURA ASSIGNEE
!            (DERNIER "NOCART" LA CONCERNANT)
!             LA GRANDEUR EST ICI A CONSIDERER DANS SON ENSEMBLE :
!             C'EST L'ENSEMBLE DES CMPS NOTES PAR "NOCART".
!             LA NOUVELLE GRANDEUR ECRASE COMPLETEMENT UNE EVENTUELLE
!             ANCIENNE GRANDEUR SUR TOUTES LES MAILLES AFFECTEES.
!
!         2) SI ON APPELLE "TECART", LA NOUVELLE GRANDEUR AFFECTEE
!            N'ECRASE QUE LES CMPS QUE L'ON AFFECTE VRAIMENT :
!           LES CMPS NON AFFECTEES PAR "NOCART" SONT ALORS TRANSPARENTES
!
!         REMARQUE :
!           SI L'ON VEUT DONNER UNE VALEUR PAR DEFAUT SUR LES CMPS
!           IL SUFFIT DE FAIRE UN "NOCART" DES LE DEBUT EN NOTANT
!           TOUTES LES CMPS SUR "TOUT" LE MAILLAGE.
!
!
!
! ---------------------------------------------------------------------
!    EXEMPLE :
!
!      GMA1 = (MA1,MA2)
!      GMA2 = (MA2,MA3)
!
!      CALL ALCART()
!      CALL NOCART(GMA1,('DX','DY'),(1.,2.))
!      CALL NOCART(GMA2,('DX','DZ'),(4.,5.))
!
!    1) ON NE FAIT PAS TECART() :
!          MAILLE   'DX'   'DY'  'DZ'  ("X" VEUT DIRE "N'EXISTE PAS")
!           MA1      1.     2.    X
!           MA2      X      4.    5.
!           MA3      X      4.    5.
!
!    2) ON FAIT TECART()
!          MAILLE   'DX'   'DY'  'DZ'
!           MA1      1.     2.    X
!           MA2      1.     4.    5.
!           MA3      X      4.    5.
!
! ----------------------------------------------------------------------
    character(len=19) :: carte2
! DEB --
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    carte2= carte
!
!     -- ON ETEND LA CARTE:
    call expcar(carte2)
!
!     -- ON COMPRIME LA CARTE:
    call cmpcar(carte2)
!
end subroutine
