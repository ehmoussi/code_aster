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

subroutine gdsig(fami, kpg, ksp, x0pg, petik,&
                 rot0, rotk, granc, imate, gn,&
                 gm, pn, pm)
!
! FONCTION: POUR UN ELEMENT DE POUTRE EN GRAND DEPLACEMENT, CALCULE LE
!           TORSEUR DES EFFORTS AUX POINTS DE GAUSS, EN AXES GENERAUX.
!
!     IN  : X0PG      : DERIVEE DES COORDONNEES P./R. L'ABSCISSE CURVI.
!           PETIK     : VECTEUR-COURBURE EN AXES GENE.
!           ROT0      : MATRICE DE ROTATION DES AXES PRINCIPAUX D'INERT.
!                       AU POINT DE GAUSS DANS LA POSITION DE REFERENCE,
!                       PAR RAPPORT AUX AXES GENERAUX
!           ROTK      : MATRICE DE ROTATION ACTUELLE
!           GRANC     : DIAG. DE LA MATRICE DE COMPORTEMENT
!           ALPHA     : COEFFICIENT DE DILATATION THERMIQUE
!
!     OUT : GN        : RESULTANTE DES FORCES AU PT DE GAUSS EN AX.LOCAU
!           GM        : MOMENT RESULTANT AU PT DE GAUSS EN AXES LOCAUX
!           PN        : RESULTANTE DES FORCES AU PT DE GAUSS EN AX.GENE.
!           PM        : MOMENT RESULTANT AU PT DE GAUSS EN AXES GENERAUX
! ------------------------------------------------------------------
    implicit none
#include "asterfort/promat.h"
#include "asterfort/transp.h"
#include "asterfort/verift.h"
    character(len=*) :: fami
    real(kind=8) :: x0pg(3), petik(3), rot0(3, 3), rotk(3, 3), granc(6), pn(3)
    real(kind=8) :: pm(3), gn(3), gm(3), rotabs(3, 3), rotabt(3, 3), granga(3)
    real(kind=8) :: grank(3)
    integer :: imate
!
!-----------------------------------------------------------------------
    integer :: i, kpg, ksp
    real(kind=8) :: epsthe, un
!-----------------------------------------------------------------------
    un = 1.d0
    call verift(fami, kpg, ksp, '+', imate,&
                epsth_=epsthe)
!
!
    call promat(rotk, 3, 3, 3, rot0,&
                3, 3, 3, rotabs)
    call transp(rotabs, 3, 3, 3, rotabt,&
                3)
    call promat(rotabt, 3, 3, 3, x0pg,&
                3, 3, 1, granga)
    call promat(rotabt, 3, 3, 3, petik,&
                3, 3, 1, grank)
!
    granga(1) = granga(1) - un
    do i = 1, 3
        gn(i) = granc(i) * granga(i)
        gm(i) = granc(3+i) * grank(i)
    end do
!
!     DILATATION THERMIQUE : -E*A*ALPHA*(T-TREF)
!
    gn(1) = gn(1) - granc(1)*epsthe
!
    call promat(rotabs, 3, 3, 3, gn,&
                3, 3, 1, pn)
    call promat(rotabs, 3, 3, 3, gm,&
                3, 3, 1, pm)
!
end subroutine
