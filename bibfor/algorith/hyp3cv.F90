! --------------------------------------------------------------------
! Copyright (C) 2005 UCBL LYON1 - T. BARANGER     WWW.CODE-ASTER.ORG
! Copyright (C) 2007 - 2017 - EDF R&D - www.code-aster.org
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

subroutine hyp3cv(c11, c22, c33, c12, c13,&
                  c23, k, sv, codret)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    real(kind=8) :: c11, c22, c33
    real(kind=8) :: c12, c13, c23
    real(kind=8) :: k
    real(kind=8) :: sv(6)
    integer :: codret
!
! ----------------------------------------------------------------------
!
! LOI DE COMPORTEMENT HYPERELASTIQUE DE SIGNORINI
!
! 3D - CALCUL DES CONTRAINTES - PARTIE VOLUMIQUE
!
! ----------------------------------------------------------------------
!
!
! IN  C11,C22,C33,C12,C13,C23 : ELONGATIONS
! IN  K      : MODULE DE COMPRESSIBILITE
! OUT SV     : CONTRAINTES VOLUMIQUES
! OUT CODRET : CODE RETOUR ERREUR INTEGRATION (1 SI PROBLEME, 0 SINON)
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: grd(6)
    real(kind=8) :: t1, t3, t5, t7, temp
    real(kind=8) :: t10, t13, t15, t16
!
! ----------------------------------------------------------------------
!
    t1 = c11*c22
    t3 = c23**2
    t5 = c12**2
    t7 = c12*c13
    t10 = c13**2
    temp = t1*c33-c11*t3-t5*c33+2.d0*t7*c23-t10*c22
!
    if (temp .le. 0.d0) then
        codret=1
        goto 99
    endif
!
    t13 = sqrt(temp)
    t15 = k*(t13-1.d0)
!
    if (t13 .eq. 0.d0) then
        codret=1
        goto 99
    endif
    t16 = 1.d0/t13
!
    grd(1) = t15*t16*(c22*c33-t3)/2.d0
    grd(2) = t15*t16*(c11*c33-t10)/2.d0
    grd(3) = t15*t16*(t1-t5)/2.d0
    grd(4) = t15*t16*(-2.d0*c12*c33+2.d0*c13*c23)/2.d0
    grd(5) = t15*t16*(2.d0*c12*c23-2.d0*c13*c22)/2.d0
    grd(6) = t15*t16*(-2.d0*c11*c23+2.d0*t7)/2.d0
!
    sv(1) = 2.d0*grd(1)
    sv(2) = 2.d0*grd(2)
    sv(3) = 2.d0*grd(3)
    sv(4) = 2.d0*grd(4)
    sv(5) = 2.d0*grd(5)
    sv(6) = 2.d0*grd(6)
99  continue
end subroutine
