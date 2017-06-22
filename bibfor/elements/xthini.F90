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

subroutine xthini(nomte, nfh, nfe)
! person_in_charge: sam.cuvilliez at edf.fr
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: nomte
    integer :: nfh, nfe
!
!
!          BUT : INITIALISER LES DIMENSIONS DES DDL DANS UN TE
!                POUR LES ELEMENTS X-FEM EN THERMIQUE
!
!
! IN   NOMTE  : NOM DU TYPE ELEMENT
! OUT  NFH    : NOMBRE DE FONCTIONS HEAVISIDES
! OUT  NFE    : NOMBRE DE FONCTIONS SINGULIÈRES D'ENRICHISSEMENT
! OUT  NDDL   : NOMBRE DE DDL TOTAL DE L'ÉLÉMENT
!     ------------------------------------------------------------------
!
    integer :: nno, ier, nnos, nfiss
    integer :: jtab(7), iret
    character(len=8) :: enr
!
! ----------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',nno=nno,nnos=nnos)
!
! --- INITIALISATIONS
!
    nfh = 0
    nfe = 0
!
    call teattr('S', 'XFEM', enr, ier, typel=nomte)
!
! --- DDL ENRICHISSEMENT : HEAVYSIDE, ENRICHIS (FOND)
!
    if (enr(1:2) .eq. 'XH') then
        nfh = 1
!       NOMBRE DE FISSURES :
        call tecach('NOO', 'PLST', 'L', iret, nval=7,&
                    itab=jtab)
        nfiss = jtab(7)
!       ON NE TRAITE PAS LA JONCTION DE FISSURES EN THERMMIQUE
        ASSERT(nfiss.eq.1)
    endif
!
    if (enr(1:2) .eq. 'XT' .or. enr(3:3) .eq. 'T') then
        nfe = 1
    endif
!
    ASSERT((nfh.eq.1 .and. nfe.eq.0) .or. (nfh.eq.0 .and. nfe.eq.1) .or.(nfh.eq.1 .and. nfe.eq.1))
!
end subroutine
