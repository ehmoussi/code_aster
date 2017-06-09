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

subroutine mltcmj(nb, n, p, front, frn,&
                  adper, trav, c)
! person_in_charge: olivier.boiteau at edf.fr
use superv_module
    implicit none
! aslint: disable=C1513
#include "blas/zgemm.h"
    integer :: n, p, adper(*)
    complex(kind=8) :: front(*), frn(*)
    integer :: nb, decal, add, ind, nmb, i, j, kb, ia, ib, restm
    character(len=1) :: tra, trb
    integer :: i1, j1, k, m, it, numpro
    complex(kind=8) :: s, trav(p, nb, *)
    complex(kind=8) :: c(nb, nb, *), alpha, beta
    m=n-p
    nmb=m/nb
    restm = m -(nb*nmb)
    decal = adper(p+1) - 1
    tra='N'
    trb='N'
    alpha=dcmplx(-1.d0,0.d0)
    beta =dcmplx( 0.d0,0.d0)
!
    !$OMP PARALLEL DO DEFAULT(PRIVATE) &
    !$OMP SHARED(N,M,P,NMB,NB,RESTM,FRONT,ADPER,DECAL,FRN,TRAV,C) &
    !$OMP SHARED(TRA,TRB,ALPHA,BETA) &
    !$OMP SCHEDULE(STATIC,1)
    do 1000 kb = 1, nmb
        numpro = asthread_getnum() + 1
!     K : INDICE DE COLONNE DANS LA MATRICE FRONTALE (ABSOLU DE 1 A N)
        k = nb*(kb-1) + 1 +p
        do 100 i = 1, p
            s = front(adper(i))
            add= n*(i-1) + k
            do 50 j = 1, nb
                trav(i,j,numpro) = front(add)*s
                add = add + 1
50          continue
100      continue
!     BLOC DIAGONAL
!
!     SOUS LE BLOC DIAGONAL
!     2EME ESSAI : DES PRODUITS DE LONGUEUR NB
!
        do 500 ib = kb, nmb
            ia = k + nb*(ib-kb)
            it=1
            call zgemm(tra, trb, nb, nb, p,&
                       alpha, front(ia), n, trav(it, 1, numpro), p,&
                       beta, c(1, 1, numpro), nb)
!     RECOPIE
!
!
            do 501 i = 1, nb
                i1=i-1
!     IND = ADPER(K +I1) - DECAL  + NB*(IB-KB-1) +NB - I1
                if (ib .eq. kb) then
                    j1= i
                    ind = adper(k + i1) - decal
                else
                    j1=1
                    ind = adper(k + i1) - decal + nb*(ib-kb) - i1
                endif
                do 502 j = j1, nb
                    frn(ind) = frn(ind) +c(j,i,numpro)
                    ind = ind +1
502              continue
501          continue
500      continue
        if (restm .gt. 0) then
            ib = nmb + 1
            ia = k + nb*(ib-kb)
            it=1
            call zgemm(tra, trb, restm, nb, p,&
                       alpha, front(ia), n, trav(it, 1, numpro), p,&
                       beta, c(1, 1, numpro), nb)
!
!     RECOPIE
!
!
            do 801 i = 1, nb
                i1=i-1
!     IND = ADPER(K +I1) - DECAL  + NB*(IB-KB-1) +NB - I1
                j1=1
                ind = adper(k + i1) - decal + nb*(ib-kb) - i1
                do 802 j = j1, restm
                    frn(ind) = frn(ind) +c(j,i,numpro)
                    ind = ind +1
802              continue
801          continue
        endif
1000  end do
    !$OMP END PARALLEL DO
    if (restm .gt. 0) then
        kb = 1+nmb
!     K : INDICE DE COLONNE DANS LA MATRICE FRONTALE (ABSOLU DE 1 A N)
        k = nb*(kb-1) + 1 +p
        do 101 i = 1, p
            s = front(adper(i))
            add= n*(i-1) + k
            do 51 j = 1, restm
                trav(i,j,1) = front(add)*s
                add = add + 1
51          continue
101      continue
!     BLOC DIAGONAL
!
        ib = kb
        ia = k + nb*(ib-kb)
        it=1
        call zgemm(tra, trb, restm, restm, p,&
                   alpha, front(ia), n, trav(it, 1, 1), p,&
                   beta, c(1, 1, 1), nb)
!     RECOPIE
!
!
        do 902 i = 1, restm
            i1=i-1
!     IND = ADPER(K +I1) - DECAL  + NB*(IB-KB-1) +NB - I1
            j1= i
            ind = adper(k + i1) - decal
            do 901 j = j1, restm
                frn(ind) = frn(ind) +c(j,i,1)
                ind = ind +1
901          continue
902      continue
!
    endif
end subroutine
