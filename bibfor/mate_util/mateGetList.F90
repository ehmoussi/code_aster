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
!
subroutine mateGetList(mate_nb_read , v_mate_read  ,&
                       l_mfront_elas,&
                       l_elas       , l_elas_func  , l_elas_istr,&
                       l_elas_orth  , l_elas_meta  ,&
                       i_mate_elas  , i_mate_mfront)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getmat.h"
#include "asterc/getmjm.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/utmess.h"
!
integer, intent(out) :: mate_nb_read
character(len=32), pointer, intent(out) :: v_mate_read(:)
aster_logical, intent(out) :: l_mfront_elas
aster_logical, intent(out) :: l_elas, l_elas_func
aster_logical, intent(out) :: l_elas_istr, l_elas_orth, l_elas_meta
integer, intent(out) :: i_mate_elas, i_mate_mfront
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Get list of materials
!
! --------------------------------------------------------------------------------------------------
!
! Out mate_nb_read     : number of material factor keywords
! Out v_mate_read      : list of material factor keywords
! Out l_mfront_elas    : .TRUE. if MFront material is present
! Out l_elas           : .TRUE. if elastic material (isotropic) is present
! Out l_elas_func      : .TRUE. if elastic material (function, isotropic) is present
! Out l_elas_istr      : .TRUE. if elastic material (transverse isotropic) is present
! Out l_elas_orth      : .TRUE. if elastic material (orthotropic) is present
! Out l_elas_meta      : .TRUE. if elastic material (metallurgy) is present
! Out i_mate_elas      : index of ELAS properties in list of material properties
! Out i_mate_mfront    : index of MFront/Elasticity properties in list of material properties
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: k16dummy
    integer :: i_mate, prop_nb, i_keyw, idummy, i_prop
    character(len=32) :: nomrc
    integer, parameter :: nb_keyw_mfront = 13
    character(len=16), parameter :: mfront_keyw(nb_keyw_mfront) = &
            (/'YoungModulus    ','PoissonRatio    ','ThermalExpansion',&
              'MassDensity     ',&
              'YoungModulus1   ','YoungModulus2   ','YoungModulus3   ',&
              'PoissonRatio12  ','PoissonRatio23  ','PoissonRatio13  ',&
              'ShearModulus12  ','ShearModulus23  ','ShearModulus13  '/)
    character(len=8), pointer :: prop_type(:) => null()
    character(len=16), pointer :: prop_name(:) => null()
    aster_logical :: l_mfront_prop
!
! --------------------------------------------------------------------------------------------------
!
    i_mate_mfront = 0
    i_mate_elas   = 0
    l_elas        = ASTER_FALSE
    l_elas_func   = ASTER_FALSE
    l_elas_istr   = ASTER_FALSE
    l_elas_orth   = ASTER_FALSE
    l_mfront_elas = ASTER_FALSE
!
! - Get parameters from _catalog_
!
    mate_nb_read = -1
    call getmat(mate_nb_read, k16dummy)
    ASSERT(mate_nb_read .gt. 0) 
    AS_ALLOCATE(vk32 = v_mate_read, size = mate_nb_read)
    call getmat(mate_nb_read, v_mate_read)
!
! - Get special material
!
    do i_mate = 1, mate_nb_read
! ----- Get properties
        nomrc   = v_mate_read(i_mate)
        call getmjm(nomrc, 1, 0, k16dummy, k16dummy, prop_nb)
        prop_nb = -prop_nb
        ASSERT(prop_nb .gt. 0)
        AS_ALLOCATE(vk8=prop_type , size=prop_nb)
        AS_ALLOCATE(vk16=prop_name, size=prop_nb)
        call getmjm(nomrc, 1, prop_nb, prop_name, prop_type, idummy)
! ----- Detect ELAS MFront properties
        l_mfront_prop = ASTER_FALSE
        do i_prop = 1, prop_nb 
            do i_keyw = 1, nb_keyw_mfront
                if (prop_name(i_prop) .eq. mfront_keyw(i_keyw)) then
                    l_mfront_prop = ASTER_TRUE
                    i_mate_mfront = i_mate
                endif
            end do
        end do
        if (l_mfront_prop) then
            if (l_mfront_elas) then
                call utmess('F', 'MATERIAL2_2')
            else
                l_mfront_elas = ASTER_TRUE
            endif
        endif
! ----- Detect elasticity properties
        if (nomrc .eq. 'ELAS') then
            l_elas      = ASTER_TRUE
            i_mate_elas = i_mate
        endif
        if (nomrc .eq. 'ELAS_FO') then
            l_elas      = ASTER_TRUE
            l_elas_func = ASTER_TRUE
            i_mate_elas = i_mate
        endif
        if (nomrc .eq. 'ELAS_ISTR') then
            l_elas_istr = ASTER_TRUE
            i_mate_elas = i_mate
        endif
        if (nomrc .eq. 'ELAS_ISTR_FO') then
            l_elas_istr = ASTER_TRUE
            l_elas_func = ASTER_TRUE
            i_mate_elas = i_mate
        endif
        if (nomrc .eq. 'ELAS_ORTH') then
            l_elas_orth = ASTER_TRUE
            i_mate_elas = i_mate
        endif
        if (nomrc .eq. 'ELAS_ORTH_FO') then
            l_elas_orth = ASTER_TRUE
            l_elas_func = ASTER_TRUE
            i_mate_elas = i_mate
        endif
        if (nomrc .eq. 'ELAS_META') then
            l_elas_meta = ASTER_TRUE
            i_mate_elas = i_mate
        endif
        if (nomrc .eq. 'ELAS_META_FO') then
            l_elas_meta = ASTER_TRUE
            l_elas_func = ASTER_TRUE
            i_mate_elas = i_mate
        endif
! ----- Clean
        AS_DEALLOCATE(vk8=prop_type)
        AS_DEALLOCATE(vk16=prop_name)
    end do
!
end subroutine
