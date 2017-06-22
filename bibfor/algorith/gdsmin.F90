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

subroutine gdsmin()
!
!
    implicit none
!
! ----------------------------------------------------------------------
!       INTEGRATION DES LOIS EN GRANDES DEFORMATIONS SIMO-MIEHE
!                  INITIALISATION DES VARIABLES DE BASE
! ----------------------------------------------------------------------
! COMMON GRANDES DEFORMATIONS SIMO - MIEHE
!
#include "asterfort/r8inir.h"
    integer :: ind(3, 3), ind1(6), ind2(6)
    real(kind=8) :: kr(6), rac2, rc(6), id(6, 6)
    real(kind=8) :: bem(6), betr(6), dvbetr(6), eqbetr, trbetr
    real(kind=8) :: jp, dj, jm, dfb(3, 3)
    real(kind=8) :: djdf(3, 3), dbtrdf(6, 3, 3)
!
    common /gdsmc/&
     &            bem,betr,dvbetr,eqbetr,trbetr,&
     &            jp,dj,jm,dfb,&
     &            djdf,dbtrdf,&
     &            kr,id,rac2,rc,ind,ind1,ind2
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
!
!
    rac2 = sqrt(2.d0)
    rc(1)=1.d0
    rc(2)=1.d0
    rc(3)=1.d0
    rc(4)=rac2
    rc(5)=rac2
    rc(6)=rac2
!
!    KRONECKER
    kr(1)=1.d0
    kr(2)=1.d0
    kr(3)=1.d0
    kr(4)=0.d0
    kr(5)=0.d0
    kr(6)=0.d0
!
!    MATRICE IDENTITE
    call r8inir(36, 0.d0, id, 1)
    id(1,1) = 1
    id(2,2) = 1
    id(3,3) = 1
    id(4,4) = 1
    id(5,5) = 1
    id(6,6) = 1
!
!    MANIPULATION DES INDICES : IJ -> I
    ind1(1) = 1
    ind1(2) = 2
    ind1(3) = 3
    ind1(4) = 2
    ind1(5) = 3
    ind1(6) = 3
!
!    MANIPULATION DES INDICES : IJ -> J
    ind2(1) = 1
    ind2(2) = 2
    ind2(3) = 3
    ind2(4) = 1
    ind2(5) = 1
    ind2(6) = 2
!
!    MANIPULATION DES INDICES : I,J -> IJ
    ind(1,1)=1
    ind(1,2)=4
    ind(1,3)=5
    ind(2,1)=4
    ind(2,2)=2
    ind(2,3)=6
    ind(3,1)=5
    ind(3,2)=6
    ind(3,3)=3
!
end subroutine
