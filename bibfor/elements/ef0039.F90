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

subroutine ef0039(nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
    character(len=16) :: nomte
! ----------------------------------------------------------------------
!     CALCUL DE EFGE_ELNO
!     ------------------------------------------------------------------
    integer :: itab(2), ieffo, n1, i, iret, icontg
!     ------------------------------------------------------------------
!
    call tecach('OOO', 'PEFFORR', 'E', iret, nval=2,&
                itab=itab)
    ieffo=itab(1)
    n1=itab(2)
!
    call jevech('PCONTRR', 'L', icontg)
!
    do 70 i = 1, n1
        zr(ieffo-1+i)=zr(icontg-1+i)
70  end do
!
end subroutine
