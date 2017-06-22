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

subroutine vrcin_elno(nomch, cesmod, chs)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/cnocns.h"
#include "asterfort/cnsces.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    character(len=19), intent(in) :: nomch, cesmod, chs
! person_in_charge: sam.cuvilliez at edf.fr
!-----------------------------------------------------------------------
!
!   Sous-routine de vrcin1. Cas particulier ou l'on souhaite produire 
!   un champ de varc ELNO.
!
!   in nomch  : nom du champ dont le support doit etre modifie
!               (cham_no -> cham_elem_s / ELNO)
!   in cesmod : nom du cham_elem_s "modele" pour appel a cnsces
!   in chs    : nom du cham_elem_s / ELNO a creer a partir de nomch
!
!-----------------------------------------------------------------------
!
    character(len=8) :: tych
    character(len=19) :: cns1
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
!   seul les cham_no sont autorises 
    call dismoi('TYPE_CHAMP', nomch, 'CHAMP', repk=tych)
    ASSERT(tych .eq. 'NOEU')
!
!   passage cham_no -> cham_elem_s / ELNO
    cns1='&&VRCINE.CNS1'
    call cnocns(nomch, 'V', cns1)
    call cnsces(cns1, 'ELNO', cesmod, ' ', 'V', chs)
!
!   menage
    call detrsd('CHAM_NO_S', cns1)
!
    call jedema()
!
end subroutine
