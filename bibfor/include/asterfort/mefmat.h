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
interface
    subroutine mefmat(ndim, numgrp, nbz, nbgrp, nbmod,&
                      matma, dcent, cp, cf, vit,&
                      rho, pstat, dpstat, rint, phix,&
                      phiy, z, matm, matr, mata,&
                      itypg, axg, zg, rhog, vitg,&
                      cdg, cpg)
        integer :: nbmod
        integer :: nbgrp
        integer :: nbz
        integer :: ndim(14)
        integer :: numgrp(*)
        real(kind=8) :: matma(*)
        real(kind=8) :: dcent(*)
        real(kind=8) :: cp(*)
        real(kind=8) :: cf(*)
        real(kind=8) :: vit(0:*)
        real(kind=8) :: rho(0:*)
        real(kind=8) :: pstat(*)
        real(kind=8) :: dpstat(*)
        real(kind=8) :: rint(*)
        real(kind=8) :: phix(nbz*nbgrp, nbmod)
        real(kind=8) :: phiy(nbz*nbgrp, nbmod)
        real(kind=8) :: z(*)
        real(kind=8) :: matm(nbmod, nbmod)
        real(kind=8) :: matr(nbmod, nbmod)
        real(kind=8) :: mata(nbmod, nbmod)
        integer :: itypg(*)
        real(kind=8) :: axg(*)
        real(kind=8) :: zg(*)
        real(kind=8) :: rhog(*)
        real(kind=8) :: vitg(*)
        real(kind=8) :: cdg(*)
        real(kind=8) :: cpg(*)
    end subroutine mefmat
end interface
