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
! aslint: disable=W1504
!
subroutine calcco(option, perman, nume_thmc,&
                  hydr, imate, ndim, dimdef,&
                  dimcon, nbvari, yamec, yate, addeme,&
                  adcome, advihy, advico, addep1, adcp11,&
                  adcp12, addep2, adcp21, adcp22, addete,&
                  adcote, congem, congep, vintm, vintp,&
                  dsde, deps, epsv, depsv, p1,&
                  p2, dp1, dp2, temp, dtemp,&
                  phi, pvp, pad, h11, h12,&
                  kh, rho11, satur,&
                  retcom, tbiot, vihrho, vicphi,&
                  vicpvp, vicsat, angl_naut)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/thmCpl010.h"
#include "asterfort/thmCpl009.h"
#include "asterfort/thmCpl001.h"
#include "asterfort/thmCpl002.h"
#include "asterfort/thmCpl003.h"
#include "asterfort/thmCpl004.h"
#include "asterfort/thmCpl005.h"
#include "asterfort/thmCpl006.h"
#include "asterfort/thmGetParaCoupling.h"
!
integer, intent(in) :: nume_thmc
aster_logical, intent(in) :: perman
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: ndim, nbvari
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: adcome, adcote, adcp11 
integer, intent(in) :: addeme, addete, addep1
integer, intent(in) :: advico, advihy, vihrho, vicphi
real(kind=8), intent(in) :: temp
real(kind=8), intent(in) :: dtemp, dp1
real(kind=8), intent(in) :: epsv, depsv, deps(6), tbiot(6)
real(kind=8), intent(in) :: congem(dimcon)
real(kind=8), intent(inout) :: congep(dimcon)
real(kind=8), intent(in) :: vintm(nbvari)
real(kind=8), intent(inout) :: vintp(nbvari)
real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
real(kind=8), intent(out) :: phi, rho11, satur
integer, intent(out) :: retcom

integer :: yamec, yate, imate
integer :: adcp12, adcp21, adcp22
integer :: addep2
integer :: vicpvp, vicsat
real(kind=8) :: p1, p2, dp2
real(kind=8) :: pvp, pad, h11, h12, kh
character(len=16) :: hydr
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute generalized stresses and matrix for coupled quantities
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  perman           : .true. for no-transient problem
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  adcome           : adress of mechanic components in generalized stresses vector
! In  adcote           : adress of thermic components in generalized stresses vector
! In  adcp11           : adress of first component and first phase in generalized stresses vector
! In  addeme           : adress of mechanic components in generalized strains vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  advico           : index of first internal state variable for coupling law
! In  advihy           : index of internal state variable for hydraulic law 
! In  vihrho           : index of internal state variable for volumic mass of liquid
! In  vicphi           : index of internal state variable for porosity
! In  temp             : temperature at end of current time step
! In  dtemp            : increment of temperature
! In  dp1              : increment of capillary pressure
! In  deps             : increment of mechanical strains vector
! In  epsv             : current volumic strain
! In  depsv            : increment of volumic strain
! In  tbiot            : Biot tensor
! In  congem           : generalized stresses - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! In  vintm            : internal state variables - At begin of current step
! IO  vintp            : internal state variables - At end of current step
! IO  dsde             : derivative matrix
! Out phi              : porosity
! Out rho11            : volumic mass for liquid
! Out satur            : saturation
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    integer :: bdcp11
!
! --------------------------------------------------------------------------------------------------
!
    if (perman) then
        bdcp11 = adcp11 - 1
    else
        bdcp11 = adcp11
    endif
!
! - Get parameters for coupling
!
    call thmGetParaCoupling(imate, temp)
!
! - Compute
!
    select case (nume_thmc)
!
    case (1)
! ----- LIQU_SATU
        call thmCpl001(perman, option, angl_naut,&
                       ndim  , nbvari, &
                       dimdef, dimcon,&
                       adcome, adcote, bdcp11,& 
                       addeme, addete, addep1,&
                       advico, advihy, vihrho, vicphi,&
                       temp  ,&
                       dtemp , dp1   ,&
                       deps  , epsv  , depsv,&
                       tbiot ,&
                       phi   , rho11 , satur,&
                       congem, congep,&
                       vintm , vintp , dsde,&
                       retcom)

    case (2)
        call thmCpl002(option, angl_naut,&
                       ndim  , nbvari, &
                       dimdef, dimcon,&
                       adcome, adcote, adcp11,& 
                       addeme, addete, addep1,&
                       advico,&
                       vicphi,&
                       temp  , p1    ,&
                       dtemp , dp1   ,&
                       deps  , epsv  , depsv,&
                       tbiot ,&
                       phi   , rho11 , satur,&
                       congem, congep,&
                       vintm , vintp , dsde,&
                       retcom)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_VAPE ----------------------
! ======================================================================
    case (3)
        call thmCpl003(option, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yate, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addete, adcote,&
                    congem, congep, vintm, vintp, dsde,&
                    epsv, depsv, p1, dp1, temp,&
                    dtemp, phi, pvp, h11, h12,&
                    rho11, satur, retcom,&
                    tbiot, angl_naut, deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_VAPE_GAZ ------------------
! ======================================================================
    case (4)
        call thmCpl004(option, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addep2, adcp21,&
                    addete, adcote, congem, congep, vintm,&
                    vintp, dsde, deps, epsv, depsv,&
                    p1, p2, dp1, dp2, temp,&
                    dtemp, phi, pvp, h11, h12,&
                    rho11, satur, retcom,&
                    tbiot, angl_naut)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_GAZ -----------------------
! ======================================================================
    case (5)
        call thmCpl005(option, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicsat, addep1,&
                    bdcp11, addep2, adcp21, addete, adcote,&
                    congem, congep, vintm, vintp, dsde,&
                    deps, epsv, depsv, p1, p2,&
                    dp1, dp2, temp, dtemp, phi,&
                    rho11, satur, retcom,&
                    tbiot, angl_naut)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_GAZ_ATM -------------------
! ======================================================================
    case (6)
        call thmCpl006(option, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicsat, addep1,&
                    bdcp11, addete, adcote, congem, congep,&
                    vintm, vintp, dsde, epsv, depsv,&
                    p1, dp1, temp, dtemp, phi,&
                    rho11, satur, retcom,&
                    tbiot, angl_naut, deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_AD_GAZ_VAPE ---------------
! ======================================================================
    case (9)
        call thmCpl009(option, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addep2, adcp21,&
                    adcp22, addete, adcote, congem, congep,&
                    vintm, vintp, dsde, epsv, depsv,&
                    p1, p2, dp1, dp2, temp,&
                    dtemp, phi, pad, pvp, h11,&
                    h12, kh, rho11, &
                    satur, retcom, tbiot,&
                    angl_naut, deps)
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_AD_GAZ ---------------
! ======================================================================
    case (10)
        call thmCpl010(option, hydr,&
                    imate, ndim, dimdef, dimcon, nbvari,&
                    yamec, yate, addeme, adcome, advihy,&
                    advico, vihrho, vicphi, vicpvp, vicsat,&
                    addep1, bdcp11, adcp12, addep2, adcp21,&
                    adcp22, addete, adcote, congem, congep,&
                    vintm, vintp, dsde, epsv, depsv,&
                    p1, p2, dp1, dp2, temp,&
                    dtemp, phi, pad, h11, h12,&
                    kh, rho11,satur, retcom,&
                    tbiot, angl_naut, deps)
    case default
        ASSERT(ASTER_FALSE)
    end select
end subroutine
