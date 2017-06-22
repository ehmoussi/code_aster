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

subroutine lkhtet(nbmat, mater, rcos3t, h0e, h0c,&
                  htheta)
!
    implicit none
#include "asterfort/lkhlod.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), rcos3t, htheta
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : CALCUL DE H(THETA)
! =================================================================
! IN  : NBMAT :  NOMBRE DE PARAMETRES MATERIAU --------------------
! --- : MATER :  COEFFICIENTS MATERIAU A T+DT ---------------------
! ----------- :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
! ----------- :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
! --- : RCOS3T : COS(3T) ------------------------------------------
! OUT : H0E    : PARAMETRE UTILIE DANS LE CRITERE------------------
!     : H0C    : PARAMETRE UTILIE DANS LE CRITERE------------------
!     : HTHETA : H(THETA ------------------------------------------
! =================================================================
    real(kind=8) :: un, deux, six
    real(kind=8) :: gamcjs, h0ext, h0c, h0e, hlode
    real(kind=8) :: fact1, fact2, fact3
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( un     =  1.0d0  )
    parameter       ( deux   =  2.0d0  )
    parameter       ( six    =  6.0d0  )
! =================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ------------------------
! =================================================================
    h0ext = mater(4,2)
    gamcjs = mater(5,2)
! =================================================================
! ---- CALCUL DE H0C
! =================================================================
    h0c = (un - gamcjs )**(un/six)
! =================================================================
! ---- CALCUL DE H0E
! =================================================================
    h0e = (un + gamcjs )**(un/six)
! =================================================================
! ---- CALCUL DE H(THETA)
! =================================================================
    fact1 = (h0c + h0ext)/deux
    fact2 = (h0c - h0ext)/deux
!
    hlode = lkhlod(gamcjs,rcos3t)
!
    fact3 = (deux*hlode-(h0c+h0e))/(h0c-h0e)
!
    htheta = fact1 + fact2*fact3
! =================================================================
end subroutine
