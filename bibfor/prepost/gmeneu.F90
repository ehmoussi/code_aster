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

subroutine gmeneu(imod, nbnode)
!.======================================================================
    implicit none
!
!      GMENEU --   ECRITURE DES NUMEROS DE NOEUDS ET DE LEURS
!                  COORDONNEES VENANT D'UN FICHIER .GMSH DANS
!                  UN FICHIER .MAIL
!
!   ARGUMENT        E/S  TYPE         ROLE
!    NBNODE         IN    I         NOMBRE DE NOEUDS DU MAILLAGE
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/codnop.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jjmmaa.h"
    integer :: imod, nbnode
! -----  VARIABLES LOCALES
    character(len=1) :: prfnoe
    character(len=4) :: ct(3)
    character(len=8) :: chnode
    character(len=12) :: chenti, aut
    character(len=80) :: chfone
!
!
!.========================= DEBUT DU CODE EXECUTABLE ==================
!-----------------------------------------------------------------------
    integer :: inode,    node
    real(kind=8) :: x, y, z
    real(kind=8), pointer :: coor(:) => null()
    integer, pointer :: detr(:) => null()
    integer, pointer :: info(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
!
! --- INITIALISATIONS :
!     ---------------
    chnode = '        '
    prfnoe = 'N'
    chfone = '%FORMAT=(1*NOM_DE_NOEUD,3*COORD)'
    chenti = 'NBOBJ=      '
    call codent(nbnode, 'G', chenti(7:12))
!
! --- DATE :
!     ----
    call jjmmaa(ct, aut)
!
! --- RECUPERATION DES VECTEURS DE TRAVAIL :
!     ------------------------------------
    call jeveuo('&&PREGMS.INFO.NOEUDS', 'L', vi=info)
    call jeveuo('&&PREGMS.DETR.NOEUDS', 'L', vi=detr)
    call jeveuo('&&PREGMS.COOR.NOEUDS', 'L', vr=coor)
!
    call codnop(chnode, prfnoe, 1, 1)
!
    write(imod,'(A,4X,A)')'COOR_3D',chenti
    write(imod,'(A)') chfone
!
! --- ECRITURE DES NUMEROS DE NOEUDS ET DE LEURS COORDONNEES :
!     ------------------------------------------------------
    do 20 inode = 1, nbnode
        node = info(inode)
!
!      ON N'ECRIT PAS LES NOEUDS ORPHELINS
        if (detr(node+1) .eq. 0) goto 20
!
        x = coor(3*(inode-1)+1)
        y = coor(3*(inode-1)+2)
        z = coor(3*(inode-1)+3)
!
        call codent(node, 'G', chnode(2:8))
        write(imod,'(2X,A,2X,3(1PE21.14),1X)') chnode,x,y,z
!
20  end do
!
    write(imod,'(A)') 'FINSF'
    write(imod,'(A)') '%'
!
    call jedema()
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
