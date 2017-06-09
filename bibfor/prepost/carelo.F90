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

subroutine carelo(modele, carele, base, chrel1, chrel2,&
                  chrel3)
    implicit   none
#include "jeveux.h"
!
#include "asterfort/calcul.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/megeom.h"
    character(len=1) :: base
    character(len=8) :: carele, modele
    character(len=19) :: chrel1, chrel2, chrel3
!     BUT:
!       CALCULER LES REPERES LOCAUX DES ELEMENTS
! ----------------------------------------------------------------------
!     IN MODELE  : MODELE
!     IN CARELE  : CARA_ELEM
!     IN BASE    : G/V
!     OUT CHREL1 : 1ER  VECTEUR DU REPERE LOCAL
!     OUT CHREL2 : 2EME VECTEUR DU REPERE LOCAL
!     OUT CHREL3 : 3EME VECTEUR DU REPERE LOCAL
! ---------------------------------------------------------------------
!     VARIABLES LOCALES
!
    character(len=8) :: lpain(4), lpaou(3)
    character(len=19) :: ligrmo, lchin(4), lchou(3)
    character(len=24) :: chgeom
! ----------------------------------------------------------------------
!
    call jemarq()
!
    ligrmo = modele//'.MODELE'
!
    call megeom(modele, chgeom)
    lchin(1) = chgeom
    lpain(1) = 'PGEOMER'
    lchin(2) = carele//'.CARORIEN'
    lpain(2) = 'PCAORIE'
    lchin(3) = carele//'.CARCOQUE'
    lpain(3) = 'PCACOQU'
    lchin(4) = carele//'.CARMASSI'
    lpain(4) = 'PCAMASS'
!
    lchou(1) = chrel1
    lpaou(1) = 'PREPLO1'
    lchou(2) = chrel2
    lpaou(2) = 'PREPLO2'
    lchou(3) = chrel3
    lpaou(3) = 'PREPLO3'
    call calcul('C', 'REPERE_LOCAL', ligrmo, 4, lchin,&
                lpain, 3, lchou, lpaou, base,&
                'NON')
!
    call jedema()
end subroutine
