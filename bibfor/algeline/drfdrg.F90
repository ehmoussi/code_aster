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

subroutine drfdrg(parame, derpar, h0, sigc, rgdev,&
                  dudg, df)
!
    implicit      none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    real(kind=8) :: h0, sigc, rgdev, dudg, df, parame(5), derpar(4)
! --- BUT : CALCUL DE DF/DGAMP -----------------------------------------
! ======================================================================
! IN  : PARAME : PARAMETRES D'ECROUISSAGE ------------------------------
! --- : DERPAR : DERIVEES DES PARAMETRES D'ECROUISSAGE -----------------
! --- : H0     : H0 = (1-GAMCJS)**(1/6) --------------------------------
! --- : SIGC   : PARAMETRE DU MODELE -----------------------------------
! --- : RGDEV  : G(S) --------------------------------------------------
! --- : DUDG   : DU/DGAMP ----------------------------------------------
! OUT : DF     : DF/DGAMP = - ((1/A(GAMP))**2)*   ----------------------
! ------------ :              ((G/(SIGC*H0))**(1/A(GAMP))*  ------------
! ------------ :              LOG(G/(SIGC*H0))*DA/DG-DU/DG  ------------
! ======================================================================
    real(kind=8) :: agamp, da, mun, un, fact1, fact2, fact3
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
    parameter       ( un     =  1.0d0  )
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DES VARIABLES D'ECROUISSAGE ET DE SES DERIVEES ------
! ======================================================================
    agamp = parame(2)
    da = derpar(2)
! ======================================================================
! --- CALCUL FINAL -----------------------------------------------------
! ======================================================================
    fact1 = un/agamp
    fact2 = rgdev/(sigc*h0)
    fact3 = fact2**fact1
    df = mun*fact1*fact1*fact3*log(fact2)*da - dudg
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
