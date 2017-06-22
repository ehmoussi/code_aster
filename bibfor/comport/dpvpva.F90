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

subroutine dpvpva(vin, nbmat, mater, fonecr)
!
    implicit      none
    integer :: nbmat
    real(kind=8) :: vin(4), fonecr(3), mater(nbmat, 2)
! --- MODELE VISC_DRUC_PRAG : DRUCKER PRAGER VISCOPLASTIQUE-------
! ================================================================
! --- BUT : CALCUL DES VARIABLES D'ECROUISSAGE -------------------
! ================================================================
! --- : VIN    : TABLEAU DES VARIABLE INTERNES (ICI P) -----------
! --- : NBMAT  : NOMBRE DE PARAMETRES DU MODELE ------------------
! --- : MATER  : PARAMETRES DU MODELE ----------------------------
! OUT : FONECR : FONCTIONS D'ECROUISSAGE -------------------------
! ------------ : ALPHA,R ,BETA  ----------------------------------
! ================================================================
    real(kind=8) :: alpha, r, beta
    real(kind=8) :: alpha0, beta0, r0
    real(kind=8) :: alphap, betap, rpic
    real(kind=8) :: alphau, betau, rult
    real(kind=8) :: p, zero, ppic, pult
! ================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------
! ================================================================
    parameter       ( zero   =  0.0d0   )
! ================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE -----------------------
! ================================================================
    ppic = mater(4,2)
    pult = mater(5,2)
    alpha0 = mater(6,2)
    alphap = mater(7,2)
    alphau = mater(8,2)
    r0 = mater(9,2)
    rpic = mater(10,2)
    rult = mater(11,2)
    beta0 = mater(12,2)
    betap = mater(13,2)
    betau = mater(14,2)
!
! ================================================================
! CALCUL DES FONCTIONS D'ECROUISSAGES POUR LE CAS 0<P<PPIC-----
! ================================================================
    p = vin(1)
    if ((p.ge. zero) .and. (p.lt. ppic)) then
        alpha = alpha0 + (alphap-alpha0)/ppic * p
!
        r = r0 + (rpic-r0)/ppic * p
!
        beta = beta0 + (betap - beta0)/ppic * p
! ================================================================
! CALCUL DES FONCTIONS D'ECROUISSAGES POUR LE CAS PPIC< P < PULT
! ================================================================
    else if ((p.ge.ppic).and.(p.lt.pult)) then
        alpha = alphap + (alphau-alphap)/(pult-ppic) * (p - ppic)
!
        r = rpic + (rult - rpic)/(pult - ppic) * (p - ppic)
!
        beta = betap + (betau - betap)/(pult - ppic) * (p - ppic)
! ================================================================
! CALCUL DES FONCTIONS D'ECROUISSAGES POUR LE CAS P > PULT ----
! ================================================================
    else if (p.ge.pult) then
        alpha = alphau
!
        r = rult
!
        beta = betau
    endif
! ================================================================
! --- STOCKAGE ---------------------------------------------------
! ================================================================
    fonecr(1) = alpha
    fonecr(2) = r
    fonecr(3) = beta
! ================================================================
end subroutine
