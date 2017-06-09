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

subroutine mmjeux(alias, nno, ndim, coorma, ksi1,&
                  ksi2, coorpt, jeupm, dist)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/mmcoor.h"
    character(len=8) :: alias
    integer :: nno, ndim
    real(kind=8) :: coorma(27)
    real(kind=8) :: coorpt(3), dist(3)
    real(kind=8) :: jeupm
    real(kind=8) :: ksi1, ksi2
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
!
! CALCUL DE LA DISTANCE ENTRE POINT ET SA PROJECTION SUR LA
! MAILLE
!
! ----------------------------------------------------------------------
!
!
! IN  ALIAS  : TYPE DE MAILLE
! IN  NNO    : NOMBRE DE NOEUD SUR LA MAILLE
! IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
! IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE
! IN  COORPT : COORDONNEES DU POINT
! IN  KSI1   : PREMIERE COORDONNEE PARAMETRIQUE DE LA PROJECTION DU
!              POINT SUR LA MAILLE
! IN  KSI2   : SECONDE COORDONNEE PARAMETRIQUE DE LA PROJECTION DU
!              POINT SUR LA MAILLE
! OUT JEUPM  : DISTANCE ENTRE POINT ET SA PROJECTION SUR LA MAILLE
! OUT DIST   : VECTEUR RELIANT LE POINT AVEC SON PROJETE
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: coorpr(3)
    integer :: idim, ndimg
    real(kind=8) :: zero
    parameter    (zero=0.d0)
!
! ----------------------------------------------------------------------
!
    ndimg = 3
!
    do 10 idim = 1, ndimg
        dist(idim) = zero
10  end do
!
! --- COORDONNEES DU PROJETE
!
    call mmcoor(alias, nno, ndim, coorma, ksi1,&
                ksi2, coorpr)
!
! --- DISTANCE POINT DE CONTACT/PROJECTION
!
    do 140 idim = 1, ndimg
        dist(idim) = coorpr(idim) - coorpt(idim)
140  end do
!
! --- JEUPM
!
    jeupm = sqrt(dist(1)**2+dist(2)**2+dist(3)**2)
!
end subroutine
