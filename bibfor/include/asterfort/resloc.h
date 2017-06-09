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
!
#include "asterf_types.h"
!
interface
    subroutine resloc(modele, ligrel, yaxfem, yathm, tbgrca,&
                      perman, chtime, mate, sigmam, sigmap,&
                      chsigx, chdepm, chdepp, cherrm, lchar,&
                      nchar, tabido, chvois, cvoisx, chelem)
        character(len=8) :: modele
        character(len=*) :: ligrel
        aster_logical :: yaxfem
        aster_logical :: yathm
        real(kind=8) :: tbgrca(3)
        aster_logical :: perman
        character(len=24) :: chtime
        character(len=*) :: mate
        character(len=24) :: sigmam
        character(len=24) :: sigmap
        character(len=24) :: chsigx
        character(len=24) :: chdepm
        character(len=24) :: chdepp
        character(len=24) :: cherrm
        character(len=8) :: lchar(1)
        integer :: nchar
        integer :: tabido(5)
        character(len=24) :: chvois
        character(len=24) :: cvoisx
        character(len=24) :: chelem
    end subroutine resloc
end interface
