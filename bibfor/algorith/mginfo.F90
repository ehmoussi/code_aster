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

subroutine mginfo(modmec, numddl, nbmode, neq)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=8) :: modmec
    integer :: nbmode, neq
    character(len=14) :: numddl
!
!
! ----------------------------------------------------------------------
!
! UTILITAIRE
!
! INFORMATIONS SUR MATRICE MODES MECANIQUES
!
! ----------------------------------------------------------------------
!
!
! IN  MODMEC : NOM DE LA MATRICE DES MODES MECANIQUES
! OUT NUMDDL : NOM DU DDL
! OUT NBMODE : NOMBRE DE MODES
! OUT NEQ    : NOMBRE D'EQUATIONS
!
!
!
!
    character(len=24) :: matric
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INFORMATIONS SUR MATRICE DES MODES MECANIQUES
!
!
!
    call dismoi('NUME_DDL', modmec, 'RESU_DYNA', repk=numddl)
    if (numddl(1:1) .ne. ' ') then
        call dismoi('NB_EQUA', numddl, 'NUME_DDL', repi=neq)
    else
        call dismoi('REF_RIGI_PREM', modmec, 'RESU_DYNA', repk=matric)
        call dismoi('NOM_NUME_DDL', matric, 'MATR_ASSE', repk=numddl)
        call dismoi('NB_EQUA', matric, 'MATR_ASSE', repi=neq)
    endif
!
! --- NOMBRE DE MODES
!
    call jelira(modmec//'           .ORDR', 'LONMAX', nbmode)
!
    call jedema()
end subroutine
