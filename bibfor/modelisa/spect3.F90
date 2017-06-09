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

function spect3(x, a, b, func, tol,&
                coeff, xlc, vitn, defm, rhoe,&
                nbp, im, jm)
    implicit none
!
!                                 A
! DESCRIPTION : CALCULE DINTG2 = S func(X,Y) DY   POUR DINTEG.
! -----------                     B
!
!               (S EST LE SYMBOLE DE L'INTEGRALE).
!
!               TOL DONNE LE SEUIL DE CONVERGENCE RELATIVE.
!
!               func EST LA FONCTION A INTEGRER.
!               ELLE DOIT ETRE DECLAREE EXTERNAL DANS L'APPELANT.
!               SA SPECIFICATION EST :
!                        DOUBLE PRECISION FUNCTION func ( X, Y )
!                        DOUBLE PRECISION X, Y
!
!               A ET B DONNENT LES BORNES DE L'INTEGRALE.
!               COEFF EST LE TABLEAU DES COEFFICIENTS FOURNI PAR DINTEG.
!
! *****************   DECLARATIONS DES VARIABLES   *********************
!
!
! ARGUMENTS
! ---------
! aslint: disable=W0307
#include "jeveux.h"
    integer :: nbp
    real(kind=8) :: x
    real(kind=8) :: a
    real(kind=8) :: b
    real(kind=8) :: tol
    real(kind=8) :: coeff(*)
    real(kind=8) :: xlc
    real(kind=8) :: vitn(nbp, *)
    real(kind=8) :: defm(nbp, *)
    real(kind=8) :: rhoe(nbp, *)
    integer :: im
    integer :: jm
    real(kind=8) :: spect3
    interface
        function func(xx, y, xlc, vitn, rhoe,&
                      defm, nbp, im, jm)
            integer :: nbp
            real(kind=8) :: xx
            real(kind=8) :: y
            real(kind=8) :: xlc
            real(kind=8) :: vitn(nbp, *)
            real(kind=8) :: rhoe(nbp, *)
            real(kind=8) :: defm(nbp, *)
            integer :: im
            integer :: jm
            real(kind=8) :: func
        end function func
    end interface
!
! VARIABLES LOCALES
! -----------------
    integer :: index, n1, n2, i, arret
    real(kind=8) :: res, ym, dy, y0, r1, som, y
    real(kind=8) :: w(127)
!
! *****************    DEBUT DU CODE EXECUTABLE    *********************
!
    res = 0.0d0
!
    if (abs(a-b) .lt. 1.0d-30) then
        spect3 = res
        goto 9999
    endif
!
    ym = ( a + b ) / 2.0d0
    dy = ( b - a ) / 2.0d0
    y0 = func(x, ym ,xlc, vitn, rhoe, defm, nbp, im, jm)
    r1 = (y0+y0) * dy
    index = 0
    n1 = 0
    n2 = 1
    som = 0.0d0
!
! --- REPETER ...
!
10  continue
    n1 = n1 + n2
    do 20 i = n2, n1
        index = index + 1
        y = coeff(index) * dy
        w(i) = func(x,ym+y,xlc,vitn,rhoe,defm,nbp,im,jm) + &
               func(x,ym-y,xlc, vitn,rhoe,defm,nbp,im,jm)
        index = index + 1
        som = som + coeff(index)*w(i)
20  end do
    n2 = n1 + 1
    index = index + 1
    res = ( som + coeff(index)*y0 ) * dy
!
! --- TEST DE CONVERGENCE.
!
    if (abs(res-r1) .le. abs(r1*tol)) then
        arret = 1
    else
        if (n1 .ge. 127) then
            arret = 1
        else
            arret = 0
            r1 = res
            som = 0.0d0
            do 22 i = 1, n1
                index = index + 1
                som = som + coeff(index)*w(i)
22          continue
        endif
    endif
!
! --- JUSQUE ARRET = 1.
!
    if (arret .eq. 0) goto 10
!
    spect3 = res
!
9999  continue
end function
