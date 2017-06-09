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

subroutine apcpoi(sdcont_defi, model_ndim, i_zone, elem_name,&
                  zone_type  , tau1      , tau2)
!
implicit none
!
#include "asterc/r8prem.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfr.h"
#include "asterfort/assert.h"
#include "asterfort/mmmron.h"
#include "asterfort/normev.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: sdcont_defi
    integer, intent(in) :: model_ndim
    integer, intent(in) :: i_zone
    character(len=8), intent(in) :: elem_name
    character(len=4), intent(in) :: zone_type
    real(kind=8), intent(out) :: tau1(3)
    real(kind=8), intent(out) :: tau2(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Compute tangents at each node for POI1 element
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  model_ndim       : dimension of model
! In  i_zone           : index of contact zone
! In  elem_name        : name of element
! In  zone_type        : type of zone
!                        'MAIT' for master
!                        'ESCL' for slave
! Out tau1             : first tangent of local basis
! Out tau2             : second tangent of local basis
!
! --------------------------------------------------------------------------------------------------
!
    integer :: itype
    real(kind=8) :: normal(3), norme
!
! --------------------------------------------------------------------------------------------------
!
    tau1(1:3) = 0.d0
    tau2(1:3) = 0.d0
!
! - Check: POI1 is only master element
!
    if (zone_type .eq. 'MAIT') then
        call utmess('F', 'APPARIEMENT_75')
    endif
    itype = mminfi(sdcont_defi, 'VECT_ESCL', i_zone)
    if (itype .ne. 0) then
        normal(1) = mminfr(sdcont_defi, 'VECT_ESCL_DIRX', i_zone)
        normal(2) = mminfr(sdcont_defi, 'VECT_ESCL_DIRY', i_zone)
        normal(3) = mminfr(sdcont_defi, 'VECT_ESCL_DIRZ', i_zone)
        call normev(normal, norme)
    endif
!
! - Construct local basis
!
    if (itype .eq. 0) then
        call utmess('F', 'APPARIEMENT_62', sk=elem_name)
    else if (itype.eq.1) then
        if (norme .le. r8prem()) then
            call utmess('F', 'APPARIEMENT_63', sk=elem_name)
        else
            normal(1) = -normal(1)
            normal(2) = -normal(2)
            normal(3) = -normal(3)
            call mmmron(model_ndim, normal, tau1, tau2)
        endif
    else if (itype.eq.2) then
        call utmess('F', 'APPARIEMENT_62', sk=elem_name)
    else
        ASSERT(.false.)
    endif
!
end subroutine
