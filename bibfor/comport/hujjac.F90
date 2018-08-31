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

subroutine hujjac(mod, nmat, mater, indi, deps,&
                  nr, yd, yf, ye, nvi,&
                  vind, vins, vinf, drdy, bnews,&
                  mtrac, iret)
! person_in_charge: alexandre.foucault at edf.fr
! aslint: disable=W1306
    implicit none
!     ----------------------------------------------------------------
!     CALCUL DU JACOBIEN DU SYSTEME NL POUR MODELE DE HUJEUX
!     ----------------------------------------------------------------
!     IN   MOD    :  TYPE DE MODELISATION
!          MATER  :  DONNEES MATERIAU
!          NMAT   :  DIMENSION TABLEAU DONNEES MATERIAU
!          INDI   :  MECANISMES POTENTIELLEMENT ACTIFS
!          DEPS   :  INCREMENT DEFORMATION
!          NR     :  DIMENSION DU VECTEUR INCONNU
!          YD     :  VECTEUR SOLUTION A T
!          YF     :  VECTEUR SOLUTION A T+DT?
!          YE     :  VECTEUR SOLUTION APRES LCINIT
!          NVI    :  NOMBRE DE VARIABLES INTERNES
!          VIND   :  VARIABLES INTERNES A T
!          VINS   :  VARIABLES INTERNES D'ORIGINE
!          BNEWS  :  INDICATEUR LIES A LA TRACTION
!     OUT  DRDY   :  JACOBIEN DU SYSTEME NL A RESOUDRE
!          BNEWS  :  INDICATEUR LIES A LA TRACTION
!          MTRAC  :  INDICATEUR LIE A LA TRACTION
!          IRET   :  CODE RETOUR (>0 -> PB)
!     ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/hujjid.h"
#include "asterfort/hujprj.h"
#include "asterfort/lceqvn.h"
    integer :: indi(7), nr, nvi, iret, nmat
    character(len=8) :: mod
    real(kind=8) :: mater(nmat, 2), deps(6), yd(nr), yf(nr), vind(nvi)
    real(kind=8) :: drdy(nr, nr), vins(nr), ye(nr), vinf(nvi)
    aster_logical :: bnews(3), mtrac
!
    aster_logical :: prox(4), proxc(4), tracti, probt, modif, neglam(3)
    real(kind=8) :: r(nr), ydt(nr), yft(nr), dev(3), pf, qf
    real(kind=8) :: pref, e0, ptrac, rtrac, un, deux, zero, yet(nr), prob(3)
    real(kind=8) :: matert(22, 2)
    integer :: nbmeca, nbmect, i, j, ndt, msup(4), k
!
    parameter     (ndt  = 6   )
    parameter     (zero = 0.d0)
    parameter     (un   = 1.d0)
    parameter     (deux = 2.d0)
!     ----------------------------------------------------------------
! --- INITIALISATION DE LA JACOBIENNE A ZERO
    do i = 1, nr
        do j = 1, nr
            drdy(i,j) = zero
        enddo
    enddo
!
! --- PROPRIETES MATERIAU
    pref = mater(8,2)
    e0 = mater(1,1)
    rtrac = abs(pref*1.d-6)
    ptrac = mater(21,2)
!
! --- REDIMENSIONNEMENT DE YD ET YF POUR S'ADAPTER A HUJJID
! --- COPIE A PARTIR DU TRAITEMENT DE HUJMID
    call lceqvn(nr, yd, ydt)
    call lceqvn(nr, yf, yft)
    call lceqvn(nr, ye, yet)
!
    do i = 1, 6
        ydt(i) = yd(i)*e0
        yft(i) = yf(i)*e0
        yet(i) = ye(i)*e0
    end do
!
    nbmeca = 0
    do k = 1, 7
        if (indi(k) .gt. 0) then
            if (indi(k) .le. 8) nbmeca = nbmeca + 1
        endif
    end do
!
    nbmect = nbmeca
    do i = 1, 7
        if (indi(i) .gt. 8) then
            nbmect = nbmect + 1
        endif
    end do
!
    do i = 1, nbmeca
        ydt(ndt+1+i) = yd(ndt+1+i)*e0/abs(pref)
        yft(ndt+1+i) = yf(ndt+1+i)*e0/abs(pref)
        yet(ndt+1+i) = ye(ndt+1+i)*e0/abs(pref)
    end do
!
    do i = 1, 22
        matert(i,1) = mater(i,1)
        matert(i,2) = mater(i,2)
    end do
!
    call hujjid(mod, matert, indi, deps, prox,&
                proxc, ydt, yft, vind, r,&
                drdy, iret)
!
! ------------------------------------------------------------
! ---> SI ECHEC DANS LE CALCUL DE LA JACOBIENNE DR/DY
! ---  ON VERIFIE LES ETATS DE CONTRAINTES DE YF A L'ITERATION
! ---  DE CORRECTION PRECEDENTE. SI TRACTION IL Y A, ON TRAITE
! ---  LE PB
! ------------------------------------------------------------
    tracti = .false.
    probt = .false.
    if (iret .eq. 1) then
        iret = 3
        do i = 1, 3
            if (prox(i)) then
                prob(i) = un
                probt = .true.
            else if (proxc(i)) then
                prob(i) = deux
                probt = .true.
            endif
        enddo
        do i = 1, 3
            call hujprj(i, yft, dev, pf, qf)
            if (((rtrac+pf-ptrac)/abs(pref)) .ge. -r8prem()) then
                tracti = .true.
            endif
        enddo
    endif
!
    if (probt) then
        call lceqvn(nvi, vins, vind)
        do i = 1, 3
            if (prob(i) .eq. un) then
                vind(i+4) = mater(18,2)
                vind(23+i) = un
                vind(27+i) = zero
                vind(4*i+5) = zero
                vind(4*i+6) = zero
                vind(4*i+7) = zero
                vind(4*i+8) = zero
                vind(5*i+31) = zero
                vind(5*i+32) = zero
                vind(5*i+33) = zero
                vind(5*i+34) = zero
                vind(5*i+35) = mater(18,2)
            else if (prob(i).eq.deux) then
                vind(27+i) = zero
            endif
        enddo
        iret = 2
        probt = .false.
!
! --- Y AVAIT IL UN MECANISME CYCLIQUE DEJA DESACTIVE
!     DURANT CETTE TENTATIVE?
        msup(1) = 0
        msup(2) = 0
        msup(3) = 0
        msup(4) = 0
        j = 0
        do i = 5, 8
            if ((vind(23+i).ne.vins(23+i)) .and. (vind(23+i).eq.zero)) then
                j = j+1
                msup(j) = i
            endif
        end do
! --- MECANISME CYCLIQUE A DESACTIVE
! --- ET DEJA DESACTIVE ANTERIEUREMENT
        if (j .ne. 0) then
            do i = 1, j
                vind(23+msup(i)) = zero
            enddo
        endif
!
        call lceqvn(nvi, vind, vinf)
!
    endif
!
    if (tracti) then
        call lceqvn(nvi, vins, vind)
        modif = .false.
        do i = 1, nbmect
            if (yet(ndt+1+nbmeca+i) .eq. zero) then
                modif = .true.
                if (indi(i) .le. 8) then
                    if (indi(i) .lt. 5) then
                        if ((abs(vind(4*indi(i)+5)).gt.r8prem()) .or.&
                            (abs(vind(4*indi(i)+6)).gt.r8prem())) then
                            vind(23+indi(i)) = -un
                        else
                            vind(23+indi(i)) = zero
                        endif
                    else
                        vind(23+indi(i)) = zero
                    endif
                else
                    bnews(indi(i)-8) = .true.
                    neglam(indi(i)-8) = .true.
                endif
                tracti = .false.
            endif
        enddo
!
        do i = 1, nbmect
            if (indi(i) .eq. 8) then
                vind(23+indi(i)) = zero
                modif = .true.
            endif
        enddo
!
        mtrac = .false.
        do i = 1, 3
! --- ON NE DOIT PAS REACTIVE UN MECANISME DE TRACTION QUI DONNE
!     COMME PREDICTEUR UN MULTIPLICATEUR PLASTIQUE NEGATIF
            if (.not.neglam(i)) then
                call hujprj(i, yft, dev, pf, qf)
! ----------------------------------------------------
! ---> ACTIVATION MECANISMES DE TRACTION NECESSAIRES
! ----------------------------------------------------
                if (((pf+deux*rtrac-ptrac)/abs(pref)) .gt. -r8prem()) then
                    bnews(i) = .false.
                    if(.not.modif)mtrac = .true.
                endif
            endif
        enddo
        call lceqvn(nvi, vind, vinf)
        iret = 2
    endif
!
!
end subroutine
