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

subroutine pmfbts(b, wi, vs, ve)
    implicit none
!    -------------------------------------------------------------------
!     CALCUL DE : WI BT VS
!     VS = VECTEUR DE FORCES INTERNES (ISSUE DE L'INTE. SUR LES FIBRES)
!     WI = POIDS DU PT DE GAUSS EN COURS
!     B = MATRICE B A CE POINT DE GAUSS ET BT SA TRANSPOSEE
!
!    -------------------------------------------------------------------
!
! IN R*8  VS(1) = INT(SIG DS)   = N0 EFFORT NORMAL INTERNE
! IN R*8  VS(2) = INT(SIG.Y DS) = -MZ0 MOMENT FLECHISSANT Z INTERNE
! IN R*8  VS(3) = INT(SIG.Z DS) = MY0 MOMENT FLECHISSANT Y INTERNE
! IN R*8  B(4) : LES QUATRES VALEURS NON NULLE ET DIFFERENTES DE B
!
! OUT R*8 VE(12) : FORCES ELEMENTAIRES DUES A CE POINT DE GAUSS
!
    real(kind=8) :: vs(3), b(4), wi, ve(12)
!
    ve(1)=-b(1)*vs(1)*wi
    ve(2)=-b(2)*vs(2)*wi
    ve(3)=-b(2)*vs(3)*wi
    ve(4)=0.d0
!
    ve(5)=b(3)*vs(3)*wi
    ve(6)=-b(3)*vs(2)*wi
    ve(7)=-ve(1)
    ve(8)=-ve(2)
    ve(9)=-ve(3)
    ve(10)=0.d0
!
    ve(11)=b(4)*vs(3)*wi
    ve(12)=-b(4)*vs(2)*wi
!
end subroutine
