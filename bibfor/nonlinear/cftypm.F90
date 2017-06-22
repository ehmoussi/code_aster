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

subroutine cftypm(defico, posma, typma)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: defico
    integer :: posma
    character(len=4) :: typma
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! TYPE D'UNE MAILLE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE CONTACT (DEFINITION)
! IN  POSMA  : INDICE DANS CONTMA DE LA MAILLE
! OUT TYPMA  : TYPE DE LA MAILLE 'MAIT' OU 'ESCL'
!
!
!
!
    character(len=24) :: typema
    integer :: jtypma
    integer :: ztypm
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD DE CONTACT
!
    typema = defico(1:16)//'.TYPEMA'
    call jeveuo(typema, 'L', jtypma)
    ztypm = cfmmvd('ZTYPM')
!
! --- REPONSE
!
    if (zi(jtypma+ztypm*(posma-1)+1-1) .eq. 1) then
        typma = 'MAIT'
    else if (zi(jtypma+ztypm*(posma-1)+1-1).eq.-1) then
        typma = 'ESCL'
    else
        ASSERT(.false.)
    endif
!
    call jedema()
!
end subroutine
