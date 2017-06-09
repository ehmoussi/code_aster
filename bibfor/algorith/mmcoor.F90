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

subroutine mmcoor(alias, nno, ndim, coorma, ksi1,&
                  ksi2, coorpt)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/mmnonf.h"
    integer :: ndim, nno
    character(len=8) :: alias
    real(kind=8) :: ksi1, ksi2
    real(kind=8) :: coorma(27), coorpt(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! CALCUL DES COORDONNEES D'UN POINT SUR UNE MAILLE A PARTIR
! DE SES COORDONNEES PARAMETRIQUES
!
! ----------------------------------------------------------------------
!
!
! IN  ALIAS  : TYPE DE MAILLE
! IN  NNO    : NOMBRE DE NOEUD SUR LA MAILLE
! IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
! IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE
! IN  KSI1   : COORDONNEE PARAMETRIQUE KSI DU PROJETE
! IN  KSI2   : COORDONNEE PARAMETRIQUE ETA DU PROJETE
! OUT COORPT : COORDONNEES DU POINT
!
!-----------------------------------------------------------------------
!
    integer :: idim, ino
    real(kind=8) :: ff(9)
!
!-----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    do 10 idim = 1, 3
        coorpt(idim) = 0.d0
10  end do
!
! --- FONCTIONS DE FORME
!
    call mmnonf(ndim, nno, alias, ksi1, ksi2,&
                ff)
!
! --- COORDONNEES DU POINT
!
    do 40 idim = 1, 3
        do 30 ino = 1, nno
            coorpt(idim) = ff(ino)*coorma(3*(ino-1)+idim) + coorpt( idim)
30      continue
40  end do
!
end subroutine
