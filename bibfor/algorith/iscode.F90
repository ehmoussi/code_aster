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

subroutine iscode(idec, icod, ndim)
!    P. RICHARD     DATE 18/02/90
!-----------------------------------------------------------------------
!  BUT: CODER UN ENTIER CODE SUR LES 30 PREMIERES PUISSANCES
!          DE DEUX ( PAS DE PUISSANCE 0)
    implicit none
!-----------------------------------------------------------------------
!
!  IDEC     /I/: VECTEUR DES NDIM PREMIERES CMPS
!  ICOD(*)  /O/: ENTIER CODE :
!                ICOD(1) : 30 1ERES CMPS CODE SUR LES PUISS DE 2:1 A 30
!                ICOD(2) : 30 CMPS SUIV CODE SUR LES PUISS DE 2:1 A 30
!                ...
!  NDIM     /I/: NOMBRE DE CMPS A DECODER
!
!-----------------------------------------------------------------------
!
    integer :: ndim, necmax
    integer :: idec(ndim), icod(*)
    integer :: nec, iec, i, ipui, k
    parameter (necmax = 10)
    integer :: ifin(necmax)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
! --- IFIN DONNE POUR CHAQUE ENTIER CODE LE NOMBRE MAX DE CMPS
! --- QUE L'ON PEUT TROUVER SUR CET ENTIER :
!     ------------------------------------
    nec = (ndim-1)/30 + 1
    do 10 iec = 1, nec
        icod(iec)=0
        ifin(iec)=30
10  end do
    ifin(nec)=ndim - 30*(nec-1)
!
    k = 0
    do 20 iec = 1, nec
        ipui = 1
        do 30 i = 1, ifin(iec)
            k = k+1
            ipui = ipui*2
            icod(iec)=icod(iec)+idec(k)*ipui
30      continue
20  end do
!
end subroutine
