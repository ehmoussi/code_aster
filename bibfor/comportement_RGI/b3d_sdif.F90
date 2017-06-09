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

subroutine b3d_sdif(ss6, young0, rt, epic, erreur,&
                    dt3, st3, vss33, vss33t, rapp3)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!     endo diffus de la forme d=s/(r+s)
!=====================================================================
!     declarations externes
    implicit none
#include "asterfort/b3d_valp33.h"
#include "asterfort/x6x33.h"
#include "asterfort/transpos1.h"
    real(kind=8) :: ss6(6)
    real(kind=8) :: young0
    real(kind=8) :: rt
    real(kind=8) :: epic
    integer :: erreur
    real(kind=8) :: dt3(3)
    real(kind=8) :: st3(3)
    real(kind=8) :: vss33(3, 3)
    real(kind=8) :: vss33t(3, 3)
    real(kind=8) :: rapp3(3)
    real(kind=8) :: ss33(3, 3), ss3(3), rt0
    integer :: i
!
!     diagonalisation contraintes seuils actuelles et valeurs
!     propres par la methode de jacobi
    call x6x33(ss6, ss33)
    call b3d_valp33(ss33, ss3, vss33)
!     creation de la matrice de passage inverse
    call transpos1(vss33t, vss33, 3)
!
!     resistance effective au pic de traction
    rt0=young0*epic
!     endommagement du au franchissement du pic
!     independant de la taille de l element car endo diffus
!     (ecrouissage post pic nul)
    do i = 1, 3
        if (ss3(i) .gt. 0.d0) then
            dt3(i)=ss3(i)/(rt0+ss3(i))
!         dt3(i)=0.d0
!         print*,'Ds b3d_sdiffd diff(',i,')=',dt3(i)
        else
            dt3(i)=0.d0
        end if
!       resistance residuelle localisee apres endommagement diffus
        rapp3(i)=rt*(1.d0-dt3(i))
    end do
!     verif de la condition de croissance des endos inutile car
!     endo local ne depend pas de la taille des elements
!     calcul des indice de fissuration
    do i = 1, 3
        if (dt3(i) .lt. 1.d0) then
            st3(i)=1.d0/(1.d0-dt3(i))
        else
            erreur=1
        end if
    end do
end subroutine
