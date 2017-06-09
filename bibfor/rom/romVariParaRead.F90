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

subroutine romVariParaRead(ds_varipara, keywfact, iocc)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvis.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_VariPara), intent(inout) :: ds_varipara
    character(len=16), intent(in) :: keywfact
    integer, intent(in) :: iocc
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Variation of parameters for multiparametric problems - Read data
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_varipara      : datastructure for multiparametric problems - Variations
! In  keywfact         : name of factor keyword
! In  iocc             : index of factor keyword
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_vale_para, nbret
!
! --------------------------------------------------------------------------------------------------
!
    nb_vale_para = 0
!
! - Read name of parameters
!
    call getvtx(keywfact, 'NOM_PARA', iocc=iocc, nbret=nbret)
    nbret = abs(nbret)
    ASSERT(nbret .le. 1)
    if (nbret .gt. 0) then
        call getvtx(keywfact, 'NOM_PARA', iocc=iocc, scal = ds_varipara%para_name)
    endif
!
! - Read value of parameters
!
    call getvr8(keywfact, 'VALE_PARA', iocc=iocc, nbret=nb_vale_para)
    nb_vale_para = abs(nb_vale_para)
    ASSERT(nb_vale_para .ge. 1)
    AS_ALLOCATE(vr = ds_varipara%para_vale, size = nb_vale_para)
    call getvr8(keywfact, 'VALE_PARA', iocc=iocc, nbval = nb_vale_para,&
                vect = ds_varipara%para_vale)
    call getvr8(keywfact, 'VALE_INIT', iocc=iocc, scal = ds_varipara%para_init)
!
! - Total number of value of parameters
!
    ds_varipara%nb_vale_para = nb_vale_para
!
end subroutine
