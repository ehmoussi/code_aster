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

subroutine lkdphi(nbmat, mater, de, seuilv, dfdsv,&
                  dphi)
!
    implicit    none
#include "asterfort/lcprmv.h"
#include "asterfort/r8inir.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), de(6, 6)
    real(kind=8) :: dphi(6), dfdsv(6), seuilv
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : DERIVEE DE L AMPLITUDE DES DEFORMATIONS IRREVERSIBLES -
! ----------PAR RAPPORT A DEPS
! =================================================================
! IN  : NBMAT :  NOMBRE DE PARAMETRES MATERIAU --------------------
! --- : MATER :  COEFFICIENTS MATERIAU A T+DT ---------------------
! ----------- :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
! ----------- :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
!-----: DE    :  MATRICE HYPOELASTIQUE ----------------------------
!-----: SEUILV:  SEUIL VISCOPLASTIQUE -----------------------------
!-----: DFDSV :  DERIVEE DU CRITERE VISCOPLASTIQUE PAR RAPPORT A LA
!----------------CONTRAINTE
! OUT : DPHI  :  AMPLITUDE DES DEFORMATIONS IRREVERSIBLES  --------
!       DPHI   = A*n/PA*(fv(SIG,XIV)/PA)**(n-1).dfv/dsig*De
! =================================================================
    common /tdim/   ndt , ndi
    integer :: i, ndi, ndt
    real(kind=8) :: un, zero
    real(kind=8) :: pa, a, n, aa(6)
    parameter       (un     =  1.0d0  )
    parameter       (zero   =  0.0d0  )
! =================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ------------------------
! =================================================================
    pa = mater(1,2)
    a = mater(21,2)
    n = mater(22,2)
!
! =================================================================
! --- MATRICE INTERMEDIAIRE ---------------------------------------
! =================================================================
    call r8inir(6, 0.d0, aa, 1)
!
    call lcprmv(de, dfdsv, aa)
!
! =================================================================
! --- CALCUL DE DPHI/DDEPS ------------------------------------
! =================================================================
    do 10 i = 1, ndt
        if (seuilv .le. zero) then
            dphi(i) = zero
        else
            dphi(i) = a * n /pa * (seuilv/pa)**(n-un)*aa(i)
        endif
10  end do
! =================================================================
end subroutine
