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

subroutine mvnume(depmoi, depdel, depplu)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/copisd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/vtcmbl.h"
#include "asterfort/vtcopy.h"
#include "asterfort/vtzero.h"
    character(len=19) :: depmoi, depdel, depplu
!
! ----------------------------------------------------------------------
!
! ROUTINE CALCUL (INITIALISATION)
!
! PREPARATION DEPLACEMENTS AVEC TRANSFERT DE NUMEROTATION
!
! ----------------------------------------------------------------------
!
! IN  DEPMOI : DEPLACEMENTS EN T-
! IN  DEPDEL : INCREMENT DE DEPLACEMENT
! OUT DEPPLU : DEPLACEMENTS EN T+
!
! ----------------------------------------------------------------------
!
    integer :: iret
    character(len=19) :: pfchn1, pfchn2
    character(len=1) :: typcst(2), typech(2), typres
    real(kind=8) :: const(2)
    character(len=24) :: nomch(2), chpres, depmo1
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    depmo1 = '&&MVNUME.DEPMO1'
!
! --- SI LES CHAMPS N'ONT PAS LA MEME NUMEROTATION, ON TRANSFERT DEPMOI
! --- DANS LA NUMEROTATION DE DEPDEL
!
    call dismoi('PROF_CHNO', depmoi, 'CHAM_NO', repk=pfchn1)
    call dismoi('PROF_CHNO', depdel, 'CHAM_NO', repk=pfchn2)
    if (pfchn1 .ne. pfchn2) then
        call copisd('CHAMP_GD', 'V', depdel, depmo1)
        call vtzero(depmo1)
        call vtcopy(depmoi, depmo1, 'F', iret)
    else
        depmo1 = depmoi
    endif
!
! --- ON CALCULE LE CHAMP DEPPLU=DEPMO1+DEPDEL
!
    typcst(1) = 'R'
    typcst(2) = 'R'
    const(1) = 1.d0
    const(2) = 1.d0
    typech(1) = 'R'
    typech(2) = 'R'
    nomch(1) = depmo1
    nomch(2) = depdel
    typres = 'R'
    chpres = depplu
    call vtcmbl(2, typcst, const, typech, nomch,&
                typres, chpres)
!
    call jedema()
end subroutine
