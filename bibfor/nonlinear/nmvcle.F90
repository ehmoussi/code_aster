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

subroutine nmvcle(modelz, matez, cara_elemz, time, varcz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/detrsd.h"
#include "asterfort/mecact.h"
#include "asterfort/vrcins.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: modelz
    character(len=*), intent(in) :: matez
    character(len=*), intent(in) :: cara_elemz
    real(kind=8), intent(in) :: time
    character(len=*), intent(in) :: varcz
!
! --------------------------------------------------------------------------------------------------
!
! Nonlinear mechanics (algorithm)
!
! Command variables - Read
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  mate           : name of material characteristics (field)
! In  cara_elem      : name of elementary characteristics (field)
! In  time           : time
! In  varc           : command variable field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=2) :: codret
    character(len=8) :: model, mate, cara_elem
    character(len=14) :: varc
    character(len=24) :: varc_list
    character(len=24) :: varc_time
!
! --------------------------------------------------------------------------------------------------
!
    varc          = varcz
    model         = modelz
    cara_elem     = cara_elemz
    mate          = matez
!
! - Old object deleted
!
    call detrsd('VARI_COM', varc)
!
! - List of command variables
!
    varc_list = varc//'.TOUT'
!
! - Construct command variables fields
!
    call vrcins(model, mate, cara_elem, time, varc_list,&
                codret)
!
! - Construct current time <CARTE>
!
    varc_time = varc//'.INST'
    call mecact('V', varc_time, 'MODELE', model(1:8)//'.MODELE', 'INST_R',&
                ncmp=1, nomcmp='INST', sr=time)
!
end subroutine
