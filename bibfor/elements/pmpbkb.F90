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

subroutine pmpbkb(skp, nbpout, yi, zi, sk)
    implicit none
!    -------------------------------------------------------------------
!     CALCUL DE LA MATRICE DE RIGIDE POUR ELEMENTS MYULTIPOUTRES
!
!    * REMARQUE :
!      La matrice a ete determinee a l'aide de calculs symboliques.
!    -------------------------------------------------------------------

!   IN
!       skp(78,*) : tableau des matrices de rigidite des sous-poutres
!       nbpout    : nombre d assemblages de fibres
!       yi(*)     : position Y des sous-poutres
!       zi(*)     : position Z des sous-poutres
!
!   OUT
!       sk(78)       : matrice de rigidite


    integer :: ip(12), i, nbpout
    real(kind=8) :: sk(78), skp(78,*), yi(nbpout), zi(nbpout)

    data ip/0,1,3,6,10,15,21,28,36,45,55,66/

    do i =1 , nbpout
 
sk(ip(1)+1) = sk(ip(1)+1) + skp(ip(1)+ 1, i)
sk(ip(2)+1) = sk(ip(2)+1) + skp(ip(2)+ 1,i)
sk(ip(2)+2) = sk(ip(2)+2) + skp(ip(2)+ 2,i)
sk(ip(3)+1) = sk(ip(3)+1) + skp(ip(3)+ 1,i)
sk(ip(3)+2) = sk(ip(3)+2) + skp(ip(3)+ 2,i)
sk(ip(3)+3) = sk(ip(3)+3) + skp(ip(3)+ 3,i)
sk(ip(4)+1) = sk(ip(4)+1) + yi(i) *skp(ip(3)+ 1,i) - zi(i) *skp(ip(2)+ 1,i)
sk(ip(4)+2) = sk(ip(4)+2) + yi(i) *skp(ip(3)+ 2,i) - zi(i) *skp(ip(2)+ 2,i)
sk(ip(4)+3) = sk(ip(4)+3) + yi(i) *skp(ip(3)+ 3,i) - zi(i) *skp(ip(3)+ 2,i)
sk(ip(4)+4) = sk(ip(4)+4) + yi(i) *(yi(i) *skp(ip(3)+ 3,i) - zi(i) *skp(ip(3)+ 2,i)) - &
                            zi(i) *(yi(i) *skp(ip(3)+ 2,i) - &
                            zi(i) *skp(ip(2)+ 2,i)) + skp(ip(4)+ 4,i)
sk(ip(5)+1) = sk(ip(5)+1) + zi(i) *skp(ip(1)+ 1,i) + skp(ip(5)+ 1,i)
sk(ip(5)+2) = sk(ip(5)+2) + zi(i) *skp(ip(2)+ 1,i) + skp(ip(5)+ 2,i)
sk(ip(5)+3) = sk(ip(5)+3) + zi(i) *skp(ip(3)+ 1,i) + skp(ip(5)+ 3,i)
sk(ip(5)+4) = sk(ip(5)+4) + yi(i) *skp(ip(5)+ 3,i) + zi(i) *(yi(i) *skp(ip(3)+ 1,i) - &
                            zi(i) *skp(ip(2)+ 1,i)) - zi(i) *skp(ip(5)+ 2,i)
sk(ip(5)+5) = sk(ip(5)+5) + zi(i) *(zi(i) *skp(ip(1)+ 1,i) + skp(ip(5)+ 1,i)) + &
                            zi(i) *skp(ip(5)+ 1,i) + skp(ip(5)+ 5,i)
sk(ip(6)+1) = sk(ip(6)+1) - yi(i) *skp(ip(1)+ 1,i) + skp(ip(6)+ 1,i)
sk(ip(6)+2) = sk(ip(6)+2) - yi(i) *skp(ip(2)+ 1,i) + skp(ip(6)+ 2,i)
sk(ip(6)+3) = sk(ip(6)+3) - yi(i) *skp(ip(3)+ 1,i) + skp(ip(6)+ 3,i)
sk(ip(6)+4) = sk(ip(6)+4) - yi(i) *(yi(i) *skp(ip(3)+ 1,i) - zi(i) *skp(ip(2)+ 1,i)) + &
                            yi(i) *skp(ip(6)+ 3,i) - zi(i) *skp(ip(6)+ 2,i)
sk(ip(6)+5) = sk(ip(6)+5) - yi(i) *(zi(i) *skp(ip(1)+ 1,i) + skp(ip(5)+ 1,i)) + &
                            zi(i) *skp(ip(6)+ 1,i) + skp(ip(6)+ 5,i)
sk(ip(6)+6) = sk(ip(6)+6) - yi(i) *(-yi(i) *skp(ip(1)+ 1,i) + skp(ip(6)+ 1,i)) - &
                            yi(i) *skp(ip(6)+ 1,i) + skp(ip(6)+ 6,i)
sk(ip(7)+1) = sk(ip(7)+1) + skp(ip(7)+ 1,i)
sk(ip(7)+2) = sk(ip(7)+2) + skp(ip(7)+ 2,i)
sk(ip(7)+3) = sk(ip(7)+3) + skp(ip(7)+ 3,i)
sk(ip(7)+4) = sk(ip(7)+4) + yi(i) *skp(ip(7)+ 3,i) - zi(i) *skp(ip(7)+ 2,i)
sk(ip(7)+5) = sk(ip(7)+5) + zi(i) *skp(ip(7)+ 1,i) + skp(ip(7)+ 5,i)
sk(ip(7)+6) = sk(ip(7)+6) - yi(i) *skp(ip(7)+ 1,i) + skp(ip(7)+ 6,i)
sk(ip(7)+7) = sk(ip(7)+7) + skp(ip(7)+ 7,i)
sk(ip(8)+1) = sk(ip(8)+1) + skp(ip(8)+ 1,i)
sk(ip(8)+2) = sk(ip(8)+2) + skp(ip(8)+ 2,i)
sk(ip(8)+3) = sk(ip(8)+3) + skp(ip(8)+ 3,i)
sk(ip(8)+4) = sk(ip(8)+4) + yi(i) *skp(ip(8)+ 3,i) - zi(i) *skp(ip(8)+ 2,i)
sk(ip(8)+5) = sk(ip(8)+5) + zi(i) *skp(ip(8)+ 1,i) + skp(ip(8)+ 5,i)
sk(ip(8)+6) = sk(ip(8)+6) - yi(i) *skp(ip(8)+ 1,i) + skp(ip(8)+ 6,i)
sk(ip(8)+7) = sk(ip(8)+7) + skp(ip(8)+ 7,i)
sk(ip(8)+8) = sk(ip(8)+8) + skp(ip(8)+ 8,i)
sk(ip(9)+1) = sk(ip(9)+1) + skp(ip(9)+ 1,i)
sk(ip(9)+2) = sk(ip(9)+2) + skp(ip(9)+ 2,i)
sk(ip(9)+3) = sk(ip(9)+3) + skp(ip(9)+ 3,i)
sk(ip(9)+4) = sk(ip(9)+4) + yi(i) *skp(ip(9)+ 3,i) - zi(i) *skp(ip(9)+ 2,i)
sk(ip(9)+5) = sk(ip(9)+5) + zi(i) *skp(ip(9)+ 1,i) + skp(ip(9)+ 5,i)
sk(ip(9)+6) = sk(ip(9)+6) - yi(i) *skp(ip(9)+ 1,i) + skp(ip(9)+ 6,i)
sk(ip(9)+7) = sk(ip(9)+7) + skp(ip(9)+ 7,i)
sk(ip(9)+8) = sk(ip(9)+8) + skp(ip(9)+ 8,i)
sk(ip(9)+9) = sk(ip(9)+9) + skp(ip(9)+ 9,i)
sk(ip(10)+1) = sk(ip(10)+1) + yi(i) *skp(ip(9)+ 1,i) - zi(i) *skp(ip(8)+ 1,i)
sk(ip(10)+2) = sk(ip(10)+2) + yi(i) *skp(ip(9)+ 2,i) - zi(i) *skp(ip(8)+ 2,i)
sk(ip(10)+3) = sk(ip(10)+3) + yi(i) *skp(ip(9)+ 3,i) - zi(i) *skp(ip(8)+ 3,i)
sk(ip(10)+4) = sk(ip(10)+4) + yi(i) *(yi(i) *skp(ip(9)+ 3,i) - zi(i) *skp(ip(9)+ 2,i)) - &
                              zi(i) *(yi(i) *skp(ip(8)+ 3,i) - &
                              zi(i) *skp(ip(8)+ 2,i)) + skp(ip(10)+ 4,i)
sk(ip(10)+5) = sk(ip(10)+5) + yi(i) *(zi(i) *skp(ip(9)+ 1,i) + skp(ip(9)+ 5,i)) - &
                              zi(i) *(zi(i) *skp(ip(8)+ 1,i) + skp(ip(8)+ 5,i))
sk(ip(10)+6) = sk(ip(10)+6) + yi(i) *(-yi(i) *skp(ip(9)+ 1,i) + skp(ip(9)+ 6,i)) - &
                              zi(i) *(-yi(i) *skp(ip(8)+ 1,i) + skp(ip(8)+ 6,i))
sk(ip(10)+7) = sk(ip(10)+7) + yi(i) *skp(ip(9)+ 7,i) - zi(i) *skp(ip(8)+ 7,i)
sk(ip(10)+8) = sk(ip(10)+8) + yi(i) *skp(ip(9)+ 8,i) - zi(i) *skp(ip(8)+ 8,i)
sk(ip(10)+9) = sk(ip(10)+9) + yi(i) *skp(ip(9)+ 9,i) - zi(i) *skp(ip(9)+ 8,i)
sk(ip(10)+10) = sk(ip(10)+10) + yi(i) *(yi(i) *skp(ip(9)+ 9,i) - zi(i) *skp(ip(9)+ 8,i)) - &
                                zi(i) *(yi(i) *skp(ip(9)+ 8,i) - zi(i) *skp(ip(8)+ 8,i)) + &
                skp(ip(10)+ 10,i)

sk(ip(11)+1) = sk(ip(11)+1) + zi(i) *skp(ip(7)+ 1,i) + skp(ip(11)+ 1,i)
sk(ip(11)+2) = sk(ip(11)+2) + zi(i) *skp(ip(7)+ 2,i) + skp(ip(11)+ 2,i)
sk(ip(11)+3) = sk(ip(11)+3) + zi(i) *skp(ip(7)+ 3,i) + skp(ip(11)+ 3,i)
sk(ip(11)+4) = sk(ip(11)+4) + yi(i) *skp(ip(11)+ 3,i) + zi(i) *(yi(i) *skp(ip(7)+ 3,i) - &
                              zi(i) *skp(ip(7)+ 2,i)) - zi(i) *skp(ip(11)+ 2,i)
sk(ip(11)+5) = sk(ip(11)+5) + zi(i) *(zi(i) *skp(ip(7)+ 1,i) + skp(ip(7)+ 5,i)) + &
                              zi(i) *skp(ip(11)+ 1,i) + skp(ip(11)+ 5,i)
sk(ip(11)+6) = sk(ip(11)+6) - yi(i) *skp(ip(11)+ 1,i) + zi(i) *(-yi(i) *skp(ip(7)+ 1,i) + &
               skp(ip(7)+ 6,i)) + skp(ip(11)+ 6,i)
sk(ip(11)+7) = sk(ip(11)+7) + zi(i) *skp(ip(7)+ 7,i) + skp(ip(11)+ 7,i)
sk(ip(11)+8) = sk(ip(11)+8) + zi(i) *skp(ip(8)+ 7,i) + skp(ip(11)+ 8,i)
sk(ip(11)+9) = sk(ip(11)+9) + zi(i) *skp(ip(9)+ 7,i) + skp(ip(11)+ 9,i)
sk(ip(11)+10) = sk(ip(11)+10) + yi(i) *skp(ip(11)+ 9,i) + zi(i) *(yi(i) *skp(ip(9)+ 7,i) - &
                                zi(i) *skp(ip(8)+ 7,i)) - zi(i) *skp(ip(11)+ 8,i)
sk(ip(11)+11) = sk(ip(11)+11) + zi(i) *(zi(i) *skp(ip(7)+ 7,i) + skp(ip(11)+ 7,i)) + &
                                zi(i) *skp(ip(11)+ 7,i) + skp(ip(11)+ 11,i)
sk(ip(12)+1) = sk(ip(12)+1) - yi(i) *skp(ip(7)+ 1,i) + skp(ip(12)+ 1,i)
sk(ip(12)+2) = sk(ip(12)+2) - yi(i) *skp(ip(7)+ 2,i) + skp(ip(12)+ 2,i)
sk(ip(12)+3) = sk(ip(12)+3) - yi(i) *skp(ip(7)+ 3,i) + skp(ip(12)+ 3,i)
sk(ip(12)+4) = sk(ip(12)+4) - yi(i) *(yi(i) *skp(ip(7)+ 3,i) - zi(i) *skp(ip(7)+ 2,i)) + &
                              yi(i) *skp(ip(12)+ 3,i) - zi(i) *skp(ip(12)+ 2,i)
sk(ip(12)+5) = sk(ip(12)+5) - yi(i) *(zi(i) *skp(ip(7)+ 1,i) + skp(ip(7)+ 5,i)) + &
                              zi(i) *skp(ip(12)+ 1,i) + skp(ip(12)+ 5,i)
sk(ip(12)+6) = sk(ip(12)+6) - yi(i) *(-yi(i) *skp(ip(7)+ 1,i) + skp(ip(7)+ 6,i)) - &
                              yi(i) *skp(ip(12)+ 1,i) + skp(ip(12)+ 6,i)
sk(ip(12)+7) = sk(ip(12)+7) - yi(i) *skp(ip(7)+ 7,i) + skp(ip(12)+ 7,i)
sk(ip(12)+8) = sk(ip(12)+8) - yi(i) *skp(ip(8)+ 7,i) + skp(ip(12)+ 8,i)
sk(ip(12)+9) = sk(ip(12)+9) - yi(i) *skp(ip(9)+ 7,i) + skp(ip(12)+ 9,i)
sk(ip(12)+10) = sk(ip(12)+10) - yi(i) *(yi(i) *skp(ip(9)+ 7,i) - zi(i) *skp(ip(8)+ 7,i)) + &
                                yi(i) *skp(ip(12)+ 9,i) - zi(i) *skp(ip(12)+ 8,i)
sk(ip(12)+11) = sk(ip(12)+11) - yi(i) *(zi(i) *skp(ip(7)+ 7,i) + skp(ip(11)+ 7,i)) + &
                                zi(i) *skp(ip(12)+ 7,i) + skp(ip(12)+ 11,i)

sk(ip(12)+12) = sk(ip(12)+12) - yi(i) *(-yi(i) *skp(ip(7)+ 7,i) + skp(ip(12)+ 7,i)) - &
                                yi(i) *skp(ip(12)+ 7,i) + skp(ip(12)+ 12,i)

    enddo
end subroutine
