! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romGetListComponents(field_refe , nb_equa   ,&
                                v_equa_type, v_list_cmp,&
                                nb_cmp     , l_lagr)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jelira.h"
#include "asterfort/as_allocate.h"
!
character(len=24), intent(in) :: field_refe
integer, intent(in) :: nb_equa
integer, pointer :: v_equa_type(:)
character(len=8), pointer :: v_list_cmp(:)
integer, intent(out) :: nb_cmp
aster_logical, intent(out) :: l_lagr
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Get list of components in field
!
! --------------------------------------------------------------------------------------------------
!
! In  field_refe       : field to analyze
! In  nb_equa          : number of equations (length of empiric mode)
! In  v_equa_type      : pointer to name of component for each dof (-1 if Lagrange multiplier)
! In  v_list_cmp       : pointer to list of components
! Out nb_cmp           : length of v_list_type
! Out l_lagr           : flag if vector contains at least one Lagrange multiplier
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: gran_name, name_cmp
    character(len=19) :: pfchno
    integer :: i_equa, nb_lagr, nume_cmp, nb_cmp_maxi, indx_cmp
    integer, pointer :: v_deeq(:) => null()
    character(len=8), pointer :: v_cmp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    l_lagr = ASTER_FALSE
!
! - Get list of components on physical_quantities
!
    call dismoi('NOM_GD', field_refe, 'CHAM_NO', repk = gran_name)
    call jelira(jexnom('&CATA.GD.NOMCMP', gran_name), 'LONMAX', nb_cmp_maxi)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', gran_name), 'L', vk8 = v_cmp)
!
! - Access to numbering
!
    call dismoi('PROF_CHNO' , field_refe, 'CHAM_NO', repk = pfchno)
    call jeveuo(pfchno//'.DEEQ', 'L', vi = v_deeq)
!
! - Allocate lists
!
    AS_ALLOCATE(vk8 = v_list_cmp, size = nb_cmp_maxi)
    AS_ALLOCATE(vi = v_equa_type, size = nb_equa)
!
! - Count
!
    nb_lagr = 0
    nb_cmp  = 0
    do i_equa = 1, nb_equa
        nume_cmp = v_deeq(2*(i_equa-1)+2)
        if (nume_cmp .gt. 0) then
            name_cmp = v_cmp(nume_cmp)
            indx_cmp = indik8(v_list_cmp, name_cmp, 1, nb_cmp)
            if (indx_cmp .eq. 0) then
                nb_cmp   = nb_cmp + 1
                v_list_cmp(nb_cmp) = name_cmp
                indx_cmp = nb_cmp
            endif
            v_equa_type(i_equa) = indx_cmp
        else
            nb_lagr = nb_lagr + 1
            v_equa_type(i_equa) = -1
        endif
    end do
    l_lagr = nb_lagr .gt. 0
!
end subroutine
