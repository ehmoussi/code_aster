! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine numcch(modelz, list_loadz, list_ligr, nb_ligr)
!
implicit none
!
#include "asterfort/dismoi.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/as_allocate.h"
!
!
    character(len=*), intent(in) :: modelz
    character(len=*), intent(in) :: list_loadz
    character(len=24), pointer :: list_ligr(:)
    integer, intent(out) :: nb_ligr
!
! --------------------------------------------------------------------------------------------------
!
! Factor
!
! Create list of LIGREL for numbering - For loads
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  load_list      : list of loads
! In  list_ligr      : pointer to list of LIGREL
! In  nb_ligr        : number of LIGREL in list
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: ligr_name, list_load
    integer :: nb_list_ligr
    integer :: i_load, iret, ier
    character(len=24), pointer :: l_load_name(:) => null()
    character(len=8), pointer :: load_type(:) => null()
    character(len=24) :: list_load_name
    character(len=8) :: model, load_name
    integer :: nb_load
!
! --------------------------------------------------------------------------------------------------
!
    list_load = list_loadz
    model     = modelz
    nb_ligr   = 0
!
! - List of load names
!
    list_load_name = list_load//'.LCHA'
    nb_load = 0
    call jeexin(list_load_name, iret)
    if (iret .ne. 0) then
        call jelira(list_load_name, 'LONMAX', nb_load)
        call jeveuo(list_load_name, 'L', vk24 = l_load_name)
    endif
    nb_list_ligr = nb_load+1
!
! - Create object
!
    AS_ALLOCATE(vk24 = list_ligr, size = nb_list_ligr)
!
! - LIGREL for model
!
    call jeexin(model//'.MODELE    .NBNO', iret)
    if (iret .gt. 0) then
        nb_ligr = 1
        list_ligr(nb_ligr) = model(1:8)//'.MODELE'
    endif
!
! - LIGREL for loads
!
    do i_load = 1, nb_load
        load_name = l_load_name(i_load)(1:8)
        call jeexin(load_name(1:8)//'.TYPE', ier)
        if (ier .gt. 0) then
            call jeveuo(load_name(1:8)//'.TYPE', 'L', vk8 = load_type)
            ligr_name = load_name(1:8)//'.CH'//load_type(1)(1:2)// '.LIGRE'
            call jeexin(ligr_name(1:19)//'.LIEL', iret)
        else
            iret = 0
        endif
        if (iret .gt. 0) then
            nb_ligr = nb_ligr + 1
            list_ligr(nb_ligr) = ligr_name
        endif
    end do
!
end subroutine
