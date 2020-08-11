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
subroutine romModeParaRead(resultName, numeMode     ,&
                           model_    , modeSymbName_,&
                           modeSing_ , numeSlice_   ,&
                           nbSnap_)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/rsadpa.h"
!
character(len=8), intent(in) :: resultName
integer, intent(in) :: numeMode
character(len=8), optional, intent(out)  :: model_
character(len=24), optional, intent(out) :: modeSymbName_
integer, optional, intent(out)           :: numeSlice_
real(kind=8), optional, intent(out)      :: modeSing_
integer, optional, intent(out)           :: nbSnap_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Read parameters from base results datastructure for current mode
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure to save parameters
! In  numeMode         : index of mode
! Out model            : name of model
! Out modeSymbName     : type of field for mode have been constructed (NOM_CHAM)
! Out numeSlice        : index of slices (for lineic bases)
! Out modeSing         : singular value for mode
! Out nbSnap           : number of snapshots used to construct base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jvPara
    integer :: numeSlice, nbSnap
    character(len=24) :: modeSymbName
    real(kind=8) :: modeSing
    character(len=8) :: model
!
! --------------------------------------------------------------------------------------------------
!
    call rsadpa(resultName, 'L', 1, 'NUME_PLAN', numeMode, 0, sjv=jvPara)
    numeSlice    = zi(jvPara)
    call rsadpa(resultName, 'L', 1, 'FREQ'     , numeMode, 0, sjv=jvPara)
    modeSing     = zr(jvPara)
    call rsadpa(resultName, 'L', 1, 'NB_SNAP'  , numeMode, 0, sjv=jvPara)
    nbSnap       = zi(jvPara)
    call rsadpa(resultName, 'L', 1, 'MODELE'   , numeMode, 0, sjv=jvPara)
    model        = zk8(jvPara)
    call rsadpa(resultName, 'L', 1, 'NOM_CHAM' , numeMode, 0, sjv=jvPara)
    modeSymbName = zk24(jvPara)
!
    if (present(numeSlice_)) then
        numeSlice_ = numeSlice
    endif
    if (present(modeSing_)) then
        modeSing_ = modeSing
    endif
    if (present(nbSnap_)) then
        nbSnap_ = nbSnap
    endif
    if (present(model_)) then
        model_ = model
    endif
    if (present(modeSymbName_)) then
        modeSymbName_ = modeSymbName
    endif
!
end subroutine
