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

subroutine betimp(nmat, mater, sig, vind, vinf,&
                  nseui1, nseui2, nseui3, nseui4,&
                  sige, sigd)
!
use calcul_module, only : ca_vext_eltsize1_
!
implicit none
!
#include "jeveux.h"
#include "asterfort/betfpp.h"
#include "asterfort/infniv.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lchydr.h"
#include "asterfort/lcprsc.h"
#include "asterfort/tecael.h"
!       BETON_DOUBLE_DP: CONVEXE ELASTO PLASTIQUE POUR (MATER,SIG,P1,P2)
!            AVEC UN SEUIL EN COMPRESSION ET UN SEUIL EN TRACTION
!            SEUILC = FCOMP      = (SIGEQ   + A  SIGH)/B - FC
!            SEUILT = FTRAC      = (SIGEQ   + C  SIGH)/D - FT
!                AVEC SIGEQ      = SQRT(3/2(D) (D)) (CONTR EQUIVALENTE)
!                     D          = SIG - 1/3 TR(SIG) I
!                     SIGH       = 1/3 TR(SIG)    (CONTR HYDROSTATIQUE)
!       IMPRESSION DE VALEURS EN CAS DE NON CONVERGENCE
!       ----------------------------------------------------------------
!       NSEUIL = 1  --> CRITERE  EN COMPRESSION ACTIVE
!       NSEUIL = 2  --> CRITERE  EN TRACTION ACTIVE
!       NSEUIL = 3  --> CRITERES EN COMPRESSION ET EN TRACTION ACTIVE
!       NSEUIL = 11 --> PROJECTION AU SOMMET DU CONE DE COMPRESSION
!       NSEUIL = 22 --> PROJECTION AU SOMMET DU CONE DE TRACTION
!       NSEUIL = 33 --> PROJECTION AU SOMMET DES CONES DE COMPRESSION
!                       ET TRACTION
!       ----------------------------------------------------------------
!       IN  SIG    :  CONTRAINTE
!       IN  VIND   :  VARIABLES INTERNES = ( PC PT THETA ) A T
!       IN  VINF   :  VARIABLES INTERNES = ( PC PT THETA ) A T+DT
!       IN  NMAT   :  DIMENSION MATER
!       IN  MATER  :  COEFFICIENTS MATERIAU
!       IN  NSEUI1 :  CRITERE ACTIVE LORS DE LA PREMIERE RESOLUTION
!       IN  NSEUI2 :  CRITERE ACTIVE LORS DE LA DEUXIEME RESOLUTION
!       IN  NSEUI3 :  CRITERE ACTIVE LORS DE LA TROISIEME RESOLUTION
!       IN  NSEUI4 :  CRITERE ACTIVE LORS DE LA QUATRIEME RESOLUTION
!       IN  SIGE   :  CONTRAINTE ELASTIQUE
!       IN  SIGD   :  CONTRAINTE A L'INSTANT PRECEDENT
!       ----------------------------------------------------------------

    integer :: nmat, nseui4, ifm, niv
    integer :: nseui1, nseui2, nseui3
    real(kind=8) :: pc, pt, sig(6), sige(6), sigd(6), dev(6), lc
    real(kind=8) :: mater(nmat, 2), vind(*), vinf(*)
    real(kind=8) :: fc, ft, beta
    real(kind=8) :: rac2, zero, un, deux, trois
    real(kind=8) :: ke, fcomp, ftrac
    real(kind=8) :: a, b, c, d
    real(kind=8) :: sigeq, sigh, p, dfcdlc, dftdlt, kuc, kut
    real(kind=8) :: d13, dlambc, dlambt
    integer :: iadzi, iazk24
    character(len=8) :: nomail
!       ---------------------------------------------------------------
    integer :: ndt, ndi
    common /tdim/   ndt , ndi
!       ----------------------------------------------------------------
!
    data   d13      /.33333333333333d0 /
    data   zero     / 0.d0 /
    data   un       / 1.d0 /
    data   deux     / 2.d0 /
    data   trois    / 3.d0 /
    rac2 = sqrt (deux)
!
    call infniv(ifm, niv)
    if (niv .eq. 2) then
    endif
!
    call tecael(iadzi, iazk24)
    nomail = zk24(iazk24-1+3)(1:8)
!
! ---   IMPRESSION GENERALE
!
!
! ---   CARACTERISTIQUES MATERIAU
!
    beta = mater(3,2)
!
    a = rac2 * (beta - un) / (deux * beta - un)
    b = rac2 / trois * beta / (deux * beta - un)
    c = rac2
    d = deux * rac2 / trois
!
!
! --- LONGUEUR CARACTERISTIQUE POUR LOI BETON LC
!
    if (mater(9,2) .lt. zero) then
        lc = ca_vext_eltsize1_
    else
        lc = mater(9,2)
    endif
!
100 format(a43)
101 format(a43,a8)
102 format(a43,1pd12.5)
103 format(4(a9,i3))
!
! ---   TRAITEMENT DE LA CONTRAINTE ELASTIQUE
!
    call lcdevi(sige, dev)
    call lcprsc(dev, dev, p)
    sigeq = sqrt (1.5d0 * p)
!
    call lchydr(sige, sigh)
!
    pc = vind(1)
    pt = vind(2)
    call betfpp(mater, nmat, pc, pt,&
                3, fc, ft, dfcdlc, dftdlt,&
                kuc, kut, ke)
!
    fcomp = (rac2 * d13 * sigeq + a * sigh) / b - fc
    ftrac = (rac2 * d13 * sigeq + c * sigh) / d - ft
!
    write(ifm,100) ' -----------------------------------------  '
    write(ifm,100) ' NON CONVERGENCE DE LA LOI BETON_DOUBLE_DP '
    write(ifm,100) ' -----------------------------------------  '
    write(ifm,101) 'MAILLE :                                   ',&
     &                   nomail
    write(ifm,102) 'LONGUEUR CARACTERISTIQUE :                 ',&
     &                   lc
    write(ifm,102) 'CONTRAINTE ELASTIQUE EQUIVALENTE :         ',&
     &                   sigeq
    write(ifm,102) 'CONTRAINTE ELASTIQUE HYDROSTATIQUE :       ',&
     &                   sigh
    write(ifm,102) 'ECROUISSAGE EN COMPRESSION :               ',&
     &                   pc
    write(ifm,102) 'ECROUISSAGE EN TRACTION :                  ',&
     &                   pt
    write(ifm,102) 'RESISTANCE COMPRESSION AVANT ECROUISSAGE : ',&
     &                   fc
    write(ifm,102) 'RESISTANCE TRACTION AVANT ECROUISSAGE :    ',&
     &                   ft
    write(ifm,102) 'ECROUISSAGE ULTIME EN COMPRESSION :        ',&
     &                   kuc
    write(ifm,102) 'ECROUISSAGE AU PIC EN COMPRESSION :        ',&
     &                   ke
    write(ifm,102) 'ECROUISSAGE ULTIME EN TRACTION :           ',&
     &                   kut
    write(ifm,102) 'VALEUR DU CRITERE DE COMPRESSION :         ',&
     &                   fcomp
    write(ifm,102) 'VALEUR DU CRITERE DE TRACTION :            ',&
     &                   ftrac
!
! ---   TRAITEMENT DE LA CONTRAINTE (NON ELASTIQUE) A L'INSTANT MOINS
!
    call lcdevi(sigd, dev)
    call lcprsc(dev, dev, p)
    sigeq = sqrt (1.5d0 * p)
!
    call lchydr(sigd, sigh)
!
    write(ifm,102) 'CONTRAINTE EQUIVALENTE A L INSTANT MOINS : ',&
     &                   sigeq
    write(ifm,102) 'CONTRAINTE HYDROSTATIQUE A L INSTANT MOINS:',&
     &                   sigh
!
! ---   TRAITEMENT DE LA CONTRAINTE ELASTO PLASTIQUE
!
    call lcdevi(sig, dev)
    call lcprsc(dev, dev, p)
    sigeq = sqrt (1.5d0 * p)
!
    call lchydr(sig, sigh)
!
    pc = vinf(1)
    pt = vinf(2)
    call betfpp(mater, nmat, pc, pt,&
                3, fc, ft, dfcdlc, dftdlt,&
                kuc, kut, ke)
!
    fcomp = (rac2 * d13 * sigeq + a * sigh) / b - fc
    ftrac = (rac2 * d13 * sigeq + c * sigh) / d - ft
    dlambc = vinf(1) - vind(1)
    dlambt = vinf(2) - vind(2)
!
    write(ifm,103) 'NSEUI1 : ',nseui1,' NSEUI2 : ',nseui2,&
     &                 ' NSEUI3 : ',nseui3,' NSEUI4 : ',nseui4
    write(ifm,102) 'CONTRAINTE EQUIVALENTE A L INSTANT PLUS :  ',&
     &                   sigeq
    write(ifm,102) 'CONTRAINTE HYDROSTATIQUE A L INSTANT PLUS :',&
     &                   sigh
    write(ifm,102) 'ECROUISSAGE EN COMPRESSION A L INST. PLUS :',&
     &                   pc
    write(ifm,102) 'ECROUISSAGE EN TRACTION A L INSTANT PLUS:  ',&
     &                   pt
    write(ifm,102) 'RESISTANCE COMPRESSION APRES ECROUISSAGE : ',&
     &                   fc
    write(ifm,102) 'RESISTANCE TRACTION APRES ECROUISSAGE :    ',&
     &                   ft
    write(ifm,102) 'VALEUR DU CRITERE DE COMPRESSION :         ',&
     &                   fcomp
    write(ifm,102) 'VALEUR DU CRITERE DE TRACTION :            ',&
     &                   ftrac
    write(ifm,102) 'INCREMENT DE DEFO. PLAS. EN COMPRESSION :  ',&
     &                   dlambc
    write(ifm,102) 'INCREMENT DE DEFO. PLAS. EN TRACTION :     ',&
     &                   dlambt
    write(ifm,100) ' -----------------------------------------  '
!
!
end subroutine
