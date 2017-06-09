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

subroutine calcul_cara_maille( coord, noeuds, topologie, surface, centre, normale )
!
!
! --------------------------------------------------------------------------------------------------
!
!     Calcul pour une maille : centre de gravité, surface
!       coord       : coordonnées des noeuds rangées suivant les conventions (x,y,z)
!       noeuds      : noeuds de l'élément
!       topologie   : topologie de la maille (1:ligne 2:surface)
!       surface     :   1       : surface totale de la maille,
!                       2       : surface totale de la maille / nombre de noeuds
!       cdg         : cdg des noeuds sommet de la maille
!       normale     : si topologie=2 ==> vecteur normal à la face, normé
!                                 =1 ==> vecteur tangent au segment, normé
! --------------------------------------------------------------------------------------------------
! person_in_charge: jean-luc.flejou at edf.fr
!
implicit none
        real(kind=8),intent(in)    :: coord(*)
        integer,intent(in)         :: noeuds(:)
        integer,intent(in)         :: topologie
        real(kind=8),optional,intent(out)   :: surface(*)
        real(kind=8),optional,intent(out)   :: centre(*)
        real(kind=8),optional,intent(out)   :: normale(*)
!
#include "asterfort/provec.h"
#include "blas/ddot.h"
!
! --------------------------------------------------------------------------------------------------
    integer :: ii, pta, ptb, ptc, ptd, inoe, nbnoeu
    real(kind=8) :: cdg(3), vectab(3), vectcd(3), vect(3), surf
! --------------------------------------------------------------------------------------------------
!   centre de gravité de la maille
    cdg(:) = 0.0
    do ii = lbound(noeuds,1), ubound(noeuds,1)
        inoe = 3*(noeuds(ii)-1)
        cdg(1:3) = cdg(1:3) + coord(inoe+1:inoe+3)
    enddo
    nbnoeu = size(noeuds)
    cdg(1:3) = cdg(1:3) / nbnoeu
!   Surface de la maille
    pta = 0; ptb = 0; ptc = 0; ptd = 0; surf = 0.0
    if (topologie.eq.1) then
        pta = 3*(noeuds(1)-1)
        ptb = 3*(noeuds(2)-1)
        vectab(1:3) = coord(ptb+1:ptb+3) - coord(pta+1:pta+3)
        surf = ddot(2,vectab,1,vectab,1)
        surf = sqrt(surf)
        vect(1:3) = vectab(1:3)/surf
    else if (topologie.eq.2) then
        pta = 3*(noeuds(1)-1)
        ptb = 3*(noeuds(3)-1)
        if (nbnoeu.eq.3 .or. nbnoeu.eq.6 .or. nbnoeu.eq.7) then
            ptc = 3*(noeuds(1)-1)
            ptd = 3*(noeuds(2)-1)
        else if (nbnoeu.eq.4 .or. nbnoeu.eq.8 .or. nbnoeu.eq.9) then
            ptc = 3*(noeuds(2)-1)
            ptd = 3*(noeuds(4)-1)
        endif
        vectab(1:3) = coord(ptb+1:ptb+3) - coord(pta+1:pta+3)
        vectcd(1:3) = coord(ptd+1:ptd+3) - coord(ptc+1:ptc+3)
        call provec(vectab, vectcd, vect)
        surf = ddot(3,vect,1,vect,1)
        vect = vect(1:3)/sqrt(surf)
        surf = sqrt(surf)*0.5d0
    endif
!   Resultat
    if ( present(surface) ) then
        surface(1)   = surf
        surface(2)   = surf / nbnoeu
    endif
    if ( present(centre) ) then
        centre(1:3) = cdg(1:3)
    endif
    if ( present(normale) ) then
        normale(1:3) = vect(1:3)
    endif
end subroutine
