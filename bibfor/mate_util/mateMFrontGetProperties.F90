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
subroutine mateMFrontGetProperties(nomrc_mfront , l_mfront_func, l_mfront_anis,&
                                   mfront_nbvale, mfront_prop  , mfront_valr  , mfront_valk)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getmjm.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/gettco.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/mateMFrontToAsterProperties.h"
!
character(len=32), intent(inout) :: nomrc_mfront
aster_logical, intent(out) :: l_mfront_func, l_mfront_anis
integer, intent(out) :: mfront_nbvale
character(len=16), intent(out) :: mfront_prop(16)
real(kind=8), intent(out) :: mfront_valr(16)
character(len=16), intent(out) :: mfront_valk(16)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Get MFront keywords
!
! --------------------------------------------------------------------------------------------------
!
! In  nomrc_mfront     : name of material property for MFront (factor keyword)
! Out l_mfront_func    : .TRUE. if MFront properties are functions
! Out l_mfront_anis    : .TRUE. if MFront properties are anisotropic
! Out mfront_nbvale    : number of properties for NOMRC
! Out mfront_prop      : name of properties for NOMRC
! Out mfront_valr      : values of properties for NOMRC (real)
! Out mfront_valk      : values of properties for NOMRC (function)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: k16dummy, typeco
    integer :: i_prop, prop_nb, ind, n, idummy, indexE
    character(len=16) :: prop_valk
    real(kind=8) :: prop_valr
    character(len=8), pointer :: prop_type(:) => null()
    character(len=16), pointer :: prop_name(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    l_mfront_func  = ASTER_FALSE
    l_mfront_anis  = ASTER_FALSE
    mfront_nbvale  = 0
    mfront_valr(:) = r8nnem()
    mfront_valk(:) = ' '
    mfront_prop(:) = ' '
!
! - Get simple keywords under factor keyword
!
    call getmjm(nomrc_mfront, 1, 0, k16dummy, k16dummy, prop_nb)
    prop_nb = - prop_nb
    ASSERT(prop_nb .gt. 0)
    AS_ALLOCATE(vk8=prop_type , size=prop_nb)
    AS_ALLOCATE(vk16=prop_name, size=prop_nb)
    call getmjm(nomrc_mfront, 1, prop_nb, prop_name, prop_type, idummy)
!
! - Is function ?
!
    ind = index(nomrc_mfront,'_FO')
    l_mfront_func = ind .gt. 0
!
! - Get parameters
!
    do i_prop = 1, prop_nb
        call mateMFrontToAsterProperties(prop_name(i_prop),&
                                         index_ = indexE, l_anis_ = l_mfront_anis)
        if (indexE .gt. 0) then
            mfront_nbvale              = mfront_nbvale + 1
            mfront_prop(mfront_nbvale) = prop_name(i_prop)
            if (prop_type(i_prop)(1:2) .eq. 'R8') then
                call getvr8(nomrc_mfront, prop_name(i_prop), iocc=1, scal=prop_valr, nbret=n)
                mfront_valr(mfront_nbvale) = prop_valr
            elseif (prop_type(i_prop)(1:2) .eq. 'CO') then
                call getvid(nomrc_mfront, prop_name(i_prop), iocc=1, scal=prop_valk, nbret=n)
                call gettco(prop_valk, typeco)
                if (typeco == ' ') then
                    call utmess('F', 'FONCT0_71', sk=prop_name(i_prop))
                endif
                ASSERT(l_mfront_func)
                mfront_valk(mfront_nbvale) = prop_valk
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
    end do
    AS_DEALLOCATE(vk8=prop_type)
    AS_DEALLOCATE(vk16=prop_name)
!
end subroutine
