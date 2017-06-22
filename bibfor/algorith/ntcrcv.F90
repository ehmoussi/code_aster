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

subroutine ntcrcv(sdcrit)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=19) :: sdcrit
!
! ----------------------------------------------------------------------
!
! ROUTINE THER_NON_LINE (STRUCTURES DE DONNES)
!
! CREATION DE LA SD POUR ARCHIVAGE DES INFORMATIONS DE CONVERGENCE
!
! ----------------------------------------------------------------------
!
!
! OUT SDCRIT : SD POUR ARCHIVAGE DES INFORMATIONS DE CONVERGENCE
!                (1) NOMBRE ITERATIONS NEWTON
!                (2) NOMBRE ITERATIONS RECHERCHE LINEAIRE
!                (3) RESI_GLOB_RELA
!                (4) RESI_GLOB_MAXI
!                (5) PARAMETRE DE RECHERCHE LINEAIRE RHO
!
!
!
!
    integer :: jcrr, jcrk
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- CREATION
!
    call wkvect(sdcrit(1:19)//'.CRTR', 'V V R8', 5, jcrr)
    call wkvect(sdcrit(1:19)//'.CRDE', 'V V K16', 5, jcrk)
    zk16(jcrk+1-1) = 'ITER_GLOB'
    zk16(jcrk+2-1) = 'ITER_LINE'
    zk16(jcrk+3-1) = 'RESI_GLOB_RELA'
    zk16(jcrk+4-1) = 'RESI_GLOB_MAXI'
    zk16(jcrk+5-1) = 'RHO'
!
    call jedema()
!
end subroutine
