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

subroutine xlagsc(nb_dim, nb_node_mesh, nb_edge, nb_edge_max, algo_lagr,&
                  jtabno, jtabin      , jtabcr , crack      , sdline_crack,&
                  l_pilo, tabai, l_ainter)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedetr.h"
#include "asterfort/wkvect.h"
#include "asterfort/xrell1.h"
#include "asterfort/xrell2.h"
#include "asterfort/xrell3.h"
#include "asterfort/xsella.h"
!
!
    integer, intent(in) :: jtabno
    integer, intent(in) :: jtabin
    integer, intent(in) :: jtabcr
    integer, intent(in) :: nb_node_mesh
    integer, intent(in) :: nb_edge
    integer, intent(in) :: nb_dim
    integer, intent(in) :: nb_edge_max
    integer, intent(in) :: algo_lagr
    character(len=14), intent(in) :: sdline_crack
    character(len=8), intent(in) :: crack
    aster_logical, intent(in) :: l_pilo, l_ainter
    character(len=19) :: tabai

!
! --------------------------------------------------------------------------------------------------
!
! XFEM - Contact definition
!
! Create list of linear relations for equality between Lagrange
!
! --------------------------------------------------------------------------------------------------
!
! (VOIR BOOK VI 15/07/05) :
!    - DETERMINATION DES NOEUDS
!    - CREATION DES RELATIONS DE LIAISONS ENTRE LAGRANGE
!
! --------------------------------------------------------------------------------------------------
!
! In  crack          : name of crack 
! In  nb_dim         : dimension of space
! In  nb_node_mesh   : number of (physical) nodes in mesh
! In  nb_edge        : number of cut edges
! In  nb_edge_max    : number maximum of edges
! In  algo_lagr      : type of Lagrange multiplier space selection
! In  sdline_crack   : name of datastructure of linear relations for crack
! In  jtabno         : adress of table of nodes for edges (middle et vertex nodes)
! In  jtabin         : adress of table of intersection points
! In  jtabcr         : adress of table of score
! In  l_pilo         : .true. if creation of linear relations for continuation method (PILOTAGE)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpino
    integer :: nb_node_sele
    aster_logical :: l_create_group
!
! --------------------------------------------------------------------------------------------------
!
    l_create_group = .false.
    if (algo_lagr .eq. 1) then
!
! ----- Table of nodes
!
        call wkvect('&&XLAGSP.PICKNO', 'V V I', nb_edge_max, jpino)
!
! ----- Selection of edges
!
        call xsella(crack       , nb_node_mesh, nb_edge, zi(jtabno), zi(jpino),&
                    nb_node_sele)
!
! ----- Create list of linear relations (algorithm 1)
!
        call xrell1(zi(jtabno)  , nb_edge, zi(jpino), nb_node_sele, sdline_crack,&
                       tabai, l_ainter)

    else if (algo_lagr.eq.2) then
!
! ----- Create list of linear relations (algorithm 2)
!
        call xrell2(zi(jtabno)    , nb_dim      , nb_edge, zr(jtabin), zr(jtabcr),&
                    l_create_group, sdline_crack, l_pilo, tabai, l_ainter)

    else if (algo_lagr.eq.3) then
!
! ----- Create list of linear relations (algorithm 3)
!
        call xrell3(zi(jtabno), nb_edge, crack, sdline_crack,&
                    zr(jtabcr), tabai, l_ainter)

    endif
!
    call jedetr('&&XLAGSP.PICKNO')

end subroutine
