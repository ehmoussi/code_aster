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

subroutine sepavp(ck, cm, cmat, ndim, alpha,&
                  beta, nbmod, lambd1, lambd2, interv)
!  BUT:  < SEPARATION DES VALEURS PROPRES >
    implicit none
!
!   CETTE ROUTINE ENCADRE CHACUNE DES VALEURS PROPRES D'UN PROBLEME A
!   MATRICES RAIDEUR ET MASSE COMPLEXES HERMITIENNES SYMETRIQUES
!   STOCKEES CARREES PLEINES PAR DES REELS RANGES DANS LES TABLEAUX
!   ALPHA ET BETA
!
!-----------------------------------------------------------------------
!
! CK       /I/: MATRICE RAIDEUR DU PROBLEME
! CM       /I/: MATRICE MASSE DU PROBLEME
! CMAT     /M/: MATRICE COMPLEXE DE TRAVAIL
! NDIM     /I/: DIMENSION DES MATRICES
! BETA     /O/: BORNE SUP DE L'INTERVALE CONTENANT LA VP
! ALPHA    /O/: BORNE INF DE L'INTERVALE CONTENANT LA VP
! NBMOD    /M/: NOMBRE DE MODES PROPRES DESIRE/EXISTANT
! LAMBD1   /I/: BORNE INFERIEURE DE L'INTERVE DE RECHERCHE
! LAMBD2   /I/: BORNE SUPERIEURE DE L'INTERVE DE RECHERCHE
! INTERV   /I/: LONGUEUR MAXIMAL D'UN INTERVE CONTENANT UNE VP
!
!-----------------------------------------------------------------------
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nbval.h"
#include "asterfort/utmess.h"
    integer :: ndim, nbmod
    complex(kind=8) :: ck(*), cm(*), cmat(*)
    real(kind=8) :: alpha(ndim+1), beta(ndim+1)
    real(kind=8) :: lambd1, lambd2, valr(2)
    real(kind=8) :: interv
    integer :: i, n1, n2, nb, ct
    real(kind=8) :: a, b, c
    aster_logical :: sortie
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    do 10 i = 1, nbmod
        alpha(i)=-1
        beta(i) =-1
 10 end do
    alpha(1)=lambd1
    call nbval(ck, cm, cmat, ndim, lambd1,&
               n1)
    call nbval(ck, cm, cmat, ndim, lambd2,&
               n2)
    nbmod=min(n2-n1,nbmod)
    beta(nbmod)=lambd2
    valr(1)=lambd1
    valr(2)=lambd2
    call utmess('I', 'ALGELINE6_9', si=nbmod, nr=2, valr=valr)
    do 20 i = 1, nbmod
        if (alpha(i) .ge. 0.d0) then
            a=alpha(i)
        else
            sortie=.false.
            ct=i
 70         continue
            ct=ct-1
            if (ct .le. 1) then
                sortie=.true.
                a=lambd1
            endif
            if (beta(ct) .ge. 0.d0) then
                sortie=.true.
                a=beta(ct)
            endif
            if (sortie) goto 80
            goto 70
 80         continue
        endif
        if (beta(i) .ge. 0.d0) then
            b=beta(i)
        else
            sortie=.false.
            ct=i
 50         continue
            ct=ct+1
            if (ct .ge. nbmod) then
                sortie=.true.
                b=lambd2
            endif
            if (alpha(ct) .ge. 0.d0) then
                sortie=.true.
                b=alpha(ct)
            endif
            if (sortie) goto 60
            goto 50
 60         continue
        endif
 30     continue
        if (beta(i) .ge. 0.d0) then
            if (alpha(i) .ge. 0.d0) then
                if ((beta(i)-alpha(i)) .le. interv) goto 40
            endif
        endif
        c=(a+b)/2
        call nbval(ck, cm, cmat, ndim, c,&
                   nb)
        nb=nb-n1
        ASSERT(nb.ge.0 .and.nb.le.nbmod)
        if (nb .gt. 0) then
            if (beta(nb) .lt. 0.d0) then
                beta(nb)=c
            else
                beta(nb)=min(c,beta(nb))
            endif
        endif
        if (alpha(nb+1) .lt. 0.d0) then
            alpha(nb+1)=c
        else
            alpha(nb+1)=max(c,alpha(nb+1))
        endif
        if (nb .lt. i) a=c
        if (nb .ge. i) b=c
        goto 30
 40     continue
 20 end do
end subroutine
