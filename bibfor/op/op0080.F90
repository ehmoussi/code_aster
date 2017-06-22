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

subroutine op0080()
    implicit none
!  P. RICHARD     DATE 12/03/91
!-----------------------------------------------------------------------
!  BUT : OPERATEUR DE CALCUL DE MODES PAR SOUS-STRUCTURATION CYCLIQUE
!-----------------------------------------------------------------------
!
!
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/argu80.h"
#include "asterfort/calcyc.h"
#include "asterfort/desccy.h"
#include "asterfort/immocy.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/projcy.h"
#include "asterfort/refe80.h"
    character(len=8) :: nomres
    character(len=16) :: nomope, nomcon
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
! --- PHASE DE VERIFICATION
!
!-----------------------------------------------------------------------
    integer :: ifm, niv
!-----------------------------------------------------------------------
    call infmaj()
!
    call getres(nomres, nomcon, nomope)
!
! --- RECUPERATION BASE MODALE OU RESULTAT CYCLIQUE ET CREATION .REFE
!
    call refe80(nomres)
!
! --- RECUPERATION DES PRINCIPAUX ARGUMENTS DE LA COMMANDE
!
    call argu80(nomres)
!
! --- CREATION DE LA NUMEROTATION DES DDL CYCLIQUES
!
    call desccy(nomres)
!
! --- CALCUL DES SOUS-MATRICES PROJETEES
!
    call projcy(nomres)
!
! --- CALCUL DES MODES PROPRES DEMANDES
!
    call calcyc(nomres)
!
! --- IMPRESSION DU CONCEPT RESULTAT
!
    call infniv(ifm, niv)
    if (niv .gt. 1) call immocy(nomres, ifm)
!
end subroutine
