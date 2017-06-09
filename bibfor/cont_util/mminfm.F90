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

subroutine mminfm(posmae, defico, questz, irep)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: defico
    integer :: posmae
    character(len=*) :: questz
    integer :: irep
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! REPOND A UNE QUESTION SUR UNE OPTION/CARACTERISTIQUE DU CONTACT
! VARIABLE SUIVANT LA MAILLE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD POUR LA DEFINITION DU CONTACT
! IN  POSMAE : POSITION DE LA MAILLE ESCLAVE DANS LES SD CONTACT
! IN  QUESTI : QUESTION POSEE
! OUT IREP   : VALEUR
!
!
!
!
    integer :: zmaes, ztypm
    character(len=24) :: maescl, typema
    integer :: jmaesc, jtypma
    character(len=24) :: questi
    integer :: indmae, posma2
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    irep = 0
    questi = questz
!
! --- ACCES AUX SDS
!
    typema = defico(1:16)//'.TYPEMA'
    maescl = defico(1:16)//'.MAESCL'
!
    zmaes = cfmmvd('ZMAES')
    ztypm = cfmmvd('ZTYPM')
!
    call jeveuo(typema, 'L', jtypma)
    call jeveuo(maescl, 'L', jmaesc)
!
! --- INDICE
!
    indmae = zi(jtypma+ztypm*(posmae-1)+2-1)
    posma2 = zi(jmaesc+zmaes*(indmae-1)+1-1)
    ASSERT(posma2.eq.posmae)
!
! --- QUESTION
!
    if (questi .eq. 'IZONE') then
        irep = zi(jmaesc+zmaes*(indmae-1)+2-1)
    else if (questi.eq.'NPTM') then
        irep = zi(jmaesc+zmaes*(indmae-1)+3-1)
    else if (questi.eq.'NDEXFR') then
        irep = zi(jmaesc+zmaes*(indmae-1)+4-1)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
