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

subroutine sigvte(sigmtd, sigmt)
!
    implicit none
!
! ......................................................................
!     FONCTION  :  CALCUL DE   SIGMT  ( 3 , 3 ) TENSEUR 3D
!
!                  A PARTIR DE SIGMTD  ( 5 ) VECTEUR CONTRAINTES PLANES
!
! ......................................................................
!
    real(kind=8) :: sigmtd ( 5 )
!
    real(kind=8) :: sigmt ( 3 , 3 )
!
!
!
! DEB
!
!
!---- CONTRAINTES NORMALES
!
    sigmt ( 1 , 1 ) = sigmtd ( 1 )
    sigmt ( 2 , 2 ) = sigmtd ( 2 )
!
    sigmt ( 3 , 3 ) = 0.d0
!
!---- CISAILLEMENT
!
    sigmt ( 1 , 2 ) = sigmtd ( 3 )
    sigmt ( 1 , 3 ) = sigmtd ( 4 )
    sigmt ( 2 , 3 ) = sigmtd ( 5 )
!
!---- SYMETRISATION
!
    sigmt ( 2 , 1 ) = sigmt ( 1 , 2 )
    sigmt ( 3 , 1 ) = sigmt ( 1 , 3 )
    sigmt ( 3 , 2 ) = sigmt ( 2 , 3 )
!
! FIN
!
end subroutine
