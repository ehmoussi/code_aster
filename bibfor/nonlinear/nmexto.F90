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

subroutine nmexto(type_count, field_disc, type_extr_cmp, type_extr_elem, type_extr,&
                  nb_node   , nb_elem   , nb_cmp       , nb_poin       , nb_spoi  ,&
                  nb_count)
!
implicit none
!
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=4), intent(in) :: type_count
    character(len=4), intent(in) :: field_disc
    integer, intent(in) :: nb_node
    integer, intent(in) :: nb_elem
    integer, intent(in) :: nb_poin
    integer, intent(in) :: nb_spoi
    integer, intent(in) :: nb_cmp
    character(len=8), intent(in) :: type_extr
    character(len=8), intent(in) :: type_extr_elem
    character(len=8), intent(in) :: type_extr_cmp
    integer, intent(out) :: nb_count
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Extraction (OBSERVATION/SUIVI_DDL) utilities 
!
! Count number of extractions - By type
!
! --------------------------------------------------------------------------------------------------
!
!
! In  type_count       : type of count
!      'COMP' : NOMBRE DE COMPOSANTES
!      'POIN' : NOMBRE DE POINTS
!      'LIEU' : NOMBRE DE LIEUX
! In  field_disc       : localization of field (discretization: NOEU, ELGA or ELEM)
! In  type_extr        : type of extraction
! In  type_extr_elem   : type of extraction by element
! In  type_extr_cmp    : type of extraction for components
! In  nb_node          : number of nodes
! In  nb_elem          : number of elements
! In  nb_poin          : number of points (Gauss)
! In  nb_spoi          : number of subpoints
! In  nb_cmp           : number of components
! In  nb_count         : number of count
!
! --------------------------------------------------------------------------------------------------
!
    nb_count = 0
!
    if (type_count .eq. 'COMP') then
        if (type_extr_cmp .eq. ' ') then
            nb_count = nb_cmp
        else
            nb_count = 1
        endif
    else if (type_count.eq.'POIN') then
        if (field_disc .eq. 'ELGA' .or. field_disc.eq.'ELEM') then
            if (type_extr_elem .eq. 'VALE') then
                nb_count = nb_poin*nb_spoi
            elseif ((type_extr_elem.eq.'MIN').or.&
                    (type_extr_elem.eq.'MAX').or.&
                    (type_extr_elem.eq.'MOY')) then
                nb_count = 1
            else
                ASSERT(.false.)
            endif
        else if (field_disc.eq.'NOEU') then
            nb_count = 1
        else
            ASSERT(.false.)
        endif
    else if (type_count.eq.'LIEU') then
        if (field_disc .eq. 'NOEU') then
            if (type_extr .eq. 'VALE') then
                nb_count = nb_node
            elseif ((type_extr.eq.'MIN').or.&
                    (type_extr.eq.'MAX').or.&
                    (type_extr.eq.'MAXI_ABS').or.&
                    (type_extr.eq.'MINI_ABS').or.&
                    (type_extr.eq.'MOY')) then
                nb_count = 1
            else
                ASSERT(.false.)
            endif
        else if (field_disc.eq.'ELGA' .or. field_disc.eq.'ELEM') then
            if (type_extr .eq. 'VALE') then
                nb_count = nb_elem
            elseif ((type_extr.eq.'MIN').or.&
                    (type_extr.eq.'MAX').or.&
                    (type_extr.eq.'MAXI_ABS').or.&
                    (type_extr.eq.'MINI_ABS').or.&
                    (type_extr.eq.'MOY')) then
                nb_count = 1
            else
                ASSERT(.false.)
            endif
        else
            ASSERT(.false.)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
