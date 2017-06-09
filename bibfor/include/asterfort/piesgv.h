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
    subroutine piesgv(neps, tau, mat, lccrma, vim,&
                      epsm, epsp, epsd, typmod, lcesga,&
                      etamin, etamax, lcesbo, copilo)
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

        subroutine lcesbo(ep0, ep1, l0, l1, etamin, etamax, vide, etam, etap)
        real(kind=8),intent(in) :: ep0(6),ep1(6),l0,l1,etamin,etamax   
        aster_logical, intent(out)    :: vide     
        real(kind=8),intent(out):: etam,etap     
        end subroutine lcesbo
        end interface

        character(len=8),intent(in) :: typmod(*)
        integer,intent(in)      :: neps, mat
        real(kind=8),intent(in) :: tau, epsm(neps), epsd(neps), epsp(neps), etamin, etamax,vim(3)
        real(kind=8),intent(out):: copilo(2,*)
    end subroutine piesgv
end interface 
