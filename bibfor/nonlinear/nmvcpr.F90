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
subroutine nmvcpr(modelz     , cara_elemz     , hval_incr,&
                  ds_material, ds_constitutive,&
                  base       , nume_dof       )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/assvec.h"
#include "asterfort/nmvcpr_elem.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nmdebg.h"
!
character(len=*), intent(in) :: modelz, cara_elemz
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=19), intent(in) :: hval_incr(*)
character(len=1), intent(in) :: base
character(len=24), intent(in) :: nume_dof
!
! --------------------------------------------------------------------------------------------------
!
! Nonlinear mechanics (algorithm)
!
! Command variables - Second member for prediction
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  cara_elem        : name of elementary characteristics (field)
! In  hval_incr        : hat-variable for incremental values
! In  base             : JEVEUX base to create objects
! In  nume_dof         : numbering of dof
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    real(kind=8) :: coef_vect(2)
    character(len=19) :: vect_elem(2)
    integer :: nume_harm
    character(len=8) :: vect_curr, vect_prev
    character(len=19) :: varc_refe, cnvcpr
    character(len=19) :: mult_comp, chsith, compor
    character(len=24) :: mate, mateco
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_14')
    endif
!
! - Initializations
!
    nume_harm = 0
    mate      = ds_material%mater
    mateco    = ds_material%mateco
    varc_refe = ds_material%varc_refe(1:19)
    compor    = ds_constitutive%compor(1:19)
    cnvcpr    = ds_material%fvarc_pred(1:19)
    mult_comp = compor
    chsith    = '&&VECTME.CHSITH'
    vect_prev = '&&VEPREV'
    vect_curr = '&&VECURR'
!
! - Compute elementary vectors - Previous
!
    call nmvcpr_elem(modelz    , mate      , mateco    , cara_elemz,&
                     nume_harm , '-'       , hval_incr ,&
                     varc_refe , compor    ,&
                     base      , vect_prev)
!
! - Compute elementary vectors - Current
!
    call nmvcpr_elem(modelz    , mate      , mateco    , cara_elemz,&
                     nume_harm , '+'       , hval_incr ,&
                     varc_refe , compor    ,&
                     base      , vect_curr)
!
! - Assembling
!
    coef_vect(1) = +1.d0
    coef_vect(2) = -1.d0
    vect_elem(1) = vect_curr
    vect_elem(2) = vect_prev
    call assvec(base, cnvcpr, 2, vect_elem, coef_vect,&
                nume_dof, ' ', 'ZERO', 1)
    if (niv .ge. 2) then
        call nmdebg('VECT', cnvcpr, 6)
    endif
!
end subroutine
