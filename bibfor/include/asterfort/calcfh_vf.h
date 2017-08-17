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
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface 
    subroutine calcfh_vf(option, perman, thmc, ndim, dimdef,&
                      dimcon, yate, addep1, addep2,&
                      adcp11, adcp12,&
                      addete, dsde, p1, p2,&
                      grap1, t, grat, pvp,&
                      pad, rho11, h11, h12, r,&
                      dsatp1, permli, dperml,&
                      krel2, dkr2s, dkr2p, fick, dfickt,&
                      dfickg, fickad, dfadt, kh, cliq,&
                      alpliq, viscl, dviscl, mamolg, viscg,&
                      dviscg, mamolv, ifa,&
                      valfac, valcen)
        integer, parameter :: maxfa=6
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        character(len=16) :: option
        aster_logical :: perman
        character(len=16) :: thmc
        integer :: yate
        integer :: addep1
        integer :: addep2
        integer :: adcp11
        integer :: adcp12
        integer :: addete
        real(kind=8) :: dsde(1:dimcon, 1:dimdef)
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: grap1(3)
        real(kind=8) :: t
        real(kind=8) :: grat(3)
        real(kind=8) :: pvp
        real(kind=8) :: pad
        real(kind=8) :: rho11
        real(kind=8) :: h11
        real(kind=8) :: h12
        real(kind=8) :: r
        real(kind=8) :: dsatp1
        real(kind=8) :: permli
        real(kind=8) :: dperml
        real(kind=8) :: krel2
        real(kind=8) :: dkr2s
        real(kind=8) :: dkr2p
        real(kind=8) :: fick
        real(kind=8) :: dfickt
        real(kind=8) :: dfickg
        real(kind=8) :: fickad
        real(kind=8) :: dfadt
        real(kind=8) :: kh
        real(kind=8) :: cliq
        real(kind=8) :: alpliq
        real(kind=8) :: viscl
        real(kind=8) :: dviscl
        real(kind=8) :: mamolg
        real(kind=8) :: viscg
        real(kind=8) :: dviscg
        real(kind=8) :: mamolv
        integer :: ifa
        real(kind=8) :: valfac(maxfa, 14, 6)
        real(kind=8) :: valcen(14, 6)
    end subroutine calcfh_vf
end interface 
