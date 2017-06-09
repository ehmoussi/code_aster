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

subroutine stktit(ifl, icl, iv, rv, cv,&
                  cnl, mcl, nbm, nlt, tit,&
                  irteti)
    implicit none
!       SECONDE LECTURE DES DONNEES POUR UN MOT CLE DE TYPE TITRE
!       ----------------------------------------------------------------
!       IN      IFL,ICL,IV,RV,CV,CNL = VOIR LIRITM
!               MCL             = MOTS CLES TYPE TITRE
!               NBM             = NB DE MOTS CLES TYPE TITRE
!               TIT             = NOMU//'           .TITR'
!               NLT             = NUMERO LIGNE COURANTE DU TITRE
!       OUT     (RETURN)        = MOT CLE SUIVANT (MOT CLE NON RECONNU)
!               (RETURN 1)      = EXIT            (MOT CLE FIN TROUVE)
!               (RETURN 2)      = LIGNE SUIVANTE  (MOT CLE FINSF TROUVE
!                                                  OU ERREUR DETECTE)
!       ----------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lirlig.h"
#include "asterfort/lxscan.h"
#include "asterfort/tesfin.h"
#include "asterfort/tesmcl.h"
    integer :: nbm
    real(kind=8) :: rv
    character(len=8) :: mcl(nbm)
    character(len=14) :: cnl
    character(len=*) :: cv
    character(len=80) :: lig
    character(len=24) :: tit
!
!
!-----------------------------------------------------------------------
    integer :: iad, icl, ideb, ifl, irtet, irteti, iv
    integer :: nlt
!-----------------------------------------------------------------------
    call jemarq()
    irteti = 0
!
! - ITEM = MOT CLE TYPE TITRE ?
!
    call tesmcl(icl, iv, cv, mcl(1), irtet)
    if (irtet .eq. 1) goto 3
!
! - OUI > REQUETE EN ECRITURE POUR OBJET TITRE
!
    call jeveuo(tit, 'E', iad)
!
! - LIRE LIGNE SUIVANTE
!
  4 continue
    call lirlig(ifl, cnl, lig, 2)
!
! - LIRE PREMIER ITEM DE LA LIGNE
!
    ideb = 1
    call lxscan(lig, ideb, icl, iv, rv,&
                cv)
!
! - ITEM = MOT  CLE FIN  OU FINSF ?
!
    call tesfin(icl, iv, cv, irtet)
    if (irtet .eq. 1) then
        goto 1
    else if (irtet .eq. 2) then
        goto 2
    endif
!
! - STOCKAGE DE LA LIGNE NLT
!
    zk80(iad+nlt) = lig
!
! - INCREMENTATION DU NUMERO DE LIGNE TITRE
!
    nlt = nlt + 1
!
! - LIGNE SUIVANTE
!
    goto 4
!
  1 continue
    irteti = 1
    goto 999
  2 continue
    irteti = 2
    goto 999
  3 continue
    irteti = 0
    goto 999
!
999 continue
    call jedema()
end subroutine
