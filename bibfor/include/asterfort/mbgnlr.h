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
! aslint: disable=W1504
!
interface
    subroutine mbgnlr(option,vecteu,matric,nno,ncomp,imate,icompo,dff,alpha,beta,&
                  h,preten,igeom,ideplm,ideplp,kpg,fami,ipoids,icontp,ivectu,imatuu)
    character(len=4) :: fami
    character(len=16) :: option
    integer :: nno, ncomp, kpg
    integer :: imate, icompo, igeom, ideplm, ideplp, ipoids, icontp, ivectu
    integer :: imatuu
    real(kind=8) :: dff(2, nno), alpha, beta, h, preten
    aster_logical :: vecteu, matric
    end subroutine mbgnlr
end interface
