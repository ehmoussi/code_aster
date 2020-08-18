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
subroutine romAlgoNLInit(phenom, model, mesh, numeDof, resultName, paraAlgo, lLineSearch_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/romCreateEquationFromNode.h"
#include "asterfort/romAlgoNLCheck.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/nonlinDSTableIOCreate.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=4), intent(in) :: phenom
character(len=24), intent(in) :: model
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: numeDof
character(len=8), intent(in) :: resultName
type(ROM_DS_AlgoPara), intent(inout) :: paraAlgo
aster_logical, intent(in), optional :: lLineSearch_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Init ROM algorithm datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom           : phenomenon (MECA/THER)
! In  model            : name of model
! In  mesh             : name of mesh
! In  numeDof          : name of numbering (NUME_DDL)
! In  resultName       : name of datastructure for results
! IO  paraAlgo         : datastructure for ROM parameters
! In  l_line_search    : .true. if line search
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_hrom, l_hrom_corref
    integer :: nb_mode
    real(kind=8), pointer :: v_gamma(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_37')
    endif
!
! - Get parameters
!
    l_hrom        = paraAlgo%l_hrom
    l_hrom_corref = paraAlgo%l_hrom_corref
    nb_mode       = paraAlgo%ds_empi%nb_mode
!
! - Check ROM algorithm datastructure
!
    call romAlgoNLCheck(phenom, model, mesh, paraAlgo, lLineSearch_)
!
! - Prepare the list of equations at interface
!
    if (l_hrom) then
        call romCreateEquationFromNode(paraAlgo%ds_empi%ds_mode, paraAlgo%v_equa_int, numeDof,&
                                       grnode_ = paraAlgo%grnode_int)
    endif
!
! - Prepare the list of equation of internal interface
!
    if (l_hrom_corref) then
        call romCreateEquationFromNode(paraAlgo%ds_empi%ds_mode, paraAlgo%v_equa_sub, numeDof,&
                                       grnode_ = paraAlgo%grnode_sub)
    endif
!
! - Initializations for EF correction
!
    paraAlgo%phase = 'HROM'
!
! - Create object for reduced coordinates
!
    call wkvect(paraAlgo%gamma, 'V V R', nb_mode, vr = v_gamma)
!
! - Create datastructure of table in results datastructure for the reduced coordinates
!
    call romTableCreate(resultName, paraAlgo%tablResu)
!
! - Create table in results datastructure (if necessary)
!
    call nonlinDSTableIOCreate(paraAlgo%tablResu)
!
end subroutine
