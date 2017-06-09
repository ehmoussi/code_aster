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

subroutine hbmajs(dg, nbmat, materf, se, i1e,&
                  sigeqe, etap, sigp)
    implicit      none
    integer :: nbmat
    real(kind=8) :: dg, materf(nbmat, 2), se(6), i1e, sigp(6), sigeqe, etap
! ======================================================================
! --- LOI DE HOEK BROWN : MISE A JOUR DES CONTRAINTES A T+ -------------
! ======================================================================
! IN   DG      INCREMENT DE LA VARIABLE GAMMA --------------------------
! IN   NBMAT   NOMBRE DE DONNEES MATERIAU ------------------------------
! IN   MATERF  DONNEES MATERIAU ----------------------------------------
! IN   SE      DEVIATEUR ELASTIQUE -------------------------------------
! IN   ETAP    VALEUR DE ETA A GAMMA_PLUS ------------------------------
! OUT  SIGP    CONTRAINTES A T+ ----------------------------------------
! ======================================================================
    integer :: ii, ndi, ndt
    real(kind=8) :: k, mu, i1, dev(6), un, neuf, trois
! =================================================================
    parameter       ( un     =  1.0d0  )
    parameter       ( neuf   =  9.0d0  )
    parameter       ( trois  =  3.0d0  )
! ======================================================================
    common /tdim/   ndt, ndi
! ======================================================================
    k = materf(5,1)
    mu = materf(4,1)
    do 10 ii = 1, ndt
        dev(ii) = se(ii)*(un-trois*mu*dg/(sigeqe*(etap+un)))
10  end do
    i1 = i1e - neuf*k*etap*dg/(etap+un)
    do 20 ii = 1, ndt
        sigp(ii) = dev(ii)
20  end do
    do 30 ii = 1, ndi
        sigp(ii) = sigp(ii) + i1/trois
30  end do
! ======================================================================
end subroutine
