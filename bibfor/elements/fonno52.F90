! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine fonno52(noma, na, nb, ndim, vnor,vdir)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/gdire3.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/normev.h"
#include "asterfort/provec.h"
#include "asterfort/vecini.h"
    character(len=8) :: noma
    integer :: na, nb, ndim
    real(kind=8) :: vnor(2, 3), vdir(2, 3)
    
!
!
!     ------------------------------------------------------------------
!     BUT : CALCUL DES VECTEURS DE LA BASE LOCALE :
!             - VDIR : VECTEUR DANS LA DIRECTION DE PROPAGATION
!           CAS OU CONFIG_INIT = DECOLLEE, ON A LE MOT CLE NORMALE
!
!           RQ : CHACUN CONTIENT EN FAIT 2 VECTEURS IDENTIQUES (UN PAR LEVRE)
!                PAR COHERENCE AVEC LE CAS CONFIG_INIT = COLLEE
!     ------------------------------------------------------------------
!
! ENTREES
!     NOMA   : NOM DU MAILLAGE
!     NA     : EN 2D : NUMERO DU NOEUD DU FRONT DE FISSURE
!              EN 3D : NUMERO DU NOEUD SOMMET COURANT
!     NB     : EN 2D : NUMERO DU NOEUD DE LA LEVRE SUPERIEURE "ELOIGNE3 DU FOND
!              EN 3D : NUMERO DU NOEUD SOMMET SUIVANT
!     NDIM   : DIMENSION DU MAILLAGE
!
! SORTIES
!     VNOR   : VECTEUR NORMAL A LA SURFACE DE LA FISSURE
!     VDIR   : VECTEUR DANS LA DIRECTION DE PROPAGATION
!
!     ----------------------------------------------------
!

    real(kind=8) :: norme, nx, ny, nz
    real(kind=8) :: x1, x2, x21, y1, y2, y21, z1
    real(kind=8) :: z2, z21
    real(kind=8), pointer :: vale(:) => null()
!
!     -----------------------------------------------------------------
!
    call jemarq()

!     RECUPERATION DE L'ADRESSE DES COORDONNEES DES NOEUD DU FOND DE FISSURE
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
    
    nx = vnor(1,1)
    ny = vnor(1,2)
    nz = vnor(1,3)
!
    if (ndim.eq.2) then
!       CALCUL DU VECTEUR ALLANT DE B VERS A
        x1 = vale( (nb-1)*3 + 1 )
        y1 = vale( (nb-1)*3 + 2 )
        z1 = vale( (nb-1)*3 + 3 )
        x2 = vale( (na-1)*3 + 1 )
        y2 = vale( (na-1)*3 + 2 )
        z2 = vale( (na-1)*3 + 3 )

        x21 = x2-x1
        y21 = y2-y1
        z21 = z2-z1

!       ON SOUSTRAIT A CE VECTEUR SA COMPOSANTE SUIVANT LA NOMALE
        vdir(1,1) = x21 - (x21*nx+y21*ny+z21*nz)*nx
        vdir(1,2) = y21 - (x21*nx+y21*ny+z21*nz)*ny
        vdir(1,3) = z21 - (x21*nx+y21*ny+z21*nz)*nz
        
    else if(ndim.eq.3) then
    
!       CALCUL DU VECTEUR ALLANT DE B VERS A
        x1 = vale( (na-1)*3 + 1 )
        y1 = vale( (na-1)*3 + 2 )
        z1 = vale( (na-1)*3 + 3 )
        x2 = vale( (nb-1)*3 + 1 )
        y2 = vale( (nb-1)*3 + 2 )
        z2 = vale( (nb-1)*3 + 3 )

        x21 = x2-x1
        y21 = y2-y1
        z21 = z2-z1
!
!    CALCUL DU PRODUIT VECTORIEL : U VECT N , OU U EST LE VECTEUR ARETE
!
        vdir(1,1) = y21*nz - z21*ny
        vdir(1,2) = z21*nx - x21*nz
        vdir(1,3) = x21*ny - y21*nx

!
    else
        ASSERT(.FALSE.)
    endif
!
!    ON NORMALISE
!
        norme = sqrt(vdir(1,1)*vdir(1,1)+vdir(1,2)*vdir(1,2)+vdir(1,3)*vdir(1,3))
        vdir(1,1) = vdir(1,1)/norme
        vdir(1,2) = vdir(1,2)/norme
        vdir(1,3) = vdir(1,3)/norme
!
!    ON RECOPIE DANS VDIR(2,*) QUI EST IDENTIQUE DANS CE CAS   
        vdir(2,1) = vdir(1,1)
        vdir(2,2) = vdir(1,2)
        vdir(2,3) = vdir(1,3)

    call jedema()
end subroutine
