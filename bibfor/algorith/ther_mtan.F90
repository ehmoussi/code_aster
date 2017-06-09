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

subroutine ther_mtan(model    , mate    , time    , varc_curr, compor   ,&
                     temp_iter, dry_prev, dry_curr, resu_elem, matr_elem)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/exixfe.h"
#include "asterfort/megeom.h"
#include "asterfort/meharm.h"
#include "asterfort/mecara.h"
#include "asterfort/reajre.h"
#include "asterfort/xajcin.h"
#include "asterfort/inical.h"
!
!
    character(len=24), intent(in) :: model
    character(len=24), intent(in) :: time
    character(len=24), intent(in) :: mate
    character(len=24), intent(in) :: temp_iter
    character(len=24), intent(in) :: dry_prev   
    character(len=24), intent(in) :: dry_curr
    character(len=24), intent(in) :: compor
    character(len=19), intent(in) :: varc_curr
    character(len=19), intent(in) :: resu_elem   
    character(len=24), intent(in) :: matr_elem
!
! --------------------------------------------------------------------------------------------------
!
! Thermic
! 
! Tangent matrix (volumic terms)
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  mate             : name of material characteristics (field)
! In  time             : time (<CARTE>)
! In  compor           : name of comportment definition (field)
! In  temp_iter        : temperature field at current Newton iteration
! In  dry_prev         : previous drying
! In  dry_curr         : current drying
! In  varc_curr        : command variable for current time
! In  matr_elem        : name of matr_elem result
! In  resu_elem        : name of resu_elem
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_in_maxi, nbout
    parameter (nb_in_maxi = 8, nbout = 1)
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
!
    character(len=1) :: base, stop_calc
    character(len=16) :: option
    character(len=24) :: ligrel_model
    character(len=24) :: chgeom
    integer :: nbin
!
! --------------------------------------------------------------------------------------------------
!
!
! - Initializations
!
    stop_calc    = 'S'
    base         = 'V'
    option       = 'MTAN_RIGI_MASS'
    ligrel_model = model(1:8)//'.MODELE'
!
! - Init fields
!
    call inical(nb_in_maxi, lpain, lchin, nbout, lpaout,&
                lchout    )    
!
! - Geometry field
!
    call megeom(model, chgeom)
!
! - Input fields
!
    lpain(1)  = 'PGEOMER'
    lchin(1)  = chgeom(1:19)
    lpain(2)  = 'PMATERC'
    lchin(2)  = mate(1:19)
    lpain(3)  = 'PTEMPSR'
    lchin(3)  = time(1:19)
    lpain(4)  = 'PTEMPEI'
    lchin(4)  = temp_iter(1:19)
    lpain(5)  = 'PCOMPOR'
    lchin(5)  = compor(1:19)
    lpain(6)  = 'PTMPCHI'
    lchin(6)  = dry_prev(1:19)
    lpain(7)  = 'PTMPCHF'
    lchin(7)  = dry_curr(1:19)
    lpain(8)  = 'PVARCPR'
    lchin(8)  = varc_curr(1:19)
    nbin      = 8
!
! - Output fields
!
    lpaout(1) = 'PMATTTR'
    lchout(1) = resu_elem
!
! - Compute
!
    call calcul(stop_calc, option, ligrel_model, nbin  , lchin,&
                lpain    , nbout , lchout      , lpaout, base ,&
                'OUI')
!
! - Add RESU_ELEM in MATR_ELEM
!
    call reajre(matr_elem, lchout(1), base)
!
end subroutine
