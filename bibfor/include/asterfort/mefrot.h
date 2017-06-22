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
    subroutine mefrot(ndim, som, vit0, promas, provis,&
                      z, ru, rint, re, cp,&
                      cf, dh, vit, rho, visc,&
                      itypg, zg, tg, dg, rugg,&
                      axg, xig, afluid, pm, cfg,&
                      vitg, rhog, viscg)
        integer :: ndim(14)
        real(kind=8) :: som(9)
        real(kind=8) :: vit0
        character(len=8) :: promas
        character(len=8) :: provis
        real(kind=8) :: z(*)
        real(kind=8) :: ru
        real(kind=8) :: rint(*)
        real(kind=8) :: re(*)
        real(kind=8) :: cp(*)
        real(kind=8) :: cf(*)
        real(kind=8) :: dh
        real(kind=8) :: vit(0:*)
        real(kind=8) :: rho(0:*)
        real(kind=8) :: visc(*)
        integer :: itypg(*)
        real(kind=8) :: zg(*)
        real(kind=8) :: tg(*)
        real(kind=8) :: dg(*)
        real(kind=8) :: rugg(*)
        real(kind=8) :: axg(*)
        real(kind=8) :: xig(*)
        real(kind=8) :: afluid
        real(kind=8) :: pm
        real(kind=8) :: cfg(*)
        real(kind=8) :: vitg(*)
        real(kind=8) :: rhog(*)
        real(kind=8) :: viscg(*)
    end subroutine mefrot
end interface
