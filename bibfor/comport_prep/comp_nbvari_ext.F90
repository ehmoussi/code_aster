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

subroutine comp_nbvari_ext(l_umat        , nb_vari_umat ,&
                           l_mfront_proto, l_mfront_offi,&
                           libr_name     , subr_name    ,&
                           model_dim     , model_mfront ,&
                           nb_vari_exte)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/mfront_get_nbvari.h"
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    aster_logical, intent(in) :: l_umat
    integer, intent(in) :: nb_vari_umat
    aster_logical, intent(in) :: l_mfront_proto
    aster_logical, intent(in) :: l_mfront_offi
    character(len=255), intent(in) :: libr_name
    character(len=255), intent(in) :: subr_name
    integer, intent(in) :: model_dim
    character(len=16), intent(in) :: model_mfront
    integer, intent(out) :: nb_vari_exte
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Count number of internal variables for external constitutive laws (MFront and UMAT)
!
! --------------------------------------------------------------------------------------------------
!
! In  l_umat           : .true. if UMAT
! In  nb_vari_umat     : number of internal variables for UMAT
! In  l_mfront_proto   : .true. if MFront prototype
! In  l_mfront_offi    : .true. if MFront official
! In  libr_name        : name of library if UMAT or MFront
! In  subr_name        : name of comportement in library if UMAT or MFront
! In  model_dim        : dimension of modelisation (2D or 3D)
! In  model_mfront     : type of modelisation MFront
! Out nb_vari_exte     : number of internal variable if external computing for comportment
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_vari_mfront
!
! --------------------------------------------------------------------------------------------------
!
    nb_vari_exte = 0
!
! - Number of internal variables for UMAT
!
    if (l_umat) then
        nb_vari_exte = nb_vari_umat
    endif
!
! - Number of internal variables for MFront
!
    if ((l_mfront_offi .or. l_mfront_proto) .and. libr_name.ne.' ') then
        call mfront_get_nbvari(libr_name, subr_name, model_mfront, model_dim, nb_vari_mfront)
        if ( nb_vari_mfront .eq. 0 ) then
            nb_vari_mfront = 1
        endif
        nb_vari_exte = nb_vari_mfront
    endif
!
end subroutine
