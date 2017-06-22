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

subroutine vtzero(chamna)
!    - fonction realisee:  initialisation a zero du .vale du cham_no chamna
!     ------------------------------------------------------------------
!     IN  CHAMNA  :  K* : CHAM_NO
!----------------------------------------------------------------------
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: chamna
!
!
! DECLARATION VARIABLES LOCALES
    integer :: neq, ival, i, neq1
    character(len=24) :: kval, chamn
!
! CORPS DU PROGRAMME
    call jemarq()
    chamn=chamna
!
!
    kval=chamn(1:19)//'.VALE'
    call jeveuo(kval, 'E', ival)
    call jelira(kval, 'LONMAX', neq)
    neq1=neq-1
    do i = 0, neq1
        zr(ival+i)=0.d0
    end do
!
!
!
    call jedema()
end subroutine
