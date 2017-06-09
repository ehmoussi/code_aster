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

subroutine cldual_maj(list_load, disp)

implicit none

#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeexin.h"
#include "asterfort/load_list_info.h"
#include "asterfort/ischar_iden.h"
#include "asterfort/solide_tran_maj.h"
#include "asterfort/utmess.h"

!
    character(len=19), intent(in) :: list_load
    character(len=19), intent(in) :: disp
!
! --------------------------------------------------------------------------------------------------
!
! Loads - Computation
!
! Update dualized relations for non-linear Dirichlet boundary conditions (undead)
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load        : name of datastructure for list of loads
! In  disp             : displacements
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: dual_type
    character(len=8) :: load_name
    character(len=8), pointer :: dual_prdk(:) => null()
    character(len=8), pointer :: load_type(:) => null()
    character(len=13)  :: load_dual
    aster_logical :: ltran
    aster_logical :: load_empty
    integer :: nb_link,i_link,iexi
    integer :: i_load, nb_load
    integer :: i_load_diri
    aster_logical :: ischar_diri
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    i_load_diri = 0
    ltran       = .false._1
    ischar_diri = .false._1
!
! - Loads
!
    call load_list_info(load_empty, nb_load    , v_load_name, v_load_info,&
                        list_load_ = list_load)
    ASSERT(.not.load_empty)
!
! - Identify undead Dirichlet load
!
    do i_load = 1, nb_load
        ischar_diri = ischar_iden(v_load_info, i_load, nb_load, 'DIRI', 'SUIV')
        if (ischar_diri) then
            i_load_diri = i_load
!
! --------- Get load
!
            load_name = v_load_name(i_load_diri)(1:8)
            load_dual = load_name//'.DUAL'
!
! --------- Some checks
!
            call jeexin(load_name//'.DUAL.PRDK', iexi)
            ASSERT(iexi.gt.0)
            call jeveuo(load_name//'.TYPE', 'L', vk8=load_type)
            ASSERT(load_type(1).eq.'MECA_RE')
!
! --------- Datastructure access
!
            call jeveuo(load_dual//'.PRDK', 'L', vk8=dual_prdk)
            call jelira(load_dual//'.PRDK', 'LONUTI', ival=nb_link)
!
! --------- Find type of dual relation
!
            do i_link = 1,nb_link
               dual_type = dual_prdk(i_link)
               if (dual_type.eq.' ' .or. dual_type.eq.'LIN') then
! -------- Nothing to do
               else if (dual_type(1:2).eq.'2D' .or.  dual_type(1:2).eq.'3D') then
                   ltran=.true._1
               else if (dual_type.eq.'NLIN') then
!                  -- Le nom de la charge est malheureusement inexploitable.
!                     C'est une copie temporaire.
                   call utmess('F','CHARGES_30')
               else
!                  --  par exemple : 'ROTA3D', ...
                   call utmess('F','CHARGES_30')
               endif
            enddo
!
! --------- Update for LIAISON_SOLIDE
!
            if (ltran) then
                call solide_tran_maj(load_name, disp)
            endif
        endif
    end do
!
    call jedema()
end subroutine
