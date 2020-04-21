! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine mginfo(modmecz, numeDof, nbmode, nbEqua)
!
implicit none
!
#include "asterfort/dismoi.h"
#include "asterfort/jelira.h"
!
character(len=*), intent(in) :: modmecz
integer, intent(out) :: nbmode, nbEqua
character(len=14), intent(out) :: numeDof
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
! IN  MODMEC : NOM DE LA MATRICE DES MODES MECANIQUES
! OUT NUMDDL : NOM DU DDL
! OUT NBMODE : NOMBRE DE MODES
! OUT NEQ    : NOMBRE D'EQUATIONS

    character(len=24) :: matrix
    character(len=8) :: modmec
!
! ----------------------------------------------------------------------
!
    modmec  = modmecz
    nbEqua  = 0
    nbMode  = 0
    numeDof = ' '
    call dismoi('NUME_DDL', modmec, 'RESU_DYNA', repk=numeDof)
    if (numeDof(1:1) .ne. ' ') then
        call dismoi('NB_EQUA', numeDof, 'NUME_DDL', repi=nbEqua)
    else
        call dismoi('REF_RIGI_PREM', modmec, 'RESU_DYNA', repk=matrix)
        call dismoi('NOM_NUME_DDL', matrix, 'MATR_ASSE', repk=numeDof)
        call dismoi('NB_EQUA', matrix, 'MATR_ASSE', repi=nbEqua)
    endif
    call jelira(modmec//'           .ORDR', 'LONMAX', nbmode)
!
end subroutine
