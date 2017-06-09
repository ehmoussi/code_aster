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

subroutine fpouli(nx, l1, l2, norml1, norml2,&
                  vecter)
! ......................................................................
!    - FONCTION REALISEE:  CALCUL FORCES INTERNES MEPOULI
    implicit none
!                          OPTION : 'FULL_MECA        '
!                          OPTION : 'RAPH_MECA        '
!
!    - ARGUMENTS:
!        DONNEES:
!
! ......................................................................
!
    real(kind=8) :: nx, l1(3), l2(3)
    real(kind=8) :: norml1, norml2, coef1, coef2
    real(kind=8) :: vecter(*)
    integer :: i, ivec
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    coef1 = nx / norml1
    coef2 = nx / norml2
    ivec = 0
!
!*** LIGNES 1, 2, 3
!
    do 11 i = 1, 3
        ivec = ivec + 1
        vecter(ivec) = coef1 * l1(i)
11  end do
!
!*** LIGNES 4, 5, 6
!
    do 21 i = 1, 3
        ivec = ivec + 1
        vecter(ivec) = coef2 * l2(i)
21  end do
!
!*** LIGNES 7, 8, 9
!
    do 31 i = 1, 3
        ivec = ivec + 1
        vecter(ivec) = -vecter(i) - vecter(i+3)
31  end do
!
end subroutine
