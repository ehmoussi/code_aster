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
subroutine kfomvg(sr , m  , usm        , satur      ,&
                  krl, krg, dkrl_dsatur, dkrg_dsatur)
!
implicit none
!
real(kind=8), intent(in) :: sr, m, usm, satur
real(kind=8), intent(out) :: krl, krg, dkrl_dsatur, dkrg_dsatur
!
! --------------------------------------------------------------------------------------------------
!
! THM - Permeability (HYDR_VGM)
!
! Compute value and derivative of permeability
!
! --------------------------------------------------------------------------------------------------
!
! In  sr               : parameter VG_SR
! In  m                : parameter 1.d0-1.d0/n
! In  usm              : parameter 1.d0/m
! In  satur            : saturation
! Out krl              : value of kr(liquid)
! Out dkrl_dsatur      : value of d(kr(liquid))/dSatur
! Out krg              : value of kr(gaz)
! Out dkrg_dsatur      : value of d(kr(gaz))/dSatur
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: umsr, usumsr, a
!
! --------------------------------------------------------------------------------------------------
!
    umsr        = (1.d0-sr)
    usumsr      = 1.d0/umsr
    krl         = (satur**0.5d0)*((1.d0-(1.d0-satur**usm)**m)**2.d0)
    krg         = ((1.d0-satur)**0.5d0)*((1.d0-satur**usm)**(2.d0*m))
    a           = 1.d0-satur**usm
    dkrl_dsatur = usumsr*(krl/(2.d0*satur)+&
                  2.d0*((satur)**0.5d0)*(1.d0-a**m)*(a**(m-1.d0))*(satur**(usm-1.d0)))
    a           = 1.d0-satur
    dkrg_dsatur = usumsr*(-krg/(2.d0*a)-&
                  2.d0*(a**0.5d0)*((1.d0-satur**usm)**(2.d0*m-1.d0))*(satur**(usm-1.d0)))
!
end subroutine
