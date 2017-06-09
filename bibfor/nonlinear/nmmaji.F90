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

subroutine nmmaji(numedd, lgrot, lendo, sdnume, coef,&
                  incmoz, ddincz, incplz, ordre)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/majour.h"
    aster_logical :: lgrot, lendo
    real(kind=8) :: coef
    character(len=*) :: incplz, incmoz, ddincz
    character(len=24) :: numedd
    character(len=19) :: sdnume
    integer :: ordre
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! MISE A JOUR DE L'INCONNUE EN DEPLACEMENT
!
! ----------------------------------------------------------------------
!
! INCPLU = INCMOI + COEF*DDINNC
!
! IN  NUMEDD : NOM DU NUME_DDL
! IN  COEF   : COEFFICIENT MULTIPLICATEUR
! IN  INCMOI : CHAMP DE DEPL. INITIAL
! OUT INCPLU : CHAMP DE DEPL. CORRIGE
! IN  DDINNC : INCREMENT CHAMP DE DEPL.
! IN  LGROT  : .TRUE.  S'IL Y A DES DDL DE GRDE ROTATION
! IN  SDNUME : SD NUMEROTATION
! IN  ORDRE  : 0 -> MAJ DES INCREMENTS
!              1 -> MAJ DES DEPL
!
!
!
!
    integer :: neq
    character(len=24) :: incplu, incmoi
    character(len=24) :: ddincc
    real(kind=8), pointer :: ddepl(:) => null()
    real(kind=8), pointer :: depm(:) => null()
    real(kind=8), pointer :: depp(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    incplu = incplz
    incmoi = incmoz
    ddincc = ddincz
!
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
    call jeveuo(incmoi(1:19)//'.VALE', 'L', vr=depm)
    call jeveuo(incplu(1:19)//'.VALE', 'E', vr=depp)
    call jeveuo(ddincc(1:19)//'.VALE', 'E', vr=ddepl)
!
! --- MISE A JOUR
!
    call majour(neq, lgrot, lendo, sdnume, depm,&
                ddepl, coef, depp, ordre)
!
    call jedema()
end subroutine
