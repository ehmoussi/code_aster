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
subroutine romModeParaSave(resultName, numeMode    ,&
                           model     , modeSymbName,&
                           modeSing  , numeSlice   ,&
                           nbSnap)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/rsadpa.h"
!
character(len=8), intent(in) :: resultName
integer, intent(in) :: numeMode
character(len=8), intent(in)  :: model
character(len=24), intent(in) :: modeSymbName
integer, intent(in)           :: numeSlice
real(kind=8), intent(in)      :: modeSing
integer, intent(in)           :: nbSnap
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Save parameters in base results datastructure for current mode
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure to save parameters
! In  numeMode         : index of mode
! In  model            : name of model
! In  modeSymbName     : type of field for mode have been constructed (NOM_CHAM)
! In  numeSlice        : index of slices (for lineic bases)
! In  modeSing         : singular value for mode
! In  nbSnap           : number of snapshots used to construct base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jvPara
!
! --------------------------------------------------------------------------------------------------
!
    call rsadpa(resultName, 'E', 1, 'NUME_MODE', numeMode, 0, sjv=jvPara)
    zi(jvPara)   = numeMode
    call rsadpa(resultName, 'E', 1, 'NUME_PLAN', numeMode, 0, sjv=jvPara)
    zi(jvPara)   = numeSlice
    call rsadpa(resultName, 'E', 1, 'FREQ'     , numeMode, 0, sjv=jvPara)
    zr(jvPara)   = modeSing
    call rsadpa(resultName, 'E', 1, 'NB_SNAP'  , numeMode, 0, sjv=jvPara)
    zi(jvPara)   = nbSnap
    call rsadpa(resultName, 'E', 1, 'MODELE'   , numeMode, 0, sjv=jvPara)
    zk8(jvPara)  = model
    call rsadpa(resultName, 'E', 1, 'NOM_CHAM' , numeMode, 0, sjv=jvPara)
    zk24(jvPara) = modeSymbName
!
end subroutine
