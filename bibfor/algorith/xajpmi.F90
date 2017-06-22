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

subroutine xajpmi(ndim, list, long, ipt, cpt, newpt,&
                  longar, ajout)
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/padist.h"
!
    integer :: ndim, long, ipt, cpt
    real(kind=8) :: newpt(3), longar, list(*)
    aster_logical :: ajout
!
!         AJOUTER UN POINT MILIEU DANS UNE LISTE
!              ET INFORMATIONS COMPLÉMENTAIRES SUR LES ARETES
!
!     ENTREE
!       LIST    : LA LISTE
!       LONG    : LONGUEUR MAX DE LA LISTE
!       IPT     : LONGUEUR DE LA LISTE AVANT AJOUT
!       CPT     : COMPTEUR SPÉCIFIQUE
!       NEWPT   : COORDONNES DU POINT A AJOUTER
!       LONGAR  : LONGUEUR DE L'ARETE
!     SORTIE
!       LIST
!     ----------------------------------------------------------------
!
    real(kind=8) :: p(3), cridist
    parameter(cridist=1.d-9)
    integer :: i, j
    aster_logical :: deja
!
! --------------------------------------------------------------------
!
!
!     VERIFICATION SI CE POINT EST DEJA DANS LA LISTE
    deja = .false.
!
    do i = 1, ipt
        do j = 1, ndim
            p(j) = list(ndim*(i-1)+j)
        end do
        if (padist(ndim,p,newpt) .lt. (longar*cridist)) deja = .true.
    end do
!
    if (.not. deja) then
!       CE POINT N'A PAS DEJA ETE TROUVE, ON LE GARDE
        ipt = ipt + 1
        cpt = cpt + 1
!       TROP DE POINTS DANS LA LISTE
        ASSERT(ipt .le. long)
        do j = 1, ndim
            list(ndim*(ipt-1)+j) = newpt(j)
        end do
    endif
!
    ajout=(.not.deja)
end subroutine
