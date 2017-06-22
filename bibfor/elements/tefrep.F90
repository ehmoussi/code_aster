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

subroutine tefrep(option, nomte, param, iforc)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
    character(len=*) :: param
!
! ......................................................................
! person_in_charge: jacques.pellet at edf.fr
!    - BUT:
!     RECUPERER L'ADRESSE DU CHAMP LOCAL CORRESPONDANT AUX EFFORTS
!     REPARTIS (CHAR_MECA_FR.D.D)
! ......................................................................
!
    integer :: iforc, itab(8), k, iret, ino, ico
    integer :: iadzi, iazk24, nbval, jad, nbno, nbcmp
    character(len=24) :: valk(4)
    character(len=8) :: nommai
!     ------------------------------------------------------------------
!
    call tecach('OON', param, 'L', iret, nval=8,&
                itab=itab)
    ASSERT(iret.eq.0.or.iret.eq.3)
!
    if (iret .eq. 0) then
        iforc=itab(1)
!
    else if (iret.eq.3) then
        iforc=itab(1)
!       -- APRES CONCERTATION (JP+JLF) ON DECIDE :
!       1) SI UN NOEUD NE PORTE PAS TOUTES LES CMPS => <F>
!       2) SI UN NOEUD NE PORTE AUCUNE COMPOSANTE, ON LE MET
!          A ZERO.
        nbval=itab(2)
        nbno=itab(3)
        jad=itab(8)
        nbcmp=nbval/nbno
        ASSERT(nbval.eq.nbno*nbcmp)
!
        do 3,ino=1,nbno
        ico=0
        do 1, k=1,nbcmp
        if (zl(jad-1+(ino-1)*nbcmp+k)) ico=ico+1
 1      continue
        if (ico .ne. 0 .and. ico .ne. nbcmp) goto 12
        ASSERT(iforc.ne.0)
        if (ico .eq. 0) then
            do 2, k=1,nbcmp
            zr(iforc-1+(ino-1)*nbcmp+k)=0.d0
 2          continue
        endif
 3      continue
        goto 9999
!
!
12      continue
        call tecael(iadzi, iazk24)
        nommai=zk24(iazk24-1+3)
        valk(1) = param
        valk(2) = option
        valk(3) = nomte
        valk(4) = nommai
        call utmess('F', 'CALCUL_18', nk=4, valk=valk)
    endif
!
9999  continue
end subroutine
