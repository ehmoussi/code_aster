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

subroutine cfverd(noma, numedd, defico)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfnomm.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/posddl.h"
#include "asterfort/utmess.h"
    character(len=8) :: noma
    character(len=24) :: numedd
    character(len=24) :: defico
!
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - UTILITAIRE)
!
! VERIFICATION MODELE CONTACT PUR 2D
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
! IN  NUMEDD : NOM DU NUME_DDL
!
!
!
!
    character(len=8) :: nomno
    integer :: nnoco
    integer :: ino, jbid, verdim, posno
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nnoco = cfdisi(defico,'NNOCO')
!
    do 10 ino = 1, nnoco
        posno = ino
        call cfnomm(noma, defico, 'NOEU', posno, nomno)
        call posddl('NUME_DDL', numedd, nomno, 'DZ', jbid,&
                    verdim)
        if (verdim .ne. 0) then
            call utmess('F', 'CONTACT_85')
        endif
10  end do
!
    call jedema()
end subroutine
