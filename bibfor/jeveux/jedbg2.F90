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

subroutine jedbg2(dbgav, dbgap)
    implicit none
#include "asterfort/assert.h"
    integer :: dbgav, dbgap
! BUT :  CONSULTER ET EVENTUELLEMENT METTRE A JOUR
!        LA VALEUR IDEBUG DE JEVEUX
!
!      IDEBUG=1 => "DEBUG_JEVEUX"
!      IDEBUG=0 => PAS DE "DEBUG_JEVEUX"
!
!
! OUT  I  DBGAV : VALEUR DE IDEBUG AVANT L'APPEL A JEDBG2 (0 OU 1)
! IN   I  DBGAP : VALEUR DE IDEBUG APRES L'APPEL A JEDBG2 (-1,0 OU 1)
!                 SI DBGAP=-1 : ON NE MODIFIE PAS IDEBUG
!-----------------------------------------------------------------------
    integer :: lundef, idebug
    common /undfje/  lundef,idebug
!
    dbgav=idebug
!
    if (dbgap .eq. -1) then
    else if (dbgap.eq.0) then
        idebug=0
    else if (dbgap.eq.1) then
        idebug=1
    else
        ASSERT(.false.)
    endif
end subroutine
