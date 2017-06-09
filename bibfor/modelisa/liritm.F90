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

subroutine liritm(ifl, icl, iv, rv, cv,&
                  cnl, deblig, ilec)
    implicit none
!       LECTURE DE L ITEM SUIVANT
!       EN IGNORANT                     - LES SEPARATEURS
!                                       - LES LIGNES BLANCHES
!                                       - LES CARACTERES DERIERE %
!                                         JUSQU'EN FIN DE LIGNE
!       ----------------------------------------------------------------
!       IN  DEBLIG      = -1    >  LIRE ITEM EN DEBUT DE LIGNE SUIVANTE
!           IFL                 >  NUMERO LOGIQUE FICHIER MAILLAGE
!           ILEC        = 1     >  PREMIERE LECTURE DU FICHIER
!                       = 2     >  SECONDE  LECTURE DU FICHIER
!       OUT DEBLIG      = 0     >  ITEM LUT DANS LA LIGNE
!           DEBLIG      = 1     >  ITEM LUT EN DEBUT DE LIGNE
!           ICL         =-1     >  FIN DE LIGNE
!                       = 0     >  ERREUR DE LECTURE
!                       = 1     >  LECTURE ENTIER
!                       = 2     >  LECTURE REEL
!                       = 3     >  LECTURE IDENTIFICATEUR
!                       = 4     >  LECTURE CONSTANTE DE TEXTE
!                       = 5     >  LECTURE SEPARATEUR
!           IV                  >  ENTIER LU
!           RV                  >  REEL LU
!           CV                  >  CHAINE LUE
!           CNL                 >  NUMERO LIGNE (CHAINE)
!       ----------------------------------------------------------------
#include "asterfort/lirlig.h"
#include "asterfort/lxscan.h"
    integer :: ifl, icl, iv, ideb, deblig, ilec
    real(kind=8) :: rv
    character(len=*) :: cv
    character(len=80) :: lig
    character(len=14) :: cnl
    save            lig , ideb
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (deblig .eq. -1) then
        call lirlig(ifl, cnl, lig, ilec)
        ideb = 1
        deblig = 1
    else
        deblig = 0
    endif
!
! - LECTURE ITEM SUIVANT
!
 1  continue
    call lxscan(lig, ideb, icl, iv, rv,&
                cv)
!
! - FIN DE LIGNE OU COMMENTAIRE
!
    if (icl .eq. -1 .or. (icl.eq.5.and.cv(1:1).eq.'%')) then
        call lirlig(ifl, cnl, lig, ilec)
        ideb = 1
        deblig = 1
        goto 1
    endif
!
! - SEPARATEUR SAUF %
!
    if (icl .eq. 5 .and. cv(1:1) .ne. '%') goto 1
!
end subroutine
