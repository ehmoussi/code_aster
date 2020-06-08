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

subroutine dvcrob(mesh , modele,  ds_inout , materi, sd_obsv)
! original routine in stat_non_line : nmcrob

use NonLin_Datastructure_type
!
implicit none
!
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmcroi.h"
#include "asterfort/nmcrot.h"
#include "asterfort/nmextr.h"
#include "asterfort/nmobno.h"
#include "asterfort/utmess.h"
#include "asterfort/nmarnr.h"



character(len=*), intent(in) :: mesh
character(len=*), intent(in) :: modele
character(len=8),intent(in) :: materi
type(NL_DS_InOut), intent(in) :: ds_inout
character(len=19), intent(out) :: sd_obsv

! --------------------------------------------------------------------------------------------------
!
! DYNA_VIBRA - Observation
!
! Create observation datastructure
!
! --------------------------------------------------------------------------------------------------
!
! Out sd_obsv          : datastructure for observation parameters
!
! --------------------------------------------------------------------------------------------------
! ancienne routine : nmcrob
! supprimer ce qui ne concerne pas champs DEPL, VITE, ACCE

    integer :: nb_obsv, nb_keyw_fact, numrep
    character(len=8) :: result
    character(len=14) :: sdextr_obsv
    character(len=16) :: keyw_fact
    character(len=24) :: extr_info
    integer, pointer :: v_extr_info(:) => null()

    nb_obsv   = 0
    sd_obsv   = '&&NMCROB.OBSV'
    keyw_fact = 'OBSERVATION'
    call getfac(keyw_fact, nb_keyw_fact)
    ASSERT(nb_keyw_fact.le.99)
    result    = ds_inout%result

! - Read datas for extraction
!
    sdextr_obsv = sd_obsv(1:14)

! - Read parameters
!
    call nmextr(mesh , modele,  sdextr_obsv,  ds_inout , keyw_fact,&
                nb_keyw_fact, nb_obsv   ,  materi)
!
! - Set reuse index in OBSERVATION table
!
    call nmarnr(result, 'PARA_CALC', numrep)
    extr_info  = sdextr_obsv(1:14)//'     .INFO'
    call jeveuo(extr_info, 'E', vi = v_extr_info)
    v_extr_info(4) = numrep
!
! - Read parameters
!
    if (nb_obsv .ne. 0) then
!
        call utmess('I', 'OBSERVATION_3', si=nb_obsv)
!
! ----- Read time list
!
        call nmcroi(sd_obsv, keyw_fact, nb_keyw_fact)
!
! ----- Read name of columns
!
        call nmobno(sd_obsv, keyw_fact, nb_keyw_fact)
!
! ----- Create table
!
        call nmcrot(result, sd_obsv)
    endif
!
end subroutine
