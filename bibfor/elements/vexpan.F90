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

subroutine vexpan(nb1, vecl1, vecl)
    implicit none
    integer :: nb1, kompt
    real(kind=8) :: vecl1(42), vecl(48)
!
!     EXPANSION DU VECTEUR VECL1 : DUE A L'AJOUT DE LA ROTATION FICTIVE
!
!-----------------------------------------------------------------------
    integer :: i, i1, i2, ib
!-----------------------------------------------------------------------
    kompt=-1
    do 60 ib = 1, nb1
        kompt=kompt+1
        do 70 i = 1, 5
            i1=5*(ib-1)+i
            i2=i1+kompt
            vecl(i2)=vecl1(i1)
70      end do
        vecl(6*ib)=0.d0
60  end do
end subroutine
