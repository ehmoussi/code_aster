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

subroutine dsde2d(ndim, f, dsde, d)
! person_in_charge: sebastien.fayolle at edf.fr
!
! ----------------------------------------------------------------------
!     CALCUL DU TERME D=2FF(dS/dE)F^TF^T POUR LES FORMULATIONS INCO_LOG
! ----------------------------------------------------------------------
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  F       : GRADIENT TRANSFORMATION EN T
! IN  DSDE    : 2dS/dC = dS/dE_GL AVEC RACINE DE 2 ET 2
! OUT D       : 2FF(dS/dE)F^TF^T
!
    implicit none
    integer :: ndim, indi(6), indj(6), mn, op, ij, kl, nmax
    real(kind=8) :: f(3, 3), d(6, 6), dsde(6, 6), f1, f2, f3, f4
    real(kind=8) :: rind(6)
    data    indi / 1, 2, 3, 1, 1, 2 /
    data    indj / 1, 2, 3, 2, 3, 3 /
    data    rind / 0.5d0, 0.5d0, 0.5d0, 0.70710678118655d0,&
     &               0.70710678118655d0, 0.70710678118655d0 /
!
    nmax=2*ndim
!
    do 100 mn = 1, nmax
        do 200 op = 1, nmax
            d(mn,op) = 0.d0
            do 300 ij = 1, nmax
                do 400 kl = 1, nmax
                    f1 = f(indi(mn),indi(ij))*f(indj(mn),indj(ij))
                    f2 = f(indi(op),indi(kl))*f(indj(op),indj(kl))
                    f3 = f(indi(mn),indj(ij))*f(indj(mn),indi(ij))
                    f4 = f(indi(op),indj(kl))*f(indj(op),indi(kl))
                    d(mn,op) = d(mn,op) +(f1+f3)*(f2+f4)*dsde(ij,kl)* rind(ij)*rind(kl)
400              continue
300          continue
200      continue
100  end do
end subroutine
