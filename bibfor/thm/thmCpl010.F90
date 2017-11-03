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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine thmCpl010(option   , angl_naut,&
                     j_mater  ,&
                     ndim     , nbvari   ,&
                     dimdef   , dimcon   ,&
                     adcome   , adcote   , adcp11, adcp12, adcp21, adcp22,&
                     addeme   , addete   , addep1, addep2,&
                     temp     , p1       , p2    ,&
                     dtemp    , dp1      , dp2   ,&
                     deps     , epsv     , depsv ,&
                     tbiot    ,&
                     phi      , rho11    , satur ,&
                     padp     , pvp      , h11   , h12   ,&
                     congem   , congep   ,&
                     vintm    , vintp    , dsde  ,&
                     retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/appmas.h"
#include "asterfort/calor.h"
#include "asterfort/capaca.h"
#include "asterfort/dhdt.h"
#include "asterfort/dhw2dt.h"
#include "asterfort/dhw2p1.h"
#include "asterfort/dhw2p2.h"
#include "asterfort/dilata.h"
#include "asterfort/dileau.h"
#include "asterfort/dilgaz.h"
#include "asterfort/dmadp1.h"
#include "asterfort/dmadp2.h"
#include "asterfort/dmadt.h"
#include "asterfort/dmasdt.h"
#include "asterfort/dmasp1.h"
#include "asterfort/dmasp2.h"
#include "asterfort/dmdepv.h"
#include "asterfort/dmwdp1.h"
#include "asterfort/dmwdp2.h"
#include "asterfort/dmwdt.h"
#include "asterfort/dpladg.h"
#include "asterfort/dqdeps.h"
#include "asterfort/dqdp.h"
#include "asterfort/dqdt.h"
#include "asterfort/dspdp1.h"
#include "asterfort/dspdp2.h"
#include "asterfort/enteau.h"
#include "asterfort/entgaz.h"
#include "asterfort/inithm.h"
#include "asterfort/majpad.h"
#include "asterfort/majpas.h"
#include "asterfort/masvol.h"
#include "asterfort/sigmap.h"
#include "asterfort/unsmfi.h"
#include "asterfort/viemma.h"
#include "asterfort/viporo.h"
#include "asterfort/virhol.h"
#include "asterfort/visatu.h"
#include "asterfort/thmEvalSatuInit.h"
!
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: j_mater, ndim, nbvari
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: adcome, adcote, adcp11, adcp12, adcp21, adcp22
integer, intent(in) :: addeme, addete, addep1, addep2
real(kind=8), intent(in) :: temp, p1, p2
real(kind=8), intent(in) :: dtemp, dp1, dp2
real(kind=8), intent(in) :: epsv, depsv, deps(6), tbiot(6)
real(kind=8), intent(out) :: phi, rho11, satur
real(kind=8), intent(out) :: padp, pvp, h11, h12
real(kind=8), intent(in) :: congem(dimcon)
real(kind=8), intent(inout) :: congep(dimcon)
real(kind=8), intent(in) :: vintm(nbvari)
real(kind=8), intent(inout) :: vintp(nbvari)
real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
integer, intent(out)  :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute generalized stress and matrix for coupled quantities - 'LIQU_AD_GAZ'
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  j_mater          : coded material address
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  adcome           : adress of mechanic components in generalized stresses vector
! In  adcote           : adress of thermic components in generalized stresses vector
! In  adcp11           : adress of first component and first phase in generalized stresses vector
! In  adcp12           : adress of first component and second phase in generalized stresses vector
! In  adcp21           : adress of second component and first phase in generalized stresses vector
! In  adcp22           : adress of second component and second phase in generalized stresses vector
! In  addeme           : adress of mechanic components in generalized strains vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  addep2           : adress of gaz pressure in generalized strains vector
! In  temp             : temperature at end of current time step
! In  p1               : capillary pressure at end of current time step
! In  p2               : gaz pressure at end of current time step
! In  dtemp            : increment of temperature
! In  dp1              : increment of capillary pressure
! In  dp2              : increment of gaz pressure
! In  deps             : increment of mechanical strains vector
! In  epsv             : current volumic strain
! In  depsv            : increment of volumic strain
! In  tbiot            : Biot tensor
! Out phi              : porosity
! Out rho11            : volumic mass for liquid
! Out satur            : saturation
! Out padp             : "dissolved" air pressure
! Out pvp              : steam pressure
! Out h11              : enthalpy of liquid
! Out h12              : enthalpy of steam
! In  congem           : generalized stresses - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! In  vintm            : internal state variables - At begin of current step
! IO  vintp            : internal state variables - At end of current step
! IO  dsde             : derivative matrix
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8) :: phim, phi0
    real(kind=8) :: pvpm
    real(kind=8) :: alp11, alp12, alp21
    real(kind=8) :: rho0, rho110, rho11m, rho21m, rho22m
    real(kind=8) :: cp11, cp12, cp21, cp22
    real(kind=8) :: rho12, rho21, rho22
    real(kind=8) :: em, alpliq, cliq, csigm
    real(kind=8) :: coeps
    real(kind=8) :: m11m, m21m, m22m
    real(kind=8) :: epsvm, cs, mdal(6), dalal, alpha0, alphfi, cbiot, unsks
    real(kind=8) :: rgaz, mamolg, kh
    aster_logical :: l_emmag
    real(kind=8) :: saturm, dsatur
    real(kind=8) :: dpad, signe
    real(kind=8) :: dmdeps(6), sigmp(6), dsdp1(6), dsdp2(6)
    real(kind=8) :: dqeps(6)
    real(kind=8) :: pas, p1m, padm
    real(kind=8) :: dp11t, dp11p1, dp11p2
    real(kind=8) :: dp21t, dp21p1, dp21p2
    integer :: advihy, advico
    integer :: vihrho, vicphi, vicpvp, vicsat
!
! --------------------------------------------------------------------------------------------------
!
    padp   = 0.d0
    pvp    = 0.d0
    h11    = 0.d0
    h12    = 0.d0
    rho12  = 0.d0
    rho21  = 0.d0
    rho22  = 0.d0
    cp11   = 0.d0
    cp12   = 0.d0
    cp21   = 0.d0
    cp22   = 0.d0
    signe  = 1.d0
    alp11  = 0.d0
    alp12  = 0.d0
    alp21  = 0.d0
    retcom = 0
!
! - Get storage parameters for behaviours
!
    advico    = ds_thm%ds_behaviour%advico
    advihy    = ds_thm%ds_behaviour%advihy
    vihrho    = ds_thm%ds_behaviour%vihrho
    vicphi    = ds_thm%ds_behaviour%vicphi
    vicpvp    = ds_thm%ds_behaviour%vicpvp
    vicsat    = ds_thm%ds_behaviour%vicsat
!
! - Get initial parameters
!
    phi0 = ds_thm%ds_parainit%poro_init
!
! - Compute steam pressure
!
    pvp    = 0.d0
    pvpm   = 0.d0
    p1m    = p1-dp1
!
! - Get material parameters
!
    rgaz   = ds_thm%ds_material%solid%r_gaz
    rho0   = ds_thm%ds_material%solid%rho
    csigm  = ds_thm%ds_material%solid%cp
    rho110 = ds_thm%ds_material%liquid%rho
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    cp11   = ds_thm%ds_material%liquid%cp
    mamolg = ds_thm%ds_material%gaz%mass_mol
    cp21   = ds_thm%ds_material%gaz%cp
    kh     = ds_thm%ds_material%ad%coef_henry
    cp22   = ds_thm%ds_material%ad%cp
!
! - Storage coefficient
!
    l_emmag = ds_thm%ds_material%hydr%l_emmag
    em      = ds_thm%ds_material%hydr%emmag
!
! - Evaluation of initial saturation
!
    call thmEvalSatuInit(j_mater, p1m   , p1    ,&
                         saturm, satur  , dsatur, retcom)
!
! - Evaluation of initial porosity
!
    phi    = vintm(advico+vicphi) + phi0
    phim   = vintm(advico+vicphi) + phi0
!
! - Evaluation of initial enthalpies/initial mass/volumic mass
!
    h11    = congem(adcp11+ndim+1)
    h12    = congem(adcp12+ndim+1)
    m11m   = congem(adcp11)
    m21m   = congem(adcp21)
    m22m   = congem(adcp22)
    rho11m = vintm(advihy+vihrho) + rho110
    rho11  = vintm(advihy+vihrho) + rho110
!
! - Prepare initial parameters for coupling law
!
    call inithm(angl_naut, tbiot , phi0 ,&
                epsv     , depsv ,&
                epsvm    , cs    , mdal , dalal,&
                alpha0   , alphfi, cbiot, unsks)
!
! ==================================================================================================
!
! Internal state variables
!
! ==================================================================================================
!
    vintp(advico+vicpvp) = 0.d0
!
! - Evaluation of porosity and save it in internal variables
!
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! ----- Compute standard porosity
        if (ds_thm%ds_elem%l_dof_meca) then
            call viporo(nbvari,&
                        advico, vicphi,&
                        dtemp , dp1   , dp2   ,&
                        deps  , depsv ,&
                        signe , satur , unsks , phi0,&
                        cs    , tbiot , cbiot ,&
                        alpha0, alphfi,&
                        vintm , vintp ,&
                        phi   , phim  , retcom)
        endif
! ----- Compute porosity with storage coefficient
        if (l_emmag) then
            call viemma(nbvari, vintm, vintp,&
                        advico, vicphi,&
                        phi0  , dp1   , dp2 , signe, satur,&
                        em    , phi   , phim)
        endif
! ----- Update "dissolved" air pressure
        call majpad(rgaz , kh  ,&
                    temp , p2  ,&
                    dtemp, dp2 ,&
                    pvpm , pvp ,&
                    padm , padp, dpad)
! ----- Compute volumic mass for water
        if (ds_thm%ds_elem%l_dof_ther) then
            call virhol(nbvari, vintm , vintp ,&
                        advihy, vihrho,&
                        dtemp , dp1   , dp2   , dpad,& 
                        cliq  , alpliq, signe ,&
                        rho110, rho11 , rho11m,&
                        retcom)
        else
            call virhol(nbvari, vintm , vintp ,&
                        advihy, vihrho,&
                        dtemp , dp1   , dp2   , dpad,& 
                        cliq  , 0.d0  , signe ,&
                        rho110, rho11 , rho11m,&
                        retcom)
        endif
! ----- Save saturation in internal state variables
        call visatu(nbvari, vintp, advico, vicsat, satur)
    else
! ----- Update "dissolved" air pressure
        call majpad(rgaz , kh  ,&
                    temp , p2  ,&
                    dtemp, dp2 ,&
                    pvpm , pvp ,&
                    padm , padp, dpad)
    endif
    if (retcom .ne. 0) then
        goto 30
    endif
!
! - Update differential thermal expansion ratio
!
    if (ds_thm%ds_elem%l_dof_meca) then
        call dilata(angl_naut, phi, tbiot, alphfi)
    endif
!
! - Update Biot modulus
!
    if (ds_thm%ds_elem%l_dof_meca) then
        call unsmfi(phi, tbiot, cs)
    endif
!
! ==================================================================================================
!
! Generalized stresses
!
! ==================================================================================================
!
!
! - Compute volumic mass for dry air
!
    rho21m = masvol(mamolg, p2-dp2-pvpm, rgaz, temp-dtemp)
    rho21  = masvol(mamolg, p2-pvp     , rgaz, temp)
!
! - Compute volumic mass for dissolved air
!
    rho22m = masvol(mamolg, padm, rgaz, temp-dtemp)
    rho22  = masvol(mamolg, padp, rgaz, temp)
!
! - Compute dry air pressure
!
    pas    = majpas(p2, pvp)
!
    if (ds_thm%ds_elem%l_dof_ther) then
! ----- Compute thermal expansion of liquid
        alp11 = dileau(satur,phi,alphfi,alpliq)
! ----- Compute thermal expansion of dry air
        alp21 = dilgaz(satur,phi,alphfi,temp)
! ----- Compute specific heat capacity
        call capaca(rho0, rho11, rho12, rho21, rho22,&
                    satur, phi  , &
                    csigm, cp11 , cp12 , cp21  , cp22 ,&
                    dalal, temp , coeps, retcom)
        if (retcom .ne. 0) then
            goto 30
        endif
        if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! --------- Update enthalpy of liquid
            congep(adcp11+ndim+1) = congep(adcp11+ndim+1) +&
                                    enteau(dtemp, alpliq, temp,&
                                           rho11, dp2   , dp1 , dpad,&
                                           signe, cp11)
! --------- Update enthalpy of steam
            congep(adcp12+ndim+1) = 0.d0
! --------- Update enthalpy of dry air
            congep(adcp21+ndim+1) = congep(adcp21+ndim+1) +&
                                    entgaz(dtemp, cp21)
! --------- Update enthalpy of dissolved air
            congep(adcp22+ndim+1) = congep(adcp22+ndim+1) +&
                                    entgaz(dtemp, cp22)
! --------- Get new enthalpy of liquid
            h11 = congep(adcp11+ndim+1)
! --------- Get new enthalpy of steam
            h12 = congep(adcp12+ndim+1)
! --------- Update "reduced" heat Q'
            congep(adcote) = congep(adcote) + &
                             calor(mdal , temp , dtemp, deps,&
                                   dp1  , dp2  , signe, &
                                   alp11, alp12, coeps, ndim)
        endif
    endif
!
! - Update mechanical stresses from pressures
!
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (ds_thm%ds_elem%l_dof_meca) then
            call sigmap(satur, signe, tbiot, dp2, dp1,&
                        sigmp)
            do i = 1, 3
                congep(adcome+6+i-1)=congep(adcome+6+i-1)+sigmp(i)
            end do
            do i = 4, 6
                congep(adcome+6+i-1)=congep(adcome+6+i-1)+sigmp(i)*rac2
            end do
        endif
    endif
!
! - Update quantity of mass
!
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        congep(adcp11) = appmas(m11m ,&
                                phi  , phim  ,&
                                satur, saturm,&
                                rho11, rho11m,&
                                epsv , epsvm)
        congep(adcp12) = 0.d0
        congep(adcp21) = appmas(m21m,&
                                phi       , phim,&
                                1.d0-satur, 1.d0-saturm,&
                                rho21     , rho21m,&
                                epsv      , epsvm)
        congep(adcp22) = appmas(m22m,&
                                phi  , phim  ,&
                                satur, saturm,&
                                rho22, rho22m,&
                                epsv , epsvm)
    endif
!
! ==================================================================================================
!
! Tangent matrix
!
! ==================================================================================================
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! ----- Compute partial derivatives
        call dpladg(ndim  , dimcon,&
                    rgaz  , kh    ,&
                    congem, adcp11,&
                    temp  , padp  ,&
                    dp11p1, dp11p2,&
                    dp21p1, dp21p2,&
                    dp11t , dp21t)
!
! ----- Mechanic
!
        if (ds_thm%ds_elem%l_dof_meca) then
! --------- Derivative of _pressure part_ of stresses by capillary pressure
            call dspdp1(signe, tbiot, satur, dsdp1)
! --------- Derivative of _pressure part_ of stress by total gaz pressure
            call dspdp2(tbiot, dsdp2)
            do i = 1, 3
                dsde(adcome+6+i-1,addep1) = dsde(adcome+6+i-1,addep1) +&
                                            dsdp1(i)
                dsde(adcome+6+i-1,addep2) = dsde(adcome+6+i-1,addep2) +&
                                            dsdp2(i)
            end do
            do i = 4, 6
                dsde(adcome+6+i-1,addep1) = dsde(adcome+6+i-1,addep1) +&
                                            dsdp1(i)*rac2
                dsde(adcome+6+i-1,addep2) = dsde(adcome+6+i-1,addep2) +&
                                            dsdp2(i)*rac2
            end do
! --------- Derivative of quantity of mass by capillary pressure
            call dmdepv(rho11, satur, tbiot, dmdeps)
            do i = 1, 6
                dsde(adcp11,addeme+ndim-1+i) = dsde(adcp11,addeme+ ndim-1+i) +&
                                               dmdeps(i)
            end do
! --------- Derivative of quantity of mass by steam pressure
            do i = 1, 6
                dsde(adcp12,addeme+ndim-1+i) = 0.d0
            end do
! --------- Derivative of quantity of mass by gaz pressure
                call dmdepv(rho21, 1.d0-satur, tbiot, dmdeps)
            do i = 1, 6
                dsde(adcp21,addeme+ndim-1+i) = dsde(adcp21,addeme+ ndim-1+i) +&
                                               dmdeps(i)
            end do
! --------- Derivative of quantity of mass by dissolved air pressure
            call dmdepv(rho22, satur, tbiot, dmdeps)
            do i = 1, 6
                dsde(adcp22,addeme+ndim-1+i) = dsde(adcp22,addeme+ ndim-1+i) +&
                                               dmdeps(i)
            end do
        endif
!
! ----- Thermic
!
        if (ds_thm%ds_elem%l_dof_ther) then
! --------- Derivative of enthalpy of liquid by capillary pressure
            dsde(adcp11+ndim+1,addep2) = dsde(adcp11+ndim+1,addep2) +&
                                         dhw2p2(dp11p2,alpliq,temp,rho11)
! --------- Derivative of enthalpy of liquid by gaz pressure
            dsde(adcp11+ndim+1,addep1) = dsde(adcp11+ndim+1,addep1) + &
                                         dhw2p1(signe,dp11p1,alpliq,temp,rho11)
! --------- Derivative of enthalpy of liquid by temperature
            dsde(adcp11+ndim+1,addete) = dsde(adcp11+ndim+1,addete) + &
                                         dhw2dt(dp11t,alpliq,temp,rho11,cp11)
! --------- Derivative of enthalpy of steam by temperature
            dsde(adcp12+ndim+1,addete) = 0.d0
! --------- Derivative of enthalpy of air by temperature
            dsde(adcp21+ndim+1,addete) = dsde(adcp21+ndim+1,addete) + &
                                         dhdt(cp21)
! --------- Derivative of enthalpy of dissolved air by temperature
            dsde(adcp22+ndim+1,addete) = dsde(adcp22+ndim+1,addete) + &
                                         dhdt(cp22)
! --------- Derivative of quantity of mass of liquid by temperature
            dsde(adcp11,addete) = dsde(adcp11,addete) + &
                                  dmwdt(rho11, phi,satur,cliq,dp11t,alp11)
! --------- Derivative of quantity of mass of dissolved air by temperature
            dsde(adcp22,addete) = dsde(adcp22,addete) + &
                                  dmadt(rho22, satur,phi,mamolg,dp21t,kh,alphfi)
! --------- Derivative of quantity of mass of steam by temperature
            dsde(adcp12,addete) = 0.d0
! --------- Derivative of quantity of mass of dry air by temperature
            dsde(adcp21,addete) = dsde(adcp21,addete) + &
                                  dmasdt(rho12, rho21, alp21, h11, h12, &
                                         satur, phi  ,&
                                         pas  , temp )
! --------- Derivative of "reduced" heat Q' of homogeneized medium by temperature
            dsde(adcote,addete) = dsde(adcote,addete) + dqdt(coeps)
! --------- Derivative of "reduced" heat Q' of liquid by capillary pressure
            dsde(adcote,addep1) = dsde(adcote,addep1) + dqdp(signe,alp11,temp)
! --------- Derivative of "reduced" heat Q' of liquid+steam by gaz pressure
            dsde(adcote,addep2) = dsde(adcote,addep2) - dqdp(signe,alp11+alp12,temp)
! --------- Derivative of "reduced" heat Q' by mechanical strains
            if (ds_thm%ds_elem%l_dof_meca) then
                call dqdeps(mdal, temp, dqeps)
                do i = 1, 6
                    dsde(adcote,addeme+ndim-1+i) = dsde(adcote,addeme+ ndim-1+i) +&
                                                   dqeps(i)
                end do
            endif
        endif
! ----- Derivative of quantity of mass of homogeneized medium by capillary pressure
        dsde(adcp11,addep1) = dsde(adcp11,addep1) +&
                              dmwdp1(rho11  , signe, satur, dsatur, phi, cs, cliq, -dp11p1,&
                                     l_emmag, em)
! ----- Derivative of quantity of mass of homogeneized medium by gaz pressure
        dsde(adcp11,addep2) = dsde(adcp11,addep2) +&
                              dmwdp2(rho11  , satur, phi, cs, cliq, dp11p2,&
                                     l_emmag, em)
! ----- Derivative of quantity of mass of steam by capillary pressure
        dsde(adcp12,addep1) = 0.d0
! ----- Derivative of quantity of mass of steam by gaz pressure
        dsde(adcp12,addep2) = 0.d0
! ----- Derivative of quantity of mass of "dry" air by capillary pressure
        dsde(adcp21,addep1) = dsde(adcp21,addep1) +&
                              dmasp1(rho11  , rho12, rho21, satur, dsatur, phi, cs, p2,&
                                     l_emmag, em)
! ----- Derivative of quantity of mass of "dry" air by gaz pressure
        dsde(adcp21,addep2) = dsde(adcp21,addep2) +&
                              dmasp2(rho11  , rho12, rho21, satur, phi, cs, pas,&
                                     l_emmag, em)
! ----- Derivative of quantity of mass of "dissolved" air by capillary pressure
        dsde(adcp22,addep1) = dsde(adcp22,addep1) +&
                              dmadp1(rho22  , satur, dsatur, phi, cs, mamolg, kh, dp21p1,&
                                     l_emmag, em)
! ----- Derivative of quantity of mass of "dissolved" air by gaz pressure
        dsde(adcp22,addep2) = dsde(adcp22,addep2) +&
                              dmadp2(rho22  , satur, phi, cs, mamolg, kh, dp21p2,&
                                     l_emmag, em)
    endif
!
 30 continue
!
end subroutine
