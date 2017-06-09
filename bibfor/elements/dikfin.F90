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

subroutine dikfin(nbt, dnsdu, dnsdt, dmsdt, dnsdu2,&
                  dnsdt2, dmsdt2, ky, kz, krx,&
                  krz, klv, klv2)
! ----------------------------------------------------------------------
    implicit none
#include "asterfort/r8inir.h"
    integer :: nbt
    real(kind=8) :: dnsdu, dnsdt, dmsdt, dnsdu2, dnsdt2, dmsdt2, ky, kz, krx
    real(kind=8) :: krz
    real(kind=8) :: klv(nbt), klv2(nbt)
!
!     CALCUL DES MATRICES KLV ET KLV2 (MATRICES TANGENTE ET SECANTE)
!     POUR LES ELEMENTS DE TYPE CORNIERE.
!
! ----------------------------------------------------------------------
!
! IN  : NBT    : NOMBRE DE VALEURS POUR LES DEMI-MATRICES
!       DNSDU  :
!       DMSDT  :
!       DNSDT  :
!       DNSDU2 :
!       DMSDT2 :
!       DNSDT2 :
!       KY,KZ,KRX,KRZ : RAIDEURS POUR LES DIRECTIONS DE
!                       COMPORTEMENT LINEAIRE
!
! OUT : KLV    :
!       KLV2   :
!
! ----------------------------------------------------------------------
! --- MISE A ZERO DE KLV ET KLV2
!
!-----------------------------------------------------------------------
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    zero = 0.d0
    call r8inir(nbt, zero, klv, 1)
    call r8inir(nbt, zero, klv2, 1)
!
! --- AFFECTATION DES TERMES NON NULS DE KLV
!
    klv(1) = dnsdu
    klv(11) = dnsdt
    klv(3) = ky
    klv(6) = kz
    klv(10) = krx
    klv(15) = dmsdt
    klv(21) = krz
    klv(22) = -dnsdu
    klv(56) = -dnsdt
    klv(26) = -dnsdt
    klv(30) = -ky
    klv(39) = -kz
    klv(49) = -krx
    klv(60) = -dmsdt
    klv(72) = -krz
    klv(28) = dnsdu
    klv(62) = dnsdt
    klv(36) = ky
    klv(45) = kz
    klv(55) = krx
    klv(66) = dmsdt
    klv(78) = krz
!
! --- AFFECTATION DES TERMES NON NULS DE KLV2
!
    klv2(1) = dnsdu2
    klv2(11) = dnsdt2
    klv2(3) = ky
    klv2(6) = kz
    klv2(10) = krx
    klv2(15) = dmsdt2
    klv2(21) = krz
    klv2(22) = -dnsdu2
    klv2(56) = -dnsdt2
    klv2(26) = -dnsdt2
    klv2(30) = -ky
    klv2(39) = -kz
    klv2(49) = -krx
    klv2(60) = -dmsdt2
    klv2(72) = -krz
    klv2(28) = dnsdu2
    klv2(62) = dnsdt2
    klv2(36) = ky
    klv2(45) = kz
    klv2(55) = krx
    klv2(66) = dmsdt2
    klv2(78) = krz
! ----------------------------------------------------------------------
!
end subroutine
