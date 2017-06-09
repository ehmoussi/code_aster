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

subroutine mdlibe(nomres, nbnli)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
!     Memory clearup of resulting vectors in a DYNA_VIBRA//TRAN/GENE calculation
!     with a non-constant integration step
!     ------------------------------------------------------------------
! in  : nomres : result name (usually &&AD****)
! in  : nbnli  : number of localised non linearities
! ----------------------------------------------------------------------
!
#include "asterfort/jelibe.h"
#include "asterfort/jeexin.h"
!   Input arguments
    character(len=8), intent(in) :: nomres
    integer,          intent(in) :: nbnli
!   Local variables
    integer           :: iret
    character(len=9)  :: bl8pt
    character(len=12) :: bl11pt
!-----------------------------------------------------------------------
    bl11pt = '           .'
    bl8pt  = '        .'

    call jelibe(nomres//bl11pt//'DEPL')
    call jelibe(nomres//bl11pt//'VITE')
    call jelibe(nomres//bl11pt//'ACCE')
    call jelibe(nomres//bl11pt//'ORDR')
    call jelibe(nomres//bl11pt//'DISC')
    call jelibe(nomres//bl11pt//'PTEM')

    if (nbnli .gt. 0 ) then
        call jelibe(nomres//bl8pt//'NL.TYPE')
        call jelibe(nomres//bl8pt//'NL.INTI')
        call jelibe(nomres//bl8pt//'NL.VIND')
        call jeexin(nomres//bl8pt//'NL.VINT', iret)
        if (iret.gt.0) call jelibe(nomres//bl8pt//'NL.VINT')
    end if
!
end subroutine
