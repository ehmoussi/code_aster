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

subroutine cfnbsf(defico, isurf, typent, nbent, jdec)
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
    character(len=4) :: typent
    integer :: isurf, jdec
    integer :: nbent
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! ACCES AUX NOEUDS/MAILLES D'UNE ZONE DONNEE
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD DE DEFINITION DU CONTACT
! IN  TYPENT : TYPE D'ENTITE
!               NOEU  NBRE NOEUDS ATTACHES A LA SURFACE
!               MAIL  NBRE MAILLES ATTACHEES A LA SURFACE
! IN  ISURF  : NUMERO DE LA SURFACE
! OUT NBENT  : NOMBRE D'ENTITES
! OUT JDEC   : DECALAGE DANS LES VECTEURS POUR LE PREMIER DE LA SURFACE
!               NOEU  DEFICO(1:16)//'.NOEUCO'
!               MAIL  DEFICO(1:16)//'.MAILCO'
!
!
!
!
    character(len=24) :: psurno, psurma
    integer :: jsuno, jsuma
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- RECUPERATION DE QUELQUES DONNEES
!
    psurno = defico(1:16)//'.PSUNOCO'
    psurma = defico(1:16)//'.PSUMACO'
    call jeveuo(psurno, 'L', jsuno)
    call jeveuo(psurma, 'L', jsuma)
!
! --- INITIALISATIONS
!
    if (typent .eq. 'NOEU') then
        nbent = zi(jsuno+isurf) - zi(jsuno+isurf-1)
        jdec = zi(jsuno+isurf-1)
    else if (typent.eq.'MAIL') then
        nbent = zi(jsuma+isurf) - zi(jsuma+isurf-1)
        jdec = zi(jsuma+isurf-1)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
!
end subroutine
