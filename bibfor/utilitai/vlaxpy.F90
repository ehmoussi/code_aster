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

subroutine vlaxpy(alpha, chamna, chamnb)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=*) :: chamna, chamnb
    real(kind=8) :: alpha
!-----------------------------------------------------------------------
!    - FONCTION REALISEE:  ENCAPSULATION DAXPY SUR LES .VALE DES CHAM_NO
!                    CHAMN1 ET CHAMN2 UNIQUEMENT SUR LES DDL DE LAGRANGE
!                       CHAMN2.VALE = ALPHA * CHAMN1.VALE + CHAMN2.VALE
!     ------------------------------------------------------------------
!     IN  ALPHA     :  R8  : COEFF. MULTIPLICATEUR
!     IN  CHAMNA    :  K*  : CHAM_NO MAITRE 1
!     IN/OUT CHAMNB :  K*  : CHAM_NO MAITRE 2
!----------------------------------------------------------------------
    integer :: neq,   i
    character(len=19) :: prno
    character(len=24) :: chamn1, chamn2
    integer, pointer :: delg(:) => null()
    real(kind=8), pointer :: val1(:) => null()
    real(kind=8), pointer :: val2(:) => null()
!----------------------------------------------------------------------
!
    call jemarq()
    chamn1=chamna
    chamn2=chamnb
!
! --- NUMEROTATION POUR TRIER LES LAGRANGE ET LES DDLS PHYSIQUES
    call dismoi('PROF_CHNO', chamn1, 'CHAM_NO', repk=prno)
    call jeveuo(prno(1:14)// '.NUME.DELG', 'L', vi=delg)
!
!
! --- MISE A JOUR DES VALEURS DES LAGRANGE
    call jeveuo(chamn1(1:19)//'.VALE', 'L', vr=val1)
    call jeveuo(chamn2(1:19)//'.VALE', 'E', vr=val2)
    call jelira(chamn2(1:19)//'.VALE', 'LONMAX', neq)
    do i = 1, neq
        if (delg(i) .ne. 0) val2(i)=alpha*val1(i) + val2(i)
    end do
!
    call jedema()
end subroutine
