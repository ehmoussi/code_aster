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

subroutine drfdrs(q, parame, h0, sigc, rgdev,&
                  duds, dfds)
!
    implicit    none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    real(kind=8) :: q(6), parame(5), h0, sigc, rgdev, duds(6), dfds(6)
! --- BUT : CALCUL DE DU/DSIG ------------------------------------------
! ======================================================================
! IN  : N      : NOMBRE TOTAL DE COMPOSANTES DU TENSEUR ----------------
! --- : Q      : DG/DSIG -----------------------------------------------
! --- : PARAME : PARAMETRES D'ECROUISSAGE ------------------------------
! --- : H0     : H0 = (1-GAMCJS)**(1/6) --------------------------------
! --- : SIGC   : PARAMETRE DU MODELE -----------------------------------
! --- : RGDEV  : G(S) --------------------------------------------------
! --- : DUDS   : DU/DSIG -----------------------------------------------
! OUT : DFDS   : DF/DSIG = (1/A)*((1/(SIGC*H0))**(1/A))*G**((1-A)/A)*Q -
! ------------ :         - DU/DSIG  ------------------------------------
! ======================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: agamp, fact1, fact2, fact3, fact4, un
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( un     =  1.0d0   )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DES VARIABLES D'ECROUISSAGES ------------------------
! ======================================================================
    agamp = parame(2)
! ======================================================================
! --- VARIABLE INTERMEDIAIRE -------------------------------------------
! ======================================================================
    fact2 = un/agamp
    fact3 = (un/(sigc*h0))**fact2
    fact3 = fact3*fact2
    fact2 = (un-agamp)/agamp
    fact4 = rgdev**fact2
    fact1 = fact3*fact4
! ======================================================================
! --- CALCUL FINAL -----------------------------------------------------
! ======================================================================
    do 10 ii = 1, ndt
        dfds(ii) = fact1*q(ii)-duds(ii)
10  end do
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
