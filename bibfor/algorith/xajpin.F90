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

subroutine xajpin(ndim, list, long, ipt, cpt,&
                  newpt, longar, ainter, ia, in,&
                  al, ajout)
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/padist.h"
#include "asterfort/xxmmvd.h"
    aster_logical :: ajout
    integer :: ndim, long, ipt, cpt, ia, in
    real(kind=8) :: newpt(3), longar, al, list(*), ainter(*)
! person_in_charge: samuel.geniaut at edf.fr
!         AJOUTER UN POINT D'INTERSECTION DANS UNE LISTE
!              ET INFORMATIONS COMPLÉMENTAIRES SUR LES ARETES
!
!     ENTREE
!       NDIM   : DIMENSION DU MAILLAGE
!       LIST   : LA LISTE
!       LONG   : LONGUEUR MAX DE LA LISTE
!       IPT    : LONGUEUR DE LA LISTE AVANT AJOUT
!       CPT    : COMPTEUR SPÉCIFIQUE
!       NEWPT  : COORDONNES DU POINT A AJOUTER
!       LONGAR : LONGUEUR DE L'ARETE
!       AINTER : LISTE DES ARETES
!       IA     : NUMERO DE L'ARETE (0 SI NOEUD SOMMET)
!       IN     : NUMÉRO NOEUD SI NOEUD SOMMET        (0 SINON)
!       AL     : POSITION DU PT SUR L'ARETE (0.D0 SI NOEUD SOMMET)
!     SORTIE
!       LIST,AINTER
!     ------------------------------------------------------------------
    real(kind=8) :: p(3), cridist
    parameter(cridist=1.d-9)
    integer :: i, j
    aster_logical :: deja
    integer :: zxain
! ----------------------------------------------------------------------
!
!
    zxain = xxmmvd('ZXAIN')
!
!     VERIFICATION SI CE POINT EST DEJA DANS LA LISTE
    deja = .false.
!
    do 100 i = 1, ipt
        do 99 j = 1, ndim
            p(j) = list(ndim*(i-1)+j)
 99     continue
        if (padist(ndim,p,newpt) .lt. (longar*cridist)) deja = .true.
100 end do
!
    if (.not. deja) then
!       CE POINT N'A PAS DEJA ETE TROUVE, ON LE GARDE
        ipt = ipt + 1
        cpt = cpt + 1
!       TROP DE POINTS DANS LA LISTE
        ASSERT(ipt .le. long)
        do 101 j = 1, ndim
            list(ndim*(ipt-1)+j) = newpt(j)
101     continue
        ainter(zxain*(ipt-1)+1)=ia
        ainter(zxain*(ipt-1)+2)=in
        ainter(zxain*(ipt-1)+3)=longar
        ainter(zxain*(ipt-1)+4)=al
    endif
!
    ajout=.not. deja
end subroutine
