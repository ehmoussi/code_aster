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

subroutine montee(nout, lchout, lpaout, fin)

use calcul_module, only : ca_calvoi_, ca_igr_, ca_nbgr_, ca_ligrel_

implicit none
! person_in_charge: jacques.pellet at edf.fr

#include "asterfort/monte1.h"
#include "asterfort/typele.h"

    integer :: nout
    character(len=*) :: lchout(*), fin
    character(len=8) :: lpaout(*)
!-----------------------------------------------------------------------
! Entrees:
!     fin    : ' ' / 'FIN' : necessaire a cause de calvoi=1
!
! Sorties:
!     met a jour les champs globaux de sortie de l option ca_nuop_
!-----------------------------------------------------------------------
    integer :: igr2, te2
!-----------------------------------------------------------------------

    if (ca_calvoi_ .eq. 0) then
        if (fin .eq. ' ') then
            igr2=ca_igr_
            te2=typele(ca_ligrel_,igr2,1)
            call monte1(te2, nout, lchout, lpaout,&
                        igr2)
        endif
    else
!       -- on recopie tout a la fin :
        if (fin .eq. 'FIN') then
            do 1, igr2=1,ca_nbgr_
            te2=typele(ca_ligrel_,igr2,1)
            call monte1(te2, nout, lchout, lpaout,&
                        igr2)
 1          continue
        endif
    endif


end subroutine
