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

subroutine asgnbn(ibla, nbloc, bloca, nbterm, inobl, iadbl,&
                  nomblo, numblo, fact)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 13/10/92
!-----------------------------------------------------------------------
!  BUT:      < ASSEMBLAGE GENERALISE BAS NIVEAU >
!
!   ASSEMBLER LES TERME D'UN BLOC ELEMENTAIRE DANS LE BLOC ASSEMBLE
!     (TOUS LES TERMES DU BLOC ELEMENTAIRES NON PAS LE BLOC ASSEMBLE
!   COURANT POUR DESTINATION)
!
!-----------------------------------------------------------------------
!
! NOM----- / /:
!
! IBLA     /M/: NUMERO DU BLOC ASSEMBLE COURANT
! BLOCA    /I/: BLOC ASSEMBLE COURANT
! NBTERM   /I/: NOMBRE DE TERMES BLOC ELEMENTAIRE
! INOBL    /I/: VECTEUR NUMERO BLOC ARRIVEES TERME BLOC ELEMENTAIRE
! IADBL    /I/: VECTEUR DES ADRESSE RELATIVE DANS BLOC ASSEMBLE
! NOMBLO   /I/: NOM K24 DU OU DE LA FAMILLE DES BLOCS ELEMENTAIRES
! NUMBLO   /I/: NUMERO DU BLOC ELEMENTAIRE DANS LA FAMILLE OU 0
! FACT     /I/: FACTEUR REEL MULTIPLICATIF
!
!
!
!
!
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=24) :: nomblo
    integer :: nbterm, inobl(nbterm), iadbl(nbterm), nbloc, ntria
    real(kind=8) :: fact, bloca(*)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ibla, llblo, numblo, iblo
!-----------------------------------------------------------------------
    call jemarq()
    if (numblo .eq. 0) then
! provisoire, a modifier
        if (ibla.gt.nbloc) then
            iblo = ibla - nbloc
            call jelira(nomblo,'NMAXOC',ntria)
            call jeveuo(jexnum(nomblo,ntria), 'L', llblo)
        else
            iblo = ibla
            call jeveuo(jexnum(nomblo,1), 'L', llblo)
        end if
    else  
        if (ibla.gt.nbloc) then
            iblo = ibla - nbloc   
        else       
            iblo = ibla
        end if
        call jeveuo(jexnum(nomblo, numblo), 'L', llblo)
    endif
!
    do  i = 1, nbterm
        if (inobl(i) .eq. iblo) then
            bloca(iadbl(i))=bloca(iadbl(i))+(fact*zr(llblo+i-1))
        endif
    end do
!
    if (numblo .eq. 0) then
    else
    endif
!
    call jedema()
end subroutine
