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

subroutine nmmacv(vecdep, sstru, vecass)
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
    character(len=19) :: sstru
    character(len=19) :: vecdep
    character(len=24) :: vecass
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - MACRO_ELEMENT)
!
! CALCUL DE LA CONTRIBUTION AU SECOND MEMBRE DES MACRO-ELEMENTS
!
! ----------------------------------------------------------------------
!
!
! IN  VECDEP : VECTEUR DEPLACEMENT
! IN  SSTRU  : MATRICE ASSEMBLEE DES SOUS-ELEMENTS STATIQUES
! OUT VECASS : VECT_ASSE CALCULE
!
!
!
!
    integer ::   jrsst
    real(kind=8), pointer :: cnfi(:) => null()
    real(kind=8), pointer :: depl(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- CALCUL VECT_ASSE(MACR_ELEM) = MATR_ASSE(MACR_ELEM) * VECT_DEPL
!
    call jeveuo(vecass(1:19)//'.VALE', 'E', vr=cnfi)
    call jeveuo(vecdep(1:19)//'.VALE', 'L', vr=depl)
    call jeveuo(sstru(1:19) //'.&INT', 'L', jrsst)
    call mrmult('ZERO', jrsst, depl, cnfi, 1,&
                .true._1)
!
    call jedema()
!
end subroutine
