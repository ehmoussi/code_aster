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

subroutine drudrs(parame, q, h0, sigc, dudsig)
!
    implicit      none
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    real(kind=8) :: q(6), parame(5), h0, sigc, dudsig(6)
! --- BUT : CALCUL DE DU/DSIG ------------------------------------------
! ======================================================================
! IN  : NDT    : NOMBRE TOTAL DE COMPOSANTES DU TENSEUR ----------------
! --- : NDI    : NOMBRE DE COMPOSANTES DIAGONALES DU TENSEUR -----------
! --- : PARAME : PARAMETRES D'ECROUISSAGES -----------------------------
! --- : Q      : DG/DSIG -----------------------------------------------
! --- : H0     : H0 = (1-GAMCJS)**(1/6) --------------------------------
! --- : SIGC   : PARAMETRE MATERIAU ------------------------------------
! OUT : DUDSIG : DUDSIG = - M(GAMP)*K(GAMP)*Q/(RAC(6)*SIGC*H0) ---------
! ------------ :          - K(GAMP)*M(GAMP)*I/(3*SIGC) -----------------
! ======================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: mgamp, kgamp, fact1, fact2, mun, trois, six
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
    parameter       ( trois  =  3.0d0  )
    parameter       ( six    =  6.0d0  )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DES VARIABLES D'ECROUISSAGES ------------------------
! ======================================================================
    kgamp = parame(3)
    mgamp = parame(4)
! ======================================================================
! --- CALCUL INTERMEDIAIRE ---------------------------------------------
! ======================================================================
    fact1 = mun*mgamp*kgamp/(sqrt(six)*sigc*h0)
    fact2 = mun*mgamp*kgamp/(trois*sigc)
! ======================================================================
! --- CALCUL FINAL -----------------------------------------------------
! ======================================================================
    do 10 ii = 1, ndt
        dudsig(ii) = fact1*q(ii)
10  end do
    do 20 ii = 1, ndi
        dudsig(ii) = dudsig(ii) + fact2
20  end do
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
