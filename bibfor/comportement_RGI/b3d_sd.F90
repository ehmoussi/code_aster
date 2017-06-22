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

subroutine b3d_sd(ss6, t33, n33, l3, vt33,&
                  young0, xnu0, gf0, fr, rt,&
                  epic, beta1, gama1, reg, erreur,&
                  d03, dt3, st3, vss33, vss33t,&
                  local, e23, nfid1, rrr, rapp6,&
                  dpic0, istep)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!     calcul des endommagements de traction en fonctions des contraintes
!     calcul des indices de fissuration, des resistances residuelles si
!=====================================================================
    implicit none
#include "asterfort/b3d_valp33.h"
#include "asterfort/x6x33.h"
#include "asterfort/transpos1.h"
#include "asterfort/b3d_l3.h"
#include "asterfort/x33x6.h"
#include "asterfort/b3d_erupt.h"
#include "asterfort/b3d_dam.h"
#include "asterfort/dmin_3d.h"
#include "asterfort/b3d_chrep.h"
#include "asterf_types.h"
    real(kind=8) :: ss6(6)
    real(kind=8) :: t33(3, 3)
    real(kind=8) :: n33(3, 3)
    real(kind=8) :: l3(3)
    real(kind=8) :: vt33(3, 3)
    real(kind=8) :: young0
    real(kind=8) :: xnu0
    real(kind=8) :: gf0
    real(kind=8) :: fr
    real(kind=8) :: rt
    real(kind=8) :: epic
    real(kind=8) :: beta1
    real(kind=8) :: gama1
    real(kind=8) :: reg
    integer :: erreur
    real(kind=8) :: d03(3)
    real(kind=8) :: dt3(3)
    real(kind=8) :: st3(3)
    real(kind=8) :: vss33(3, 3)
    real(kind=8) :: vss33t(3, 3)
    aster_logical :: local
    real(kind=8) :: e23(3)
    real(kind=8) :: nfid1
    aster_logical :: rrr
    real(kind=8) :: rapp6(6)
    real(kind=8) :: dpic0
    integer :: istep
!     declarations locales
    real(kind=8) :: ss3(3), ss33(3, 3)
    integer :: i, j
    real(kind=8) :: gf
    real(kind=8) :: rapp33(3, 3), x33(3, 3), su
!
!***********************************************************************
!     calcul des tailles des elements dans les directions principales de
    if (istep .ne. 0) then
!      pour une formulation non locale a deux longueurs internes
!      remplacer la longueur de l element par la premiere longueur inter
!      (l element devient la longueur non locale)
    else
!      en formulation locale on va utiliser les tailles reelles des elem
!      ecriture tensorielle des contraintes seuils
        call x6x33(ss6, ss33)
!      diagonalisation contraintes seuils actuelles et valeurs
!      propres par la methode de jacobi
        call b3d_valp33(ss33, ss3, vss33)
!      creation de la matrice de passage inverse
        call transpos1(vss33t, vss33, 3)
        call b3d_l3(local, t33, n33, vt33, vss33,&
                    l3)
    end if
!***********************************************************************
!     calcul des endommagements dans les 3 directions principales
!     choix de l energie de fissuration en fonction du type d endo (loca
    if (local) then
        gf=gf0
    else
        gf=gf0*nfid1
    end if
!     calcul de l endommagement
    do i = 1, 3
!      print*,'ss3(',i,')=',ss3(i)
!      calcul de l extremite de la branche descendante de la loi de
!      comportement de traction pour la direction consideree
        call b3d_erupt(local, i, l3, e23, rt,&
                       beta1, epic, fr, gf, young0,&
                       dpic0)
!      calcul de l'endommagement
        call b3d_dam(ss3(i), young0, epic, reg, rt,&
                     xnu0, dt3(i), e23(i), fr, beta1,&
                     dpic0)
!      calcul de 1/(1-d)=st pour le calcul de la matrice d endommagement
    end do
!     verif de la condition de croissance des endos
    call dmin_3d(d03, dt3)
!     calcul des indice de fissuration
    do i = 1, 3
        if (dt3(i) .lt. 1.d0) then
            st3(i)=1.d0/(1.d0-dt3(i))
        else
            erreur=1
        end if
    end do
!***********************************************************************
!     Calcul des resistances residuelles si necessaire ds la base prin d
    if (rrr) then
        su=young0*epic
        do i = 1, 3
            do j = 1, 3
                if (i .eq. j) then
!         Rapp=s(1-d(s)), on cherche (s)
                    if (ss3(i) .gt. su) then
                        rapp33(i,j)=ss3(i)*(1.d0-dt3(i))
                    else
                        rapp33(i,j)=su*(1.d0-dt3(i))
                    end if
!          print*,'Resistance(',i,')=',rapp33(i,i),'su',
!     #    su,'ss',ss3(i),'dt',dt3(i)
!          read*
                else
                    rapp33(i,j)=0.d0
                end if
            end do
        end do
!      retour des resistances en base fixe
        call b3d_chrep(x33, rapp33, vss33t)
        call x33x6(x33, Rapp6)
    end if
end subroutine
