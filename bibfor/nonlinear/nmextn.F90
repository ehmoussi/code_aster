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

subroutine nmextn(field_disc, type_extr_cmp, type_extr_elem, type_extr, nb_node,&
                  nb_elem   , nb_cmp       , nb_poin       , nb_spoi  , nb_extr)
!
implicit none
!
#include "asterfort/nmexto.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=4), intent(in) :: field_disc
    integer, intent(in) :: nb_node
    integer, intent(in) :: nb_elem
    integer, intent(in) :: nb_poin
    integer, intent(in) :: nb_spoi
    integer, intent(in) :: nb_cmp
    character(len=8), intent(in) :: type_extr
    character(len=8), intent(in) :: type_extr_elem
    character(len=8), intent(in) :: type_extr_cmp
    integer, intent(out) :: nb_extr
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Extraction (OBSERVATION/SUIVI_DDL) utilities 
!
! Count number of extractions
!
! --------------------------------------------------------------------------------------------------
!
! In  field_disc       : localization of field (discretization: NOEU, ELGA or ELEM)
! In  type_extr        : type of extraction
! In  type_extr_elem   : type of extraction by element
! In  type_extr_cmp    : type of extraction for components
! In  nb_node          : number of nodes
! In  nb_elem          : number of elements
! In  nb_poin          : number of points (Gauss)
! In  nb_spoi          : number of subpoints
! In  nb_cmp           : number of components
! Out nb_extr          : number of extractions
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nfor, npoin, nlieu
!
! --------------------------------------------------------------------------------------------------
!
    nb_extr = 0
!
! - Number of components to extract
!
    call nmexto('COMP' , field_disc, type_extr_cmp, type_extr_elem, type_extr,&
                nb_node, nb_elem   , nb_cmp       , nb_poin       , nb_spoi  ,&
                nfor)
!
! - Number of points to extract
!
    call nmexto('POIN' , field_disc, type_extr_cmp, type_extr_elem, type_extr,&
                nb_node, nb_elem   , nb_cmp       , nb_poin       , nb_spoi  ,&
                npoin)
!
! - Number of localization to extract
!
    call nmexto('LIEU' , field_disc, type_extr_cmp, type_extr_elem, type_extr,&
                nb_node, nb_elem   , nb_cmp       , nb_poin       , nb_spoi  ,&
                nlieu)
!
! - Total of extraction
!
    nb_extr = nlieu * npoin * nfor
!
end subroutine
