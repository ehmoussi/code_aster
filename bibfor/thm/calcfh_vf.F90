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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine calcfh_vf(nume_thmc,&
                     option   , hydr  , j_mater, ifa,&
                     t        , p1    , p2     , pvp, pad ,&
                     rho11    , h11   , h12    ,&
                     satur    , dsatur, & 
                     valfac   , valcen)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calcfh_vf_lvga.h"
#include "asterfort/calcfh_vf_ladg.h"
!
integer, intent(in) :: nume_thmc
character(len=16), intent(in) :: option, hydr
integer, intent(in) :: j_mater
integer, intent(in) :: ifa
real(kind=8), intent(in) :: t, p1, p2, pvp, pad
real(kind=8), intent(in) :: rho11, h11, h12
real(kind=8), intent(in) :: satur, dsatur
real(kind=8), intent(inout) :: valcen(14, 6)
real(kind=8), intent(inout) :: valfac(6, 14, 6)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Finite volume
!
! Compute flux and stress for hydraulic
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_thmc        : index of coupling law for THM
! In  option           : option to compute
! In  hydr             : type of hydraulic law
! In  j_mater          : coded material address
! In  ifa              : index of current face
! In  t                : temperature - At end of current step
! In  p1               : capillary pressure - At end of current step
! In  p2               : gaz pressure - At end of current step
! In  pvp              : steam pressure
! In  pad              : dissolved air pressure
! In  rho11            : current volumic mass of liquid
! In  h11              : enthalpy of capillary pressure and first phase
! In  h12              : enthalpy of capillary pressure and second phase
! In  satur            : saturation
! In  dsatur           : derivative of saturation (/pc)
! IO  valfac           : values at faces
! IO  valcen           : values at nodes
!
! --------------------------------------------------------------------------------------------------
!
    select case (nume_thmc)
    case (9)
        call calcfh_vf_lvga(option, hydr  , j_mater, ifa, &
                            t     , p1    , p2     , pvp, pad,&
                            rho11 , h11   , h12    ,&
                            satur , dsatur, & 
                            valfac, valcen)

    case (10)
        call calcfh_vf_ladg(option, hydr  , j_mater, ifa, &
                            t     , p1    , p2     , pvp, pad,&
                            rho11 , h11   , h12    ,&
                            satur , dsatur, & 
                            valfac, valcen)

    case default
        ASSERT(ASTER_FALSE)
    end select
!
end subroutine
