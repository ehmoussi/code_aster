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

subroutine ingrma(sdmail, nomma, lgrma, nbgrma, codret)
!     RETOURNE LA LISTE DES GROUPES DE MAILLES CONTENANT UNE MAILLE
!     PARTICULIERE DONT ON DONNE LE NOM OU LE NUMERO
!-----------------------------------------------------------------------
!     ENTREES:
!        SDMAIL : NOM DE LA SD MAILLAGE
!        NOMMA  : NOM DE LA MAILLE
!     SORTIES:
!        LGRMA  : ADR DU TABLEAU DES GROUP_MA CONTENANT LA MAILLE
!        NBGRMA : NBRE DE GROUPES DANS CETTE LISTE
!        CODRET : 0 SI OK, <>0 SI ERREUR
!-----------------------------------------------------------------------
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
    character(len=8) :: sdmail, nomma
    integer :: lgrma(*), nbgrma, codret
!
! 0.2. ==> JEVEUX
!
!
! 0.3. ==> VARIABLES LOCALES
!
    character(len=24) :: nommai, grpmai
    integer :: i, j, ier, num, nbg, nbmag, jgrma
!
!====
! 1. PREALABLES
!====
!
! 1.1. ==> INITIALISATIONS
!
    codret = 0
    nbgrma = 0
    nommai = sdmail//'.NOMMAI         '
    grpmai = sdmail//'.GROUPEMA       '
!
! 1.2. ==> VERIFICATIONS
!
    call jeexin(nommai, ier)
    ASSERT(ier.ne.0)
!
    call jeexin(grpmai, ier)
    ASSERT(ier.ne.0)
!
    num = 0
    call jenonu(jexnom(nommai, nomma), num)
    ASSERT(num.ne.0)
!
!====
! 2. BOUCLE SUR LES GROUP_MA
!====
!
    call jelira(grpmai, 'NOMUTI', nbg)
    do 200 i = 1, nbg
        call jeveuo(jexnum(grpmai, i), 'L', jgrma)
        call jelira(jexnum(grpmai, i), 'LONUTI', nbmag)
!     --- BCLE SUR LES MAILLES DU GROUP_MA
        do 210 j = 1, nbmag
            if (zi(jgrma-1+j) .eq. num) then
                nbgrma = nbgrma + 1
                lgrma(nbgrma) = i
            endif
210      continue
200  end do
!
!====
! 99. SORTIE
!====
!
!
end subroutine
