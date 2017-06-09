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

subroutine lispcp(motfac, iexci, phase, npuis)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
    character(len=16) :: motfac
    integer :: iexci
    real(kind=8) :: phase
    integer :: npuis
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! LECTURE PULSATION ET PUISSANCE
!
! ----------------------------------------------------------------------
!
!
! IN  MOTFAC : MOT-CLEF FACTEUR DES EXCITATIONS
! IN  IEXCI  : OCCURRENCE DE L'EXCITATION
! OUT PHASE  : PHASE POUR LES FONCTIONS MULTIPLICATRICES COMPLEXES
! OUT NPUIS  : PUISSANCE POUR LES FONCTIONS MULTIPLICATRICES COMPLEXES
!
! ----------------------------------------------------------------------
!
    integer ::  n
    integer :: eximcp
!
! ----------------------------------------------------------------------
!
    phase = 0.d0
    npuis = 0
    eximcp = getexm(motfac,'PHAS_DEG')
    if (eximcp .eq. 1) then
        call getvr8(motfac, 'PHAS_DEG', iocc=iexci, scal=phase, nbret=n)
        call getvis(motfac, 'PUIS_PULS', iocc=iexci, scal=npuis, nbret=n)
    endif
!
end subroutine
