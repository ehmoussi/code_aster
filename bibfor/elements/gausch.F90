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

subroutine gausch(npgxyz, xpg, ypg, zpg, hpg)
!
!......................................................................C
!......................................................................C
!                                                                      C
! BUT: CALCUL DES POIDS ET POINTS DE GAUSS POUR DES POLYNOMES          C
!      NON HOMOGENE A TROIS VARIABLES                                  C
!                                                                      C
! ENTREES  ---> NPGXZ(I)    : NOMBRE DE POINTS DE GAUSS DANS           C
!                             LA DIRECTION "I"                         C
!                                                                      C
! SORTIES  <--- XPG,YPG,ZPG : COORDONNEES DES POINTS DE GAUSS          C
!          <--- HPG         : POIDS DES POINTS DE GAUSS                C
!                                                                      C
!......................................................................C
!......................................................................C
!
    implicit     none
    integer :: npgxyz(3)
    real(kind=8) :: xpg(1), ypg(1), zpg(1), hpg(1)
!----------------------------------------------------------------------
    integer :: npari, i, j, k, npi
    real(kind=8) :: a(4), h(4), coord(3, 4), hpgxyz(3, 4)
!----------------------------------------------------------------------
!
    do 10 i = 1, 3
!
        if (npgxyz(i) .eq. 2) then
!
            npari = 2
            a(1) = -1.d0/(sqrt(3.d0))
            a(2) = -a(1)
            h(1) = 1.d00
            h(2) = 1.d00
!
        else if (npgxyz(i).eq.3) then
!
            npari = 3
            a(1) = -sqrt(3.d0/5.d0)
            a(2) = 0.d00
            a(3) = -a(1)
            h(1) = 5.d0/9.d0
            h(2) = 8.d0/9.d0
            h(3) = h(1)
!
        else if (npgxyz(i).eq.4) then
!
            npari = 4
            a(1) = -sqrt((3.d0+2.d0*sqrt(6.d0/5.d0))/7.d0)
            a(2) = -sqrt((3.d0-2.d0*sqrt(6.d0/5.d0))/7.d0)
            a(3) = -a(2)
            a(4) = -a(1)
            h(1) = .5d0-1.d0/(6.d0*sqrt(6.d0/5.d0))
            h(2) = .5d0+1.d0/(6.d0*sqrt(6.d0/5.d0))
            h(3) = h(2)
            h(4) = h(1)
!
        endif
!
        do 20 j = 1, npari
            coord(i,j) = a(j)
            hpgxyz(i,j) = h(j)
20      continue
10  end do
    npi = 0
    do 30 i = 1, npgxyz(1)
        do 30 j = 1, npgxyz(2)
            do 30 k = 1, npgxyz(3)
                npi = npi + 1
                xpg( npi ) = coord(1,i)
                ypg( npi ) = coord(2,j)
                zpg( npi ) = coord(3,k)
                hpg( npi ) = hpgxyz(1,i)*hpgxyz(2,j)*hpgxyz(3,k)
30          continue
!
!------------------------------------------------------------
end subroutine
