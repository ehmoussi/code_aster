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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine varcCalcMeta(modelz,&
                        nbin  , nbout     ,&
                        lpain , lchin     ,&
                        lpaout, lchout    ,&
                        base  , vect_elemz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/gcnco2.h"
#include "asterfort/corich.h"
#include "asterfort/reajre.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
!
character(len=*), intent(in) :: modelz
integer, intent(in) :: nbin, nbout
character(len=8), intent(in) :: lpain(*), lpaout(*)
character(len=19), intent(in) :: lchin(*)
character(len=19), intent(inout) :: lchout(*)
character(len=1), intent(in) :: base
character(len=*), intent(in) :: vect_elemz
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Call to CALCUL special for metallurgy
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  nbin             : effective number of input fields
! In  nbout            : effective number of output fields
! In  lpain            : list of input parameters
! In  lchin            : list of input fields
! In  lpaout           : list of output parameters
! IO  lchout           : list of output fields
! In  base             : JEVEUX base to create objects
! In  vect_elem        : name of elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: newnom
    character(len=16) :: option
    character(len=19) :: resu_elem, ligrmo
    integer :: ibid, nb_resu
    character(len=24), pointer :: p_relr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    ligrmo = modelz(1:8)//'.MODELE'
    option = 'CHAR_MECA_META_Z'
!
! - Get last resu_elem
!
    call jelira(vect_elemz(1:8)//'           .RELR', 'LONUTI', nb_resu)
    call jeveuo(vect_elemz(1:8)//'           .RELR', 'L', vk24 = p_relr)
    resu_elem = p_relr(nb_resu)(1:19)
    newnom    = resu_elem(10:16)
!
! - Generate new resu_elem
!
    call gcnco2(newnom)
    resu_elem(10:16) = newnom(2:8)
    call corich('E', resu_elem, -1, ibid)
    lchout(1) = resu_elem

!
! - Compute
!
    call calcul('C'  , option, ligrmo, nbin  , lchin,&
                lpain, nbout , lchout, lpaout, base ,&
                'OUI')
    call reajre(vect_elemz, resu_elem, base)
!
end subroutine
