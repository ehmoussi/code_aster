! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine elrfd2(elrefz, x, dimd, dff2, nno, ndim)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elrfno.h"
!
    character(len=*), intent(in) :: elrefz
    integer, intent(in)          :: dimd
    real(kind=8), intent(in)     :: x(*)
    integer, intent(out)         :: nno, ndim
    real(kind=8), intent(out)    :: dff2(3, 3, *)
!
! --------------------------------------------------------------------------------------------------
!
!
! BUT:   CALCUL DES DERIVEES 2EMES DES FONCTIONS DE FORME
!        AU POINT DE COORDONNEES X
!
! --------------------------------------------------------------------------------------------------
!   IN   ELREFZ : NOM DE L'ELREFE (K8)
!        X      : COORDONNEES DU POINT DE CALCUL : X(IDIM)
!        DIMD   : DIMENSION DE DFF2
!   OUT  DFF2   : DERIVEES 2EMES DES FONCTIONS DE FORME :
!                 DFF2(IDIM,JDIM,INO)
!        NNO    : NOMBRE DE NOEUDS
!        NDIM   : DIMENSION DE L'ESPACE DE L'ELREFE : 1,2 OU 3
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: x1, x2, x3, x4, d1, d2, d3, d4, x0, y0
    real(kind=8), parameter :: zero = 0.d0, un = 1.d0, deux = 2.d0, trois = 3.0d0, quatre = 4.d0
    real(kind=8), parameter :: six = 6.0d0, sept = 7.0d0, huit = 8.0d0
    real(kind=8), parameter :: undemi = 0.5d0, uns4 = 0.25d0
!
    call elrfno(elrefz, nno, ndim=ndim)
    ASSERT(dimd.ge. (nno*ndim*ndim))
!
!     -- POUR LES ELEMENTS LINEAIRES : C'EST FACILE : 0.
!     ------------------------------------------------------------------
   select case(elrefz)
        case('SE2')
            dff2(1:ndim,1:ndim,1:nno) = 0.d0
        case('TR3')
            dff2(1:ndim,1:ndim,1:nno) = 0.d0
        case('TE4')
            dff2(1:ndim,1:ndim,1:nno) = 0.d0
        case('TR6')
            dff2(1,1,1) = quatre
            dff2(2,1,1) = quatre
            dff2(1,2,1) = quatre
            dff2(2,2,1) = quatre
!
            dff2(1,1,2) = quatre
            dff2(2,1,2) = zero
            dff2(1,2,2) = zero
            dff2(2,2,2) = zero
!
            dff2(1,1,3) = zero
            dff2(2,1,3) = zero
            dff2(1,2,3) = zero
            dff2(2,2,3) = quatre
!
            dff2(1,1,4) = -huit
            dff2(2,1,4) = -quatre
            dff2(1,2,4) = -quatre
            dff2(2,2,4) = zero
!
            dff2(1,1,5) = zero
            dff2(2,1,5) = quatre
            dff2(1,2,5) = quatre
            dff2(2,2,5) = zero
!
            dff2(1,1,6) = zero
            dff2(2,1,6) = -quatre
            dff2(1,2,6) = -quatre
            dff2(2,2,6) = -huit
!
        case('TR7')
            x0 = x(1)
            y0 = x(2)
!
            dff2(1,1,1) = quatre - six * y0
            dff2(2,1,1) = sept - six * ( x0 + y0 )
            dff2(1,2,1) = sept - six * ( x0 + y0 )
            dff2(2,2,1) = quatre - six * x0
!
            dff2(1,1,2) = quatre - six * y0
            dff2(2,1,2) = trois - six * ( x0 + y0 )
            dff2(1,2,2) = trois - six * ( x0 + y0 )
            dff2(2,2,2) = - six * x0
!
            dff2(1,1,3) = - six * y0
            dff2(2,1,3) = trois - six * ( x0 + y0 )
            dff2(1,2,3) = trois - six * ( x0 + y0 )
            dff2(2,2,3) = quatre - six * x0
!
            dff2(1,1,4) = huit * ( -un + trois * y0 )
            dff2(2,1,4) = quatre * ( -quatre + six * ( x0 + y0 ))
            dff2(1,2,4) = quatre * ( -quatre + six * ( x0 + y0 ))
            dff2(2,2,4) = 24.0d0 * x0
!
            dff2(1,1,5) = 24.0d0 * y0
            dff2(2,1,5) = quatre * ( -deux + six * ( x0 + y0 ))
            dff2(1,2,5) = quatre * ( -deux + six * ( x0 + y0 ))
            dff2(2,2,5) = 24.0d0 * x0
!
            dff2(1,1,6) = 24.0d0 * y0
            dff2(2,1,6) = quatre * ( -quatre + six * ( x0 + y0 ))
            dff2(1,2,6) = quatre * ( -quatre + six * ( x0 + y0 ))
            dff2(2,2,6) = huit * ( -un + trois * x0 )
!
            dff2(1,1,7) = -54.0d0 * y0
            dff2(2,1,7) = 27.0d0 * ( un - deux * ( x0 + y0 ))
            dff2(1,2,7) = 27.0d0 * ( un - deux * ( x0 + y0 ))
            dff2(2,2,7) = -54.0d0 * x0
!
!         ------------------------------------------------------------------
        case('QU4')
            x0 = x(1)
            y0 = x(2)
!
            dff2(1,1,1) = zero
            dff2(2,1,1) = uns4
            dff2(1,2,1) = uns4
            dff2(2,2,1) = zero
!
            dff2(1,1,2) = zero
            dff2(2,1,2) = -uns4
            dff2(1,2,2) = -uns4
            dff2(2,2,2) = zero
!
            dff2(1,1,3) = zero
            dff2(2,1,3) = uns4
            dff2(1,2,3) = uns4
            dff2(2,2,3) = zero
!
            dff2(1,1,4) = zero
            dff2(2,1,4) = -uns4
            dff2(1,2,4) = -uns4
            dff2(2,2,4) = zero
!
        case('QU8')
            x0 = x(1)
            y0 = x(2)
!
            dff2(1,1,1) = (un - y0) * undemi
            dff2(2,1,1) = (un - deux*x0 - deux*y0) * uns4
            dff2(1,2,1) = (un - deux*x0 - deux*y0) * uns4
            dff2(2,2,1) = (un - x0) * undemi
!
            dff2(1,1,2) = (un - y0) * undemi
            dff2(2,1,2) = -(un + deux*x0 - deux*y0) * uns4
            dff2(1,2,2) = -(un + deux*x0 - deux*y0) * uns4
            dff2(2,2,2) = (un + x0) * undemi
!
            dff2(1,1,3) = (un + y0) * undemi
            dff2(2,1,3) = (un + deux*x0 + deux*y0) * uns4
            dff2(1,2,3) = (un + deux*x0 + deux*y0) * uns4
            dff2(2,2,3) = (un + x0) * undemi
!
            dff2(1,1,4) = (un + y0) * undemi
            dff2(2,1,4) = -(un - deux*x0 + deux*y0) * uns4
            dff2(1,2,4) = -(un - deux*x0 + deux*y0) * uns4
            dff2(2,2,4) = (un - x0) * undemi
!
            dff2(1,1,5) = -un + y0
            dff2(2,1,5) = x0
            dff2(1,2,5) = x0
            dff2(2,2,5) = zero
!
            dff2(1,1,6) = zero
            dff2(2,1,6) = -y0
            dff2(1,2,6) = -y0
            dff2(2,2,6) = -un - x0
!
            dff2(1,1,7) = -un - y0
            dff2(2,1,7) = -x0
            dff2(1,2,7) = -x0
            dff2(2,2,7) = zero
!
            dff2(1,1,8) = zero
            dff2(2,1,8) = y0
            dff2(1,2,8) = y0
            dff2(2,2,8) = -un + x0
!         ------------------------------------------------------------------
        case('QU9')
            x0 = x(1)
            y0 = x(2)
!
            dff2(1,1,1) = y0 * (y0 - un) * undemi
            dff2(2,1,1) = (x0 - undemi) * (y0 - undemi)
            dff2(1,2,1) = (x0 - undemi) * (y0 - undemi)
            dff2(2,2,1) = x0 * (x0 - un) * undemi
!
            dff2(1,1,2) = y0 * (y0 - un) * undemi
            dff2(2,1,2) = (x0 + undemi) * (y0 - undemi)
            dff2(1,2,2) = (x0 + undemi) * (y0 - undemi)
            dff2(2,2,2) = x0 * (x0 + un) * undemi
!
            dff2(1,1,3) = y0 * (y0 + un) * undemi
            dff2(2,1,3) = (x0 + undemi) * (y0 + undemi)
            dff2(1,2,3) = (x0 + undemi) * (y0 + undemi)
            dff2(2,2,3) = x0 * (x0 + un) * undemi
!
            dff2(1,1,4) = y0 * (y0 + un) * undemi
            dff2(2,1,4) = (x0 - undemi) * (y0 + undemi)
            dff2(1,2,4) = (x0 - undemi) * (y0 + undemi)
            dff2(2,2,4) = x0 * (x0 - un) * undemi
!
            dff2(1,1,5) = -y0 * (y0 - un)
            dff2(2,1,5) = -deux * x0 * (y0 - undemi)
            dff2(1,2,5) = -deux * x0 * (y0 - undemi)
            dff2(2,2,5) = -(x0 + un) * (x0 - un)
!
            dff2(1,1,6) = -(y0 + un) * (y0 - un)
            dff2(2,1,6) = -deux * y0 * (x0 + undemi)
            dff2(1,2,6) = -deux * y0 * (x0 + undemi)
            dff2(2,2,6) = -x0 * (x0 + un)
!
            dff2(1,1,7) = -y0 * (y0 + un)
            dff2(2,1,7) = -deux * x0 * (y0 + undemi)
            dff2(1,2,7) = -deux * x0 * (y0 + undemi)
            dff2(2,2,7) = -(x0 + un) * (x0 - un)
!
            dff2(1,1,8) = -(y0 + un) * (y0 - un)
            dff2(2,1,8) = -deux * y0 * (x0 - undemi)
            dff2(1,2,8) = -deux * y0 * (x0 - undemi)
            dff2(2,2,8) = -x0 * (x0 - un)
!
            dff2(1,1,9) = deux * (y0 + un) * (y0 - un)
            dff2(2,1,9) = quatre * x0 * y0
            dff2(1,2,9) = quatre * x0 * y0
            dff2(2,2,9) = deux * (x0 + un) * (x0 - un)
!         ------------------------------------------------------------------
        case('SE3')
!
            dff2(1,1,1) = un
            dff2(1,1,2) = un
            dff2(1,1,3) = -deux
!
!         ------------------------------------------------------------------
        case('SE4')
!
            x1 = -un
            x2 = un
            x3 = -un/3.d0
            x4 = un/3.d0
!
            d1 = (x1-x2)* (x1-x3)* (x1-x4)
            d2 = (x2-x3)* (x2-x4)* (x2-x1)
            d3 = (x3-x4)* (x3-x1)* (x3-x2)
            d4 = (x4-x1)* (x4-x2)* (x4-x3)
!
            dff2(1,1,1) = 2* ((x(1)-x2)+ (x(1)-x3)+ (x(1)-x4))/d1
            dff2(1,1,2) = 2* ((x(1)-x3)+ (x(1)-x4)+ (x(1)-x1))/d2
            dff2(1,1,3) = 2* ((x(1)-x4)+ (x(1)-x1)+ (x(1)-x2))/d3
            dff2(1,1,4) = 2* ((x(1)-x1)+ (x(1)-x2)+ (x(1)-x3))/d4
!
!         ------------------------------------------------------------------
!         -- POUR LES ELEREFE NON ENCORE RENSEIGNES, ON REND NDIM=NNO=0
        case default
            nno = 0
            ndim = 0
!
    end select
!
end subroutine
