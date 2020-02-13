! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine mateMFrontCheck(l_mfront_func, l_mfront_anis ,&
                           noobrc_elas  , l_elas        , l_elas_func, l_elas_istr, l_elas_orth,&
                           mfront_nbvale, mfront_prop   , mfront_valr, mfront_valk)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/mateMFrontToAsterProperties.h"
!
aster_logical, intent(in) :: l_mfront_func, l_mfront_anis
character(len=19), intent(in) :: noobrc_elas
aster_logical, intent(in) :: l_elas, l_elas_func, l_elas_istr, l_elas_orth
integer, intent(in) :: mfront_nbvale
character(len=16), intent(in) :: mfront_prop(16)
real(kind=8), intent(in) :: mfront_valr(16)
character(len=16), intent(in) :: mfront_valk(16)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Check consistency between MFront/Elasticity and ELAS
!
! --------------------------------------------------------------------------------------------------
!
! In  l_mfront_func    : .TRUE. if MFront properties are functions
! In  l_mfront_anis    : .TRUE. if MFront properties are anisotropic
! In  noobrc_elas      : name of .CPT object for ELAS
! In  l_elas           : .TRUE. if elastic material (isotropic) is present
! In  l_elas_func      : .TRUE. if elastic material (function, isotropic) is present
! In  l_elas_istr      : .TRUE. if elastic material (transverse isotropic) is present
! In  l_elas_orth      : .TRUE. if elastic material (orthotropic) is present
! In  mfront_nbvale    : number of properties for NOMRC
! In  mfront_prop      : name of properties for NOMRC
!                        if create properties, mfront_prop is changed to the ASTER keyword
! In  mfront_valr      : values of properties for NOMRC (real)
! In  mfront_valk      : values of properties for NOMRC (function)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_mfront, i_prop_r, i_prop_k
    integer :: nb_prop, indexE
    integer :: nb_prop_r, nb_prop_c, nb_prop_k2, nb_prop_k
    character(len=16) :: mf_prop_name, valk(4)
    character(len=16) :: mf_prop_valk, as_prop_valk, prop_name, prop_name_mf
    real(kind=8) :: mf_prop_valr, as_prop_valr, test, valr(2)
    aster_logical :: l_prop_find
    character(len=16), pointer :: v_valk(:) => null()
    real(kind=8), pointer :: v_valr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!

!
! - Inconsistency (isotropy/anisotropy)
!
    if (l_mfront_anis) then
        if (l_elas) then
            call utmess('F', 'MATERIAL2_5')
        endif
    else
        if (l_elas_orth .or. l_elas_istr) then
            call utmess('F', 'MATERIAL2_6')
        endif
    endif
!
! - Inconsistency (function/scalar)
!
    if (l_mfront_func) then
        if (.not. l_elas_func) then
            call utmess('A', 'MATERIAL2_7')
            goto 999
        endif
    else
        if (l_elas_func) then
            call utmess('A', 'MATERIAL2_8')
            goto 999
        endif
    endif
!
! - Inconsistency (values)
!
    call jeveuo(noobrc_elas//'.VALR', 'L', vr = v_valr)
    call jeveuo(noobrc_elas//'.VALK', 'L', vk16 = v_valk)
    call jelira(noobrc_elas//'.VALR', 'LONUTI', nb_prop_r)
    call jelira(noobrc_elas//'.VALC', 'LONUTI', nb_prop_c)
    call jelira(noobrc_elas//'.VALK', 'LONUTI', nb_prop_k2)
    nb_prop_k = (nb_prop_k2-nb_prop_r-nb_prop_c)/2
    nb_prop   = nb_prop_k2 / 2
    ASSERT(nb_prop_c .eq. 0)
!
! - Check properties (real)
!
    do i_prop_r = 1, nb_prop_r
! ----- Name of property (aster)
        prop_name    = v_valk(i_prop_r)
! ----- Value of property (aster)
        as_prop_valr = v_valr(i_prop_r)
! ----- Name of property (MFront)
        prop_name_mf = ' '
        call mateMFrontToAsterProperties(prop_name_mf, prop_name, index_ = indexE)
        if (indexE .gt. 0) then
! --------- Value of property (MFront)
            l_prop_find = .false.
            do i_mfront = 1, mfront_nbvale
                mf_prop_name = mfront_prop(i_mfront)
                mf_prop_valr = mfront_valr(i_mfront)
                if (mf_prop_name .eq. prop_name_mf) then
                    l_prop_find = .true.
                    exit
                endif
            end do
! --------- Test
            if (l_prop_find) then
                valk(1) = prop_name_mf
                valk(2) = prop_name
                if (mf_prop_valr .le. r8prem()) then
                    test = abs(as_prop_valr - mf_prop_valr)
                else
                    test = abs(as_prop_valr - mf_prop_valr)/abs(mf_prop_valr)
                endif
                if (test .gt. r8prem()) then
                    valr(1) = mf_prop_valr
                    valr(2) = as_prop_valr
                    call utmess('F', 'MATERIAL2_14', nk = 2, valk=valk,&
                                                     nr = 2, valr=valr)
                endif
            endif
        endif
    end do
!
! - Check properties (function)
!
    do i_prop_k = 1, nb_prop_k
! ----- Name of property (aster)
        prop_name    = v_valk(i_prop_k)
! ----- Value of property (aster)
        as_prop_valk = v_valk(nb_prop+i_prop_k)
! ----- Name of property (MFront)
        prop_name_mf = ' '
        call mateMFrontToAsterProperties(prop_name_mf, prop_name, index_ = indexE)
        if (indexE .gt. 0) then
! --------- Value of property (MFront)
            l_prop_find = .false.
            do i_mfront = 1, mfront_nbvale
                mf_prop_name = mfront_prop(i_mfront)
                mf_prop_valk = mfront_valk(i_mfront)
                if (mf_prop_name .eq. prop_name_mf) then
                    l_prop_find = .true.
                    exit
                endif
            end do
! --------- Test
            if (l_prop_find) then
                valk(1) = prop_name_mf
                valk(2) = prop_name
                valk(3) = mf_prop_valk
                valk(4) = as_prop_valk
                if (as_prop_valk .ne. mf_prop_valk) then
                    call utmess('F', 'MATERIAL2_12', nk = 4, valk=valk)
                endif
            endif
        endif
    end do
!
999 continue
!
end subroutine
