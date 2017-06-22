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

subroutine calcvh(nbmat, materf, eta, vp, sigeqe,&
                  vh, vg)
    implicit      none
    integer :: nbmat
    real(kind=8) :: vh, vg, materf(nbmat, 2), eta, vp(3), sigeqe
! ======================================================================
! --- LOI DE HOEK BROWN :CALCUL DE TERMES DE LA FONCTION DE CHARGE (H/G)
! ======================================================================
! IN     NBMAT  NOMBRE DE DONNEES MATERIAU -----------------------------
! IN     MATERF DONNES MATERIAU ----------------------------------------
! IN     VP     VALEURS PROPRES DU DEVIATEUR ELASTIQUE -----------------
! IN/OUT VH     VALEUR DE LA FONCTION H --------------------------------
! IN/OUT VG     VALEUR DE LA FONCTION G --------------------------------
! ======================================================================
    real(kind=8) :: aux4, k, mu, un, trois
! ======================================================================
    parameter       ( un     =  1.0d0  )
    parameter       ( trois  =  3.0d0  )
! ======================================================================
    mu = materf(4,1)
    k = materf(5,1)
    aux4 = trois*mu/sigeqe
    vh = un/(eta+un)
    vg = vh*(trois*k*eta+aux4*vp(3))
! ======================================================================
end subroutine
