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

subroutine jaexin(nomlu, iret)
    implicit none
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
    character(len=*) :: nomlu
    integer :: iret
! ----------------------------------------------------------------------
! BUT : TESTE L'EXISTENCE REELLE D'UN OBJET JEVEUX
!
! IN  NOMLU  : NOM DE L'OBJET JEVEUX (EVENTUELLEMENT JEXNUM(NOMCO,IOBJ))
! OUT IRET   : =0 L'OBJET N'EXISTE PAS
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    character(len=32) :: noml32
    integer :: iexi, iadm, iadd
! DEB ------------------------------------------------------------------
    noml32 = nomlu
!
    call jeexin(noml32, iexi)
    if (iexi .eq. 0) goto 9998
!
    call jelira(noml32, 'IADD', iadd)
    call jelira(noml32, 'IADM', iadm)
    if (iadm .eq. 0 .and. iadd .eq. 0) goto 9998
!
    iret=1
    goto 9999
!
9998  continue
    iret=0
    goto 9999
!
9999  continue
end subroutine
