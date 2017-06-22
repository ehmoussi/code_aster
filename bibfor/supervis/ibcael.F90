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

subroutine ibcael(type)
    implicit none
#include "asterfort/jedupc.h"
#include "asterfort/jeinif.h"
#include "asterfort/jelibf.h"
#include "asterfort/utmess.h"
    character(len=*) :: type
    character(len=8) :: nomf
    integer :: info
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    info = 1
    nomf = 'ELEMBASE'
    if (type .eq. 'ECRIRE') then
        call jeinif('DEBUT', 'SAUVE', nomf, 'C', 300,&
                    512, 100)
        call jedupc('G', '&CATA', 1, 'C', '&BATA',&
                    .false._1)
        call jelibf('SAUVE', 'C', info)
        call utmess('I', 'SUPERVIS_16')
    else
        call jeinif('POURSUITE', 'LIBERE', nomf, 'C', 300,&
                    512, 100)
        call jedupc('C', '&BATA', 1, 'G', '&CATA',&
                    .false._1)
        call jelibf('LIBERE', 'C', info)
        call utmess('I', 'SUPERVIS_17')
    endif
end subroutine
