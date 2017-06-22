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

subroutine mltblc(nbsn, debfsn, mxbloc, seq, nbloc,&
                  decal, lgbloc, ncbloc)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
!       CALCUL DU NOMBRE DE BLOCS POUR LA MATRICE FACTORISEE
!       DONNEES :
!                 MXBLOC : LONGUEUR MAXIMUM D'UN BLOC
!       RESULTATS :
!                   NBLOC NBRE DE BLOCS
!                   NOBLOC(NBLOC) : NUMERO DE BLOC DE CHQUE SND
!                   LGBLOC(NBLOC) : NBRE DE COEFFICIENTS DE CHAQUE BLOC
!                   DECAL(NBSN) :  DEBUT DE CHAQUE SNOEUD DANS LE TABLEA
!                                    FACTOR QUI CONTIENT LES BLOCS
#include "asterc/ismaem.h"
#include "asterc/lor8em.h"
#include "asterfort/utmess.h"
    integer :: nbsn, seq(nbsn), debfsn(nbsn+1), mxbloc, nbloc, decal(nbsn)
    integer :: lgbloc(*), ncbloc(*)
    integer :: i, l, i0, long
    integer :: vali(3), lm, lr
!-----------------------------------------------------------------------
    integer :: ib, ni
!-----------------------------------------------------------------------
    lm=ismaem()
    lr=lor8em()
    nbloc = 1
    i0 = 1
110  continue
    i = i0
    decal(seq(i)) = 1
    long = debfsn(seq(i)+1) - debfsn(seq(i))
    if (long .gt. mxbloc) then
        vali (1) = mxbloc
        vali (2) = i
        vali (3) = long
        call utmess('F', 'ALGELINE4_21', ni=3, vali=vali)
    endif
!      DO WHILE (LONG.LE.MXBLOC)
120  continue
    if (long .le. mxbloc) then
        if (i .eq. nbsn) goto 130
        i = i + 1
        decal(seq(i)) = long + 1
        l = debfsn(seq(i)+1) - debfsn(seq(i))
        if (l .gt. mxbloc) then
            vali (1) = mxbloc
            vali (2) = i
            vali (3) = l
            call utmess('F', 'ALGELINE4_21', ni=3, vali=vali)
        endif
        long = long + l
        goto 120
! FIN DO WHILE
    endif
!      CHAQUE BLOC VA DES NUMEROS DE SNDS SEQ(I0) A SEQ(I-1)
    ncbloc(nbloc) = i - i0
    lgbloc(nbloc) = long - l
    nbloc = nbloc + 1
    i0 = i
    goto 110
!
130  continue
    ncbloc(nbloc) = nbsn - i0 + 1
    lgbloc(nbloc) = long
!
    do 140 ib = 1, nbloc
        if (lgbloc(ib) .gt. lm/lr) then
            ni=3
            vali(1)=ib
            vali(2)=lgbloc(ib)
            vali(3)=lm
            call utmess('A', 'ALGELINE3_52', ni=ni, vali=vali)
!
        endif
140  end do
end subroutine
