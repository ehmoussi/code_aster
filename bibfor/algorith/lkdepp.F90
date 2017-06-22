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

subroutine lkdepp(vin, nbmat, mater, paraep, derpar)
!
    implicit      none
    integer :: nbmat
    real(kind=8) :: vin(7), paraep(3), mater(nbmat, 2), derpar(3)
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE----------------------------
! ===================================================================
! --- BUT : DERIVEES DES VARIABLES D'ECROUISSAGE PAR RAPPORT A XIP---
! ===================================================================
! IN  : VIN    : VARIABLE INTERNE ( ICI XIP) ------------------------
! --- : NBMAT  : NOMBRE DE PARAMETRES DU MODELE ---------------------
! --- : MATER  : PARAMETRES DU MODELE -------------------------------
! IN  : PARAEP : VARIABLE D'ECROUISSAGE -----------------------------
! ------------ : AXIP -----------------------------------------------
! ----: DERPAR : DERIVEES DES VARIABLE D'ECROUISSAGE ----------------
! ------------ : DS/DXIP, DA/DXIP, DK/DXIP, DM/DXIP -----------------
! ===================================================================
    real(kind=8) :: axip
    real(kind=8) :: xiult, xie, xipic, m0, me, mpic, a0, ae, apic, mult
    real(kind=8) :: s0, spic, xams, eta, sigc
    real(kind=8) :: sigp1, sigp2, un, mun, zero
    real(kind=8) :: fact1, fact2, fact3, fact4, fact5, fact6
    real(kind=8) :: dsd, dad, dmd, xip
! ===================================================================
! --- INITIALISATION DE PARAMETRES ----------------------------------
! ===================================================================
    parameter       ( zero   =  0.0d0   )
    parameter       ( un     =  1.0d0   )
    parameter       ( mun    = -1.0d0   )
! ===================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE --------------------------
! ===================================================================
!
    sigc = mater(3,2)
    xams = mater(6,2)
    eta = mater(7,2)
    a0 = mater(8,2)
    ae = mater(9,2)
    apic = mater(10,2)
    s0 = mater(11,2)
    m0 = mater(12,2)
    me = mater(13,2)
    mpic = mater(14,2)
    mult = mater(15,2)
    xiult = mater(16,2)
    xie = mater(17,2)
    xipic = mater(18,2)
!
    sigp1 = mater(23,2)
!
    axip = paraep(1)
    spic = un
!
    sigp2 = ((mult*(sigc)**(ae-un))/(me**ae))**(un/(ae-un))
!
! ===================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS 0<XIP<XIPIC--------
! ===================================================================
    xip = vin(1)
!
    if ((xip.ge. zero) .and. (xip.lt. xipic)) then
        fact1 = un/(xip+(xams*xipic))
        fact2 = (apic-a0)/log(un+(un/xams))
        dad = fact1* fact2
!
        fact3 = (mpic-m0)/log(un+(un/xams))
        dmd = fact1*fact3
!
!
        fact4 = (spic-s0)/log(un+(un/xams))
        dsd = fact1*fact4
!
! ===================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS XIPIX< XIP < XIE---
! ===================================================================
    else if ((xip.ge.xipic).and.(xip.lt.xie)) then
        fact1 = ae - apic
        fact2 = xie - xipic
        dad = fact1/fact2
!
        dsd = mun/fact2
!
        fact3 = sigc/sigp1
        fact4 = (mpic /fact3 + spic)**(apic/axip)
        fact5 = log((mpic /fact3) + spic)
        fact6 = -apic/(paraep(1)**2)
!
        dmd = fact3*(fact6*fact4*fact5*dad-dsd)
! ===================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS XIE< XIP < XIULT---
! ===================================================================
    else if ((xip.ge.xie).and.(xip.lt.xiult)) then
!
        fact1 = (un-ae)/(log(un+(un/eta)))
!
        fact2 = un/(xip+(eta*xiult)-(un+eta)*xie)
!
        dad = fact1*fact2
!
        dsd = zero
!
        fact3 = sigc/sigp2
        fact4 = (me / fact3)**(ae/axip)
        fact5 = log(me / fact3)
        fact6 = -ae/(paraep(1)**2)
!
        dmd = fact3*(fact6*fact5*fact4)*dad
! ===================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS XIP > XIULT -------
! ===================================================================
    else if (xip.ge.xiult) then
        dad = zero
        dsd = zero
        dmd = zero
    endif
! ===================================================================
! --- STOCKAGE ------------------------------------------------------
! ===================================================================
    derpar(1) = dad
    derpar(2) = dsd
    derpar(3) = dmd
! ===================================================================
end subroutine
