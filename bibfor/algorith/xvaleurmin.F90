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

subroutine xvaleurmin(jcalculs, jvtemp, jnodto, nbno, minlo)

    implicit none

#include "jeveux.h"
#include "asterfort/assert.h"

    integer :: jcalculs, jnodto, jvtemp
    integer :: nbno, minlo

! person_in_charge: patrick.massin at edf.fr

! XVALEURMIN : RECHERCHE LE MINIMUM DANS UN VECTEUR

!ENTREE
!      CALCULS = VECTEUR CONTENANT LES VALEURS DES LEVEL SETS DANS LA NARROWBAND
!      JVTEMP  = VECTEUR LOGIQUE INDIQUANT SI LE NOEUD EST CALCULE
!      JNODTO  = LISTE DES NOEUDS DEFINISSANTS LE DOMAINE DE CALCUL
!      NBNO    = NOMBRE DE NOEUD DU TORE DE CALCUL
!      MINLO   = INDICE DU NOEUD OU LE MINIMUM EST LOCALISE

!SORTIE
!      MINLO   = INDICE DU NOEUD OU LE MINIMUM EST LOCALISE
!------------------------------------------------------------------------

    integer :: inod, node
    integer :: ideb, nodeb
    real(kind=8) :: minimum

    !   tolerances --- absolue et relative --- pour determiner si deux valeurs sont egales
    real(kind=8), parameter :: atol=1.e-12
    real(kind=8), parameter :: rtol=1.e-12
    aster_logical :: near

!----------------DEBUT---------------------------------------------------

    ! recherche du premier noeud dans la narrow band
    ideb  = 0
    nodeb = 0

    do inod = 1 , nbno
        node = zi(jnodto-1+inod)
        if (zl(jvtemp-1+node)) then
            ideb=inod
            nodeb=node
            exit
        endif
    end do

    ! assertion : la narrow band n'est pas vide
    ASSERT(ideb.ne.0)

    ! initialisation du minimum : valeur du premier noeud de la narrow band
    minlo = ideb
    minimum = zr(jcalculs-1+nodeb)

    ! recherche du minimum sur les autres noeuds de la narrow band
    do inod = ideb + 1 , nbno
        node = zi(jnodto-1+inod)

        ! la valeur courante est-elle egale au minimum ?
        near = abs(zr(jcalculs-1+node) - minimum) .le. (atol + minimum*rtol)

        if (zr(jcalculs-1+node) .lt. minimum .and. .not.near .and. zl(jvtemp-1+node))  then
            minimum = zr(jcalculs-1+node)
            minlo = inod
        endif
    end do
end subroutine
