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

subroutine conlag(matasz, cond)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
    real(kind=8) :: cond
    character(len=*) :: matasz
!
! ----------------------------------------------------------------------
!
! RECUPERATION DU CONDITIONNEMENT DES LAGRANGES D'UNE MATRICE ASSEMBLEE
!
! ----------------------------------------------------------------------
!
! IN   MATASZ : SD MATRICE ASSEMBLEE
! OUT  COND   : CONDITIONNEMENT DES LAGRANGES
!
!
!
!
!
    integer ::  neq, iret, jcol
    character(len=19) :: matass
    real(kind=8), pointer :: conl(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    matass=matasz
    cond=1.d0
!
! ---  on sort des que l'on trouve un conditionnement de lagrange
    call jeexin(matass//'.CONL', iret)
    if (iret .ne. 0) then
        call dismoi('NB_EQUA', matass, 'MATR_ASSE', repi=neq)
        call jeveuo(matass//'.CONL', 'L', vr=conl)
        do jcol = 1, neq
            cond = 1.d0/conl(jcol)
            if (cond .ne. 1.d0) goto 999
        end do
    endif
!
999 continue
!
    call jedema()
end subroutine
