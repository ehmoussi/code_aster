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

subroutine ampcpr(cmat, nb1, nb2, bmat, n1,&
                  n2, i, j, fac, npar,&
                  nsym)
    implicit none
#include "asterfort/utmess.h"
!
!***********************************************************************
!    P. RICHARD     DATE 12/03/91
!-----------------------------------------------------------------------
!  BUT:  AJOUTER UNE MATRICE PLEINE REELLE A UNE MATRICE PLEINE
!       COMPLEXE (SOIT A LA PARTIE REELLE SOIT A LA PARTIE IMAGINAIRE)
!            MULTIPLICATION POSSIBLE PAR UN FACTEUR
!-----------------------------------------------------------------------
!
! CMAT     /M/: MATRICE RECEPTRICE COMPLEXE
! NB1      /I/: NB DE LIGNES DE LA MATRICE RECEPTRICE
! NB2      /I/: NB DE COLONNES DE LA MATRICE RECEPTRICE
! BMAT     /M/: MATRICE PLEINE RELLE, A AJOUTER
! N1       /I/: NB DE LIGNE DE LA MATRICE A AJOUTER
! N2       /I/: NB DE COLONNE DE LA MATRICE A AJOUTER
! I        /I/: INDICE DU PREMIER TERME DANS RECEPTRICE
! J        /I/: INDICE DE COLONNE TERME  DANS RECEPTRICE
! FAC      /I/: FACTEUR MULTIPLICATIF DE LA MATRICE RELLE AVANT ASSEMBLA
! NPAR     /I/: INDICATEUR PARTIE RELLE (1) OU IMAGINAIRE(2)
! NSYM     /I/: INDICATEUR TRANSPOSITION (-1) MATRICE REELLE OU NON(1)
!
!-----------------------------------------------------------------------
!
    real(kind=8) :: bmat(n1, n2)
    complex(kind=8) :: cmat(*)
!
!-----------------------------------------------------------------------
!
!   CAS SANS TRANSPOSITION
!
!-----------------------------------------------------------------------
    integer :: i, icol, ideb, ifin, ii, iideb, iifin
    integer :: ilig, iterme, j, jdeb, jfin, jj, jjdeb
    integer :: jjfin, n1, n2, nb1, nb2, npar, nsym
!
    real(kind=8) :: fac
!-----------------------------------------------------------------------
    if (nsym .eq. 1) then
!
        jdeb=j
        jfin=min(j+n2-1,nb2)
        if ((j+n2-1) .gt. nb2) then
            call utmess('F', 'ALGORITH11_88')
        endif
        if (jfin .lt. jdeb) goto 9999
        jjdeb=jdeb-j+1
        jjfin=jfin-j+1
!
        ideb=i
        if ((i+n1-1) .gt. nb1) then
            call utmess('F', 'ALGORITH11_88')
        endif
        ifin=min(i+n1-1,nb1)
        if (ifin .lt. ideb) goto 9999
        iideb=ideb-i+1
        iifin=ifin-i+1
!
!    PARTIE RELLE
!
        if (npar .eq. 1) then
!
            do 10 ii = iideb, iifin
                do 20 jj = jjdeb, jjfin
                    ilig = i+ii-1
                    icol = j+jj-1
                    if (icol .ge. ilig) then
                        iterme = icol*(icol-1)/2+1+icol-ilig
                        cmat(iterme)=cmat(iterme)+dcmplx(bmat(ii,jj)*&
                        fac,0.d0)
                    endif
20              continue
10          continue
!
        else
!
!    PARTIE IMAGINAIRE
!
            do 30 ii = iideb, iifin
                do 40 jj = jjdeb, jjfin
                    ilig = i+ii-1
                    icol = j+jj-1
                    if (icol .ge. ilig) then
                        iterme = icol*(icol-1)/2+1+icol-ilig
                        cmat(iterme)=cmat(iterme)+dcmplx(0.d0,bmat(ii,&
                        jj)*fac)
                    endif
40              continue
30          continue
!
        endif
    endif
!
!
!     CAS AVEC TRANSPOSITION
!
    if (nsym .eq. -1) then
!
        jdeb=j
        jfin=min(j+n1-1,nb2)
        if ((j+n1-1) .gt. nb2) then
            call utmess('F', 'ALGORITH11_90')
        endif
        if (jfin .lt. jdeb) goto 9999
        jjdeb=jdeb-j+1
        jjfin=jfin-j+1
!
        ideb=i
        ifin=min(i+n2-1,nb1)
        if ((i+n2-1) .gt. nb1) then
            call utmess('F', 'ALGORITH11_88')
        endif
        if (ifin .lt. ideb) goto 9999
        iideb=ideb-i+1
        iifin=ifin-i+1
!
!    PARTIE RELLE
!
        if (npar .eq. 1) then
!
            do 50 ii = iideb, iifin
                do 60 jj = jjdeb, jjfin
                    ilig = i+ii-1
                    icol = j+jj-1
                    if (icol .ge. ilig) then
                        iterme = icol*(icol-1)/2+1+icol-ilig
                        cmat(iterme)=cmat(iterme)+dcmplx(bmat(jj,ii)*&
                        fac,0.d0)
                    endif
60              continue
50          continue
!
        else
!
!    PARTIE IMAGINAIRE
!
            do 70 ii = iideb, iifin
                do 80 jj = jjdeb, jjfin
                    ilig = i+ii-1
                    icol = j+jj-1
                    if (icol .ge. ilig) then
                        iterme = icol*(icol-1)/2+1+icol-ilig
                        cmat(iterme)=cmat(iterme)+dcmplx(0.d0,bmat(jj,&
                        ii)*fac)
                    endif
80              continue
70          continue
!
        endif
    endif
!
!
9999  continue
end subroutine
