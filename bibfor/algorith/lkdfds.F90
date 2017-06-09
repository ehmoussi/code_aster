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

subroutine lkdfds(nbmat, mater, s, para, var,&
                  ds2hds, ucri, dfdsig)
    implicit      none
#include "asterc/r8prem.h"
#include "asterfort/cos3t.h"
#include "asterfort/lkhtet.h"
#include "asterfort/r8inir.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2)
    real(kind=8) :: s(6), para(3), var(4), ucri
    real(kind=8) :: ds2hds(6), dfdsig(6)
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : CALCUL DE DF/DSIG -------------------------------------
! =================================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES DU MODELE -------------------
! --- : MATER  : PARAMETRES DU MODELE -----------------------------
!     : S      : TENSEUR DU DEVIATEUR DES CONTRAINTES -------------
!     : PARA   : VARIABLE D'ECROUISSAGE ---------------------------
! ------------ : PARA(1)=AXI --------------------------------------
! ------------ : PARA(2)=SXI --------------------------------------
! ------------ : PARA(3)=MXI --------------------------------------
!     : VAR  : ADXI, BDXI, DDXI -----------------------------------
!     : DS2HDS: d(sII*h(THETA))/dsig ------------------------------
!     : UCRI  : LE TERME SOUS LA PUISSANCE DANS LE CRITERE --------
! OUT : DFDSIG : dF/dsig ------------------------------------------
! =================================================================
    integer :: ndi, ndt, i
    real(kind=8) :: pref, sigc, rcos3t, h0c, h0e, htheta
    real(kind=8) :: zero, un, lgleps
    real(kind=8) :: a(6), kron(6)
    real(kind=8) :: fact1, fact3
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( zero    =  0.0d0   )
    parameter       ( un      =  1.0d0   )
    parameter       ( lgleps  =  1.0d-8  )
! =================================================================
    common /tdim/   ndt , ndi
! =================================================================
    data    kron    /un  ,un  ,un  ,zero  ,zero  ,zero/
! =================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ------------------------
! =================================================================
    sigc = mater(3,2)
    pref = mater(1,2)
! =================================================================
! --- CALCUL DE h(THETA), H0E ET H0C, -----------------------------
! =================================================================
    rcos3t = cos3t (s, pref, lgleps)
    call lkhtet(nbmat, mater, rcos3t, h0e, h0c,&
                htheta)
! =================================================================
! --- CALCUL DES TERMES INTERMEDIARES
! =================================================================
    fact1 = para(1) * sigc * h0c
    fact3 = para(1) - un
! =================================================================
! --- RESULTAT FINAL
! =================================================================
    call r8inir(6, 0.d0, a, 1)
    call r8inir(6, 0.d0, dfdsig, 1)
!
    do 10 i = 1, ndt
        a(i) = var(1) * ds2hds(i) + var(2)* kron (i)
10  end do
!
    do 20 i = 1, ndt
        if (ucri .le. r8prem()) then
            dfdsig(i) = ds2hds(i)
        else
            dfdsig(i) = ds2hds(i) - fact1*((ucri)**fact3)*a(i)
        endif
20  end do
! =================================================================
end subroutine
