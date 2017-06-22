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

subroutine calck1(norev, nomdb, sigmrv, sigmdb, tbscrv,&
                  tbscmb, prodef, londef, deklag, lrev,&
                  k1a, k1b)
!
    implicit none
#include "jeveux.h"
#include "asterc/r8pi.h"
#include "asterc/r8prem.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/calc_fact_int_cont.h"
   integer :: norev, nomdb
    real(kind=8) :: prodef, londef, deklag, lrev, k1a, k1b
    character(len=19) :: sigmrv, sigmdb, tbscrv, tbscmb
! --- BUT : CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES ELASTIQUES
! ======================================================================
! IN  : NOREV  : NOMBRE DE NOEUDS COTE REVETEMENT ----------------------
! --- : NOMDB  : NOMBRE DE NOEUDS COTE METAL DE BASE -------------------
! --- : SIGMRV : CONTRAINTES COTE REVETEMENT ---------------------------
! --- : SIGMDB : CONTRAINTES COTE METAL DE BASE ------------------------
! --- : TBSCRV : ABSCISSES CURVILIGNES COTE REVETEMENT -----------------
! --- : TBSCMB : ABSCISSES CURVILIGNES COTE METAL DE BASE --------------
! --- : PRODEF : PROFONDEUR DU DEFAUT ----------------------------------
! --- : LONDEF : LONGUEUR DU DEFAUT ------------------------------------
! --- : LREV   : LONGUEUR DU REVETEMENT --------------------------------
! --- : DEKLAG : DECALAGE DU DEFAUT COTE REVETEMENT (TOUJOURS NEGATIF) -
! OUT : K1A    : FACTEUR D'INTENSITE DE CONTRAINTES POINTE A -----------
! --- : K1B    : FACTEUR D'INTENSITE DE CONTRAINTES POINTE B -----------
! ======================================================================
! ======================================================================
    integer :: jsigmr, jsigmb, jabsrv, jabsmb
    real(kind=8) :: zero, deux, rappo, fa, fb, fab
    real(kind=8) :: a, b, pi, z, z2, z3, z4, z5
    real(kind=8) :: ldefo, rtole
    real(kind=8) :: trans
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( zero   =  0.0d0 )
    parameter       ( deux   =  2.0d0 )
! ======================================================================
    call jemarq()
! ======================================================================
! --- INITIALISATIONS DES VECTEURS -------------------------------------
! ======================================================================
    call jeveuo(tbscrv, 'L', jabsrv)
    call jeveuo(tbscmb, 'L', jabsmb)
    call jeveuo(sigmrv, 'L', jsigmr)
    call jeveuo(sigmdb, 'L', jsigmb)
! ======================================================================
! --- INITIALISATIONS DES VARIABLES REPRESENTANT LES FACTEURS ----------
! --- D'INTENSITE ------------------------------------------------------
! ======================================================================
    k1a = zero
    k1b = zero
    rtole = 1.0d-10
! ======================================================================
! --- INITIALISATIONS DES VARIABLES NECESSAIRE AU CALCUL ---------------
! ======================================================================
    ldefo = zero
    a = prodef/deux
    b = londef/deux
    pi = r8pi()
! ======================================================================
! --- VERIFICATION DE LA COHERENCE DE LA PROFONDEUR DU DEFAUT ET -------
! --- DES ABSCISSES CURVILIGNES COTE REVETEMENT ET COTE METAL DE BASE --
! ======================================================================
    ldefo = zr(jabsrv+norev-1) + zr(jabsmb+nomdb-1)
    if(deklag.ge.0.d0) ldefo = zr(jabsmb) + zr(jabsmb+nomdb-1)
    if (abs(ldefo - prodef) .gt. rtole) then
        call utmess('F', 'PREPOST_5')
    endif
! ======================================================================
! --- CALCULS DES FACTEURS D'INTENSITE DE CONTRAINTES COTE REVETEMENT --
! ======================================================================

! Decalage negatif
!
    if(deklag.lt.zero) then
       trans = - prodef/deux 
!  --- CALCULS DES FACTEURS D'INTENSITE DE CONTRAINTES COTE REVETEMENT --
       call calc_fact_int_cont(norev, zr(jsigmr), zr(jabsrv), prodef, trans, &
                               k1a, k1b)

!  --- CALCULS DES FACTEURS D'INTENSITE DE CONTRAINTES COTE METAL DE BASE --
       trans = - prodef/deux - deklag
       call calc_fact_int_cont(nomdb, zr(jsigmb), zr(jabsmb), prodef, trans, &
                               k1a, k1b)

! Decalage positif
    else if(deklag.ge.zero) then

       trans = - prodef/deux 
!  --- CALCULS DES FACTEURS D'INTENSITE DE CONTRAINTES COTE REVETEMENT --
!       call calc_fact_int_cont(norev, zr(jsigmr), zr(jabsrv), prodef, trans, &
!                               k1a, k1b)
!  --- CALCULS DES FACTEURS D'INTENSITE DE CONTRAINTES COTE METAL DE BASE --
!       trans = zero
       call calc_fact_int_cont(nomdb, zr(jsigmb), zr(jabsmb), prodef, trans, &
                               k1a, k1b)
    endif

    k1a = k1a * sqrt(a/pi)
    k1b = k1b * sqrt(a/pi)
! ======================================================================
! --- CORRECTION PAR LES FACTEURS DE BORDS -----------------------------
! ======================================================================
    z = a / (a + lrev + deklag)
    z2 = z * z
    z3 = z2 * z
    z4 = z3 * z
    z5 = z4 * z
    fa = 0.998742d0 + 0.142801d0*z - 1.133379d0*z2 + 5.491256d0*z3 - 8.981896d0*z4 + 5.765252d0*z&
         &5
    if (z .le. (0.92d0)) then
        fb = 1.0d0 - 0.012328d0*z+ 0.395205d0*z2 - 0.527964d0*z3 + 0.432714d0*z4
    else
        fb = - 414.20286d0 + 1336.75998d0*z - 1436.1197d0*z2 + 515.14949d0*z3
    endif
! ======================================================================
! --- CORRECTION PAR LES FACTEURS D'ELLIPTICITE ------------------------
! ======================================================================
    rappo = a/b
    if (a .le. b) then
        fab = 1.0d0 / sqrt(1.0d0+1.464d0*(rappo**1.65d0))
    else
        fab = 1.0d0 / ( rappo * sqrt(1.0d0+1.464d0*((1.0d0/rappo)** 1.65d0)))
    endif
    k1a = k1a * fa * fab
    k1b = k1b * fb * fab
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
