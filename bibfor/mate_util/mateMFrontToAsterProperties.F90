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
subroutine mateMFrontToAsterProperties(mfront_name, aster_name_, index_, l_anis_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
character(len=16), intent(inout) :: mfront_name
character(len=16), optional, intent(inout) :: aster_name_
integer, optional, intent(out) :: index_
aster_logical, optional, intent(out) :: l_anis_
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Change name of properties from MFront to Aster or from Aster to MFront
!
! --------------------------------------------------------------------------------------------------
!
! IO  mfront_name      : name of property (MFront)
!                        if mfront_name = ' ' => looking from aster_name
! IO  aster_name       : name of property (Aster)
!                        if aster_name = ' ' => looking from mfront_name
! Out index            : index of property (<> 0 if exists !)
! Out l_anis           : if keyword is for anisotropic elasticity
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_find_mfront
    integer :: indexE, i_keyw
    integer, parameter :: ianis = 5
    integer, parameter :: nb_keyw_max = 13
    character(len=16) :: aster_name
    character(len=16), parameter :: mfront_keyw(nb_keyw_max) = &
            (/'YoungModulus    ','PoissonRatio    ','ThermalExpansion',&
              'MassDensity     ',&
              'YoungModulus1   ','YoungModulus2   ','YoungModulus3   ',&
              'PoissonRatio12  ','PoissonRatio23  ','PoissonRatio13  ',&
              'ShearModulus12  ','ShearModulus23  ','ShearModulus13  '/)
    character(len=16), parameter :: aster_keyw(nb_keyw_max) = &
            (/'E               ','NU              ','ALPHA           ',&
              'RHO             ',&
              'E_L             ','E_T             ','E_N             ',&
              'NU_LT           ','NU_TN           ','NU_LN           ',&
              'G_LT            ','G_TN            ','G_LN            '/)
!
! --------------------------------------------------------------------------------------------------
!
    indexE        = 0
    l_find_mfront = mfront_name .eq. ' '
!
! - Find name of property for ELAS
!
    do i_keyw = 1, nb_keyw_max
        if (l_find_mfront) then
            ASSERT(present(aster_name_))
            if (aster_name_ .eq. aster_keyw(i_keyw)) then
                indexE      = i_keyw
                mfront_name = mfront_keyw(indexE)
                exit
            endif
        else
            if (mfront_name .eq. mfront_keyw(i_keyw)) then
                indexE     = i_keyw
                aster_name = aster_keyw(indexE)
                exit
            endif
        endif
    end do
!
    if (present(aster_name_)) then
        aster_name_ = aster_name
    endif
    if (present(index_)) then
        index_ = indexE
    endif
    if (present(l_anis_)) then
        if (indexE .eq. ianis) then
            l_anis_ = ASTER_TRUE
        else
            l_anis_ = ASTER_FALSE
        endif
    endif
!
end subroutine
