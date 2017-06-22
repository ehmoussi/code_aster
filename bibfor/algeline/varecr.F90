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

subroutine varecr(gamp, nbmat, mater, parame)
!
    implicit      none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbmat
    real(kind=8) :: gamp, parame(5), mater(nbmat, 2)
! --- BUT : CALCUL DES VARIABLES D'ECROUISSAGE -------------------------
! ======================================================================
! IN  : GAMP   : DEFORMATION DEVIATOIRE PLASTIQUE CUMULEE --------------
! --- : NBMAT  : NOMBRE DE PARAMETRES DU MODELE ------------------------
! --- : MATER  : PARAMETRES DU MODELE ----------------------------------
! OUT : PARAME : VARIABLE D'ECROUISSAGE S(GAMP) ------------------------
! ------------ : SGAMP, AGAMP, KGAMP, MGAMP, OMEGA ---------------------
! ======================================================================
    real(kind=8) :: sgamp, agamp, kgamp, mgamp, omega
    real(kind=8) :: gamult, gammae, mult, me, ae, mpic, apic, eta, sigc, zero
    real(kind=8) :: sigp1, sigp2, fact1, fact2, fact3, puis1, un, deux, trois
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( zero   = 0.0d0   )
    parameter       ( un     = 1.0d0   )
    parameter       ( deux   = 2.0d0   )
    parameter       ( trois  = 3.0d0   )
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE -----------------------------
! ======================================================================
    gamult = mater( 1,2)
    gammae = mater( 2,2)
    mult = mater( 3,2)
    me = mater( 4,2)
    ae = mater( 5,2)
    mpic = mater( 6,2)
    apic = mater( 7,2)
    eta = mater( 8,2)
    sigc = mater( 9,2)
    sigp1 = mater(13,2)
    sigp2 = mater(14,2)
! ======================================================================
! CALCUL DES VARIABLES D'ECROUISSAGES POUR LE CAS GAMP > GAMULT(1-EPS) -
! ======================================================================
    if (gamp .gt. gamult) then
        sgamp = zero
        omega = zero
        agamp = un
        mgamp = mult
        kgamp = sqrt(deux/trois)
! ======================================================================
! SINON ----------------------------------------------------------------
! ======================================================================
    else
! ======================================================================
! --- CALCUL DE OMEGA(GAMP) = ------------------------------------------
! --- (GAMP/GAMMAE)**ETA*  ---------------------------------------------
! ------------  *((AE-APIC)/(1-AE))*((GAMULT-GAMMAE)/(GAMULT-GAMP)) ----
! ======================================================================
        fact1 = (gamp/gammae)**eta
        fact2 = (ae-apic)/(un-ae)
        fact3 = gamult-gammae
        omega = fact1*fact2*fact3
! ======================================================================
! --- CALCUL DE A(GAMP) = (APIC+OMEGA(GAMP))/(1+OMEGA(GAMP)) -----------
! ======================================================================
        agamp = (apic*(gamult-gamp)+omega)/(gamult-gamp+omega)
! ======================================================================
! --- CALCUL DE K(GAMP) = (2/3)**(1/(2*A(GAMP))) -----------------------
! ======================================================================
        puis1 = un/(deux*agamp)
        kgamp = (deux/trois)**puis1
! ======================================================================
! --- CAS OU GAMP < GAMMAE ---------------------------------------------
! ======================================================================
        if (gamp .lt. gammae) then
! ======================================================================
! --- CALCUL DE S(GAMP) = (1-GAMP/GAMMAE) ------------------------------
! ======================================================================
            sgamp = un-gamp/gammae
! ======================================================================
! --- CALCUL DE M(GAMP) = ----------------------------------------------
! ----- SIGC/SIGP1*((MPIC*SIGP1/SIGC+1)**(APIC/A(GAMP))-S(GAMP)) -------
! ======================================================================
            fact1 = sigc/sigp1
            fact2 = mpic*sigp1/sigc+un
            puis1 = apic/agamp
            mgamp = fact1*(fact2**puis1-sgamp)
! ======================================================================
! --- CAS OU GAMP >= GAMMAE --------------------------------------------
! ======================================================================
        else
! ======================================================================
! --- CALCUL DE S(GAMP) = 0 --------------------------------------------
! ======================================================================
            sgamp = zero
! ======================================================================
! --- CALCUL DE M(GAMP) = ----------------------------------------------
! ----- SIGC/SIGP2*(ME*SIGP2/SIGC)**(AE/A(GAMP)) -----------------------
! ======================================================================
            fact1 = sigc/sigp2
            fact2 = me*sigp2/sigc
            puis1 = ae/agamp
            mgamp = fact1*(fact2**puis1)
        endif
    endif
! ======================================================================
! --- STOCKAGE ---------------------------------------------------------
! ======================================================================
    parame(1) = sgamp
    parame(2) = agamp
    parame(3) = kgamp
    parame(4) = mgamp
    parame(5) = omega
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
