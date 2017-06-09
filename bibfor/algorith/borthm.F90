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

subroutine borthm(axi, vf, perman, typvf, typmod,&
                  ndim, ndlno, ndlnm)
    implicit none
#include "asterf_types.h"
#include "asterfort/dimthm.h"
#include "asterfort/typthm.h"
    aster_logical :: axi, perman, vf
    integer :: ndim, ndlno, ndlnm
    character(len=8) :: typmod(2)
    integer :: typvf
! ======================================================================
! --- INITIALISATIONS --------------------------------------------------
! ======================================================================
    typmod(2) = ' '
! ======================================================================
! --- TYPE DE MODELISATION ? AXI/DPLAN/3D ET HM INSTAT/PERM ------------
! ======================================================================
    call typthm(axi, perman, vf, typvf, typmod,&
                ndim)
! ======================================================================
! --- MISE A JOUR DES DIMENSIONS POUR ELEMENTS DE BORD -----------------
! ======================================================================
    call dimthm(ndlno, ndlnm, ndim)
! ======================================================================
end subroutine
