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
    subroutine lcesgv(fami, kpg, ksp, ndim, neps, typmod, option, mat, lccrma, lcesga, epsm,&
                      deps, vim, itemax, precvg, sig, &
                      vip, dsidep, iret)
        interface
        subroutine lccrma(mat, fami, kpg, ksp, poum)
            integer,intent(in) :: mat, kpg, ksp
            character(len=1),intent(in):: poum
            character(len=*),intent(in) :: fami
        end subroutine lccrma

        subroutine lcesga(mode, eps, gameps, dgamde, itemax, precvg, iret)
            integer,intent(in) :: mode, itemax
            real(kind=8),intent(in) :: eps(6), precvg
            integer,intent(out):: iret
            real(kind=8),intent(out):: gameps, dgamde(6)
        end subroutine lcesga
        end interface

        character(len=8) :: typmod(*)
        character(len=16) :: option
        character(len=*) :: fami
        integer :: ndim, neps, mat, iret, kpg, ksp, itemax
        real(kind=8) :: epsm(neps), deps(neps), vim(*), precvg
        real(kind=8) :: vip(*), sig(neps), dsidep(neps, neps)
    end subroutine lcesgv
end interface 
