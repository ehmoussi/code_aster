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

subroutine rvinvt(tensor, vonm, tres, trac, detr)
    implicit none
#include "asterc/r8vide.h"
#include "asterfort/fgequi.h"
#include "asterfort/rsvnmi.h"
#include "asterfort/rvdet3.h"
    real(kind=8) :: tensor(*), vonm, tres, trac, detr
!
!
!   OPERATION REALISEE
!   ------------------
!
!     CALCUL DES QUANTITES DE VON MISES ET TRESCA POUR UN TENSEUR
!     3X3 A 2 INDICE
!
!   ARGUMENT EN ENTREE
!   ------------------
!
!     TENSOR : TABLEAU REPRESENTANT LE TENSEUR SYMETRIQUE, ORGANISE
!              COMME SUIT :   XX, YY, ZZ, XY, XZ, YZ
!
!   ARGUMENT EN SORTIE
!   ------------------
!
!     VONM : QUANTITE DE VON MISES
!            VONM = (3*T(I,J)*T(I,J)/2)**0.5)
!
!     TRES : QUANTITE DE TRESCA
!            SOIT L(I) LA IEME VALEUR PROPRE DU TENSEUR
!            TRES = MAX( L(I) - L(J) )
!
!     TRAC : TRACE DU TENSEUR
!
!     DETR : DETERMINANT DU TENSEUR
!
!*********************************************************************
!
    integer :: i, nbvp
    real(kind=8) :: t(6), equi(6), unsur3
!
    vonm = 0.0d0
    tres = 0.0d0
    detr = 0.0d0
    trac = 0.0d0
!
    do 10, i = 1, 6, 1
    if (tensor(i) .eq. r8vide()) then
        t(i) = 0.d0
    else
        t(i) = tensor(i)
    endif
    10 end do
!
    unsur3 = 1.0d0/3.0d0
    nbvp = 3
!
    call fgequi(t, 'SIGM', nbvp, equi)
    tres = equi(2)
!
    call rvdet3(t, detr)
!
    do 20, i = 1, 3 ,1
    trac = trac + t(i)
    20 end do
!
    do 30, i = 1, 3 ,1
    t(i) = t(i) - trac*unsur3
    30 end do
!
    call rsvnmi(t, vonm)
!
end subroutine
