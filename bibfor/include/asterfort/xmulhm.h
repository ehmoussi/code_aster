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

!
#include "asterf_types.h"
!
interface
    subroutine xmulhm(contac, ddls, ddlc, ddlm, jaint, ifiss,&
                      jheano, vstnc, lact, lcalel, lelim,&
                      nfh, nfiss, ninter,&
                      nlact, nno, nnol, nnom, nnos,&
                      pla, pos, typma, jstano)
        integer :: contac
        integer :: ddls
        integer :: ddlc
        integer :: ddlm
        integer :: jaint
        integer :: ifiss
        integer :: jheano
        integer :: vstnc(*)
        integer :: lact(16)
        aster_logical :: lcalel
        aster_logical :: lelim
        integer :: nfh
        integer :: nfiss
        integer :: ninter
        integer :: nlact(2)
        integer :: nno
        integer :: nnol
        integer :: nnom
        integer :: nnos
        integer :: pla(27)
        integer :: pos(16)
        character(len=8) :: typma
        integer, optional, intent(in) :: jstano
    end subroutine xmulhm
end interface
