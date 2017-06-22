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

subroutine betcvx(nmat, mater, sig, vind, vinf,&
                  elgeom, nvi, nseuil)
    implicit none
!       BETON_DOUBLE_DP: CONVEXE ELASTO PLASTIQUE POUR (MATER,SIG,P1,P2)
!            AVEC UN SEUIL EN COMPRESSION ET UN SEUIL EN TRACTION
!            SEUILC = FCOMP      = (SIGEQ   + A  SIGH)/B - FC
!            SEUILT = FTRAC      = (SIGEQ   + C  SIGH)/D - FT
!                AVEC SIGEQ      = SQRT(3/2(D) (D)) (CONTR EQUIVALENTE)
!                     D          = SIG - 1/3 TR(SIG) I
!                     SIGH       = 1/3 TR(SIG)    (CONTR HYDROSTATIQUE)
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
!       IN  MATER  :  COEFFICIENTS MATERIAU A TEMP
!       IN  ELGEOM :  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES AUX
!                     LOIS DE COMPORTEMENT
!       VAR NSEUIL :  SEUIL ELASTIQUE PRECEDENT / NOUVEAU SEUIL CALCULE
!       ----------------------------------------------------------------
#include "asterfort/betfpp.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lchydr.h"
#include "asterfort/lcprsc.h"
#include "asterfort/utmess.h"
    integer :: nvi, nmat, nseuil
    real(kind=8) :: pc, pt, sig(6), dev(6), vind(*), vinf(*)
    real(kind=8) :: mater(nmat, 2), elgeom(*)
    real(kind=8) :: fcp, ftp, fc, ft, beta
!        REAL*8          ALPHA
    real(kind=8) :: rac2, un, deux, trois
    real(kind=8) :: ke, fcomp, ftrac
    real(kind=8) :: a, b, c, d
    real(kind=8) :: sigeq, sigh, p, dfcdlc, dftdlt, kuc, kut
    real(kind=8) :: lasts, d13, dlambc, dlambt, epsi, zero
    parameter       ( zero =  0.d0   )
!       ---------------------------------------------------------------
    integer :: ndt, ndi
    common /tdim/   ndt , ndi
!       ----------------------------------------------------------------
!
    data   d13      /.33333333333333d0 /
    data   un       / 1.d0 /
    data   deux     / 2.d0 /
    data   trois    / 3.d0 /
    data   epsi     / 1.d-6 /
    rac2 = sqrt (deux)
!
! ---   SEUIL PRECEDENT
!
    lasts = nseuil
!
! ---   DEFORMATIONS PLASTIQUES PRECEDENTES
!
    if (lasts .eq. 0) then
        pc = vind(1)
        pt = vind(2)
    else
        pc = vinf(1)
        pt = vinf(2)
    endif
!
! ---   CARACTERISTIQUES MATERIAU
!
    fcp = mater(1,2)
    ftp = mater(2,2)
    beta = mater(3,2)
!
!        ALPHA = FTP / FCP
    a = rac2 * (beta - un) / (deux * beta - un)
    b = rac2 / trois * beta / (deux * beta - un)
    c = rac2
    d = deux * rac2 / trois
!
! ---   CONTRAINTE EQUIVALENTE
!
    call lcdevi(sig, dev)
    call lcprsc(dev, dev, p)
    sigeq = sqrt (1.5d0 * p)
!
! ---   CONTRAINTE HYDROSTATIQUE
!
    call lchydr(sig, sigh)
!
! ---   ECROUISSAGE EN TRACTION ET EN COMPRESSION
!
    call betfpp(mater, nmat, elgeom, pc, pt,&
                3, fc, ft, dfcdlc, dftdlt,&
                kuc, kut, ke)
!
!
! -     SEUIL EN COMPRESSION
!
    fcomp = (rac2 * d13 * sigeq + a * sigh) / b - fc
!
! -     SEUIL EN TRACTION
!
    ftrac = (rac2 * d13 * sigeq + c * sigh) / d - ft
!
! -     VERIFICATION ET CALCUL DU CAS DE PLASTICITE
! -     FCOMP > 0  -->  NSEUIL = 1  (CRITERE COMPRESSION ACTIVE)
! -     FTRAC > 0  -->  NSEUIL = 2  (CRITERE TRACTION ACTIVE)
! -     FTRAC > 0  ET FTRAC > 0
! -                -->  NSEUIL = 3  (DEUX CRITERES ACTIVES)
!
    nseuil = -1
    if (fcomp .gt. (fcp*epsi)) nseuil = 1
    if (ftrac .gt. (ftp*epsi)) nseuil = 2
    if (fcomp .gt. (fcp*epsi) .and. ftrac .gt. (ftp*epsi)) nseuil = 3
!
    dlambc = vinf(1) - vind(1)
    dlambt = vinf(2) - vind(2)
!
    if (lasts .gt. 0) then
        if (lasts .eq. 1 .and. dlambc .lt. zero) then
            if (ftrac .le. zero) then
                call utmess('A', 'ALGORITH_42')
                nseuil = 4
                goto 9999
            else
                nseuil = 2
                goto 9999
            endif
        endif
        if (lasts .eq. 2 .and. dlambt .lt. zero) then
            if (fcomp .le. zero) then
                call utmess('A', 'ALGORITH_43')
                nseuil = 4
                goto 9999
            else
                nseuil = 1
                goto 9999
            endif
        endif
        if (lasts .eq. 3 .and. dlambc .lt. zero) then
            nseuil = 2
            goto 9999
        endif
        if (lasts .eq. 3 .and. dlambt .lt. zero) then
            nseuil = 1
            goto 9999
        endif
        if (lasts .eq. 22 .and. nseuil .gt. 0) then
            nseuil = 33
            goto 9999
        endif
        if (lasts .eq. 22 .and. dlambt .lt. zero) then
            nseuil = 33
            goto 9999
        endif
        if (lasts .eq. 11 .and. nseuil .gt. 0) then
            nseuil = 44
            goto 9999
        endif
        if (lasts .eq. 11 .and. dlambc .lt. zero) then
            nseuil = 44
            goto 9999
        endif
        if (lasts .eq. 33 .and. nseuil .gt. 0) then
            nseuil = 11
            goto 9999
        endif
        if (lasts .eq. 33 .and. dlambc .lt. zero) then
            nseuil = 11
            goto 9999
        endif
        if (lasts .eq. 33 .and. dlambt .lt. zero) then
            nseuil = 11
            goto 9999
        endif
        if (lasts .eq. 4 .and. nseuil .lt. 0) then
            nseuil = 4
            goto 9999
        endif
        if (lasts .eq. 44 .and. nseuil .lt. 0) then
            nseuil = 44
            goto 9999
        endif
        if (nseuil .eq. lasts) then
            if (nseuil .eq. 2) then
                nseuil = 1
            else if (nseuil.eq.3) then
                nseuil = 2
            else if (nseuil.eq.1) then
                nseuil = 2
            else
                nseuil = 4
                goto 9999
            endif
        endif
    else
!
! ---   A LA PREMIERE RESOLUTION, ON REPREND LES MEMES CRITERES QU'AU
! ---   PAS DE CALCUL PRECEDENT
!
        if (nseuil .eq. 3) then
            if (vind(nvi) .gt. epsi) then
                nseuil = int(vind(nvi) + 0.5d0)
                if (nseuil .eq. 22) nseuil = 2
                if (nseuil .eq. 11) nseuil = 1
                if (nseuil .eq. 33) nseuil = 3
            endif
        endif
    endif
!
9999  continue
!
end subroutine
