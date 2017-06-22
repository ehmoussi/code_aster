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

subroutine dfllpe(keywf    , i_fail        , event_type,&
                  vale_ref , nom_cham      , nom_cmp   , crit_cmp,&
                  pene_maxi, resi_glob_maxi)
!
implicit none
!
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
!
!
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: i_fail
    character(len=16), intent(in) :: event_type
    real(kind=8), intent(out) :: vale_ref
    character(len=16), intent(out) :: nom_cham
    character(len=16), intent(out) :: nom_cmp
    character(len=16), intent(out) :: crit_cmp
    real(kind=8), intent(out) :: pene_maxi
    real(kind=8), intent(out) :: resi_glob_maxi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST
!
! Get parameters of EVENEMENT for current failure keyword
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read failures
! In  i_fail           : index of current factor keyword to read failure
! In  event_type       : type of event
! Out vale_ref         : value of VALE_REF for EVENEMENT=DELTA_GRANDEUR
! Out nom_cham         : value of NOM_CHAM for EVENEMENT=DELTA_GRANDEUR
! Out nom_cmp          : value of NOM_CMP for EVENEMENT=DELTA_GRANDEUR
! Out crit_cmp         : value of CRIT_CMP for EVENEMENT=DELTA_GRANDEUR
! Out pene_maxi        : value of PENE_MAXI for EVENEMENT=INTERPENETRATION
! Out resi_glob_maxi   : value of RESI_GLOB_MAXI for EVENEMENT=RESI_MAXI
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc
!
! --------------------------------------------------------------------------------------------------
!
    pene_maxi      = 0.d0
    vale_ref       = 0.d0
    resi_glob_maxi = 0.d0
    nom_cham       = ' '
    nom_cmp        = ' '
    crit_cmp       = ' '
!
! - Read parameters
!
    if (event_type .eq. 'DELTA_GRANDEUR') then
        call getvr8(keywf, 'VALE_REF', iocc=i_fail, scal=vale_ref, nbret=nocc)
        ASSERT(nocc .gt. 0)
        call getvtx(keywf, 'NOM_CHAM', iocc=i_fail, scal=nom_cham, nbret=nocc)
        ASSERT(nocc .gt. 0)
        call getvtx(keywf, 'NOM_CMP', iocc=i_fail, scal=nom_cmp, nbret=nocc)
        ASSERT(nocc .gt. 0)
        crit_cmp = 'GT'
    else if (event_type.eq.'INTERPENETRATION') then
        call getvr8(keywf, 'PENE_MAXI', iocc=i_fail, scal=pene_maxi, nbret=nocc)
        ASSERT(nocc .gt. 0)
    else if (event_type.eq.'RESI_MAXI') then
        call getvr8(keywf, 'RESI_GLOB_MAXI', iocc=i_fail, scal=resi_glob_maxi, nbret=nocc)
        ASSERT(nocc .gt. 0)
    endif
!
end subroutine
