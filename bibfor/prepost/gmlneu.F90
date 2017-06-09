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

subroutine gmlneu(igmsh, nbnode)
!.======================================================================
    implicit none
!
!      GMLNEU --   LECTURE DES NUMEROS DE NOEUDS ET DE LEURS
!                  COORDONNEES SUR LE FICHIER DE SORTIE DE GMSH
!
!   ARGUMENT        E/S  TYPE         ROLE
!    NBNODE         OUT   I         NOMBRE DE NOEUDS DU MAILLAGE
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: igmsh, nbnode
! -----  VARIABLES LOCALES
!
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!-----------------------------------------------------------------------
    integer :: imes, inode, jcoor, jdetr, jinfo, ndmax
    integer :: node
    real(kind=8) :: x, y, z
!-----------------------------------------------------------------------
    call jemarq()
!
! --- INITIALISATION :
!     --------------
    nbnode = 0
!
! --- RECUPERATION DES NUMEROS D'UNITE LOGIQUE :
!     ----------------------------------------
    imes = iunifi('MESSAGE')
!
! --- LECTURE DU NOMBRE DE NOEUDS :
!     ---------------------------
    read(igmsh,'(I10)') nbnode
!
! --- CREATION DE VECTEURS DE TRAVAIL :
!     -------------------------------
    call jedetr('&&PREGMS.INFO.NOEUDS')
    call jedetr('&&PREGMS.DETR.NOEUDS')
    call jedetr('&&PREGMS.COOR.NOEUDS')
!
    call wkvect('&&PREGMS.INFO.NOEUDS', 'V V I', nbnode, jinfo)
    call wkvect('&&PREGMS.COOR.NOEUDS', 'V V R', 3*nbnode, jcoor)
!
! --- LECTURE DES NUMEROS DE NOEUDS ET DE LEURS COORDONNEES :
!     -----------------------------------------------------
    ndmax = 0
    do 10 inode = 1, nbnode
!        READ(IGMSH,'(I10,3(E25.16))') NODE,X,Y,Z
        read(igmsh,*) node,x,y,z
        ndmax = max(node,ndmax)
!
        zi(jinfo+inode-1) = node
        zr(jcoor-1+3*(inode-1)+1) = x
        zr(jcoor-1+3*(inode-1)+2) = y
        zr(jcoor-1+3*(inode-1)+3) = z
!
10  end do
!
!
!    LISTE DES NOEUDS A DETRUIRE (0: A DETRUIRE, 1: A CONSERVER)
    call wkvect('&&PREGMS.DETR.NOEUDS', 'V V I', ndmax+1, jdetr)
    do 12 node = 0, ndmax
        zi(jdetr+node) = 0
12  end do
!
!
    write(imes,*) 'NOMBRE DE NOEUDS : ',nbnode
!
    call jedema()
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
