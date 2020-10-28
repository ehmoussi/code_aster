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
!
subroutine cm09nd(nb_node_mesh, add_node_total_face, add_node_total_bary, prefix, ndinit, &
                  nb_list_elem, nbno_fac, nbfac_modi, nomipe, nobary, &
                  mesh_out, coor)
implicit none
!
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jexnom.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: nb_list_elem, nbno_fac, nbfac_modi
integer, intent(in) :: nb_node_mesh, add_node_total_face, add_node_total_bary, ndinit
integer, intent(in) :: nomipe(nbno_fac, nbfac_modi*nb_list_elem)
integer, intent(in) :: nobary(4, nb_list_elem)
real(kind=8), intent(inout) :: coor(3, *)
character(len=8) , intent(in) :: prefix
character(len=8), intent(in) :: mesh_out
!
! ----------------------------------------------------------------------
!         CREATION DES NOEUDS MILIEUX ET DU BARYCENTRE
! ----------------------------------------------------------------------
! IN        nb_node_mesh    NOMBRE TOTAL DE NOEUDS DU MAILLAGE
! IN        add_node_total_face  NOMBRE DE NOEUDS CREES DES FACES
! IN        add_node_total_bary  NOMBRE DE NOEUDS CREES DES BARYCENTRES
! IN        PREFIX  PREFIXE POUR LE NOM DES NOEUDS (EX : N, NS, ...)
! IN        NDINIT  NUMERO INITIAL DES NOEUDS CREES
! IN        NOMIPE  LISTE DES PERES PAR NOEUDS CREES (NOEUDS SOMMETS)
! IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
! VAR       COOR    COORDONNEES DES NOEUDS
! ----------------------------------------------------------------------
!
!
    integer :: i_node, lgpref, lgnd, iret, i
    integer :: noeud(4)
    character(len=8) :: node_name
    character(len=80) :: knume
!
! ----------------------------------------------------------------------
    call jemarq()
!
! - New names
!
    lgpref = lxlgut(prefix)
    do i_node = 1, add_node_total_face + add_node_total_bary
! ----- Generate name
        call codent(ndinit-1+i_node, 'G', knume)
        lgnd = lxlgut(knume)
        if (lgnd+lgpref .gt. 8) then
            call utmess('F', 'ALGELINE_16')
        endif
        node_name = prefix(1:lgpref) // knume
! ----- Add name
        call jeexin(jexnom(mesh_out//'.NOMNOE', node_name), iret)
        if (iret .eq. 0) then
            call jecroc(jexnom(mesh_out//'.NOMNOE', node_name))
        else
            call utmess('F', 'ALGELINE4_5', sk=node_name)
        endif
    end do
!
! - New coordinates
!
    do i_node = 1, add_node_total_face
        noeud(1:3) = nomipe(1:3,i_node)
        do i = 1, 3
            coor(:, i_node+nb_node_mesh) = coor(:, i_node+nb_node_mesh) +&
                                           coor(:, noeud(i)) / 3.d0

        end do
    end do
!
    do i_node = 1, add_node_total_bary
        noeud(1:4) = nobary(1:4,i_node)
        do i = 1, 4
            coor(:, i_node+nb_node_mesh) = coor(:, i_node+nb_node_mesh) +&
                                           coor(:, noeud(i)) / 4.d0

        end do
    end do
!
    call jedema()
!
end subroutine
