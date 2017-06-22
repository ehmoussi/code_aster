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

subroutine dylach(nomo, mate, carele, lischa, numedd,&
                  vediri, veneum, vevoch, vassec)
!
!
    implicit      none
#include "jeveux.h"
#include "asterfort/asvepr.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/veassc.h"
#include "asterfort/vechms.h"
#include "asterfort/vedimd.h"
    character(len=8) :: nomo
    character(len=24) :: mate, carele
    character(len=19) :: lischa
    character(len=*) :: numedd
    character(len=19) :: vediri, veneum, vevoch, vassec
!
! ----------------------------------------------------------------------
!
! DYNA_VIBRA//HARM/GENE
!
! CALCUL ET PRE-ASSEMBLAGE DU CHARGEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  NOMO   : NOM DU MODELE
! IN  LISCHA : SD LISTE DES CHARGES
! IN  CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
! IN  MATE   : MATERIAU CODE
! IN  NUMEDD : NOM DU NUME_DDL
! OUT VEDIRI : VECT_ELEM DE L'ASSEMBLAGE DES ELEMENTS DE LAGRANGE
! OUT VENEUM : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS DE NEUMANN
! OUT VEVOCH : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS EVOL_CHAR
! OUT VASSEC : VECT_ELEM DE L'ASSEMBLAGE DES CHARGEMENTS VECT_ASSE_CHAR
!
!
!
!
    real(kind=8) :: partps(3), instan
    character(len=19) :: k19bid
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    instan = 0.d0
    partps(1) = instan
    partps(2) = 0.d0
    partps(3) = 0.d0
!
! --- CALCUL DES VECTEURS ELEMENTAIRES
!
    call vedimd(nomo, lischa, instan, vediri)
    call vechms(nomo, mate, carele, k19bid, lischa,&
                partps, veneum)
    call veassc(lischa, vassec)
!
! --- PREPARATION DE L'ASSEMBLAGE
!
    call asvepr(lischa, vediri, 'C', numedd)
    call asvepr(lischa, veneum, 'C', numedd)
    call asvepr(lischa, vevoch, 'C', numedd)
    call asvepr(lischa, vassec, 'C', numedd)
!
    call jedema()
!
end subroutine
