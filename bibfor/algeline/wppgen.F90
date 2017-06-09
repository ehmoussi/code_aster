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

subroutine wppgen(lmasse, lamor, lraide, masseg, amorg,&
                  raideg, vect, neq, nbvect, iddl)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/mcmult.h"
#include "asterfort/wkvect.h"
    integer :: lmasse, lamor, lraide, neq, nbvect, iddl(*)
    real(kind=8) :: masseg(*), amorg(*), raideg(*)
    complex(kind=8) :: vect(neq, *)
!     CALCUL DES PARAMETRES MODAUX :
!            MASSE, AMORTISSEMENT ET RAIDEUR GENERALISES
!     ------------------------------------------------------------------
! IN  LMASSE : IS : DESCRIPTEUR NORMALISE DE LA MATRICE DE MASSE
!                   = 0  ON NE CALCULE PAS LA MASSE GENERALISEE
! IN  LAMOR  : IS : DESCRIPTEUR NORMALISE DE LA MATRICE D'AMORTISSEMENT
!                   = 0  ON NE CALCULE PAS L'AMORTISSEMENT GENERALISE
! IN  LRAIDE : IS : DESCRIPTEUR NORMALISE DE LA MATRICE DE RIGIDITE
!                   = 0  ON NE CALCULE PAS LA RIGIDITE GENERALISEE
!     ------------------------------------------------------------------
!     REMARQUE : ON FAIT LES CALCULS VECTEURS APRES VECTEURS
!              : C'EST PLUS LONG MAIS PAS DE PB DE TAILLE MEMOIRE
!     ------------------------------------------------------------------
!
!
    complex(kind=8) :: rval, zero
    character(len=24) :: vecaux, vecau1
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ieq, ivect, laux, laux1
!-----------------------------------------------------------------------
    data  vecaux/'&&VPPGEN.VECTEUR.AUX0'/
    data  vecau1/'&&VPPGEN.VECTEUR.AUX1'/
!     ------------------------------------------------------------------
    call jemarq()
    zero = 0.d0
    call wkvect(vecaux, 'V V C', neq, laux)
    call wkvect(vecau1, 'V V C', neq, laux1)
    laux = laux - 1
    laux1= laux1- 1
!
!     --- CALCUL DE LA MASSE GENERALISEE ---
    if (lmasse .ne. 0) then
        do 100 ivect = 1, nbvect
            call mcmult('ZERO', lmasse, vect(1, ivect), zc(laux+1), 1,&
                        .false._1)
            rval = zero
            do 110 ieq = 1, neq
                rval = rval + dconjg(vect(ieq,ivect)) * zc(laux+ieq)
110          continue
            masseg(ivect) = dble(rval)
100      continue
    endif
!
!     --- CALCUL DE L'AMORTISSEMENT GENERALISE ---
    if (lamor .ne. 0) then
        do 200 ivect = 1, nbvect
            call mcmult('ZERO', lamor, vect(1, ivect), zc(laux+1), 1,&
                        .false._1)
            rval = zero
            do 210 ieq = 1, neq
                rval = rval + dconjg(vect(ieq,ivect)) * zc(laux+ieq)
210          continue
            amorg(ivect) = dble(rval)
200      continue
    else
        do 250 ivect = 1, nbvect
            amorg(ivect) = 0.d0
250      continue
    endif
!
!     --- CALCUL DE LA RAIDEUR GENERALISEE ---
    if (lraide .ne. 0) then
        do 300 ivect = 1, nbvect
            do 305 ieq = 1, neq
                zc(laux1+ieq) = vect(ieq,ivect)*iddl(ieq)
305          continue
            call mcmult('ZERO', lraide, zc(laux1+1), zc(laux+1), 1,&
                        .false._1)
            rval = zero
            do 310 ieq = 1, neq
                rval = rval + dconjg(vect(ieq,ivect))*zc(laux+ieq)* iddl(ieq)
310          continue
            raideg(ivect) = dble(rval)
300      continue
    endif
!
    call jedetr(vecaux)
    call jedetr(vecau1)
!
    call jedema()
end subroutine
