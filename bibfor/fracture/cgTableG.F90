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
! person_in_charge: nicolas.pignet at edf.fr
!
subroutine cgTableG(cgField, cgTheta)
!
use calcG_type
!
    implicit none
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
#include "asterfort/utimsd.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajvi.h"
#include "asterfort/tbajvk.h"
#include "asterfort/tbajvr.h"
#include "asterfort/titre.h"
#include "asterfort/assert.h"
#include "asterfort/cgcrtb.h"
! #include "asterfort/dismoi.h"
! #include "asterfort/getvid.h"
#include "asterfort/getvis.h"
! #include "asterfort/getvtx.h"

! #include "asterfort/wkvect.h"
!
    type(CalcG_field), intent(in) :: cgField
    type(CalcG_theta), intent(in) :: cgTheta
!
! --------------------------------------------------------------------------------------------------
!
!     CALC_G --- Utilities
!
!     Create table
!
! --------------------------------------------------------------------------------------------------
!
!
    integer, parameter :: nxpara = 15, nbmxpa = 20
    character(len=8) :: litypa(nxpara), typfis, k8bid
!
    integer :: livi(nbmxpa), iord
    real(kind=8) :: livr(nbmxpa), time, g(1)
    complex(kind=8) :: livc(nbmxpa)
    character(len=24) :: livk(nbmxpa)
!
    character(len=16) :: option, linopa(nxpara)
    integer :: nbpara, numfon, ibid, lfond
    aster_logical :: lmoda
!
    call jemarq()
!
    lmoda = cgField%isModeMeca()
!
    option = "G"
    call cgcrtb(cgField%table_g, option, cgField%ndim, typfis, nxpara, &
                lmoda, nbpara, linopa, litypa)
!
    k8bid = 'K8_BIDON'
   ! call tbajvk(cgField%table_g, nbpara, 'ABSC_CURV_NORM', 0.0, livr)
   ! call tbajvk(cgField%table_g, nbpara, 'TEMP', 0.0, livr)
   ! call tbajvk(cgField%table_g, nbpara, 'COMPORTEMENT', k8bid, livk)
!
    ! iord = 1
    ! call tbajvi(cgField%table_g, nbpara, 'NUME_ORDRE', iord, livi)
    ! time = 2.0
    ! call tbajvr(cgField%table_g, nbpara, 'INST', time, livr)
!
    ! call tbajvr(cgField%table_g, nbpara, 'COOR_X', cgTheta%coorNoeud(1),   livr)
    ! call tbajvr(cgField%table_g, nbpara, 'COOR_Y', cgTheta%coorNoeud(2), livr)

    g(1)= 123456789.0
    call tbajvr(cgField%table_g, nbpara, 'G', g(1), livr)
    call tbajli(cgField%table_g, nbpara, linopa, livi, livr, livc, livk, 0)
!
    !call utimsd(6, 2, .true._1, .true._1,cgField%table_g, 1, ' ')

!
!    call titre()
!
    call jedema()
!
end subroutine
