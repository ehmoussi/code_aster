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

subroutine cgepsi(ndim, nno1, nno2, npg, wref,&
                  vff1, dffr1,geom, tang, ddl, iu,iuc,eps)
    implicit none
#include "asterfort/cgcine.h"
    integer :: ndim, nno1, nno2, npg, iu(3, 3), iuc(3)
    real(kind=8) :: vff1(nno1, npg),dffr1(nno1, npg)
    real(kind=8) :: geom(ndim, nno1), wref(npg)
    real(kind=8) :: tang(*), eps(npg)
    real(kind=8) :: ddl(nno1*(ndim+1) + nno2)
! ----------------------------------------------------------------------
!
!   EPSI POUR L'ELEMENT CABLE/GAINE
!
! ----------------------------------------------------------------------

    integer :: nddl,g,n,j
    real(kind=8) :: wg, l(3), b(4, 3), courb

    nddl = nno1*(ndim+1) + nno2

    do g = 1, npg
!
!      CALCUL DES ELEMENTS GEOM DE L'EF AU POINT DE GAUSS CONSIDERE
!
        call cgcine(ndim, nno1, vff1(1, g), wref(g), dffr1(1, g),&
                    geom, tang, wg, l, b,&
                    courb)
        eps(g) = 0.d0

        do n = 1, nno1
            do j = 1, ndim
                eps(g) = eps(g) + b(j,n)*ddl(iu(j,n))
            end do
            eps(g) = eps(g) + b(ndim+1,n)*ddl(iuc(n))
        end do
    end do
!
end subroutine
