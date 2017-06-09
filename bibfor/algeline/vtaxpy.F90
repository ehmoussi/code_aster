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

subroutine vtaxpy(alpha, chamna, chamnb)
!    - FONCTION REALISEE:  ENCAPSULATION DAXPY SUR LES .VALE DES CHAM_NO
!                          CHAMN1 ET CHAMN2
!                       CHAMN2.VALE = ALPHA * CHAMN1.VALE + CHAMN2.VALE
!     ------------------------------------------------------------------
!     IN  ALPHA     :  R8  : COEFF. MULTIPLICATEUR
!     IN  CHAMNA    :  K*  : CHAM_NO MAITRE 1
!     IN/OUT CHAMNB :  K*  : CHAM_NO MAITRE 2
!----------------------------------------------------------------------
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
    character(len=*) :: chamna, chamnb
    real(kind=8) :: alpha
!
!
    integer :: neq1, neq2, ival1, ival2
    character(len=24) :: kval1, kval2, chamn1, chamn2
!
    call jemarq()
    chamn1=chamna
    chamn2=chamnb
!
    kval1=chamn1(1:19)//'.VALE'
    kval2=chamn2(1:19)//'.VALE'
    call jeveuo(kval1, 'L', ival1)
    call jeveuo(kval2, 'E', ival2)
    call jelira(kval1, 'LONMAX', neq1)
    call jelira(kval2, 'LONMAX', neq2)
    ASSERT(neq1.eq.neq2)
    call daxpy(neq2, alpha, zr(ival1), 1, zr(ival2),&
               1)
!
!
    call jedema()
end subroutine
