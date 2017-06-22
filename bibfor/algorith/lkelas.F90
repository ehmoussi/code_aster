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

subroutine lkelas(ndi, ndt, nmat, mater, deps,&
                  sigd, de, k, mu)
    implicit none
#include "asterfort/r8inir.h"
#include "asterfort/trace.h"
    integer :: ndi, ndt, nmat
    real(kind=8) :: mater(nmat, 2)
    real(kind=8) :: sigd(6)
    real(kind=8) :: deps(6), de(6, 6), mu, k
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
!       MATRICE  HYPOELASTIQUE
!       IN  NDI    :  DIMENSION DE L ESPACE
!           NDT    :  2* NDI POUR LE CALCUL TENSORIEL
!           NMAT   :  DIMENSION MATER
!           MATER :  COEFFICIENTS MATERIAU
!           DEPS   :  INCREMENT DE DEFORMATION
!           SIGD   :  CONTRAINTE  A T
!       OUT DE     :  MATRICE HYPOELASTIQUE
!            K     :  MODULE DE COMPRESSIBILITE
!            G     :  MODULE DE CISAILLEMENT
!       -----------------------------------------------------------
    integer :: i, j
    real(kind=8) :: mue, ke, pa, nelas
    real(kind=8) :: invar1
    real(kind=8) :: deux, trois
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( deux   =  2.0d0  )
    parameter       ( trois  =  3.0d0  )
! =================================================================
! --- CALCUL DU PREMIER INVARIANT DES CONTRAINTES A LINSTANT T ----
! =================================================================
    invar1 = trace (ndi, sigd)
! =================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ------------------------
! =================================================================
    mue = mater(4,1)
    ke = mater(5,1)
!
    pa = mater(1,2)
    nelas = mater(2,2)
!
! =================================================================
! --- CALCUL DES PARAMETRES AU TEMPS T + DT -----------------------
! =================================================================
    k = ke * (invar1/trois/pa)**nelas
    mu = mue * (invar1/trois/pa)**nelas
! =================================================================
! --- DEFINITION DE LA MATRICE HYPOLELASTIQUE ---------------------
! =================================================================
    call r8inir(6*6, 0.d0, de, 1)
    do i = 1, 3
        do j = 1, 3
            de(i,j) = k - deux*mu/trois
        end do
    end do
!
    do i = 1, ndt
        de(i,i) = de(i,i) + deux*mu
    end do
!
! =================================================================
end subroutine
