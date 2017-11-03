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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine op0026()
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/catabl.h"
#include "asterfort/catabl_ther.h"
#include "asterfort/infmaj.h"
#include "asterfort/utmess.h"
#include "asterfort/jemarq.h"
#include "asterfort/diinst.h"
#include "asterfort/nmchai.h"
#include "asterfort/jedema.h"
#include "asterfort/calcGetData.h"
#include "asterfort/calcGetDataMeca.h"
#include "asterfort/calcGetDataTher.h"
#include "asterfort/calcPrepDataMeca.h"
#include "asterfort/calcPrepDataTher.h"
#include "asterfort/calcCalcMeca.h"
#include "asterfort/calcCalcTher.h"
!
! --------------------------------------------------------------------------------------------------
!
!  O P E R A T E U R    C A L C U L
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: zsolal = 17
    integer, parameter :: zvalin = 28
    character(len=19) :: hval_incr(zvalin), hval_algo(zsolal)
    integer :: nb_obje
    integer, parameter :: nb_obje_maxi = 9
    character(len=16) :: obje_name(nb_obje_maxi)
    character(len=24) :: obje_sdname(nb_obje_maxi)
    integer :: nb_option
    character(len=16) :: list_option(6)
    integer :: nume_inst, nume_harm
    integer :: long
    real(kind=8) :: time_prev, time_curr
    real(kind=8) :: deltat, khi, theta
    character(len=8) :: table_new, table_old
    type(NL_DS_Constitutive) :: ds_constitutive
    character(len=16) :: phenom
    character(len=19) :: list_load
    character(len=19) :: list_inst
    character(len=24) :: model, mate, cara_elem, compor_ther
    character(len=24) :: varc_refe
    character(len=19) :: disp_prev, disp_cumu_inst, vari_prev, sigm_prev
    character(len=19) :: temp_prev, temp_curr, incr_temp
    character(len=19) :: merigi, vediri, vefint, veforc, vevarc_prev, vevarc_curr
    aster_logical :: l_elem_nonl
    character(len=24) :: ve_charther, me_mtanther, ve_evolther_l, ve_evolther_nl
    character(len=24) :: ve_resither
    character(len=24) :: time
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
!
! - Get commons data
!
    call calcGetData(table_new, table_old  ,&
                     nb_option, list_option,&
                     nume_inst, list_inst  ,&
                     phenom)
    if (phenom .eq. 'MECANIQUE') then
        call calcGetDataMeca(list_load      , model         , mate     , cara_elem,&
                             disp_prev      , disp_cumu_inst, vari_prev, sigm_prev,&
                             ds_constitutive, l_elem_nonl   , nume_harm)
    elseif (phenom .eq. 'THERMIQUE') then
        call calcGetDataTher(list_load  , model    , mate       , cara_elem,&
                             temp_prev  , incr_temp, compor_ther, theta)
    else
        ASSERT(.false.)
    endif
!
! - Get current and previous times
!
    time_prev = diinst(list_inst, nume_inst-1)
    time_curr = diinst(list_inst, nume_inst)
    deltat    = time_curr - time_prev
    khi       = 1.d0
!
! - Check lengths
!
    call nmchai('VALINC', 'LONMAX', long)
    ASSERT(long .eq. zvalin)
    call nmchai('SOLALG', 'LONMAX', long)
    ASSERT(long .eq. zsolal)
!
! - Prepare data
!
    if (phenom .eq. 'MECANIQUE') then
        call calcPrepDataMeca(model          , mate          , cara_elem,&
                              disp_prev      , disp_cumu_inst, vari_prev, sigm_prev,&
                              time_prev      , time_curr     ,&
                              ds_constitutive, varc_refe     ,&
                              hval_incr      , hval_algo     ,&
                              merigi         , vediri        , vefint   , veforc   ,&
                              vevarc_prev    , vevarc_curr   )    
    elseif (phenom .eq. 'THERMIQUE') then
        call calcPrepDataTher(model        , temp_prev     , incr_temp  ,&
                              time_curr    , deltat        , theta      , khi,&
                              time         , temp_curr     ,&
                              ve_charther  , me_mtanther   , vediri     ,&
                              ve_evolther_l, ve_evolther_nl, ve_resither)
    else
        ASSERT(.false.)
    endif
!
! - Compute 
!
    if (phenom .eq. 'MECANIQUE') then
        call calcCalcMeca(nb_option   , list_option    , &
                          list_load   , model          , mate       , cara_elem,& 
                          l_elem_nonl , ds_constitutive, varc_refe  ,&
                          hval_incr   , hval_algo      ,&
                          merigi      , vediri         , vefint     , veforc,&
                          vevarc_prev , vevarc_curr    , nume_harm  ,&
                          nb_obje_maxi, obje_name      , obje_sdname, nb_obje)
    elseif (phenom .eq. 'THERMIQUE') then
        call calcCalcTher(nb_option    , list_option   , &
                          list_load    , model         , mate       , cara_elem,&
                          time_curr    , time          ,&
                          temp_prev    , incr_temp     , compor_ther, temp_curr,&
                          ve_charther  , me_mtanther   , vediri     ,&
                          ve_evolther_l, ve_evolther_nl, ve_resither,&
                          nb_obje_maxi , obje_name     , obje_sdname, nb_obje)
    else
        ASSERT(.false.)
    endif
!
! - Table management
!
    if (phenom .eq. 'MECANIQUE') then
        call catabl(table_new, table_old, time_curr, nume_inst, nb_obje,&
                     obje_name, obje_sdname)
    elseif (phenom .eq. 'THERMIQUE') then
        call catabl_ther(table_new, table_old, time_curr, nume_inst, nb_obje,&
                         obje_name, obje_sdname)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
!
end subroutine
