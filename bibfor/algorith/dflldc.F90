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

subroutine dflldc(keywf       , i_fail       , dtmin     , event_type,&
                  subd_methode, subd_pas_mini,&
                  subd_niveau , subd_pas     ,&
                  subd_auto   , subd_inst    , subd_duree)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
!
!
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: i_fail
    real(kind=8), intent(in) :: dtmin
    character(len=16), intent(in) :: event_type
    character(len=16), intent(out) :: subd_methode
    real(kind=8), intent(out) :: subd_pas_mini
    integer, intent(out) :: subd_niveau
    integer, intent(out) :: subd_pas
    character(len=16), intent(out) :: subd_auto
    real(kind=8), intent(out) :: subd_inst
    real(kind=8), intent(out) :: subd_duree
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! Get parameters of ACTION=DECOUPE for current failure keyword
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read failures
! In  i_fail           : index of current factor keyword to read failure
! In  dtmin            : minimum time increment in list of times
! In  event_type       : type of event
! Out subd_methode     : value of SUBD_METHODE for ACTION=DECOUPE
! Out subd_pas_mini    : value of SUBD_PAS_MINI for ACTION=DECOUPE
! Out subd_niveau      : value of SUBD_NIVEAU for ACTION=DECOUPE
! Out subd_pas         : value of SUBD_PAS for ACTION=DECOUPE
! Out subd_auto        : value of SUBD_AUTO for ACTION=DECOUPE
! Out subd_inst        : value of SUBD_INST for ACTION=DECOUPE
! Out subd_duree       : value of SUBD_DUREE for ACTION=DECOUPE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbret
!
! --------------------------------------------------------------------------------------------------
!
    subd_methode  = ' '
    subd_auto     = ' '
    subd_niveau   = 0
    subd_pas      = 0
    subd_pas_mini = 0.d0
    subd_inst     = 0.d0
    subd_duree    = 0.d0
!
! - Type of step cut
!
    call getvtx(keywf, 'SUBD_METHODE', iocc=i_fail, scal=subd_methode)
!
! - Get parameters
!
    call getvr8(keywf, 'SUBD_PAS_MINI', iocc=i_fail, scal=subd_pas_mini, nbret = nbret)
    ASSERT(nbret .le. 1)
    if (subd_pas_mini .gt. dtmin) then
        call utmess('F', 'DISCRETISATION_2')
    endif
    if (subd_methode .eq. 'MANUEL') then
        call getvis(keywf, 'SUBD_NIVEAU', iocc=i_fail, scal=subd_niveau)
        call getvis(keywf, 'SUBD_PAS', iocc=i_fail, scal=subd_pas)
        ASSERT(subd_pas .ge. 2)
    else if (subd_methode .eq. 'AUTO') then
        if (event_type .eq. 'COLLISION') then
            call getvr8(keywf, 'SUBD_INST', iocc=i_fail, scal=subd_inst)
            call getvr8(keywf, 'SUBD_DUREE', iocc=i_fail, scal=subd_duree)
            subd_auto = 'COLLISION'
        else
            subd_auto = 'EXTRAPOLE'
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
