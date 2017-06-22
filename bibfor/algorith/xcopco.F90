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

subroutine xcopco(jcesd, jcesv, jcesl, ifiss, alias,&
                  ndim, nummae, iface, ksi1, ksi2,&
                  npte, geom)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cesexi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mmnonf.h"
    character(len=8) :: alias
    integer :: nummae, ndim, iface, npte, ifiss
    integer :: jcesd(10), jcesv(10), jcesl(10)
    real(kind=8) :: ksi1
    real(kind=8) :: ksi2
    real(kind=8) :: geom(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (CONTACT - GRANDS GLISSEMENTS)
!
! CALCUL DES COORDONNEES D'UN POINT DE CONTACT A PARTIR
! DES COORDONNEES PARAMETRIQUES POUR LE CONTACT METHODE CONTINUE
!
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
!
! ----------------------------------------------------------------------
!
!
!  JCES*(4)  : POINTEURS DE LA SD SIMPLE DE CONNECTIVITÉ DES FACETTES
!  JCES*(5)  : POINTEURS DE LA SD SIMPLE DES COOR DES PT D'INTER ESCLAVE
!  IFISS     : NUMÉRO DE FISSURE LOCALE
! IN  ALIAS  : TYPE DE MAILLE DE CONTACT
! IN  NDIM   : DIMENSION DU PROBLÈME
! IN  NUMMAE : INDICE DE LA MAILLE DANS CONTAMA
! IN  KSI1   : COORDONNEE PARAMETRIQUE KSI DU PROJETE
! IN  IFACE  : NUMERO DE LA FACE ESCLAVE
! IN  KSI2   : COORDONNEE PARAMETRIQUE ETA DU PROJETE
! OUT GEOM   : COORDONNEES DU PROJETE (EN 2D Z=0)
!
!
!
!
    integer :: i, j, iad, numpi(3)
    real(kind=8) :: ff(9), coor(27)
!-----------------------------------------------------------------------
!
    call jemarq()
!
!
! --- INITIALISATIONS
!
    do 100 i = 1, ndim
        geom(i) = 0.d0
100  end do
!
! --- RECUPERATION DES NUMEROS LOCAUX DES POINTS D'INTERSECTIONS
!     DE LA FACETTE DANS LA MAILLE
!
    do 150 i = 1, npte
        call cesexi('S', jcesd(4), jcesl(4), nummae, 1,&
                    ifiss, (iface-1)* ndim+i, iad)
        ASSERT(iad.gt.0)
        numpi(i) = zi(jcesv(4)-1+iad)
150  end do
!
! --- RECUPERATION DES COORDONNES REELLES DES POINTS D'INTERSECTION
!     DE LA FACETTE ESCLAVE
!
    do 200 i = 1, npte
        do 210 j = 1, ndim
            call cesexi('S', jcesd(5), jcesl(5), nummae, 1,&
                        ifiss, ndim*( numpi(i)-1)+j, iad)
            ASSERT(iad.gt.0)
            coor(ndim*(i-1)+j)=zr(jcesv(5)-1+iad)
210      continue
200  end do
!
! --- CALCUL DU POINT
!
    call mmnonf(ndim, npte, alias, ksi1, ksi2,&
                ff)
    do 300 i = 1, ndim
        do 310 j = 1, npte
            geom(i) = ff(j)*coor((j-1)*ndim+i) + geom(i)
310      continue
300  end do
!
    call jedema()
end subroutine
