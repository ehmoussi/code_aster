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

subroutine lkvacv(nbmat, mater, paravi, varvi)
!
    implicit      none
    integer :: nbmat
    real(kind=8) :: paravi(3), mater(nbmat, 2), varvi(4)
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE-------------------------
! ================================================================
! --- BUT : CALCUL DES VARIABLES D'ECROUISSAGE CRITERE VISQUEUX --
! ================================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES DU MODELE ------------------
! --- : MATER  : PARAMETRES DU MODELE ----------------------------
!     : PARAVI : VARIABLE D'ECROUISSAGE VISQUEUSE ----------------
! ------------ : PARAVI(1)=AXIV ----------------------------------
! ------------ : PARAVI(2)=SXIV ----------------------------------
! ------------ : PARAVI(3)=MXIV ----------------------------------
! OUT : VARVI  : AVXIV, BVXIV, DVXIV ----------------------------
! ================================================================
    real(kind=8) :: sigc, gamcjs, h0c
    real(kind=8) :: avxiv, bvxiv, kvxiv, dvxiv
    real(kind=8) :: un, deux, trois, six
! ================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------
! ================================================================
    parameter       ( un     =  1.0d0   )
    parameter       ( deux   =  2.0d0   )
    parameter       ( trois  =  3.0d0   )
    parameter       ( six    =  6.0d0   )
! ================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE -----------------------
! ================================================================
    sigc = mater(3,2)
    gamcjs = mater(5,2)
! ================================================================
!---- CALCUL DE Kd(XIP)-------------------------------------------
! ================================================================
    kvxiv = (deux/trois)**(un/deux/paravi(1))
! ================================================================
!---- CALCUL DE Ad(XIP)-------------------------------------------
! ================================================================
    h0c = (un - gamcjs)**(un/six)
    avxiv = -paravi(3) * kvxiv/sqrt(six)/sigc/h0c
! ================================================================
!---- CALCUL DE Bd(XIP)-------------------------------------------
! ================================================================
    bvxiv = paravi(3) * kvxiv/trois/sigc
! ================================================================
!---- CALCUL DE Dd(XIP)-------------------------------------------
! ================================================================
    dvxiv = paravi(2) * kvxiv
! ================================================================
! --- STOCKAGE ---------------------------------------------------
! ================================================================
    varvi(1) = avxiv
    varvi(2) = bvxiv
    varvi(3) = dvxiv
    varvi(4) = kvxiv
! ================================================================
end subroutine
