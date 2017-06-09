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

subroutine te0546(option, nomte)
    implicit none
! aslint: disable=W0104
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/tecach.h"
!
    character(len=16) :: nomte, option
!.......................................................................
! person_in_charge: jacques.pellet at edf.fr
!
!     BUT: CALCUL DES OPTIONS SIGM_ELGA ET EFGE_ELGA
!          POUR TOUS LES ELEMENTS
!.......................................................................
!
    integer :: itab1(8), itab2(8), iret, nbpg, nbcmp, nbsp
    integer :: kpg, ksp, kcmp, jin, jout, ico, n1
!.......................................................................
!
!
    call tecach('OOO', 'PSIEFR', 'L', iret, nval=8,&
                itab=itab1)
    ASSERT(iret.eq.0)
!
    if (option .eq. 'SIGM_ELGA') then
        call tecach('OOO', 'PSIGMR', 'E', iret, nval=8,&
                    itab=itab2)
    else if (option.eq.'EFGE_ELGA') then
        call tecach('OOO', 'PEFGER', 'E', iret, nval=8,&
                    itab=itab2)
    else
        ASSERT(.false.)
    endif
!
!     -- VERIFICATIONS DE COHERENCE :
!     --------------------------------
    nbpg=itab1(3)
    ASSERT(nbpg.ge.1)
    ASSERT(nbpg.eq.itab2(3))
!
    nbsp=itab1(7)
    ASSERT(nbsp.ge.1)
    ASSERT(nbsp.eq.itab2(7))
!
    n1=itab1(2)
    nbcmp=n1/nbpg
    ASSERT(nbcmp*nbpg.eq.n1)
    ASSERT(nbcmp*nbpg.eq.itab2(2))
!
    ASSERT(itab1(6).le.1)
    ASSERT(itab2(6).le.1)
!
!     -- RECOPIE DES VALEURS :
!     --------------------------
    jin=itab1(1)
    jout=itab2(1)
    ico=0
    do kpg = 1, nbpg
        do ksp = 1, nbsp
            do kcmp = 1, nbcmp
                ico=ico+1
                zr(jout-1+ico)=zr(jin-1+ico)
            end do
        end do
    end do
!
end subroutine
