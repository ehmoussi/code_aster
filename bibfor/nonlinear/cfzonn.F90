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

subroutine cfzonn(defico, posno, izone)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: defico
    integer :: posno
    integer :: izone
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! ZONE A LAQUELLE APPARTIENT UN NOEUD
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE CONTACT (DEFINITION)
! IN  POSNO  : INDICE DANS CONTNO DU NOEUD
! OUT IZONE  : NUMERO DE LA ZONE
!
!
!
!
    character(len=24) :: typeno
    integer :: jtypno
    integer :: ztypn
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD DE CONTACT
!
    typeno = defico(1:16)//'.TYPENO'
    call jeveuo(typeno, 'L', jtypno)
    ztypn = cfmmvd('ZTYPN')
!
! --- REPONSE
!
    izone = zi(jtypno+ztypn*(posno -1)+2-1)
!
    call jedema()
!
end subroutine
