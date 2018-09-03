! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine hujlnf(toler, nmat, mater, nvi, vind,&
                  vinf, vins, nr, yd, yf,&
                  sigd, sigf, indi, iret)
! person_in_charge: alexandre.foucault at edf.fr
! aslint: disable=W1306
    implicit none
!     ------------------------------------------------------------
!     CONTROLE DES MECANISMES ACTIVES - POST-TRAITEMENT SPECIFIQUE
!     ------------------------------------------------------------
!     IN :TOLER : TOLERANCE ISSUE DE RESI_INTE_RELA
!         NMAT  : DIMENSION TABLEAU PARAMETRES MATERIAU
!         MATER : PARAMETRES MATERIAU
!         NVI   : NOMBRE DE VARIABLES INTERNES
!         VIND  : VARIABLES INTERNES A T
!         VINS  : VARIABLES INTERNES A T (VIND0 - LCPLNL)
!         NR    : DIMENSION SYSTEME NL A RESOUDRE
!         YF    : VECTEUR SOLUTION
!         SIGD  : ETAT DE CONTRAINTES A T
!         INDI  : INDICATEUR DES MECANISMES POT. ACTIFS
!     OUT :
!         SIGF  : ETAT DE CONTRAINTES A T+DT
!         VINF  : VARIABLES INTERNES A T+DT
!         IRET  : CODE RETOUR
!                 0 - OK / 1 - ECHEC
!                 2 - RE-INTEGRATION / 3 - REDECOUPAGE
! ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterfort/hujact.h"
#include "asterfort/lceqvn.h"
    integer :: nvi, nr, iret, indi(7), nmat
    real(kind=8) :: toler, vind(nvi), mater(nmat, 2), sigf(6), sigd(6)
    real(kind=8) :: vins(nvi), vinf(nvi), yd(nr), yf(nr)
!
    integer :: k, nbmeca, kk, ndt, i
    real(kind=8) :: maxi, un, e0, pref, ydt(nr), yft(nr), ratio, cumuli
    real(kind=8) :: matert(22, 2)
    aster_logical :: negmul(8), chgmec
!
    parameter  (un   = 1.d0)
    parameter  (ndt  = 6   )
! ----------------------------------------------------------------
! --- PARAMETRES MATERIAU
    e0 = mater(1,1)
    pref = mater(8,2)
!
! --- CONSTRUCTION DE NBMECA + NEGMUL
    nbmeca = 0
    do k = 1, 8
        if (vind(23+k) .eq. un) nbmeca = nbmeca + 1
        negmul(k) = .false.
    end do
!
! ---------------------------------------------
! --- COPIE A PARTIR DU TRAITEMENT DE HUJMID
! --- REDIMENSIONNEMENT DE YD ET YF POUR HUJACT
! ---------------------------------------------
    call lceqvn(nr, yd, ydt)
    call lceqvn(nr, yf, yft)
!
    do i = 1, ndt
        ydt(i) = yd(i)*e0
        yft(i) = yf(i)*e0
    end do
    do i = 1, nbmeca
        ydt(ndt+1+i) = yd(ndt+1+i)*e0/abs(pref)
        yft(ndt+1+i) = yf(ndt+1+i)*e0/abs(pref)
    end do
!
! ---------------------------------------
! --- REMPLISSAGE DE VINF A PARTIR DE YFT
! ---------------------------------------
!
! --- DEFORMATION VOLUMIQUE PLASTIQUE CUMULEE
    vinf(23) = yft(ndt+1)
!
! ----------------------------------------------
! ---> AFFECTATION DES RAYONS DE YF VERS VINF
! --- ON S'ASSURE QUE (R+>=R-) ET (R+CYC<=RMON)
! ----------------------------------------------
    do k = 1, nbmeca
        kk = indi(k)
        if (yft(ndt+1+k) .gt. vind(kk)) then
            if ((kk.gt.4) .and. (kk.lt.8)) then
                if (yft(ndt+1+k) .le. vind(kk-4)) then
                    vinf(kk) = yft(ndt+1+k)
                else
                    vinf(kk) = vind(kk-4)
                endif
            else
                vinf(kk) = yft(ndt+1+k)
            endif
        else
            vinf(kk) = vind(kk)
        endif
    end do
!
! ----------------------------------------------
! --- CONSTRUCTION DE NEGMUL POUR HUJACT
! ----------------------------------------------
    maxi = toler
!      DO 50 K = 1, NBMECA
!        IF (YF(NDT+1+NBMECA+K).GT.MAXI) MAXI = YF(NDT+1+NBMECA+K)
! 50   CONTINUE
!
    do k = 1, nbmeca
        ratio = yf(ndt+1+nbmeca+k)/maxi
        if (ratio .lt. -un) then
            negmul(indi(k)) = .true.
        endif
    end do
!
! ----------------------------------------------
! --- CONSTRUCTION DE SIGF POUR HUJACT
! ----------------------------------------------
    do i = 1, ndt
        sigf(i) = yft(i)
    end do
!
! --- APPEL A LA ROUTINE HUJACT
    chgmec = .false.
!
    do i = 1, 22
        matert(i,1) = mater(i,1)
        matert(i,2) = mater(i,2)
    end do
!
    call hujact(matert, vind, vinf, vins, sigd,&
                sigf, negmul, chgmec, indi)
!
    cumuli = vinf(35)
!
    if (chgmec) then
        iret = 2
        call lceqvn(nvi, vind, vinf)
        vinf(35) = cumuli
        goto 999
    endif
!
999 continue
!
end subroutine
