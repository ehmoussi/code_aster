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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmcrob(meshz      , modelz         , sddisc, ds_inout , cara_elemz,&
                  ds_material, ds_constitutive, disp  , strx     , varc      ,&
                  time       , sd_obsv  )
!
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
!
character(len=*), intent(in) :: meshz
character(len=*), intent(in) :: modelz
character(len=19), intent(in) :: sddisc
type(NL_DS_InOut), intent(in) :: ds_inout
character(len=*), intent(in) :: cara_elemz
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Material), intent(in) :: ds_material
character(len=*), intent(in) :: disp
character(len=*), intent(in) :: strx
character(len=*), intent(in) :: varc
real(kind=8),  intent(in) :: time
character(len=19), intent(out) :: sd_obsv
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Observation
!
! Create observation datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  result           : name of results datastructure
! In  ds_inout         : datastructure for input/output management
! In  cara_elem        : name of datastructure for elementary parameters (CARTE)
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  disp             : displacements
! In  varc             : external state variable
! In  time             : time
! In  strx             : fibers information
! Out sd_obsv          : datastructure for observation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_obsv, nb_keyw_fact, nume_reuse
    character(len=19) :: sdarch
    character(len=8) :: result
    character(len=14) :: sdextr_obsv
    character(len=16) :: keyw_fact
    character(len=24) :: arch_info
    integer, pointer :: v_arch_info(:) => null()
    character(len=24) :: extr_info
    integer, pointer :: v_extr_info(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_obsv   = 0
    sd_obsv   = '&&NMCROB.OBSV'
    keyw_fact = 'OBSERVATION'
    call getfac(keyw_fact, nb_keyw_fact)
    ASSERT(nb_keyw_fact.le.99)
    result    = ds_inout%result
!
! - Access to storage datastructure
!
    sdarch    = sddisc(1:14)//'.ARCH'
    arch_info = sdarch(1:19)//'.AINF'
    call jeveuo(arch_info, 'L', vi = v_arch_info)
!
! - Read datas for extraction
!
    sdextr_obsv = sd_obsv(1:14)
    call nmextr(meshz       , modelz    , sdextr_obsv, ds_inout, keyw_fact,&
                nb_keyw_fact, nb_obsv   ,&
                cara_elemz  , ds_material, ds_constitutive, disp, strx,&
                varc        , time       )
!
! - Set reuse index in OBSERVATION table
!
    nume_reuse = v_arch_info(3)
    extr_info  = sdextr_obsv(1:14)//'     .INFO'
    call jeveuo(extr_info, 'E', vi = v_extr_info)
    v_extr_info(4) = nume_reuse
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
