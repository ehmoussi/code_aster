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

subroutine xvelfm(nb_cracks, cracks, model_xfem)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/dismoi.h"
#include "asterfort/exixfe.h"
#include "asterfort/utmess.h"
#include "asterfort/xvfimo.h"
!
!
    character(len=8), intent(in) :: model_xfem
    integer, intent(in) :: nb_cracks
    character(len=8), intent(in) :: cracks(nb_cracks)
!
! --------------------------------------------------------------------------------------------------
!
! XFEM (Loads)
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  model_xfem     : name of XFEM model
! In  nb_cracks      : number of cracks
! In  cracks         : list of cracks
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_crack, iret
    aster_logical :: ltrouv
    character(len=8) :: valk(2)
    character(len=16) :: typdis
!
! --------------------------------------------------------------------------------------------------
!
!
! - XFEM model checking
!
    call exixfe(model_xfem, iret)
    if (iret .eq. 0) then
        call utmess('F', 'XFEM_72', sk=model_xfem)
    endif
!
! - Loop on cracks
!
    do i_crack = 1, nb_cracks
!
! ----- Crack in model ?
!
        ltrouv = xvfimo(model_xfem,cracks(i_crack))
        if (.not.ltrouv) then
            valk(1)=cracks(i_crack)
            valk(2)=model_xfem
            call utmess('F', 'XFEM_73', nk=2, valk=valk)
        endif
!
! ----- No PRES_REP on lips if CZM
!
        call dismoi('TYPE_DISCONTINUITE', cracks(i_crack), 'FISS_XFEM', repk=typdis)
        if (typdis .eq. 'COHESIF') then
            call utmess('F', 'XFEM2_7', sk=cracks(i_crack))
        endif
    end do
!
end subroutine
