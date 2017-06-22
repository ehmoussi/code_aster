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

subroutine crprno(prof_chnoz, base, meshz, gran_namez, nb_equa)
!
implicit none
!
#include "asterfort/dismoi.h"
#include "asterfort/assert.h"
#include "asterfort/jenonu.h"
#include "asterfort/profchno_crsd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
!
!
    character(len=*), intent(in) :: prof_chnoz
    character(len=1), intent(in) :: base
    character(len=*), intent(in) :: gran_namez
    character(len=*), intent(in) :: meshz
    integer, intent(in) :: nb_equa
!
! --------------------------------------------------------------------------------------------------
!
! Create PROF_CHNO only on mesh
!
! --------------------------------------------------------------------------------------------------
!
! In  prof_chno   : name of PROF_CHNO
! In  base        : JEVEUX base to create PROF_CHNO
! In  nb_equa     : number of equations
! In  gran_name   : name of GRANDEUR
! In  mesh        : name of mesh
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_ligr_mesh
    character(len=24) :: lili
!
! --------------------------------------------------------------------------------------------------
!
    call profchno_crsd(prof_chnoz, base, nb_equa, meshz = meshz, &
                       gran_namez = gran_namez)

    lili = prof_chnoz(1:19)//'.LILI'
    call jenonu(jexnom(lili, '&MAILLA'), i_ligr_mesh)
    ASSERT(i_ligr_mesh.eq.1)

end subroutine
