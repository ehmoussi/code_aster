! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1501
!
subroutine elrfdf(elrefz, x, dimd, dff, nno, ndim)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elrfno.h"
!
character(len=*), intent(in) :: elrefz
integer, intent(in) :: dimd
real(kind=8), intent(in) :: x(*)
integer, intent(out) :: nno, ndim
real(kind=8), intent(out) :: dff(3, *)
!
! --------------------------------------------------------------------------------------------------
!
! BUT:   CALCUL DES FONCTIONS DE FORMES ET DE LEURS DERIVEES
!        AU POINT DE COORDONNEES XI,YI,ZI
!
! --------------------------------------------------------------------------------------------------
!   IN   ELREFZ : NOM DE L'elrefz (K8)
!        X      : POINT DE CALCUL DES F FORMES ET DERIVEES
!        DIMD   : DIMENSION DE DFF
!   OUT  DFF    : FONCTIONS DE FORMES EN XI,YI,ZI
!        NNO    : NOMBRE DE NOEUDS
!        NDIM : DIMENSION TOPOLOGIQUE DE L'elrefz
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: zero = 0.d0, un = 1.d0, deux = 2.d0, trois = 3.0d0, quatre = 4.d0
    real(kind=8), parameter :: huit = 8.0d0, undemi = 0.5d0, uns4 = 0.25d0, uns8 = 0.125d0
    real(kind=8) :: x0, y0, z0, al, x1, x2, x3, x4, d1, d2, d3, d4
    real(kind=8) :: pface1, pface2, pface3, pface4, z01, z02, z04
    real(kind=8) :: pmili1, pmili2, pmili3, pmili4
!
! -----  FONCTIONS FORMULES
#define al31(u)   0.5d0*(u)*(u-1.0d0)
#define al32(u)   (-(u+1.0d0)*(u-1.0d0))
#define al33(u)   0.5d0*(u)*(u+1.0d0)
#define dal31(u)   0.5d0*(2.0d0*(u)-1.0d0)
#define dal32(u)   (-2.0d0*(u))
#define dal33(u)   0.5d0*(2.0d0*(u)+1.0d0)
!
    call elrfno(elrefz, nno, ndim=ndim)
    ASSERT(dimd.ge.(nno*ndim))
!
    select case(elrefz)
        case('HE8')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
!
            dff(1,1) = - (un-y0)* (un-z0)*uns8
            dff(2,1) = - (un-x0)* (un-z0)*uns8
            dff(3,1) = - (un-x0)* (un-y0)*uns8
            dff(1,2) = (un-y0)* (un-z0)*uns8
            dff(2,2) = - (un+x0)* (un-z0)*uns8
            dff(3,2) = - (un+x0)* (un-y0)*uns8
            dff(1,3) = (un+y0)* (un-z0)*uns8
            dff(2,3) = (un+x0)* (un-z0)*uns8
            dff(3,3) = - (un+x0)* (un+y0)*uns8
            dff(1,4) = - (un+y0)* (un-z0)*uns8
            dff(2,4) = (un-x0)* (un-z0)*uns8
            dff(3,4) = - (un-x0)* (un+y0)*uns8
            dff(1,5) = - (un-y0)* (un+z0)*uns8
            dff(2,5) = - (un-x0)* (un+z0)*uns8
            dff(3,5) = (un-x0)* (un-y0)*uns8
            dff(1,6) = (un-y0)* (un+z0)*uns8
            dff(2,6) = - (un+x0)* (un+z0)*uns8
            dff(3,6) = (un+x0)* (un-y0)*uns8
            dff(1,7) = (un+y0)* (un+z0)*uns8
            dff(2,7) = (un+x0)* (un+z0)*uns8
            dff(3,7) = (un+x0)* (un+y0)*uns8
            dff(1,8) = - (un+y0)* (un+z0)*uns8
            dff(2,8) = (un-x0)* (un+z0)*uns8
            dff(3,8) = (un-x0)* (un+y0)*uns8
        case('H20')
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
!
            dff(1,1) = - (un-y0)* (un-z0)* (-deux*x0-y0-z0-un)*uns8
            dff(2,1) = - (un-x0)* (un-z0)* (-x0-deux*y0-z0-un)*uns8
            dff(3,1) = - (un-x0)* (un-y0)* (-x0-y0-deux*z0-un)*uns8
            dff(1,2) = (un-y0)* (un-z0)* (deux*x0-y0-z0-un)*uns8
            dff(2,2) = - (un+x0)* (un-z0)* (x0-deux*y0-z0-un)*uns8
            dff(3,2) = - (un+x0)* (un-y0)* (x0-y0-deux*z0-un)*uns8
            dff(1,3) = (un+y0)* (un-z0)* (deux*x0+y0-z0-un)*uns8
            dff(2,3) = (un+x0)* (un-z0)* (x0+deux*y0-z0-un)*uns8
            dff(3,3) = - (un+x0)* (un+y0)* (x0+y0-deux*z0-un)*uns8
            dff(1,4) = - (un+y0)* (un-z0)* (-deux*x0+y0-z0-un)*uns8
            dff(2,4) = (un-x0)* (un-z0)* (-x0+deux*y0-z0-un)*uns8
            dff(3,4) = - (un-x0)* (un+y0)* (-x0+y0-deux*z0-un)*uns8
            dff(1,5) = - (un-y0)* (un+z0)* (-deux*x0-y0+z0-un)*uns8
            dff(2,5) = - (un-x0)* (un+z0)* (-x0-deux*y0+z0-un)*uns8
            dff(3,5) = (un-x0)* (un-y0)* (-x0-y0+deux*z0-un)*uns8
            dff(1,6) = (un-y0)* (un+z0)* (deux*x0-y0+z0-un)*uns8
            dff(2,6) = - (un+x0)* (un+z0)* (x0-deux*y0+z0-un)*uns8
            dff(3,6) = (un+x0)* (un-y0)* (x0-y0+deux*z0-un)*uns8
            dff(1,7) = (un+y0)* (un+z0)* (deux*x0+y0+z0-un)*uns8
            dff(2,7) = (un+x0)* (un+z0)* (x0+deux*y0+z0-un)*uns8
            dff(3,7) = (un+x0)* (un+y0)* (x0+y0+deux*z0-un)*uns8
            dff(1,8) = - (un+y0)* (un+z0)* (-deux*x0+y0+z0-un)*uns8
            dff(2,8) = (un-x0)* (un+z0)* (-x0+deux*y0+z0-un)*uns8
            dff(3,8) = (un-x0)* (un+y0)* (-x0+y0+deux*z0-un)*uns8
            dff(1,9) = -deux*x0* (un-y0)* (un-z0)*uns4
            dff(2,9) = - (un-x0*x0)* (un-z0)*uns4
            dff(3,9) = - (un-x0*x0)* (un-y0)*uns4
            dff(1,10) = (un-y0*y0)* (un-z0)*uns4
            dff(2,10) = -deux*y0* (un+x0)* (un-z0)*uns4
            dff(3,10) = - (un+x0)* (un-y0*y0)*uns4
            dff(1,11) = -deux*x0* (un+y0)* (un-z0)*uns4
            dff(2,11) = (un-x0*x0)* (un-z0)*uns4
            dff(3,11) = - (un-x0*x0)* (un+y0)*uns4
            dff(1,12) = - (un-y0*y0)* (un-z0)*uns4
            dff(2,12) = -deux*y0* (un-x0)* (un-z0)*uns4
            dff(3,12) = - (un-x0)* (un-y0*y0)*uns4
            dff(1,13) = - (un-z0*z0)* (un-y0)*uns4
            dff(2,13) = - (un-x0)* (un-z0*z0)*uns4
            dff(3,13) = -deux*z0* (un-y0)* (un-x0)*uns4
            dff(1,14) = (un-z0*z0)* (un-y0)*uns4
            dff(2,14) = - (un+x0)* (un-z0*z0)*uns4
            dff(3,14) = -deux*z0* (un-y0)* (un+x0)*uns4
            dff(1,15) = (un-z0*z0)* (un+y0)*uns4
            dff(2,15) = (un+x0)* (un-z0*z0)*uns4
            dff(3,15) = -deux*z0* (un+y0)* (un+x0)*uns4
            dff(1,16) = - (un-z0*z0)* (un+y0)*uns4
            dff(2,16) = (un-x0)* (un-z0*z0)*uns4
            dff(3,16) = -deux*z0* (un+y0)* (un-x0)*uns4
            dff(1,17) = -deux*x0* (un-y0)* (un+z0)*uns4
            dff(2,17) = - (un-x0*x0)* (un+z0)*uns4
            dff(3,17) = (un-x0*x0)* (un-y0)*uns4
            dff(1,18) = (un-y0*y0)* (un+z0)*uns4
            dff(2,18) = -deux*y0* (un+x0)* (un+z0)*uns4
            dff(3,18) = (un+x0)* (un-y0*y0)*uns4
            dff(1,19) = -deux*x0* (un+y0)* (un+z0)*uns4
            dff(2,19) = (un-x0*x0)* (un+z0)*uns4
            dff(3,19) = (un-x0*x0)* (un+y0)*uns4
            dff(1,20) = - (un-y0*y0)* (un+z0)*uns4
            dff(2,20) = -deux*y0* (un-x0)* (un+z0)*uns4
            dff(3,20) = (un-x0)* (un-y0*y0)*uns4
!
!         ------------------------------------------------------------------
        case('H27')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
!
            dff(1,1) = dal31(x0)*al31(y0)*al31(z0)
            dff(2,1) = al31(x0)*dal31(y0)*al31(z0)
            dff(3,1) = al31(x0)*al31(y0)*dal31(z0)
            dff(1,2) = dal33(x0)*al31(y0)*al31(z0)
            dff(2,2) = al33(x0)*dal31(y0)*al31(z0)
            dff(3,2) = al33(x0)*al31(y0)*dal31(z0)
            dff(1,3) = dal33(x0)*al33(y0)*al31(z0)
            dff(2,3) = al33(x0)*dal33(y0)*al31(z0)
            dff(3,3) = al33(x0)*al33(y0)*dal31(z0)
            dff(1,4) = dal31(x0)*al33(y0)*al31(z0)
            dff(2,4) = al31(x0)*dal33(y0)*al31(z0)
            dff(3,4) = al31(x0)*al33(y0)*dal31(z0)
            dff(1,5) = dal31(x0)*al31(y0)*al33(z0)
            dff(2,5) = al31(x0)*dal31(y0)*al33(z0)
            dff(3,5) = al31(x0)*al31(y0)*dal33(z0)
            dff(1,6) = dal33(x0)*al31(y0)*al33(z0)
            dff(2,6) = al33(x0)*dal31(y0)*al33(z0)
            dff(3,6) = al33(x0)*al31(y0)*dal33(z0)
            dff(1,7) = dal33(x0)*al33(y0)*al33(z0)
            dff(2,7) = al33(x0)*dal33(y0)*al33(z0)
            dff(3,7) = al33(x0)*al33(y0)*dal33(z0)
            dff(1,8) = dal31(x0)*al33(y0)*al33(z0)
            dff(2,8) = al31(x0)*dal33(y0)*al33(z0)
            dff(3,8) = al31(x0)*al33(y0)*dal33(z0)
            dff(1,9) = dal32(x0)*al31(y0)*al31(z0)
            dff(2,9) = al32(x0)*dal31(y0)*al31(z0)
            dff(3,9) = al32(x0)*al31(y0)*dal31(z0)
            dff(1,10) = dal33(x0)*al32(y0)*al31(z0)
            dff(2,10) = al33(x0)*dal32(y0)*al31(z0)
            dff(3,10) = al33(x0)*al32(y0)*dal31(z0)
            dff(1,11) = dal32(x0)*al33(y0)*al31(z0)
            dff(2,11) = al32(x0)*dal33(y0)*al31(z0)
            dff(3,11) = al32(x0)*al33(y0)*dal31(z0)
            dff(1,12) = dal31(x0)*al32(y0)*al31(z0)
            dff(2,12) = al31(x0)*dal32(y0)*al31(z0)
            dff(3,12) = al31(x0)*al32(y0)*dal31(z0)
            dff(1,13) = dal31(x0)*al31(y0)*al32(z0)
            dff(2,13) = al31(x0)*dal31(y0)*al32(z0)
            dff(3,13) = al31(x0)*al31(y0)*dal32(z0)
            dff(1,14) = dal33(x0)*al31(y0)*al32(z0)
            dff(2,14) = al33(x0)*dal31(y0)*al32(z0)
            dff(3,14) = al33(x0)*al31(y0)*dal32(z0)
            dff(1,15) = dal33(x0)*al33(y0)*al32(z0)
            dff(2,15) = al33(x0)*dal33(y0)*al32(z0)
            dff(3,15) = al33(x0)*al33(y0)*dal32(z0)
            dff(1,16) = dal31(x0)*al33(y0)*al32(z0)
            dff(2,16) = al31(x0)*dal33(y0)*al32(z0)
            dff(3,16) = al31(x0)*al33(y0)*dal32(z0)
            dff(1,17) = dal32(x0)*al31(y0)*al33(z0)
            dff(2,17) = al32(x0)*dal31(y0)*al33(z0)
            dff(3,17) = al32(x0)*al31(y0)*dal33(z0)
            dff(1,18) = dal33(x0)*al32(y0)*al33(z0)
            dff(2,18) = al33(x0)*dal32(y0)*al33(z0)
            dff(3,18) = al33(x0)*al32(y0)*dal33(z0)
            dff(1,19) = dal32(x0)*al33(y0)*al33(z0)
            dff(2,19) = al32(x0)*dal33(y0)*al33(z0)
            dff(3,19) = al32(x0)*al33(y0)*dal33(z0)
            dff(1,20) = dal31(x0)*al32(y0)*al33(z0)
            dff(2,20) = al31(x0)*dal32(y0)*al33(z0)
            dff(3,20) = al31(x0)*al32(y0)*dal33(z0)
            dff(1,21) = dal32(x0)*al32(y0)*al31(z0)
            dff(2,21) = al32(x0)*dal32(y0)*al31(z0)
            dff(3,21) = al32(x0)*al32(y0)*dal31(z0)
            dff(1,22) = dal32(x0)*al31(y0)*al32(z0)
            dff(2,22) = al32(x0)*dal31(y0)*al32(z0)
            dff(3,22) = al32(x0)*al31(y0)*dal32(z0)
            dff(1,23) = dal33(x0)*al32(y0)*al32(z0)
            dff(2,23) = al33(x0)*dal32(y0)*al32(z0)
            dff(3,23) = al33(x0)*al32(y0)*dal32(z0)
            dff(1,24) = dal32(x0)*al33(y0)*al32(z0)
            dff(2,24) = al32(x0)*dal33(y0)*al32(z0)
            dff(3,24) = al32(x0)*al33(y0)*dal32(z0)
            dff(1,25) = dal31(x0)*al32(y0)*al32(z0)
            dff(2,25) = al31(x0)*dal32(y0)*al32(z0)
            dff(3,25) = al31(x0)*al32(y0)*dal32(z0)
            dff(1,26) = dal32(x0)*al32(y0)*al33(z0)
            dff(2,26) = al32(x0)*dal32(y0)*al33(z0)
            dff(3,26) = al32(x0)*al32(y0)*dal33(z0)
            dff(1,27) = dal32(x0)*al32(y0)*al32(z0)
            dff(2,27) = al32(x0)*dal32(y0)*al32(z0)
            dff(3,27) = al32(x0)*al32(y0)*dal32(z0)
!
!         ------------------------------------------------------------------
        case('PE6')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            al = (un-y0-z0)
!
            dff(1,1) = -y0*undemi
            dff(2,1) = (un-x0)*undemi
            dff(3,1) = zero
            dff(1,2) = -z0*undemi
            dff(2,2) = zero
            dff(3,2) = (un-x0)*undemi
            dff(1,3) = -al*undemi
            dff(2,3) = - (un-x0)*undemi
            dff(3,3) = - (un-x0)*undemi
            dff(1,4) = y0*undemi
            dff(2,4) = (un+x0)*undemi
            dff(3,4) = zero
            dff(1,5) = z0*undemi
            dff(2,5) = zero
            dff(3,5) = (un+x0)*undemi
            dff(1,6) = al*undemi
            dff(2,6) = - (un+x0)*undemi
            dff(3,6) = - (un+x0)*undemi
!
        case('P15')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            al = un - y0 - z0
!
            dff(1,1) = (-y0* (deux*y0-deux-x0)-y0* (un-x0))/deux
            dff(2,1) = (un-x0)* (quatre*y0-deux-x0)/deux
            dff(3,1) = zero
            dff(1,2) = -z0* (deux*z0-un-deux*x0)/deux
            dff(2,2) = zero
            dff(3,2) = (un-x0)* (quatre*z0-deux-x0)/deux
            dff(1,3) = al* (deux*x0+deux*y0+deux*z0-un)/deux
            dff(2,3) = (x0-un)* (-x0-quatre*y0-quatre*z0+deux)/deux
            dff(3,3) = (x0-un)* (-x0-quatre*y0-quatre*z0+deux)/deux
            dff(1,4) = y0* (deux*y0-un+deux*x0)/deux
            dff(2,4) = (un+x0)* (quatre*y0-deux+x0)/deux
            dff(3,4) = zero
            dff(1,5) = z0* (deux*z0-un+deux*x0)/deux
            dff(2,5) = zero
            dff(3,5) = (un+x0)* (quatre*z0-deux+x0)/deux
            dff(1,6) = al* (deux*x0-deux*y0-deux*z0+un)/deux
            dff(2,6) = (x0+un)* (-x0+quatre*y0+quatre*z0-deux)/deux
            dff(3,6) = (x0+un)* (-x0+quatre*y0+quatre*z0-deux)/deux
            dff(1,7) = -deux*y0*z0
            dff(2,7) = deux*z0* (un-x0)
            dff(3,7) = deux*y0* (un-x0)
            dff(1,8) = -deux*al*z0
            dff(2,8) = -deux*z0* (un-x0)
            dff(3,8) = (deux*al-deux*z0)* (un-x0)
            dff(1,9) = -deux*y0*al
            dff(2,9) = (deux*al-deux*y0)* (un-x0)
            dff(3,9) = -deux*y0* (un-x0)
            dff(1,10) = -deux*y0*x0
            dff(2,10) = (un-x0*x0)
            dff(3,10) = zero
            dff(1,11) = -deux*z0*x0
            dff(2,11) = zero
            dff(3,11) = (un-x0*x0)
            dff(1,12) = -deux*al*x0
            dff(2,12) = - (un-x0*x0)
            dff(3,12) = - (un-x0*x0)
            dff(1,13) = deux*y0*z0
            dff(2,13) = deux*z0* (un+x0)
            dff(3,13) = deux*y0* (un+x0)
            dff(1,14) = deux*al*z0
            dff(2,14) = -deux*z0* (un+x0)
            dff(3,14) = (deux*al-deux*z0)* (un+x0)
            dff(1,15) = deux*y0*al
            dff(2,15) = (deux*al-deux*y0)* (un+x0)
            dff(3,15) = -deux*y0* (un+x0)
!
!         ------------------------------------------------------------------
        case('P18')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
!
            dff(1,1) = y0*(deux*x0-un)*(deux*y0-un)/deux
            dff(2,1) = x0*(x0-un)*(quatre*y0-un)/deux
            dff(3,1) = zero
            dff(1,2) = z0*(deux*x0-un)*(deux*z0-un)/deux
            dff(2,2) = zero
            dff(3,2) = x0*(x0-un)*(quatre*z0-un)/deux
            dff(1,3) = (deux*x0-un)*(z0+y0-un)*(deux*z0+deux*y0-un)/deux
            dff(2,3) = x0*(x0-un)*(quatre*z0+quatre*y0-trois)/deux
            dff(3,3) = x0*(x0-un)*(quatre*z0+quatre*y0-trois)/deux
            dff(1,4) = y0*(deux*x0+un)*(deux*y0-un)/deux
            dff(2,4) = x0*(x0+un)*(quatre*y0-un)/deux
            dff(3,4) = zero
            dff(1,5) = z0*(deux*x0+un)*(deux*z0-un)/deux
            dff(2,5) = zero
            dff(3,5) = x0*(x0+un)*(quatre*z0-un)/deux
            dff(1,6) = (deux*x0+un)*(z0+y0-un)*(deux*z0+deux*y0-un)/deux
            dff(2,6) = x0*(x0+un)*(quatre*z0+quatre*y0-trois)/deux
            dff(3,6) = x0*(x0+un)*(quatre*z0+quatre*y0-trois)/deux
            dff(1,7) = deux*y0*z0*(deux*x0-un)
            dff(2,7) = deux*x0*z0*(x0-un)
            dff(3,7) = deux*x0*y0*(x0-un)
            dff(1,8) = -deux*z0*(deux*x0-un)*(z0+y0-un)
            dff(2,8) = -deux*x0*z0*(x0-un)
            dff(3,8) = -deux*x0*(x0-un)*(deux*z0+y0-un)
            dff(1,9) = -deux*y0*(deux*x0-un)*(z0+y0-un)
            dff(2,9) = -deux*x0*(x0-un)*(deux*y0+z0-un)
            dff(3,9) = -deux*x0*y0*(x0-un)
            dff(1,10) = -deux*x0*y0*(deux*y0-un)
            dff(2,10) = -(x0-un)*(x0+un)*(quatre*y0-un)
            dff(3,10) = zero
            dff(1,11) = -deux*x0*z0*(deux*z0-un)
            dff(2,11) = zero
            dff(3,11) = -(x0-un)*(x0+un)*(quatre*z0-un)
            dff(1,12) = -deux*x0*(z0+y0-un)*(deux*z0+deux*y0-un)
            dff(2,12) = -(x0-un)*(x0+un)*(quatre*z0+quatre*y0-trois)
            dff(3,12) = -(x0-un)*(x0+un)*(quatre*z0+quatre*y0-trois)
            dff(1,13) = deux*y0*z0*(deux*x0+un)
            dff(2,13) = deux*x0*z0*(x0+un)
            dff(3,13) = deux*x0*y0*(x0+un)
            dff(1,14) = -deux*z0*(deux*x0+un)*(z0+y0-un)
            dff(2,14) = -deux*x0*z0*(x0+un)
            dff(3,14) = -deux*x0*(x0+un)*(deux*z0+y0-un)
            dff(1,15) = -deux*y0*(deux*x0+un)*(z0+y0-un)
            dff(2,15) = -deux*x0*(x0+un)*(deux*y0+z0-un)
            dff(3,15) = -deux*x0*y0*(x0+un)
            dff(1,16) = -huit*x0*y0*z0
            dff(2,16) = -quatre*z0*(x0-un)*(x0+un)
            dff(3,16) = -quatre*y0*(x0-un)*(x0+un)
            dff(1,17) = huit*x0*z0*(z0+y0-un)
            dff(2,17) = quatre*z0*(x0-un)*(x0+un)
            dff(3,17) = quatre*(x0-un)*(x0+un)*(deux*z0+y0-un)
            dff(1,18) = huit*x0*y0*(z0+y0-un)
            dff(2,18) = quatre*(x0-un)*(x0+un)*(deux*y0+z0-un)
            dff(3,18) = quatre*y0*(x0-un)*(x0+un)
!
!         ------------------------------------------------------------------
        case('TE4')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
!
            dff(1,1) = zero
            dff(2,1) = un
            dff(3,1) = zero
            dff(1,2) = zero
            dff(2,2) = zero
            dff(3,2) = un
            dff(1,3) = -un
            dff(2,3) = -un
            dff(3,3) = -un
            dff(1,4) = un
            dff(2,4) = zero
            dff(3,4) = zero
!
!         ------------------------------------------------------------------
        case('TE9')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
!
            dff(1,1) = zero
            dff(2,1) = un
            dff(3,1) = zero
            dff(1,2) = zero
            dff(2,2) = zero
            dff(3,2) = un
            dff(1,3) = -un
            dff(2,3) = -un
            dff(3,3) = -un
            dff(1,4) = un
            dff(2,4) = zero
            dff(3,4) = zero
            dff(1:3,5:9) = zero
!
        case('T10')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            al = un - x0 - y0 - z0
!
            dff(1,1) = zero
            dff(2,1) = quatre*y0 - un
            dff(3,1) = zero
            dff(1,2) = zero
            dff(2,2) = zero
            dff(3,2) = quatre*z0 - un
            dff(1,3) = un - quatre*al
            dff(2,3) = un - quatre*al
            dff(3,3) = un - quatre*al
            dff(1,4) = quatre*x0 - un
            dff(2,4) = zero
            dff(3,4) = zero
            dff(1,5) = zero
            dff(2,5) = quatre*z0
            dff(3,5) = quatre*y0
            dff(1,6) = -quatre*z0
            dff(2,6) = -quatre*z0
            dff(3,6) = quatre* (al-z0)
            dff(1,7) = -quatre*y0
            dff(2,7) = quatre* (al-y0)
            dff(3,7) = -quatre*y0
            dff(1,8) = quatre*y0
            dff(2,8) = quatre*x0
            dff(3,8) = zero
            dff(1,9) = quatre*z0
            dff(2,9) = zero
            dff(3,9) = quatre*x0
            dff(1,10) = quatre* (al-x0)
            dff(2,10) = -quatre*x0
            dff(3,10) = -quatre*x0
!
!         ------------------------------------------------------------------
        case('PY5')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            z01 = un - z0
            z04 = (un-z0)*quatre
!
            pface1 = x0 + y0 + z0 - un
            pface2 = -x0 + y0 + z0 - un
            pface3 = -x0 - y0 + z0 - un
            pface4 = x0 - y0 + z0 - un
!
            if (abs(z0-un) .lt. 1.0d-6) then
                dff(1:2,1:5) = zero
!
                dff(1,1) = undemi
                dff(1,3) = -undemi
!
                dff(2,2) = undemi
                dff(2,4) = -undemi
!
                dff(3,1) = -1.d0/4.d0
                dff(3,2) = -1.d0/4.d0
                dff(3,3) = -1.d0/4.d0
                dff(3,4) = -1.d0/4.d0
                dff(3,5) = un
!
            else
!
                dff(1,1) = (-pface2-pface3)/z04
                dff(1,2) = (pface3-pface4)/z04
                dff(1,3) = (pface1+pface4)/z04
                dff(1,4) = (pface2-pface1)/z04
                dff(1,5) = zero
!
                dff(2,1) = (pface3-pface2)/z04
                dff(2,2) = (-pface3-pface4)/z04
                dff(2,3) = (pface4-pface1)/z04
                dff(2,4) = (pface1+pface2)/z04
                dff(2,5) = zero
!
                dff(3,1) = (pface2+pface3+pface2*pface3/z01)/z04
                dff(3,2) = (pface3+pface4+pface3*pface4/z01)/z04
                dff(3,3) = (pface4+pface1+pface4*pface1/z01)/z04
                dff(3,4) = (pface1+pface2+pface1*pface2/z01)/z04
                dff(3,5) = un
            endif
!
!         ------------------------------------------------------------------
        case('P13')
!
            x0 = x(1)
            y0 = x(2)
            z0 = x(3)
            z01 = un - z0
            z02 = (un-z0)*deux
!
            pface1 = x0 + y0 + z0 - un
            pface2 = -x0 + y0 + z0 - un
            pface3 = -x0 - y0 + z0 - un
            pface4 = x0 - y0 + z0 - un
!
            pmili1 = x0 - undemi
            pmili2 = y0 - undemi
            pmili3 = -x0 - undemi
            pmili4 = -y0 - undemi
!
            if (abs(z0-un) .lt. 1.0d-6) then
                dff(1:2,1:13) = zero
!
                dff(1,1) = -undemi
                dff(1,3) = undemi
                dff(1,9) = deux
                dff(1,11) = -deux
!
                dff(2,2) = -undemi
                dff(2,4) = undemi
                dff(2,10) = deux
                dff(2,12) = -deux
!
                dff(3,1) = un/quatre
                dff(3,2) = un/quatre
                dff(3,3) = un/quatre
                dff(3,4) = un/quatre
                dff(3,6) = zero
                dff(3,7) = zero
                dff(3,8) = zero
                dff(3,9) = zero
                dff(3,10:13) = -un
                dff(3,5) = trois
!
            else
!
                dff(1,1) = (pface2*pface3- (pface2+pface3)*pmili1)/z02
                dff(1,2) = (pface3-pface4)*pmili2/z02
                dff(1,3) = ((pface1+pface4)*pmili3-pface4*pface1)/z02
                dff(1,4) = (pface2-pface1)*pmili4/z02
                dff(1,5) = zero
                dff(1,6) = (pface3*pface4+pface2*pface4-pface2*pface3)/ z02
                dff(1,7) = (pface4*pface1-pface3*pface1-pface3*pface4)/ z02
                dff(1,8) = (pface4*pface1-pface1*pface2-pface4*pface2)/ z02
                dff(1,9) = (pface1*pface3+pface1*pface2-pface3*pface2)/ z02
                dff(1,10) = (-pface3-pface2)*z0/z01
                dff(1,11) = (pface3-pface4)*z0/z01
                dff(1,12) = (pface1+pface4)*z0/z01
                dff(1,13) = (pface2-pface1)*z0/z01
!
                dff(2,1) = (pface3-pface2)*pmili1/z02
                dff(2,2) = (pface3*pface4- (pface3+pface4)*pmili2)/z02
                dff(2,3) = (pface4-pface1)*pmili3/z02
                dff(2,4) = ((pface2+pface1)*pmili4-pface1*pface2)/z02
                dff(2,5) = zero
                dff(2,6) = (pface2*pface4+pface2*pface3-pface3*pface4)/ z02
                dff(2,7) = (pface4*pface1+pface3*pface1-pface3*pface4)/ z02
                dff(2,8) = (pface1*pface2-pface4*pface2-pface4*pface1)/ z02
                dff(2,9) = (pface1*pface2-pface2*pface3-pface1*pface3)/ z02
                dff(2,10) = (pface3-pface2)*z0/z01
                dff(2,11) = (-pface4-pface3)*z0/z01
                dff(2,12) = (pface4-pface1)*z0/z01
                dff(2,13) = (pface2+pface1)*z0/z01
!
                dff(3,1) = (pface2+pface3+pface2*pface3/z01)*pmili1/z02
                dff(3,2) = (pface3+pface4+pface3*pface4/z01)*pmili2/z02
                dff(3,3) = (pface1+pface4+pface1*pface4/z01)*pmili3/z02
                dff(3,4) = (pface2+pface1+pface1*pface2/z01)*pmili4/z02
                dff(3,5) = quatre*z0 - un
                dff(3,6) = - (pface3*pface4+pface2*pface4+pface2*pface3+ pface2*pface3*pface4/z01&
                           )/z02
                dff(3,7) = - (pface4*pface1+pface3*pface1+pface3*pface4+ pface3*pface4*pface1/z01&
                           )/z02
                dff(3,8) = - (pface1*pface2+pface4*pface2+pface4*pface1+ pface4*pface1*pface2/z01&
                           )/z02
                dff(3,9) = - (pface2*pface3+pface1*pface3+pface1*pface2+ pface1*pface2*pface3/z01&
                           )/z02
                dff(3,10) = pface2*pface3/z01/z01 + (pface3+pface2)*z0/ z01
                dff(3,11) = pface3*pface4/z01/z01 + (pface4+pface3)*z0/ z01
                dff(3,12) = pface4*pface1/z01/z01 + (pface1+pface4)*z0/ z01
                dff(3,13) = pface1*pface2/z01/z01 + (pface1+pface2)*z0/ z01
            endif
!
!         ------------------------------------------------------------------
        case('TR3')
!
            dff(1,1) = -un
            dff(2,1) = -un
            dff(1,2) = +un
            dff(2,2) = zero
            dff(1,3) = zero
            dff(2,3) = +un
!
        case('TR4')
!
            dff(1,1) = -un
            dff(2,1) = -un
            dff(1,2) = +un
            dff(2,2) = zero
            dff(1,3) = zero
            dff(2,3) = +un
            dff(1,4) = zero
            dff(2,4) = zero
!
        case('TR6')
!
            x0 = x(1)
            y0 = x(2)
            al = un - x0 - y0
!
            dff(1,1) = un - quatre*al
            dff(1,2) = -un + quatre*x0
            dff(1,3) = zero
            dff(1,4) = quatre* (al-x0)
            dff(1,5) = quatre*y0
            dff(1,6) = -quatre*y0
            dff(2,1) = un - quatre*al
            dff(2,2) = zero
            dff(2,3) = -un + quatre*y0
            dff(2,4) = -quatre*x0
            dff(2,5) = quatre*x0
            dff(2,6) = quatre* (al-y0)
!
!         ------------------------------------------------------------------
        case('TR7')
!
            x0 = x(1)
            y0 = x(2)
!
            dff(1,1) = -trois + 4.0d0*x0 + 7.0d0*y0 - 6.0d0*x0*y0 - 3.0d0* y0*y0
            dff(1,2) = -un + 4.0d0*x0 + 3.0d0*y0 - 6.0d0*x0*y0 - 3.0d0*y0* y0
            dff(1,3) = 3.0d0*y0*( un - 2.0d0*x0 - y0 )
            dff(1,4) = 4.0d0*(un - 2.0d0*x0 - 4.0d0*y0 + 6.0d0*x0*y0 + 3.0d0*y0*y0)
            dff(1,5) = 4.0d0*y0*( -2.0d0 + 6.0d0*x0 + 3.0d0*y0 )
            dff(1,6) = 4.0d0*y0*( -4.0d0 + 6.0d0*x0 + 3.0d0*y0 )
            dff(1,7) = 27.d0*y0*( un - 2.0d0*x0 - y0 )
!
            dff(2,1) = -trois + 4.0d0*y0 + 7.0d0*x0 - 6.0d0*x0*y0 - 3.0d0* x0*x0
            dff(2,2) = 3.0d0*x0*( un - 2.0d0*y0 - x0 )
            dff(2,3) = -un + 4.0d0*y0 + 3.0d0*x0 - 6.0d0*x0*y0 - 3.0d0*x0* x0
            dff(2,4) = 4.0d0*x0*( -4.0d0 + 6.0d0*y0 + 3.0d0*x0 )
            dff(2,5) = 4.0d0*x0*( -2.0d0 + 6.0d0*y0 + 3.0d0*x0 )
            dff(2,6) = 4.0d0*(un - 2.0d0*y0 - 4.0d0*x0 + 6.0d0*x0*y0 + 3.0d0*x0*x0)
            dff(2,7) = 27.d0*x0*( un - 2.0d0*y0 - x0 )
!
!         ------------------------------------------------------------------
        case('QU4')
!
            x0 = x(1)
            y0 = x(2)
!
            dff(1,1) = -(un-y0)*uns4
            dff(2,1) = -(un-x0)*uns4
            dff(1,2) = (un-y0)*uns4
            dff(2,2) = -(un+x0)*uns4
            dff(1,3) = (un+y0)*uns4
            dff(2,3) = (un+x0)*uns4
            dff(1,4) = -(un+y0)*uns4
            dff(2,4) = (un-x0)*uns4
!
        case('QU8')
!
            x0 = x(1)
            y0 = x(2)
!
            dff(1,1) = -uns4* (un-y0)* (-deux*x0-y0)
            dff(2,1) = -uns4* (un-x0)* (-deux*y0-x0)
            dff(1,2) = uns4* (un-y0)* ( deux*x0-y0)
            dff(2,2) = -uns4* (un+x0)* (-deux*y0+x0)
            dff(1,3) = uns4* (un+y0)* (deux*x0+y0)
            dff(2,3) = uns4* (un+x0)* (deux*y0+x0)
            dff(1,4) = -uns4* (un+y0)* (-deux*x0+y0)
            dff(2,4) = uns4* (un-x0)* ( deux*y0-x0)
            dff(1,5) = -deux*x0* (un-y0)*undemi
            dff(2,5) = - (un-x0*x0)*undemi
            dff(1,6) = (un-y0*y0)*undemi
            dff(2,6) = -deux*y0* (un+x0)*undemi
            dff(1,7) = -deux*x0* (un+y0)*undemi
            dff(2,7) = (un-x0*x0)*undemi
            dff(1,8) = - (un-y0*y0)*undemi
            dff(2,8) = -deux*y0* (un-x0)*undemi
!
!         ------------------------------------------------------------------
        case('QU9')
!
            x0 = x(1)
            y0 = x(2)
!
            dff(1,1) = dal31(x0)*al31(y0)
            dff(2,1) = al31(x0)*dal31(y0)
            dff(1,2) = dal33(x0)*al31(y0)
            dff(2,2) = al33(x0)*dal31(y0)
            dff(1,3) = dal33(x0)*al33(y0)
            dff(2,3) = al33(x0)*dal33(y0)
            dff(1,4) = dal31(x0)*al33(y0)
            dff(2,4) = al31(x0)*dal33(y0)
            dff(1,5) = dal32(x0)*al31(y0)
            dff(2,5) = al32(x0)*dal31(y0)
            dff(1,6) = dal33(x0)*al32(y0)
            dff(2,6) = al33(x0)*dal32(y0)
            dff(1,7) = dal32(x0)*al33(y0)
            dff(2,7) = al32(x0)*dal33(y0)
            dff(1,8) = dal31(x0)*al32(y0)
            dff(2,8) = al31(x0)*dal32(y0)
            dff(1,9) = dal32(x0)*al32(y0)
            dff(2,9) = al32(x0)*dal32(y0)
!
!         ------------------------------------------------------------------
        case('PO1')
!
        case('SE2')
            dff(1,1) = -undemi
            dff(1,2) = undemi
!
!         ------------------------------------------------------------------
        case('SE3')
            x0 = x(1)
!
            dff(1,1) = x0 - undemi
            dff(1,2) = x0 + undemi
            dff(1,3) = -deux*x0
!         ------------------------------------------------------------------
        case('SE4')
            x0 = x(1)
!
            x1 = -un
            x2 = un
            x3 = -un/trois
            x4 = un/trois
            d1 = (x1-x2)* (x1-x3)* (x1-x4)
            dff(1,1) = ((x0-x2)* (x0-x3)+ (x0-x2)* (x0-x4)+ (x0-x3)* (x0- x4))/d1
            d2 = (x2-x1)* (x2-x3)* (x2-x4)
            dff(1,2) = ((x0-x1)* (x0-x3)+ (x0-x1)* (x0-x4)+ (x0-x3)* (x0- x4))/d2
            d3 = (x3-x1)* (x3-x2)* (x3-x4)
            dff(1,3) = ((x0-x1)* (x0-x2)+ (x0-x1)* (x0-x4)+ (x0-x2)* (x0- x4))/d3
            d4 = (x4-x1)* (x4-x2)* (x4-x3)
            dff(1,4) = ((x0-x1)* (x0-x2)+ (x0-x1)* (x0-x3)+ (x0-x2)* (x0- x3))/d4
!
!         ------------------------------------------------------------------
        case default
            ASSERT(ASTER_FALSE)
    end select
!
end subroutine
