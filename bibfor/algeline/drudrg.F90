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

subroutine drudrg(parame, derpar, h0, sigc, rgdev,&
                  invar1, dudg)
!
    implicit  none
#include "asterfort/derpro.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    real(kind=8) :: parame(5), derpar(4), h0, sigc, rgdev, invar1, dudg
! --- BUT : CALCUL DE DU/DGAMP -----------------------------------------
! ======================================================================
! IN  : PARAME : VECTEUR DES VARIABLES D'ECROUISSAGE -------------------
! --- : DERIVE : VECTEUR DES DERIVEES DES VARIABLES D'ECROUISSAGE ------
! --- : H0     : H0 = (1-GAMCJS)**(1/6) --------------------------------
! --- : SIGC   : PARAMETRE DU MODELE -----------------------------------
! --- : RGDEV  : G(S) --------------------------------------------------
! --- : INVAR1 : PREMIER INVARIANT DES CONTRAINTES ---------------------
! OUT : DUDG   : DUDG = - G/(RAC(6)*SIGC*H0)*D(KM)/DGAMP ---------------
! ------------ :        - INVAR1/(3*SIGC)*D(KM)DGAMP -------------------
! ------------ :        + D(KS)/DGAMP ----------------------------------
! ======================================================================
    real(kind=8) :: mun, trois, six, fact1, fact2
    real(kind=8) :: sgamp, kgamp, mgamp, ds, dk, dm, dkm, dks
! ======================================================================
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    =  -1.0d0  )
    parameter       ( trois  =   3.0d0  )
    parameter       ( six    =   6.0d0  )
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DES VARIABLES D'ECROUISSAGES ET DE SES DERIVEES -----
! ======================================================================
    sgamp = parame(1)
    kgamp = parame(3)
    mgamp = parame(4)
    ds = derpar(1)
    dk = derpar(3)
    dm = derpar(4)
! ======================================================================
! --- CALCUL INTERMEDIAIRE ---------------------------------------------
! ======================================================================
    fact1 = mun*rgdev/(sqrt(six)*sigc*h0)
    fact2 = mun*invar1/(trois*sigc)
    call derpro(kgamp, dk, mgamp, dm, dkm)
    call derpro(kgamp, dk, sgamp, ds, dks)
! ======================================================================
! --- CALCUL FINAL -----------------------------------------------------
! ======================================================================
    dudg = (fact1+fact2)*dkm + dks
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
