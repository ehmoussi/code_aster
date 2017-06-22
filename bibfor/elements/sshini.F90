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

subroutine sshini(nno, nnos, hexa, shb6, shb8)
    implicit none
!
! Solid-SHell INItialization
!
!
! Initializations of some variables to ease SHB element identification.
!
!
! IN  nno      number of nodes in element
! IN  nnos     number of corner nodes in element
! OUT nnob     number of base node: 3 for triangle, 5 for quadrangle
! OUT nshift   variable required to evaluate SHB shell-like frame
! OUT hexa     true if SHB8 or SHB20
! OUT shb6     true if SHB6
! OUT shb8     true if SHB8
!
#include "asterf_types.h"
!
    integer, intent(in) :: nno
    integer, intent(in) :: nnos
    aster_logical, intent(out) :: hexa
    aster_logical, intent(out) :: shb6
    aster_logical, intent(out) :: shb8
!
!-----------------------------------------------------------------------
!
    shb6 = .false._1
    shb8 = .false._1
!
    if (nnos.eq.8) then
!      Initializations for SHB8 or SHB20
       hexa=.true._1
       if (nno.eq.nnos) then
!         SHB8
          shb8=.true._1
       endif
!
    elseif(nnos.eq.6) then
!      Initializations for SHB6 or SHB15
       hexa=.false._1
       if (nno.eq.nnos) then
!         SHB6
          shb6=.true._1
       endif 
    endif
end subroutine
