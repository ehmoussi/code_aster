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

subroutine lkcriv(vintr, invar, s, vin, nbmat,&
                  mater, ucriv, seuil)
!
    implicit    none
#include "asterfort/cos3t.h"
#include "asterfort/lcprsc.h"
#include "asterfort/lkhtet.h"
#include "asterfort/lkvacv.h"
#include "asterfort/lkvarv.h"
    integer :: nbmat
    real(kind=8) :: invar, s(6), mater(nbmat, 2), vin(7), seuil
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : CRITERE VISQUEUX --------------------------------------
! =================================================================
! IN  : VINTR  :  VIN(3) ou XIVMAX ---------------------------------
! --- : INVAR :  INVARIANT DES CONTRAINTES ------------------------
! --- : S     :  DEVIATEUR DU TENSEUR DES CONTRAINTES A T+DT ------
! --- : VIN   :  VARIABLES INTERNES -------------------------------
! --- : NBMAT :  NOMBRE DE PARAMETRES MATERIAU --------------------
! --- : MATER :  COEFFICIENTS MATERIAU A T+DT ---------------------
! ----------- :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
! ----------- :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
! OUT : SEUIL :  VALEUR DE F(S) VISQUEUX  -------------------------
! =================================================================
    integer :: ndi, ndt
    real(kind=8) :: sii, sigc, pref, lgleps
    real(kind=8) :: h0e, h0c, htheta
    real(kind=8) :: rcos3t, ucriv
    real(kind=8) :: paravi(3), varvi(4), vintr
! =================================================================
    common /tdim/   ndt , ndi
! =================================================================
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( lgleps  = 1.0d-8 )
! =================================================================
! =================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ------------------------
! =================================================================
    sigc = mater(3,2)
    pref = mater(1,2)
! =================================================================
! --- CALCUL DU DEVIATEUR ET DU PREMIER INVARIANT DES CONTRAINTES -
! =================================================================
    call lcprsc(s, s, sii)
    sii = sqrt (sii)
! =================================================================
! --- APPEL A HOC ET  H(THETA) ------------------------------------
! =================================================================
!
    rcos3t = cos3t (s, pref, lgleps)
    call lkhtet(nbmat, mater, rcos3t, h0e, h0c,&
                htheta)
! =================================================================
! --- APPEL AUX FONCTIONS D ECROUISSAGE DU CRITERE VISQUEUX -------
! =================================================================
!
    call lkvarv(vintr, nbmat, mater, paravi)
    call lkvacv(nbmat, mater, paravi, varvi)
! =================================================================
! ---  CRITERE ELASTOPLASTIQUE ------------------------------------
! =================================================================
    ucriv = varvi(1)*sii*htheta + varvi(2)*invar+varvi(3)
!
    if (ucriv .lt. 0.0d0) ucriv=0.0d0
!
    seuil = sii*htheta - sigc*h0c*(ucriv)**paravi(1)
!      SEUIL =-1.0D0
! =================================================================
end subroutine
