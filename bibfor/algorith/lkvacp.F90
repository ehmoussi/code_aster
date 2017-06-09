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

subroutine lkvacp(nbmat, mater, paraep, varpl)
!
    implicit      none
    integer :: nbmat
    real(kind=8) :: paraep(3), mater(nbmat, 2), varpl(4)
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE------------------------
! ===============================================================
! --- BUT : CALCUL DES VARIABLES D'ECROUISSAGE ------------------
! ===============================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES DU MODELE -----------------
! --- : MATER  : PARAMETRES DU MODELE ---------------------------
!     : PARAEP : VARIABLE D'ECROUISSAGE -------------------------
! ------------ : PARAEP(1)=AXIP ---------------------------------
! ------------ : PARAEP(2)=SXIP ---------------------------------
! ------------ : PARAEP(3)=MXIP ---------------------------------
! OUT : VARPL  : ADXIP, BDXIP, DDXIP, KDXIP ---------------------
! ===============================================================
    real(kind=8) :: sigc, gamcjs, h0c
    real(kind=8) :: adxip, bdxip, ddxip, kdxip
    real(kind=8) :: un, deux, trois, six
! ===============================================================
! --- INITIALISATION DE PARAMETRES ------------------------------
! ===============================================================
    parameter       ( un     =  1.0d0   )
    parameter       ( deux   =  2.0d0   )
    parameter       ( trois  =  3.0d0   )
    parameter       ( six    =  6.0d0   )
!
! ===============================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ----------------------
! ===============================================================
    sigc = mater(3,2)
    gamcjs = mater(5,2)
! ===============================================================
!---- CALCUL DE Kd(XIP)------------------------------------------
! ===============================================================
    kdxip = (deux/trois)**(un/deux/paraep(1))
! ===============================================================
!---- CALCUL DE Ad(XIP)------------------------------------------
! ===============================================================
    h0c = (un - gamcjs)**(un/six)
    adxip = -paraep(3) * kdxip/sqrt(six)/sigc/h0c
! ===============================================================
!---- CALCUL DE Bd(XIP)------------------------------------------
! ===============================================================
    bdxip = paraep(3) * kdxip/trois/sigc
! ===============================================================
!---- CALCUL DE Dd(XIP)------------------------------------------
! ===============================================================
    ddxip = paraep(2) * kdxip
! ===============================================================
! --- STOCKAGE --------------------------------------------------
! ===============================================================
    varpl(1) = adxip
    varpl(2) = bdxip
    varpl(3) = ddxip
    varpl(4) = kdxip
! ===============================================================
end subroutine
