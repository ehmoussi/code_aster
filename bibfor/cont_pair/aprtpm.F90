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
!
subroutine aprtpm(pair_tole       , elem_dime     , &
                  elem_mast_nbnode, elem_mast_coor, elem_mast_code,&
                  elem_slav_nbnode, elem_slav_coor, elem_slav_code,&
                  poin_inte_sl    , nb_poin_inte  ,poin_inte_ma, iret)
!
implicit none
!
#include "asterfort/reerel.h"
#include "asterfort/assert.h"
#include "asterfort/jacsur.h"
#include "asterfort/mmnewd.h"
!
real(kind=8), intent(in) :: pair_tole
integer, intent(in) :: elem_dime
integer, intent(in) :: elem_mast_nbnode
real(kind=8), intent(in) :: elem_mast_coor(3,9)
character(len=8), intent(in) :: elem_mast_code
integer, intent(in) :: elem_slav_nbnode
real(kind=8), intent(in) :: elem_slav_coor(3,9)
character(len=8), intent(in) :: elem_slav_code
integer, intent(in) :: nb_poin_inte
real(kind=8), intent(out) :: poin_inte_ma(elem_dime-1,16)
real(kind=8), intent(in) :: poin_inte_sl(elem_dime-1,16)
integer, intent(out) :: iret

!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Projection from slave parametric space to master one
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_poin_inte
    real(kind=8) :: node_real(3), ksi(2), ksi_ma(2), jacobian
    real(kind=8) :: tau1(3), tau2(3), norm(3)
    character(len=8) :: elin_slav_code
    integer :: elin_slav_nbnode
    character(len=8) :: elin_mast_code
    integer :: elin_mast_nbnode, iret_
!
! --------------------------------------------------------------------------------------------------
!
    iret = 0
    if (elem_slav_code .eq. "QU8" .or. elem_slav_code .eq. "QU9") then
        elin_slav_code = "QU4"
        elin_slav_nbnode =  4
    elseif (elem_slav_code .eq. "TR6") then
        elin_slav_code = "TR3"
        elin_slav_nbnode =  3
    elseif (elem_slav_code .eq. "SE3") then
        elin_slav_code = "SE2"
        elin_slav_nbnode =  2
    else
        elin_slav_code = elem_slav_code
        elin_slav_nbnode = elem_slav_nbnode
    end if

    if (elem_mast_code .eq. "QU8" .or. elem_mast_code .eq. "QU9") then
        elin_mast_code = "QU4"
        elin_mast_nbnode =  4
    elseif (elem_mast_code .eq. "TR6") then
        elin_mast_code = "TR3"
        elin_mast_nbnode =  3
    elseif (elem_slav_code .eq. "SE3") then
        elin_mast_code = "SE2"
        elin_mast_nbnode =  2
    else
        elin_mast_code = elem_mast_code
        elin_mast_nbnode = elem_mast_nbnode
    end if
!
! - Loop on intersection points
!
    do i_poin_inte = 1, nb_poin_inte
        norm(1:3) = 0.d0
        tau1(1:3) = 0.d0
        tau2(1:3) = 0.d0
        ksi(:)    = 0.d0
        ksi_ma(:) = 0.d0
        ksi(1) = poin_inte_sl (1, i_poin_inte)
        if (elem_dime .eq. 3) then
            ksi(2) = poin_inte_sl (2, i_poin_inte)
        endif

!
! --------- Transfert slave intersection coordinates in real space
!
        call reerel(elem_slav_code, elem_slav_nbnode, elem_dime, elem_slav_coor,&
                    ksi           , node_real)
!
! --------- Compute jacobian and normal
!
        call jacsur(elem_slav_coor, elin_slav_nbnode, elin_slav_code, elem_dime,&
                    ksi(1) ,ksi(2), jacobian        , norm)

        call mmnewd(elin_mast_code, elin_mast_nbnode, elem_dime, elem_mast_coor,&
                    node_real     , 70              , pair_tole, norm          ,&
                    ksi_ma(1)     , ksi_ma(2)       , tau1     , tau2          ,&
                    iret_)
        if (iret_.eq. 1) then
            iret = 1
            ASSERT(.false.)
        endif

        poin_inte_ma(1,i_poin_inte) = ksi_ma(1)
        if (elem_dime .eq. 3) then
            poin_inte_ma(2,i_poin_inte) = ksi_ma(2)
        endif
    end do
end subroutine
