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

subroutine cfzone(defico, izone, typsur, isurf)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: defico
    character(len=4) :: typsur
    integer :: izone, isurf
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! NUMERO DE LA ZONE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
! IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
! IN  TYPSUR : TYPE DE SURFACE
!               'MAIT'
!               'ESCL'
! OUT ISURF  : NUMERO DANS LA SURFACE
!                 POUR ACCES PSUNOCO/PSUMACO/PNOEUQU
!
!
!
!
    character(len=24) :: pzone
    integer :: jzone
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- RECUPERATION DE QUELQUES DONNEES
!
    pzone = defico(1:16)//'.PZONECO'
    call jeveuo(pzone, 'L', jzone)
!
! --- INITIALISATIONS
!
    if (typsur .eq. 'ESCL') then
        isurf = zi(jzone+izone)
    else if (typsur.eq.'MAIT') then
        isurf = zi(jzone+izone-1) + 1
    else
        ASSERT(.false.)
    endif
!
    call jedema()
!
end subroutine
