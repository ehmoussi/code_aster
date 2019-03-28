! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine mateMFrontAddProperties(mate         , v_mate_read,&
                                   i_mate_mfront, i_mate_elas, i_mate_add ,&
                                   l_elas       , l_elas_func, l_elas_istr, l_elas_orth)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mateMFrontGetProperties.h"
#include "asterfort/mateMFrontCheck.h"
#include "asterfort/mateMFrontAddElasticity.h"
#include "asterfort/codent.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: mate
character(len=32), pointer :: v_mate_read(:)
integer, intent(in) :: i_mate_mfront, i_mate_elas, i_mate_add
aster_logical, intent(in) :: l_elas, l_elas_func, l_elas_istr, l_elas_orth
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Add elastic properties from MFront
!
! --------------------------------------------------------------------------------------------------
!
! In  mate             : name of output datastructure
! In  v_mate_read      : list of material factor keywords
! In  i_mate_mfront    : index of MFront/Elasticity properties in list of material properties
! In  i_mate_elas      : index of ELAS properties in list of material properties
! In  i_mate_add       : index of material to add
! In  l_elas           : .TRUE. if elastic material (isotropic) is present
! In  l_elas_func      : .TRUE. if elastic material (function, isotropic) is present
! In  l_elas_istr      : .TRUE. if elastic material (transverse isotropic) is present
! In  l_elas_orth      : .TRUE. if elastic material (orthotropic) is present
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: nom
    character(len=32) :: nomrc_mfront
    character(len=19) :: noobrc_elas
    integer :: mfront_nbvale
    real(kind=8) :: mfront_valr(16)
    character(len=16) :: mfront_valk(16), mfront_prop(16)
    aster_logical :: l_mfront_func, l_mfront_anis, l_new_elas
!
! --------------------------------------------------------------------------------------------------
!
    l_new_elas  = i_mate_add .gt. 0
!
! - Access to elastic material
!
    noobrc_elas = ' '
    if (i_mate_elas .gt. 0) then
        call codent(i_mate_elas, 'D0', nom)
        noobrc_elas = mate//'.CPT.'//nom
    endif
!
! - Get properties for MFront
!
    nomrc_mfront = v_mate_read(i_mate_mfront)
    call mateMFrontGetProperties(nomrc_mfront , l_mfront_func, l_mfront_anis,&
                                 mfront_nbvale, mfront_prop  , mfront_valr  , mfront_valk)
!
! - Check consistency between MFront/Elasticity and ELAS
!
    if (l_elas .or. l_elas_istr .or. l_elas_orth) then
        call mateMFrontCheck(l_mfront_func, l_mfront_anis ,&
                             noobrc_elas  , l_elas        , l_elas_func , l_elas_istr, l_elas_orth,&
                             mfront_nbvale, mfront_prop   , mfront_valr , mfront_valk)
    endif
!
! - Add elastic properties
!
    if (l_new_elas) then
        call utmess('I', 'MATERIAL2_15')
        call mateMFrontAddElasticity(l_mfront_func, l_mfront_anis,&
                                     mate         , i_mate_add   ,&
                                     mfront_nbvale, mfront_prop  ,&
                                     mfront_valr  , mfront_valk)
    endif
!
end subroutine
