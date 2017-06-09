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

subroutine cfgran(resoco, nbliac, kkliai, kkliac)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/r8maem.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resoco
    integer :: nbliac, kkliai, kkliac
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
!
! VERIFICATION SI L'ENSEMBLE DES LIAISONS SUPPOSEES TROP GRAND
!
! ----------------------------------------------------------------------
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
! OUT KKLIAI : NUMERO DE LA LIAISON AYANT LE MU LE PLUS NEGATIF
!              0 SI TOUS LES MU SONT POSITIF (ON A CONVERGE)
! OUT KKLIAC : NUMERO DE LA LIAISON _ACTIVE_ AYANT LE MU LE PLUS NEGATIF
!
!
!
!
    real(kind=8) :: rminmu, valmu
    character(len=19) :: liac, mu
    integer :: jliac, jmu
    integer :: iliac, index
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    kkliai = 0
    kkliac = 0
    index = 0
    rminmu = r8maem()
!
! --- ACCES STRUCTURES DE DONNEES DE CONTACT
!
    mu = resoco(1:14)//'.MU'
    liac = resoco(1:14)//'.LIAC'
    call jeveuo(mu, 'L', jmu)
    call jeveuo(liac, 'L', jliac)
!
! --- MU MINIMUM
!
    do 10 iliac = 1, nbliac
        valmu = zr(jmu+iliac-1)
        if (rminmu .gt. valmu) then
            rminmu = valmu
            index = iliac
        endif
10  end do
!
! --- ON REPERE LA LIAISON KKMIN AYANT LE MU LE PLUS NEGATIF
!
    kkliac = index
    if (kkliac .ne. 0) then
        kkliai = zi(jliac-1+kkliac)
    endif
!
! --- SI TOUS LES MU SONT > 0 -> ON A CONVERGE (IL Y A CONTACT)
!
    if (rminmu .ge. 0.d0) then
        kkliai = 0
        kkliac = 0
    endif
!
    call jedema()
!
end subroutine
