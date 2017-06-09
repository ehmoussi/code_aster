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

subroutine utnuav(noma, k, iocc, lno)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/reliem.h"
    integer :: k, iocc
    character(len=*) :: noma, lno
!
!     COMMANDE:  PROJ_CHAMP / NUAG_DEG_XX
!
! BUT : CREER LA LISTE DES NUMEROS DE NOEUDS D'UNE OCCURENCE DE
!       VIS_A_VIS
! ----------------------------------------------------------------------
!
    character(len=16) :: limocl(5), tymocl(5)
    character(len=8) :: ma8
    integer :: n1
!
    call jemarq()
    ma8=noma
!
    if (k .eq. 1) then
        limocl(1)='GROUP_MA_1'
        limocl(2)='GROUP_NO_1'
        limocl(3)='MAILLE_1'
        limocl(4)='NOEUD_1'
        limocl(5)='TOUT_1'
    else
        limocl(1)='GROUP_MA_2'
        limocl(2)='GROUP_NO_2'
        limocl(3)='MAILLE_2'
        limocl(4)='NOEUD_2'
        limocl(5)='TOUT_2'
    endif
!
    tymocl(1)='GROUP_MA'
    tymocl(2)='GROUP_NO'
    tymocl(3)='MAILLE'
    tymocl(4)='NOEUD'
    tymocl(5)='TOUT'
!
    call reliem(' ', ma8, 'NU_NOEUD', 'VIS_A_VIS', iocc,&
                5, limocl, tymocl, lno, n1)
    ASSERT(n1.gt.0)
!
    call jedema()
end subroutine
