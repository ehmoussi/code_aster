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
subroutine getBehaviourPara(l_mfront_offi , l_mfront_proto, l_kit_thm,&
                            keywf         , i_comp        , algo_inte,&
                            iter_inte_maxi, resi_inte_rela)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nmdocv.h"
!
aster_logical, intent(in) :: l_mfront_offi
aster_logical, intent(in) :: l_mfront_proto
aster_logical, intent(in) :: l_kit_thm
character(len=16), intent(in) :: keywf
integer, intent(in) :: i_comp
character(len=16), intent(in) :: algo_inte
real(kind=8), intent(out) :: iter_inte_maxi
real(kind=8), intent(out) :: resi_inte_rela
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  l_mfront_proto   : .true. if MFront prototype
! In  l_mfront_offi    : .true. if MFront official
! In  l_kit_thm        : .true. if kit THM
! In  keywf            : factor keyword to read (COMPORTEMENT)
! In  i_comp           : factor keyword index
! In  algo_inte        : algorithm for integration of behaviour
! Out iter_inte_maxi   : value for ITER_INTE_MAXI
! Out resi_inte_rela   : value for RESI_INTE_RELA
!
! --------------------------------------------------------------------------------------------------
!
    iter_inte_maxi = 0.d0
    resi_inte_rela = 0.d0
!
! - Get
!
    call nmdocv(keywf, i_comp, algo_inte, 'ITER_INTE_MAXI', iter_inte_maxi)
    if ( l_mfront_offi .or. l_mfront_proto) then
        if (l_mfront_offi .or. l_kit_thm) then
            call nmdocv(keywf, i_comp, algo_inte, 'RESI_INTE_RELA', resi_inte_rela)
        else
            call nmdocv(keywf, i_comp, algo_inte, 'RESI_INTE_MAXI', resi_inte_rela)
        endif
    else
        call nmdocv(keywf, i_comp, algo_inte, 'RESI_INTE_RELA', resi_inte_rela) 
    endif
!
end subroutine
