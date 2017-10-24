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

subroutine lcgrad(resi, rigi, ndim, ndimsi, neps,&
                  sigma, apg, lag, grad, aldc,&
                  r, c, ktg, sig, dsidep)
    implicit none
!
#include "asterf_types.h"
#include "asterfort/r8inir.h"
    aster_logical :: resi, rigi
    integer :: ndim, ndimsi, neps
    real(kind=8) :: sigma(6), ktg(6, 6, 4), apg, lag, grad(ndim), aldc, r, c
    real(kind=8) :: sig(neps), dsidep(neps, neps)
! ----------------------------------------------------------------------
!  GRAD_VARI : CALCUL DES TERMES COMMUNS AU LAGRANGIEN AUGMENTE
! ----------------------------------------------------------------------
! IN  RESI   .TRUE. SI CALCUL DES CONTRAINTES
! IN  RIGI   .TRUE. SI CALCUL DE LA RIGIDITE
! IN  NDIM   DIMENSION DE L'ESPACE
! IN  NDIMSI DIMENSION DES DEFORMATIONS ET DES CONTRAINTES MECANIQUES
! IN  NEPS   DIMENSION DES DEFORMATIONS ET DES CONTRAINTES
! IN  SIGMA  CONTRAINTES MECANIQUES
! IN  APG    VARIABLE NON LOCALE NODALE INTERPOLEE AU POINT DE GAUSS
! IN  LAG    MULTIPLICATEUR DE LAGRANGE
! IN  GRAD   GRADIENT DE LA VARIABLE NON LOCALE
! IN  ALDC   VARIABLE NON LOCALE ISSUE DE LA LOI DE COMPORTEMENT
! IN  R      COEFFICIENT D'AUGMENTATION DU LAGRANGIEN AUGMENTE
! IN  C      COEFFICIENT DE PONDERATION DU TERME NON LOCAL
! IN  KTG    MATRICES TANGENTES PAR BOUT
!             KTG(6,6,1) DSIGMA/DEPS
!             KTG(6,1,2) DSIGMA/DPHI
!             KTG(6,1,3) DALDC/DEPS
!             KTG(1,1,4) DALDC/DPHI
! OUT SIG    CONTRAINTES GENERALISEES
! OUT DSIDEP MATRICE TANGENTE GENERALISEE
! ----------------------------------------------------------------------
    integer :: i, j
! ----------------------------------------------------------------------
!
!
! -- CALCUL DES CONTRAINTES GENERALISEES
!
    if (resi) then
        do 10 i = 1, ndimsi
            sig(i) = sigma(i)
 10     continue
        sig(ndimsi+1) = lag + r*(apg-aldc)
        sig(ndimsi+2) = apg-aldc
        do 20 i = 1, ndim
            sig(ndimsi+2+i) = c*grad(i)
 20     continue
    endif
!
!
! -- CALCUL DE LA MATRICE TANGENTE GENERALISEE
!
    if (rigi) then
! 	  write (6,*) 'lcgrad neps = ',neps

!         write (6,*) 'DIM     = ',ndim,ndimsi,neps
!         write (6,*) 'R,C     = ',r,c
!         write (6,*) 'DSIDEP1 = ',ktg(1:ndimsi,1:ndimsi,1)
!         write (6,*) 'DSIDEP2 = ',ktg(1:ndimsi,1,2)
!         write (6,*) 'DSIDEP3 = ',ktg(1:ndimsi,1,3)
!         write (6,*) 'DSIDEP4 = ',ktg(1,1,4)

        call r8inir(neps*neps, 0.d0, dsidep, 1)
!
!      SIG - EPS
        do 30 i = 1, ndimsi
            do 40 j = 1, ndimsi
                dsidep(i,j) = ktg(i,j,1)
 40         continue
 30     continue
!
!      SIG - A ET SIG - MU
        do 50 i = 1, ndimsi
            dsidep(i,ndimsi+1) = r*ktg(i,1,2)
            dsidep(i,ndimsi+2) = ktg(i,1,2)
 50     continue
!
!      SIGA - EPS ET SIGMU - EPS
        do 60 i = 1, ndimsi
            dsidep(ndimsi+1,i) = -r*ktg(i,1,3)
            dsidep(ndimsi+2,i) = -ktg(i,1,3)
 60     continue
!
!      SIGA - A
        dsidep(ndimsi+1,ndimsi+1) = (1-r*ktg(1,1,4))*r
!
!      SIGA - MU ET SIGMU - A
        dsidep(ndimsi+1,ndimsi+2) = 1-r*ktg(1,1,4)
        dsidep(ndimsi+2,ndimsi+1) = 1-r*ktg(1,1,4)
!
!      SIGMU - MU
        dsidep(ndimsi+2,ndimsi+2) = - ktg(1,1,4)
!
!      SIGG - GRAD
        do 70 i = 1, ndim
            dsidep(ndimsi+2+i,ndimsi+2+i) = c
 70     continue
!

! 	do i = 1,ndimsi+2
! 	do j = 1,ndimsi+2
! 	write (6,*) 'M[',i-1,',',j-1,'] = ',dsidep(i,j)
! 	end do
! 	end do

    endif
!
end subroutine
