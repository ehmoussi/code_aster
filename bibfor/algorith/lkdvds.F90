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

subroutine lkdvds(dt, nbmat, mater, gv, dfdsv,&
                  seuilv, dvds)
!
    implicit    none
#include "asterfort/lcprte.h"
#include "asterfort/r8inir.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), dvds(6, 6), dt
    real(kind=8) :: gv(6), dfdsv(6), seuilv
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : DERIVEE DE L AMPLITUDE DES DEFORMATIONS IRREVERSIBLES -
! ----------PAR RAPPORT A DEPS
! =================================================================
! IN  : DT    :  PAS DE TEMPS -------------------------------------
! ----: NBMAT :  NOMBRE DE PARAMETRES MATERIAU --------------------
! --- : MATER :  COEFFICIENTS MATERIAU A T+DT ---------------------
! ----------- :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
! ----------- :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
! --- : GV : GV=dfv/dsig-(dfv/dsig*n)*n ---------------------------
!-----: DFDSV :  DERIVEE DU CRITERE VISCOPLASTIQUE PAR RAPPORT A LA
!----------------CONTRAINTE
!-----: SEUILV:  SEUIL VISCOPLASTIQUE -----------------------------
! OUT : DVDS  :  DERIVEE DE DEPSV/ DSIG  --------------------------
! =================================================================
    common /tdim/   ndt , ndi
    integer :: i, k, ndi, ndt
    real(kind=8) :: pa, aa(6, 6), a, n, un, zero
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( un  = 1.0d0 )
    parameter       ( zero = 0.0d0)
! =================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ------------------------
! =================================================================
    pa = mater(1,2)
    a = mater(21,2)
    n = mater(22,2)
! =================================================================
! --- MATRICE INTERMEDIAIRE ---------------------------------------
! =================================================================
    call r8inir(6*6, 0.d0, aa, 1)
    call lcprte(dfdsv, gv, aa)
!
! =================================================================
! --- CALCUL DE DPHI/DDEPS ------------------------------------
! =================================================================
!
    do 10 i = 1, ndt
        do 20 k = 1, ndt
            if (seuilv .le. zero) then
                dvds(i,k) = zero
            else
                dvds(i,k) = a * n /pa * (seuilv/pa)**(n-un)* aa(i,k)* dt
            endif
20      end do
10  end do
! =================================================================
end subroutine
