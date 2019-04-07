! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
#include "MeshTypes_type.h"
!
interface
    subroutine lrmmfa(fid, nomamd, nbnoeu, grpnoe,&
                      gpptnn, grpmai, gpptnm, nbgrno, nbgrma,&
                      typgeo, nomtyp, nmatyp, prefix, infmed)
        med_idt :: fid
        character(len=*) :: nomamd
        integer :: nbnoeu
        character(len=24) :: grpnoe
        character(len=24) :: gpptnn
        character(len=24) :: grpmai
        character(len=24) :: gpptnm
        integer :: nbgrno
        integer :: nbgrma
        integer :: typgeo(MT_NTYMAX)
        character(len=8) :: nomtyp(MT_NTYMAX)
        integer :: nmatyp(MT_NTYMAX)
        character(len=6) :: prefix
        integer :: infmed
    end subroutine lrmmfa
end interface
