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

subroutine mmreli(alias, nno, ndim, coorma, coorpt,&
                  ksi1, ksi2, dksi1, dksi2, alpha)
! person_in_charge: mickael.abbas at edf.fr
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/mmresi.h"
    character(len=8) :: alias
    integer :: nno, ndim
    real(kind=8) :: coorma(27), coorpt(3)
    real(kind=8) :: ksi1, ksi2, dksi1, dksi2
    real(kind=8) :: alpha
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT)
!
! ALGORITHME DE NEWTON POUR CALCULER LA PROJECTION D'UN POINT SUR UNE
! MAILLE - VERSION GENERALE
!
! DETERMINATION DU PARAMETRE DE RECHERCHE LINEAIRE
!                                     __
! ==> FONCTION G(ALPHA)  ==  1/2 * || \/D(KSI+ALPHA*DKSI) ||^2
!
!
! ----------------------------------------------------------------------
!
! IN  ALIAS  : TYPE DE MAILLE
! IN  NNO    : NOMBRE DE NOEUD SUR LA MAILLE
! IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
! IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE
! IN  COORPT : COORDONNEES DU NOEUD A PROJETER SUR LA MAILLE
! IN  KSI1   : PREMIERE COORDONNEE PARAMETRIQUE DU POINT PROJETE
! IN  KSI2   : SECONDE COORDONNEE PARAMETRIQUE DU POINT PROJETE
! IN  DKSI1  : DIRECTION DE RECHERCHE SUIVANT LA PREMIERE COORDONNEE
! IN  DKSI2  : DIRECTION DE RECHERCHE SUIVANT LA SECONDE COORDONNEE
! OUT ALPHA  : PARAMETRE D'AVANCEMENT SUIVANT LA DIRECTION DE RECHERCHE
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: g0, gp0
    real(kind=8) :: alpha1, ksia1, ga1, res1
    real(kind=8) :: alpha2, ksia2, ga2, res2
    real(kind=8) :: coeffa, coeffb, unsdet
    real(kind=8) :: omega1, amin, amax
    parameter   (omega1=1.d-4,amin=1.d-1,amax=5.d-1)
    integer :: nadamx, iada
    parameter   (nadamx=2)
!
! ----------------------------------------------------------------------
!                                  __
! --- CALCUL DE G(0)  ==  1/2 * || \/D(KSI) ||^2
!
    call mmresi(alias, nno, ndim, coorma, coorpt,&
                ksi1, ksi2, g0)
!
! --- CALCUL DE G'(0) == -2 * G(0)
!
    gp0 = -2.d0 * g0
!
! ----------------------------------------------------------------------
!
! --- PREMIER PARAMETRE D'AVANCEMENT (ALPHA == 1)
!
    alpha1 = 1.d0
    ksia1 = ksi1 + alpha1 * dksi1
    ksia2 = ksi2 + alpha1 * dksi2
    call mmresi(alias, nno, ndim, coorma, coorpt,&
                ksia1, ksia2, ga1)
    if (ga1 .le. (g0+omega1*gp0)) then
        alpha = alpha1
        goto 9999
    endif
    res1 = ga1-g0-gp0*alpha1
!
! ----------------------------------------------------------------------
!
! --- DEUXIEME PARAMETRE D'AVANCEMENT AVEC APPROXIMATION QUADRATIQUE
!
    alpha2 = -gp0/(2.d0*res1)
    if (alpha2 .lt. amin*alpha1) alpha2=amin*alpha1
    if (alpha2 .gt. amax*alpha1) alpha2=amax*alpha1
    ksia1 = ksi1 + alpha2 * dksi1
    ksia2 = ksi2 + alpha2 * dksi2
    call mmresi(alias, nno, ndim, coorma, coorpt,&
                ksia1, ksia2, ga2)
    if (ga2 .le. (g0+omega1*gp0*alpha2)) then
        alpha = alpha2
        goto 9999
    endif
    res2 = ga2-g0-gp0*alpha2
!
! ----------------------------------------------------------------------
!
! --- ADAPTATION DU PARAMETRE D'AVANCEMENT AVEC APPROXIMATION CUBIQUE
!
    do 1 iada = 1, nadamx
!
        ASSERT(abs(alpha1 - alpha2).gt.r8prem())
        unsdet = (1.d0 / (alpha1 - alpha2))
        coeffa = unsdet*( res1/alpha1**2- res2/alpha2**2)
        coeffb = unsdet*(-alpha2*res1/alpha1**2+alpha1*res2/alpha2**2)
        alpha1 = alpha2
        ga1 = ga2
        res1 = res2
        if (abs(coeffa) .le. r8prem()) then
            alpha = alpha2
            goto 9999
        endif
        alpha2 = (-coeffb+sqrt(coeffb*coeffb-3.d0*coeffa*gp0))/ (3.d0*coeffa)
        if (alpha2 .lt. amin*alpha1) alpha2=amin*alpha1
        if (alpha2 .gt. amax*alpha1) alpha2=amax*alpha1
        ksia1 = ksi1 + alpha2 * dksi1
        ksia2 = ksi2 + alpha2 * dksi2
        call mmresi(alias, nno, ndim, coorma, coorpt,&
                    ksia1, ksia2, ga2)
        if (ga2 .le. (g0+omega1*gp0*alpha2)) then
            alpha = alpha2
            goto 9999
        endif
        res2 = ga2-g0-gp0*alpha2
!
 1  end do
!
! ----------------------------------------------------------------------
!
9999  continue
end subroutine
