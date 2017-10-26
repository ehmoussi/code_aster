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

subroutine rcZ2s0(typ, ma, mb, presa, presb, ns, s2)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jedema.h"
#include "asterfort/jexnom.h"
#include "asterfort/codent.h"
#include "asterfort/jeexin.h"
#include "asterfort/utmess.h"
    character(len=2) :: typ
    real(kind=8) :: ma(12), mb(12), presa, presb, s2
    integer :: ns
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_ZE200
!     CALCUL de la partie simplifiée (B3600) DU SN ou du SP
!
!     ------------------------------------------------------------------
!
    real(kind=8) :: s2p, s2m, racine, racicor, k1, c1, k2, c2
    integer :: jvalin, i, i0, i1, i2, i3, i4, i5, i6, jinfois, numcha
    integer :: iret, jchars, k
    real(kind=8) :: rayon, ep, inertie, k2tub, c2tub, k2cor
    real(kind=8) :: c2cor, rtub, itub, rcor, icor, coefp, coefm
    real(kind=8) :: coefcor, coeftub, pij, mij(3), mijcor(3)
    real(kind=8) :: s2ms, racines, racicors, fact, e1(2), e2(2)
    real(kind=8) :: e3(2), e4(2), e5(2), e6(2), mijs(3), mijcors(3), mse(12)
    character(len=8) ::  knumec
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
    s2 = 0.d0
    s2p = 0.d0
    s2m = 0.d0
    racine = 0.d0
    racicor = 0.d0
!-----------------------------------------------------
!--- RECUPERATION DES CARACTERISTIQUES GEOMETRIQUES
!--- ET INDICES DE CONTRAINTE
!-----------------------------------------------------
    call jeveuo('&&RC3200.INDI', 'L', jvalin)
    k1 = zr(jvalin)
    c1 = zr(jvalin+1)
    k2 = zr(jvalin+2)
    c2 = zr(jvalin+3) 
    rayon = zr(jvalin+6) 
    ep = zr(jvalin+7) 
    inertie = zr(jvalin+8)
    k2tub = zr(jvalin+11)
    c2tub = zr(jvalin+12)
    k2cor = zr(jvalin+13)
    c2cor = zr(jvalin+14)
    rtub = zr(jvalin+15)
    itub = zr(jvalin+16)
    rcor = zr(jvalin+17)
    icor = zr(jvalin+18)
!
   if (typ .eq. 'SN') then
       coefp = c1
       coefm = c2
       coefcor = c2cor
       coeftub = c2tub
   else
       coefp = k1*c1
       coefm = k2*c2
       coefcor = k2cor*c2cor
       coeftub = k2tub*c2tub
   endif 
!-----------------------------------------------------
! --- CALCUL DE LA PARTIE DUE A LA PRESSION S2P
!-----------------------------------------------------
    pij = presa - presb
    s2p = coefp*rayon*abs(pij)/ep
!---------------------------------------------------------
! --- CALCUL DE LA PARTIE DUE AUX MOMENTS S2M SANS SEISME
!---------------------------------------------------------
    do 100 i = 1, 3    
        mij(i) = ma(i+3) - mb(i+3)
        racine = racine + mij(i)**2
        mijcor(i) = ma(9+i) - mb(9+i)
        racicor = racicor + mijcor(i)**2
 100 continue
!
    if (rcor+rtub .lt. 1e-8) then
        s2m = coefm*rayon*sqrt(racine)/inertie
    else
        s2m = coefcor*rcor*sqrt(racicor)/icor+ coeftub*rtub*sqrt(racine)/itub
    endif
!---------------------------------------------------------
! --- CALCUL DE LA PARTIE DUE AUX MOMENTS S2M AVEC SEISME
!---------------------------------------------------------
    if (ns .eq. 0) goto 999
!
    call jeveuo('&&RC3200.SEIS_INFOI', 'L', jinfois)
    numcha = zi(jinfois+4)
    knumec = 'C       '
    call codent(numcha, 'D0', knumec(2:8))
    call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec), iret)
    if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
    call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jchars)
    do 11 k = 1, 12
          mse(k) = zr(jchars-1+k)
11  continue
!
    s2m = 0.d0
    s2ms = 0.d0
    racines = 0.d0
    racicors = 0.d0
    fact = 2
    do 2 i0 = 1, 2
        i1 = 2*(i0-2)+1
        e1(i0) = i1 * fact
        e2(i0) = i1 * fact
        e3(i0) = i1 * fact
        e4(i0) = i1 * fact
        e5(i0) = i1 * fact
        e6(i0) = i1 * fact
 2  continue
!
    do 60 i1 = 1, 2
        do 50 i2 = 1, 2
           do 40 i3 = 1, 2
               do 30 i4 = 1, 2
                   do 20 i5 = 1, 2
                       do 10 i6 = 1, 2
                           mijs(1) = ma(4) - mb(4)+ mse(4)*e1(i1)
                           mijs(2) = ma(5) - mb(5)+ mse(5)*e2(i2)
                           mijs(3) = ma(6) - mb(6)+ mse(6)*e3(i3)
                           racines = mijs(1)**2+mijs(2)**2+mijs(3)**2
                           mijcors(1) = ma(10) - mb(10)+ mse(10)*e4(i4)
                           mijcors(2) = ma(11) - mb(11)+ mse(11)*e5(i5)
                           mijcors(3) = ma(12) - mb(12)+ mse(12)*e6(i6)
                           racicors = mijcors(1)**2+mijcors(2)**2+mijcors(3)**2
!
                           if (rcor+rtub .lt. 1e-8) then
                               s2ms = coefm*rayon*sqrt(racines)/inertie
                           else
                               s2ms = coefcor*rcor*sqrt(racicors)/icor+&
                                     coeftub*rtub*sqrt(racines)/itub
                           endif
                           s2m = max(s2m,s2ms)
10                     continue
20                 continue
30             continue
40         continue
50      continue
60  continue
!
999 continue
!!-------------------------------
! --- SOMME PRESSION + MOMENTS
!!-------------------------------
    s2 = s2p+s2m
!
    call jedema()
!
end subroutine
