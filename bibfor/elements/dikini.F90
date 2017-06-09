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

subroutine dikini(nbt, nu1, mu1, dxu1, dryu1,&
                  nu2, mu2, dxu2, dryu2, ky,&
                  kz, krx, krz, k01, k02,&
                  rbid)
! ----------------------------------------------------------------------
    implicit none
#include "asterfort/r8inir.h"
    integer :: nbt
    real(kind=8) :: nu1, mu1, dxu1, dryu1
    real(kind=8) :: nu2, mu2, dxu2, dryu2
    real(kind=8) :: ky, kz, krx, krz, rbid
    real(kind=8) :: k01(nbt), k02(nbt)
!
!     CALCUL DES MATRICES K01 ET K02 (MATRICES TANGENTES INITIALES
!     POUR LES MECANISMES 1 ET 2) DANS LE CAS D'UN COMPORTEMENT
!     DE TYPE "ASSE_CORN".
!
! ----------------------------------------------------------------------
!
! IN  : NBT   : NOMBRE DE VALEURS POUR LES DEMI-MATRICES
!       DXU$  : DEPLACEMENT ULTIME POUR LE MECANISME $ (1 OU 2)
!       DRYU$ : ROTATION ULTIME POUR LE MECANISME $
!       NU$   : EFFORT ULTIME POUR LE MECANISME $
!       MU$   : MOMENT ULTIME POUR LE MECANISME $
!       KY,KZ,KRX,KRZ : RAIDEURS POUR LES DIRECTIONS DE
!                       COMPORTEMENT LINEAIRE
!
! OUT : K01   : MATRICE TANGENTE INITIALE POUR LE MECANISME 1
!       K02   : MATRICE TANGENTE INITIALE POUR LE MECANISME 2
!
! ----------------------------------------------------------------------
! --- VALEUR SIMULANT UNE GRANDE PENTE INITIALE (R(P)/P)
!
!      RBID = 1.D4
!
! --- MISE A ZERO DE K01 ET K02
!
!-----------------------------------------------------------------------
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    zero = 0.d0
    call r8inir(nbt, zero, k01, 1)
    call r8inir(nbt, zero, k02, 1)
!
! --- AFFECTATION DES TERMES NON NULS DE K01
!
    k01(1) = rbid*nu1/dxu1
    k01(3) = ky
    k01(6) = kz
    k01(10) = krx
    k01(15) = rbid*mu1/dryu1
    k01(21) = krz
    k01(22) = -rbid*nu1/dxu1
    k01(30) = -ky
    k01(39) = -kz
    k01(49) = -krx
    k01(60) = -rbid*mu1/dryu1
    k01(72) = -krz
    k01(28) = rbid*nu1/dxu1
    k01(36) = ky
    k01(45) = kz
    k01(55) = krx
    k01(66) = rbid*mu1/dryu1
    k01(78) = krz
!
! --- AFFECTATION DES TERMES NON NULS DE K02
!
    k02(1) = rbid*nu2/dxu2
    k02(3) = ky
    k02(6) = kz
    k02(10) = krx
    k02(15) = rbid*mu2/dryu2
    k02(21) = krz
    k02(22) = -rbid*nu2/dxu2
    k02(30) = -ky
    k02(39) = -kz
    k02(49) = -krx
    k02(60) = -rbid*mu2/dryu2
    k02(72) = -krz
    k02(28) = rbid*nu2/dxu2
    k02(36) = ky
    k02(45) = kz
    k02(55) = krx
    k02(66) = rbid*mu2/dryu2
    k02(78) = krz
! ----------------------------------------------------------------------
!
end subroutine
