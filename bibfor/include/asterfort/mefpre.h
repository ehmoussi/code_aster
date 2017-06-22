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
    subroutine mefpre(ndim, alpha, z, cf, dh,&
                      vit, rho, pstat, dpstat, dvit,&
                      itypg, zg, hg, axg, pm,&
                      xig, afluid, cdg, cfg, vitg,&
                      rhog)
        integer :: ndim(14)
        real(kind=8) :: alpha
        real(kind=8) :: z(*)
        real(kind=8) :: cf(*)
        real(kind=8) :: dh
        real(kind=8) :: vit(*)
        real(kind=8) :: rho(*)
        real(kind=8) :: pstat(*)
        real(kind=8) :: dpstat(*)
        real(kind=8) :: dvit(*)
        integer :: itypg(*)
        real(kind=8) :: zg(*)
        real(kind=8) :: hg(*)
        real(kind=8) :: axg(*)
        real(kind=8) :: pm
        real(kind=8) :: xig(*)
        real(kind=8) :: afluid
        real(kind=8) :: cdg(*)
        real(kind=8) :: cfg(*)
        real(kind=8) :: vitg(*)
        real(kind=8) :: rhog(*)
    end subroutine mefpre
end interface
