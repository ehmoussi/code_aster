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

subroutine hujpic(kk, k, tin, vin, mater,&
                  yf, pc)
    implicit none
!  LOI DE HUJEUX: CALCUL DE LA PRESSION ISOTROPE CYCLIQUE
!  IN  KK       :  NUMERO D'ORDRE DU MECANISME (1 A 4)
!      K        :  MECANISME K = 8
!      TIN( )   :  CHAMPS DE CONTRAINTES
!      VIN      :  VARIABLES INTERNES ASSOCIEES
!      MATER    :  COEFFICIENT MATERIAU
!      YF       :  VECTEUR SOLUTION DU SYSTEME DE NEWTON LOCAL
!
!  OUT
!      PC     :  PRESSION ISOTROPE CYCLIQUE
!  -----------------------------------------------------------
    integer :: ndt, ndi, i, k, kk, nmod
    parameter     (nmod = 15)
!
    real(kind=8) :: vin(*), d, x4
    real(kind=8) :: tin(ndt), pc, d13, zero
    real(kind=8) :: epsvp, beta, pcref, pcr
    real(kind=8) :: i1, mater(22, 2), yf(nmod)
!
    common /tdim/ ndt  , ndi
!
    data   d13, zero /0.333333333334d0, 0.d0/
!
! ==================================================================
! --- VARIABLES INTERNES -------------------------------------------
! ==================================================================
!
    epsvp = yf(7)
    x4 = vin(21)
!
! ==================================================================
! --- CARACTERISTIQUES MATERIAU ------------------------------------
! ==================================================================
!
    beta = mater(2, 2)
    d = mater(3, 2)
    pcref = mater(7, 2)
    pcr = pcref*exp(-beta*epsvp)
!
! ======================================================================
! ----------------- CONSTRUCTION PRESSION ISOTROPE ---------------------
! ======================================================================
!
    i1 = zero
    do i = 1, ndi
        i1=i1+d13*tin(i)
    enddo
!
! ======================================================================
! ------------ CONSTRUCTION PRESSION ISOTROPE CYCLIQUE -----------------
! ======================================================================
!
    pc = abs(i1)+d*pcr*x4
!
end subroutine
