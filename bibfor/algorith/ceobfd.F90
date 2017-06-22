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

subroutine ceobfd(dm, epsm, lambda, mu, ecrod,&
                  fd)
! person_in_charge: ludovic.idoux at edf.fr
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/diago3.h"
    real(kind=8) :: epsm(6), dm, fd
    real(kind=8) :: lambda, mu, ecrod
! ----------------------------------------------------------------------
!     LOI DE COMPORTEMENT DU MODELE D'ENDOMMAGEMENT ANISOTROPE
!     ROUTINE DE CALCUL DE LA PARTIE POSITIVE DE LA
!     FORCE THERMODYNAMIQUE FD
!
!  IN DM     : ENDOMMAGEMENT DE COMPRESSION
!  IN EPSM   : TENSEUR DE DEFORMATION
!  IN LAMBDA : /
!  IN MU     : / COEFFICIENTS DE LAME
!  IN ECROD  : PARAMETRE DU MODELE
!
! OUT FD     : FORCE THERMODYNAMIQUE
! ----------------------------------------------------------------------
!
    integer :: i
!
    real(kind=8) :: eps(6), d
    real(kind=8) :: un, deux, treps, trem, dcoefd, ene
    real(kind=8) :: vecc(3, 3), valcc(3)
!
    un=1.d0
    deux=2.d0
!
    d=dm
    do 100 i = 1, 6
        eps(i)=epsm(i)
100  end do
!
    treps=eps(1)+eps(2)+eps(3)
    call diago3(eps, vecc, valcc)
    do 22 i = 1, 3
        if (valcc(i) .gt. 0.d0) then
            valcc(i)=0.d0
        endif
22  end do
!
    trem=valcc(1)**2+valcc(2)**2+valcc(3)**2
    if (treps .gt. 0.d0) then
        treps=0.d0
    endif
    dcoefd=deux*(un-d)
    ene=lambda/deux*treps**2+mu*trem
    fd=dcoefd*ene-deux*d*ecrod
!
! CALCUL DE LA PARTIE POSITIVE DE FD
! ON COMPARE A R8PREM() * ECROD (FICHE 16142)
    if (fd .lt. r8prem()*ecrod) then
        fd=0.d0
    endif
!
end subroutine
