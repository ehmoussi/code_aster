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

subroutine dpvpsi(nbmat, mater, se, seqe, i1e,&
                  fonecr, dp, sig)
! -----REACTUALISATION DES CONTRAINTES SI VISCOPLASTICITE ------------
! --- VISC_DRUC_PRAG --------------------------------------------------
! ====================================================================
    implicit      none
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), dp, se(6), seqe, i1e, fonecr(3), sig(6)
! ====================================================================
! --- MISE A JOUR DES CONTRAINTES ------------------------------------
! ====================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: k, mu, troisk, trois, un
    real(kind=8) :: i1, dev(6)
    real(kind=8) :: beta
    parameter ( trois  =  3.0d0 )
    parameter ( un     =  1.0d0 )
! ====================================================================
    common /tdim/   ndt, ndi
! ====================================================================
! --- AFFECTATION DES VARIABLES --------------------------------------
! ====================================================================
    mu = mater(4,1)
    k = mater(5,1)
    troisk = trois*k
    beta = fonecr(3)
! ====================================================================
! --- MISE A JOUR DU DEVIATEUR ---------------------------------------
! ====================================================================
    do 10 ii = 1, ndt
        dev(ii) = se(ii)*(un-trois*mu*dp/seqe)
10  end do
! ====================================================================
! --- MISE A JOUR DU PREMIER INVARIANT -------------------------------
! ====================================================================
    i1 = i1e - trois*troisk*beta*dp
! ====================================================================
! --- MISE A JOUR DU VECTEUR DE CONTRAINTES --------------------------
! ====================================================================
    do 20 ii = 1, ndt
        sig(ii) = dev(ii)
20  end do
    do 30 ii = 1, ndi
        sig(ii) = sig(ii) + i1/trois
30  end do
! ====================================================================
end subroutine
