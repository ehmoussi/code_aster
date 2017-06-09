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

subroutine nbzoco(keywf, mesh, i_zone, nb_cont_surf)
!
implicit none
!
#include "asterfort/getvtx.h"
#include "asterfort/verima.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: i_zone
    integer, intent(out) :: nb_cont_surf
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Count number of surfaces of contact
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read
! In  mesh             : name of mesh
! In  i_zone           : index of contact zone
! Out nb_cont_surf     : number of surfaces of contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_group_mast, nb_group_slav, nb_mast, nb_slav
    character(len=24) :: list_elem
!
! --------------------------------------------------------------------------------------------------
!
    nb_cont_surf  = 0
    nb_group_mast = 0
    nb_group_slav = 0
    nb_mast       = 0
    nb_slav       = 0
!
! - Number of master elements
!
    call getvtx(keywf, 'GROUP_MA_MAIT', iocc=i_zone, vect=list_elem,&
                nbret=nb_group_mast)
    if (nb_group_mast .ne. 0) then
        call verima(mesh, list_elem, nb_group_mast, 'GROUP_MA')
    endif
    call getvtx(keywf, 'MAILLE_MAIT', iocc=i_zone, vect=list_elem,&
                nbret=nb_mast)
    if (nb_mast .ne. 0) then
        call verima(mesh, list_elem, nb_mast, 'MAILLE')
    endif
!
! - Number of slave elements
!
    call getvtx(keywf, 'GROUP_MA_ESCL', iocc=i_zone, vect=list_elem,&
                nbret=nb_group_slav)
    if (nb_group_slav .ne. 0) then
        call verima(mesh, list_elem, nb_group_slav, 'GROUP_MA')
    endif
    call getvtx(keywf, 'MAILLE_ESCL', iocc=i_zone, vect=list_elem,&
                nbret=nb_slav)
    if (nb_group_slav .ne. 0) then
        call verima(mesh, list_elem, nb_slav, 'MAILLE')
    endif
!
! - Total number of contact surfaces
!
    if (nb_group_mast .ne. 0) then
        nb_cont_surf = nb_cont_surf + 1
    endif
    if (nb_group_slav .ne. 0) then
        nb_cont_surf = nb_cont_surf + 1
    endif
    if (nb_mast .ne. 0) then
        nb_cont_surf = nb_cont_surf + 1
    endif
    if (nb_slav .ne. 0) then
        nb_cont_surf = nb_cont_surf + 1
    endif
!
end subroutine
