! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine cgtyfi(typfis, nomfis, typdis)
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    character(len=8) :: typfis, nomfis
    character(len=16) :: typdis
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : DETERMINATION DU TYPE ET DU NOM DE LA SD DECRIVANT LE
!           FOND DE FISSURE
!
! OUT :
!   TYPFIS : TYPE DE LA SD DECRIVANT LE FOND DE FISSURE
!            ('FONDIFSS' OU 'FISSURE')
!   NOMFIS : NOM DE LA SD DECRIVANT LE FOND DE FISSURE
!   TYPDIS : TYPE DE DISCONTINUITE SI FISSURE XFEM 
!            'FISSURE' OU 'COHESIF'
! ======================================================================
!
    integer ::  ifond, ifiss
!
    call jemarq()
!
    call getvid('THETA', 'FOND_FISS', iocc=1, scal=nomfis, nbret=ifond)
    call getvid('THETA', 'FISSURE', iocc=1, scal=nomfis, nbret=ifiss)
!
    ASSERT(ifond.eq.0.or.ifond.eq.1)
    ASSERT(ifiss.eq.0.or.ifiss.eq.1)
!
!     NORMALEMENT, CETTE REGLE D'EXCLUSION EST VERIFIEE DANS LE CAPY
    ASSERT(ifond+ifiss.eq.1)
!
    typdis = ' '
!
    if (ifond.eq.1) then
!
        typfis='FONDFISS'
!
    else if (ifiss.eq.1) then
!
        typfis='FISSURE'
!
        call dismoi('TYPE_DISCONTINUITE', nomfis, 'FISS_XFEM', repk=typdis)
!
    endif
!
    call jedema()
!
end subroutine
