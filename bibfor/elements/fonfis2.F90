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

subroutine fonfis2(noma, nbnoff, fonoeu, absfon)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/wkvect.h"
!
    integer :: nbnoff

    character(len=8) :: noma
    character(len=24) :: absfon, fonoeu
!
!
!     ----------------------------------------------------------------
! FONCTION REALISEE:
!
!     POUR CHAQUE NOEUD DU FOND DE FISSURE ON RECUPERE SES
!     COORDONNEES ET ON CALCULE SON ABSCISSE CURVILIGNE
!
!     ------------------------------------------------------------------
! ENTREE:
!        NOMA   : NOM DU MAILLAGE
!        NBNOFF : NOMBRE DE NOEUDS AU FOND DE FISSURE
!        FONOEU : NOMS DES NOEUDS DU FOND DE FISSURE
!
! SORTIE:
!        ABSFON : VECTEUR .ABSFON CONTENANT LES ABSCISSES 
!                 CURVILIGNES DES NOEUDS DU FOND
!     ------------------------------------------------------------------
!
!
    integer :: i, iabsfon,  jnoe, ni, nj
    real(kind=8) :: absci, coori(3), coorj(3), norm, xij, yij, zij
    real(kind=8), pointer :: vale(:) => null()
!
!
    call jemarq()
!
!     ADRESSES DES COORDONNEES DES NOEUDS DU MAILLAGE
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
!
!     ALLOCATION DU VECTEUR DES COORDONNEES ET DES ABSCISSES CURVILIGNES
!     DES NOEUDS DU FOND
    call wkvect(absfon, 'G V R', nbnoff, iabsfon)
!
!     RECUPERATION DES NOMS DES NOEUDS DU FOND DE FISSURE
    call jeveuo(fonoeu, 'L', jnoe)
!
!     RECUPERATION DES COORDONNNES DE NI
    call jenonu(jexnom(noma//'.NOMNOE', zk8(jnoe)), ni)
!
    coori(1) = vale((ni-1)*3 + 1)
    coori(2) = vale((ni-1)*3 + 2)
    coori(3) = vale((ni-1)*3 + 3)
!
!     REMPLISSAGE DE .FONDFISS DANS LA SD_FOND_FISS :
!     DONNEES DU CAS 2D OU DU PREMIER NOEUD POUR LE CAS 3D
     zr(iabsfon-1 + 1) = 0.d0
!
!     REMPLISSAGE DE .FONDFISS DANS LA SD_FOND_FISS: CAS 3D
    if (nbnoff .ne. 1) then
        do i = 2, nbnoff
!
!         NUMEROS (ABSOLUS) DES NOEUDS DU FOND: NI ET NJ
            call jenonu(jexnom(noma//'.NOMNOE', zk8(jnoe-1+i-1)), ni)
            call jenonu(jexnom(noma//'.NOMNOE', zk8(jnoe-1+i)), nj)
!
!         COORDONNEES DES NOEUDS I ET J
            coori(1) = vale((ni-1)*3 + 1)
            coori(2) = vale((ni-1)*3 + 2)
            coori(3) = vale((ni-1)*3 + 3)
!
            coorj(1) = vale((nj-1)*3 + 1)
            coorj(2) = vale((nj-1)*3 + 2)
            coorj(3) = vale((nj-1)*3 + 3)
!
!         CALCUL DES ABSCISSES CURVILIGNES

            xij = coorj(1) - coori(1)
            yij = coorj(2) - coori(2)
            zij = coorj(3) - coori(3)
            norm = sqrt(xij*xij + yij*yij + zij*zij)
            absci = zr(iabsfon-1 + (i-2) + 1)
!
            zr(iabsfon-1 + (i-1) + 1) = absci + norm
        enddo
    endif
!
    call jedema()
end subroutine
