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

subroutine nmamab(modele, carele, lamor)
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
!
    character(len=24) :: modele, carele
    aster_logical :: lamor
!
    character(len=24) :: rep1, rep2
! ----------------------------------------------------------------------
!
!
    lamor = .false.
    call dismoi('EXI_AMOR', modele, 'MODELE', repk=rep1)
    call dismoi('EXI_AMOR', carele, 'CARA_ELEM', repk=rep2)
!
    if (rep1 .eq. 'OUI' .or. rep2 .eq. 'OUI') lamor=.true.
!
end subroutine
