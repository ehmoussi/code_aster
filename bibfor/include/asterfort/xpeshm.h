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
    subroutine xpeshm(nno, nnop, nnops, ndim, nddls,&
                      nddlm, npg, igeom, jpintt, jpmilt, jheavn,&
                      ivf, ipoids, idfde, ivectu, ipesa,&
                      heavt, lonch, cnset, rho, axi,&
                      yaenrm, nfiss, nfh, jfisno)
        integer :: ndim
        integer :: nnop
        integer :: nno
        integer :: nnops
        integer :: nddls
        integer :: nddlm
        integer :: npg
        integer :: igeom
        integer :: jpintt
        integer :: jpmilt
        integer :: jheavn
        integer :: ivf
        integer :: ipoids
        integer :: idfde
        integer :: ivectu
        integer :: ipesa
        integer :: heavt(*)
        integer :: lonch(10)
        integer :: cnset(*)
        real(kind=8) :: rho
        aster_logical :: axi
        integer :: yaenrm
        integer :: nfiss
        integer :: nfh
        integer :: jfisno
    end subroutine xpeshm
end interface 
