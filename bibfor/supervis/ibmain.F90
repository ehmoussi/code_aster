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

subroutine ibmain()
    implicit none
#include "asterf_types.h"
#include "asterc/faster.h"
#include "asterc/gtopti.h"
#include "asterc/inisig.h"
#include "asterfort/ib0mai.h"
#include "asterfort/lxinit.h"
!     ENSEMBLE DES INITIALISATIONS POUR L'EXECUTION D'UN JOB
!
!     ------- COMMUN DEBUG SUPERVISEUR ---------------------------------
!
    integer :: issuiv, iret
!
!     --- BUFFERISATION EN CAS DE SUIVI INTERACTIF
    call gtopti('suivi_batch', issuiv, iret)
    if (issuiv .gt. 0 .and. iret .eq. 0) then
        call faster()
    endif
!
!     --- INITIALISATION DE L'ANALYSEUR LEXICAL ET DE L'UNITE DE LECTURE
    call lxinit()
!
!     --- INITIALISATION DE L"INTERCEPTION DE CERTAINS SIGNAUX
    call inisig()
!
!     --- INITIALISATION DE JEVEUX   ---
    call ib0mai()
!
end subroutine
