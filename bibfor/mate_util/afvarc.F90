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

subroutine afvarc(chmate, mesh, model)
!
use Material_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/afvarc_read.h"
#include "asterfort/afvarc_obje_crea.h"
#include "asterfort/afvarc_obje_affe.h"
#include "asterfort/afvarc_shrink.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
!
!
    character(len=8), intent(in) :: chmate
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! For AFFE_MATERIAU/AFFE_VARC
!
! --------------------------------------------------------------------------------------------------
!
! In  chmate           : name of material field (CHAM_MATER)
! In  mesh             : name of mesh
! In  model            : name of model
!
! --------------------------------------------------------------------------------------------------
!
    type(Mat_DS_VarcListCata) :: varc_cata
    type(Mat_DS_VarcListAffe) :: varc_affe
    integer :: nb_affe_varc
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Read data
!
    call afvarc_read(varc_cata, varc_affe)
    nb_affe_varc = varc_affe%nb_affe_varc
!
    if (nb_affe_varc .ne. 0) then
! ----- Create objects
        call afvarc_obje_crea('G', chmate, mesh, varc_cata, varc_affe)
! ----- Affect values in objects
        call afvarc_obje_affe('G', chmate, mesh, model, varc_cata, varc_affe)
! ----- Shrink number of components to save memory
        call afvarc_shrink(chmate, varc_affe)
    endif
!
    call jedema()
end subroutine
