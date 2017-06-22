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

subroutine apcpou(sdcont_defi, i_zone, elem_name, zone_type,&
                  tau1       , tau2)
!
implicit none
!
#include "asterfort/mminfi.h"
#include "asterfort/mminfr.h"
#include "asterfort/assert.h"
#include "asterfort/normev.h"
#include "asterfort/provec.h"
#include "asterfort/utmess.h"
#include "blas/dcopy.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: sdcont_defi
    integer, intent(in) :: i_zone
    character(len=8), intent(in) :: elem_name
    character(len=4), intent(in) :: zone_type
    real(kind=8), intent(inout) :: tau1(3)
    real(kind=8), intent(inout) :: tau2(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Compute tangents at each node for beam element
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  i_zone           : index of contact zone
! In  elem_name        : name of element
! In  zone_type        : type of zone
!                        'MAIT' for master
!                        'ESCL' for slave
! IO  tau1             : first tangent of local basis
! IO  tau2             : second tangent of local basis
!
! --------------------------------------------------------------------------------------------------
!
    integer :: itype
    real(kind=8) :: vector(3), norme
!
! --------------------------------------------------------------------------------------------------
!
!
! - Type of normal
!
    if (zone_type .eq. 'ESCL') then
        itype = mminfi(sdcont_defi, 'VECT_ESCL', i_zone)
        vector(1) = mminfr(sdcont_defi, 'VECT_ESCL_DIRX', i_zone)
        vector(2) = mminfr(sdcont_defi, 'VECT_ESCL_DIRY', i_zone)
        vector(3) = mminfr(sdcont_defi, 'VECT_ESCL_DIRZ', i_zone)
    else if (zone_type.eq.'MAIT') then
        itype = mminfi(sdcont_defi, 'VECT_MAIT', i_zone)
        vector(1) = mminfr(sdcont_defi, 'VECT_MAIT_DIRX', i_zone)
        vector(2) = mminfr(sdcont_defi, 'VECT_MAIT_DIRY', i_zone)
        vector(3) = mminfr(sdcont_defi, 'VECT_MAIT_DIRZ', i_zone)
    else
        ASSERT(.false.)
    endif
!
! - Construct local basis
!
    if (itype .eq. 0) then
        call utmess('F', 'APPARIEMENT_61', sk=elem_name)
    else if (itype.eq.1) then
        call normev(vector, norme)
        call provec(vector, tau1, tau2)
    else if (itype.eq.2) then
        call normev(vector, norme)
        call dcopy(3, vector, 1, tau2, 1)
    else
        ASSERT(.false.)
    endif
!
end subroutine
