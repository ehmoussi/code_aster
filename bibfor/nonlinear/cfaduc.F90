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

subroutine cfaduc(resoco, nbliac)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit      none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: nbliac
    character(len=24) :: resoco
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - RESOLUTION)
!
! CALCUL DU SECOND MEMBRE - CAS DU CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
!
!
!
!
    integer :: iliai, iliac
    real(kind=8) :: jeuini
    character(len=19) :: liac, mu
    integer :: jliac, jmu
    character(len=24) :: jeux
    integer :: jjeux
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES STRUCTURES DE DONNEES DE CONTACT
!
    liac = resoco(1:14)//'.LIAC'
    jeux = resoco(1:14)//'.JEUX'
    mu = resoco(1:14)//'.MU'
    call jeveuo(liac, 'L', jliac)
    call jeveuo(jeux, 'L', jjeux)
    call jeveuo(mu, 'E', jmu)
!
! --- ON MET {JEU(DEPTOT)} - [A].{DDEPL0} DANS MU
!
    do 10 iliac = 1, nbliac
        iliai = zi(jliac-1+iliac)
        jeuini = zr(jjeux+3*(iliai-1)+1-1)
        zr(jmu+iliac-1) = jeuini
10  end do
!
    call jedema()
end subroutine
