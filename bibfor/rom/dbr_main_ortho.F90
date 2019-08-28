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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_main_ortho(ds_para_ortho, field_iden, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/vpgskp.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/romBaseCreateMatrix.h"
#include "asterfort/romBaseSave.h"
#include "asterfort/dbr_calcpod_svd.h"
!
type(ROM_DS_ParaDBR_ORTHO), intent(in) :: ds_para_ortho
character(len=24), intent(in) :: field_iden
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Main subroutine to compute empiric modes - Orthogonalization
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para_ortho    : datastructure for orthogonalization parameters
! In  field_iden       : identificator of field (name in results datastructure)
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: lmatb, nb_mode, nb_equa, nb_snap
    real(kind=8) :: alpha
    real(kind=8), pointer :: trav1(:) => null()
    real(kind=8), pointer :: trav3(:) => null()
    integer, pointer :: ddlexc(:) => null()
    real(kind=8), pointer :: v_matr_phi(:) => null()
    character(len=1) :: mode_type
    real(kind=8), pointer :: v(:) => null()
    real(kind=8), pointer :: s(:) => null()
    integer :: nb_sing, nb_line_svd
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_72')
    endif
!
! - Get parameters
!
    nb_mode    = ds_empi%nb_mode
    nb_equa    = ds_empi%ds_mode%nb_equa
    nb_snap    = ds_empi%nb_snap
    alpha      = ds_para_ortho%alpha
    mode_type  = 'R'
!
! - Working vectors
!
    AS_ALLOCATE(vr=trav1, size=nb_equa)
    AS_ALLOCATE(vr=trav3, size=nb_mode)
    AS_ALLOCATE(vi=ddlexc, size=nb_equa)
!
! - All DOF
!
    ddlexc(1:nb_equa) = 1
!
! - Get empiric base
!
    call romBaseCreateMatrix(ds_para_ortho%ds_empi_init, v_matr_phi)
!
! - Compute
!
    call vpgskp(nb_equa, nb_mode, v_matr_phi, alpha, lmatb,&
                0      , trav1  , ddlexc    , trav3)
!
! - Compute empiric modes by SVD
!
    call dbr_calcpod_svd(nb_mode, nb_equa, v_matr_phi, s, v, nb_sing, nb_line_svd)
!
! - Save new base
!
    call romBaseSave(ds_empi   , nb_mode, nb_snap, mode_type, field_iden,&
                     v_matr_phi)
!
! - Cleaning
!
    AS_DEALLOCATE(vr = trav1)
    AS_DEALLOCATE(vr = trav3)
    AS_DEALLOCATE(vi = ddlexc)
    AS_DEALLOCATE(vr = v_matr_phi)
    AS_DEALLOCATE(vr = v)
    AS_DEALLOCATE(vr = s)
!
end subroutine
