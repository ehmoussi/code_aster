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

subroutine foattr(motcle, iocc, nomfon)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
    integer :: iocc
    character(len=*) :: motcle, nomfon
!     SURCHARGE LES ATTRIBUTS D'UN CONCEPT DE TYPE "FONCTION"
!     ----------------------------------------------------------------
    character(len=4) :: interp(2)
    character(len=8) :: prolg, prold
    character(len=16) :: npara, nresu
    character(len=19) :: temp
    character(len=24) :: prol
!     ----------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: if, l1, l2, l3, l4, l5, l6
    integer :: l7, l8, l9, lpro, nbfonc, nbprol
!
!-----------------------------------------------------------------------
    call jemarq()
    temp = nomfon
    ASSERT(lxlgut(temp).le.24)
    prol = temp//'.PROL'
    call jeveuo(prol, 'E', lpro)
    call jelira(prol, 'LONUTI', nbprol)
!
    if (zk24(lpro) .eq. 'NAPPE   ') then
        nbfonc = ( nbprol - 7 ) / 2
!
        call getvtx(motcle, 'INTERPOL', iocc=iocc, nbval=2, vect=interp,&
                    nbret=l1)
        if (l1 .eq. 1) zk24(lpro+1) = interp(1)//interp(1)
        if (l1 .eq. 2) zk24(lpro+1) = interp(1)//interp(2)
!
        call getvtx(motcle, 'NOM_PARA', iocc=iocc, scal=npara, nbret=l2)
        if (l2 .ne. 0) zk24(lpro+2) = npara
!
        call getvtx(motcle, 'NOM_RESU', iocc=iocc, scal=nresu, nbret=l3)
        if (l3 .ne. 0) zk24(lpro+3) = nresu
!
        call getvtx(motcle, 'PROL_GAUCHE', iocc=iocc, scal=prolg, nbret=l4)
        if (l4 .ne. 0) zk24(lpro+4)(1:1) = prolg(1:1)
!
        call getvtx(motcle, 'PROL_DROITE', iocc=iocc, scal=prold, nbret=l5)
        if (l5 .ne. 0) zk24(lpro+4)(2:2) = prold(1:1)
!
        zk24(lpro+5) = temp
!
        call getvtx(motcle, 'NOM_PARA_FONC', iocc=iocc, scal=npara, nbret=l6)
        if (l6 .ne. 0) zk24(lpro+6) = npara
!
        call getvtx(motcle, 'INTERPOL_FONC', iocc=iocc, nbval=2, vect=interp,&
                    nbret=l7)
        if (l7 .ne. 0) then
            do 10 if = 1, nbfonc
                if (l7 .eq. 1) zk24(lpro+7+2*(if-1)) = interp(1)// interp(1)
                if (l7 .eq. 2) zk24(lpro+7+2*(if-1)) = interp(1)// interp(2)
10          continue
        endif
!
        call getvtx(motcle, 'PROL_GAUCHE_FONC', iocc=iocc, scal=prolg, nbret=l8)
        if (l8 .ne. 0) then
            do 12 if = 1, nbfonc
                zk24(lpro+8+2*(if-1))(1:1) = prolg(1:1)
12          continue
        endif
!
        call getvtx(motcle, 'PROL_DROITE_FONC', iocc=iocc, scal=prold, nbret=l9)
        if (l9 .ne. 0) then
            do 14 if = 1, nbfonc
                zk24(lpro+8+2*(if-1))(2:2) = prold(1:1)
14          continue
        endif
!
!
    else
!
        call getvtx(motcle, 'INTERPOL', iocc=iocc, nbval=2, vect=interp,&
                    nbret=l1)
        if (l1 .ne. 0) then
            if (l1 .eq. 1) zk24(lpro+1) = interp(1)//interp(1)
            if (l1 .eq. 2) zk24(lpro+1) = interp(1)//interp(2)
        endif
!
        call getvtx(motcle, 'NOM_PARA', iocc=iocc, scal=npara, nbret=l2)
        if (l2 .ne. 0) zk24(lpro+2) = npara
!
        call getvtx(motcle, 'NOM_RESU', iocc=iocc, scal=nresu, nbret=l3)
        if (l3 .ne. 0) zk24(lpro+3) = nresu
!
        call getvtx(motcle, 'PROL_GAUCHE', iocc=iocc, scal=prolg, nbret=l4)
        if (l4 .ne. 0) zk24(lpro+4)(1:1) = prolg(1:1)
!
        call getvtx(motcle, 'PROL_DROITE', iocc=iocc, scal=prold, nbret=l5)
        if (l5 .ne. 0) zk24(lpro+4)(2:2) = prold(1:1)
!
        zk24(lpro+5) = temp
!
    endif
!
    call jedema()
end subroutine
