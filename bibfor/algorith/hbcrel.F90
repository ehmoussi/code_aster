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

subroutine hbcrel(vp, gamma, dg, nbmat, materf,&
                  sigeqe, i1e, etap, parame, seuil)
    implicit      none
    integer :: nbmat
    real(kind=8) :: vp(3), gamma, materf(nbmat, 2), sigeqe, i1e, seuil, dg, etap
    real(kind=8) :: parame(4)
! ======================================================================
! --- HOEK BROWN : CALCUL DU CRITERE PLASTIQUE F(SIGE,DG) --------------
! ======================================================================
! IN  VP     VALEURS PROPRES DU DEVIATEUR DE SIGMA ---------------------
! IN  GAMMA  VALEUR DE LA VARIABLE D ECROUISSAGE GAMMA_PLUS ------------
! IN  DG     INCREMENT DE GAMMA ----------------------------------------
! IN  NBMAT  NOMBRE DE DONNEES MATERIAU -------------------------------
! IN  MATERF DONNEES MATERIAU ------------------------------------------
! IN  ETAP   VALEUR DE ETA A GAMMA_PLUS --------------------------------
! IN  PARAME VALEUR DES PARAMETRES D ECROUISSAGE -----------------------
! OUT SEUIL  VALEUR DU CRITERE PLASTIQUE -------------------------------
! ======================================================================
    real(kind=8) :: difsig, sig3, mu, k, sigbd, un, trois, neuf
    real(kind=8) :: aux1, aux2
! ======================================================================
    parameter       ( un     =  1.0d0  )
    parameter       ( trois  =  3.0d0  )
    parameter       ( neuf   =  9.0d0  )
! ======================================================================
! --- RECUPERATION DES DONNEES MATERIAU --------------------------------
! ======================================================================
    mu = materf(4,1)
    k = materf(5,1)
    sigbd = materf(14,2)
! ======================================================================
! --- CALCUL DES VALEURS PROPRES DE SIG --------------------------------
! ======================================================================
    difsig = (vp(3)-vp(1))*(un - trois*mu*dg/(sigeqe*(etap+un)))
    sig3 = vp(3)*(un - trois*mu*dg/(sigeqe*(etap+un))) + (i1e - neuf*k*etap*dg/(etap+un))/trois
! ======================================================================
! --- CALCUL DU SEUIL --------------------------------------------------
! ======================================================================
    aux1 = -sig3*parame(2)+parame(1)
    aux2 = parame(3)*(un+sig3/sigbd)
    seuil = (difsig - aux2)**2 - aux1
! ======================================================================
end subroutine
