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
subroutine thmCpl003(option, angl_naut,&
                     hydr  , j_mater  ,&
                     ndim  , nbvari   ,&
                     dimdef, dimcon   ,&
                     adcote, adcp11   , adcp12, & 
                     addete, addep1   , &
                     advico, advihy   ,&
                     vihrho, vicphi   , vicpvp, vicsat,&
                     temp  , p1       ,&
                     dtemp , dp1      ,&
                     deps  , epsv     , depsv ,&
                     tbiot ,&
                     phi   , rho11    , satur ,&
                     pvp   , h11      , h12   ,&
                     congem, congep   ,&       
                     vintm , vintp    , dsde  ,& 
                     retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8maem.h"
#include "asterfort/appmas.h"
#include "asterfort/assert.h"
#include "asterfort/calor.h"
#include "asterfort/capaca.h"
#include "asterfort/dhdt.h"
#include "asterfort/dhwdp1.h"
#include "asterfort/dilata.h"
#include "asterfort/dileau.h"
#include "asterfort/dilgaz.h"
#include "asterfort/dmdepv.h"
#include "asterfort/dmvpd2.h"
#include "asterfort/dmvpp1.h"
#include "asterfort/dmwdt2.h"
#include "asterfort/dmwp1v.h"
#include "asterfort/dqvpdp.h"
#include "asterfort/dqvpdt.h"
#include "asterfort/enteau.h"
#include "asterfort/entgaz.h"
#include "asterfort/inithm.h"
#include "asterfort/masvol.h"
#include "asterfort/sigmap.h"
#include "asterfort/unsmfi.h"
#include "asterfort/viemma.h"
#include "asterfort/viporo.h"
#include "asterfort/vipvp1.h"
#include "asterfort/virhol.h"
#include "asterfort/visatu.h"
#include "asterfort/thmEvalSatuInit.h"
#include "asterfort/thmEvalSatuMiddle.h"
!
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angl_naut(3)
character(len=16), intent(in) :: hydr
integer, intent(in) :: j_mater, ndim, nbvari
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: adcote, adcp11, adcp12
integer, intent(in) :: addep1, addete
integer, intent(in) :: advihy, advico
integer, intent(in) :: vihrho, vicphi, vicpvp, vicsat
real(kind=8), intent(in) :: temp, p1
real(kind=8), intent(in) :: dtemp, dp1
real(kind=8), intent(in) :: epsv, depsv, deps(6), tbiot(6)
real(kind=8), intent(out) :: phi, rho11, satur
real(kind=8), intent(out) :: pvp, h11, h12
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
! Compute generalized stress and matrix for coupled quantities - 'LIQU_VAPE'
!
! --------------------------------------------------------------------------------------------------
!
!
! In  option           : option to compute
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  hydr             : type of hydraulic law
! In  j_mater          : coded material address
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  adcote           : adress of thermic components in generalized stresses vector
! In  adcp11           : adress of first component and first phase in generalized stresses vector
! In  adcp12           : adress of first component and second phase in generalized stresses vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  advico           : index of first internal state variable for coupling law
! In  advihy           : index of internal state variable for hydraulic law 
! In  vihrho           : index of internal state variable for volumic mass of liquid
! In  vicphi           : index of internal state variable for porosity
! In  vicpvp           : index of internal state variable for pressure of steam
! In  vicsat           : index of internal state variable for saturation
! In  temp             : temperature at end of current time step
! In  p1               : capillary pressure at end of current time step
! In  dtemp            : increment of temperature
! In  dp1              : increment of capillary pressure
! In  deps             : increment of mechanical strains vector
! In  epsv             : current volumic strain
! In  depsv            : increment of volumic strain
! In  tbiot            : Biot tensor
! Out phi              : porosity
! Out rho11            : volumic mass for liquid
! Out satur            : saturation
! Out h11              : enthalpy of liquid
! Out h12              : enthalpy of steam
! Out pvp              : steam pressure
! In  congem           : generalized stresses - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! In  vintm            : internal state variables - At begin of current step
! IO  vintp            : internal state variables - At end of current step
! IO  dsde             : derivative matrix
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: phim, phi0
    real(kind=8) :: pvpm, pvp0
    real(kind=8) :: alp11, alp12
    real(kind=8) :: rho0, rho110, rho11m, rho12m
    real(kind=8) :: cp11, cp12, cp21, cp22
    real(kind=8) :: rho12, rho21, rho22
    real(kind=8) :: em, alpliq, cliq, csigm
    real(kind=8) :: coeps
    real(kind=8) :: m11m, m12m
    real(kind=8) :: epsvm, cs, mdal(6), dalal, alpha0, alphfi, cbiot, unsks
    real(kind=8) :: rgaz, mamolv
    aster_logical :: l_emmag
    real(kind=8) :: saturm, dsatur, phids
    real(kind=8) :: dpad, dpvp, dp2, signe
    real(kind=8) :: dpvpt, dpvpl
    real(kind=8) :: p1m, p2
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(.not.(ds_thm%ds_elem%l_dof_meca))
    dpvp   = 0.d0
    dpvpl  = 0.d0
    dpvpt  = 0.d0
    dpad   = 0.d0
    rho11  = 0.d0
    rho12  = 0.d0
    rho21  = 0.d0
    rho22  = 0.d0
    cp21   = 0.d0
    cp22   = 0.d0
    alp11  = 0.d0
    alp12  = 0.d0
    signe  = -1.d0
    phi    = 0.d0
    phids  = 0.d0
    saturm = 0.d0
    dsatur = 0.d0
    satur  = 0.d0
    retcom = 0
!
! - No gaz pressure (=> infinity)
!
    dp2    = 0.d0
    p2     = r8maem()
!
! - Get initial parameters
!
    phi0   = ds_thm%ds_parainit%poro_init
    pvp0   = ds_thm%ds_parainit%prev_init
!
! - Compute steam pressure
!
    pvp    = vintm(advico+vicpvp) + pvp0
    pvpm   = vintm(advico+vicpvp) + pvp0
    p1m    = pvpm-p1+dp1
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
    mamolv = ds_thm%ds_material%steam%mass_mol
    cp12   = ds_thm%ds_material%steam%cp
!
! - Storage coefficient
!
    l_emmag = ds_thm%ds_material%hydr%l_emmag
    em      = ds_thm%ds_material%hydr%emmag
!
! - Evaluation of initial saturation
!
    call thmEvalSatuInit(hydr  , j_mater, p1m   , p1    ,&
                         saturm, satur  , dsatur, retcom)
!
! - Evaluation of initial porosity
!
    phi  = vintm(advico+vicphi) + phi0
    phim = vintm(advico+vicphi) + phi0
!
! - Evaluation of initial enthalpies/initial mass/volumic mass
!
    h11    = congem(adcp11+ndim+1)
    h12    = congem(adcp12+ndim+1)
    m11m   = congem(adcp11)
    m12m   = congem(adcp12)
    rho11  = vintm(advihy+vihrho) + rho110
    rho11m = vintm(advihy+vihrho) + rho110
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
! - Evaluation of volumic mass and save it in internal variables
!
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
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
    endif
    if (retcom .ne. 0) then
        goto 30
        endif
!
! - Compute steam pressure (no dissolved air)
!
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        call vipvp1(ndim  , nbvari,&
                    dimcon,&
                    adcp11, adcp12, advico, vicpvp,&
                    congem, &
                    cp11  , cp12  ,&
                    mamolv, rgaz  , rho11 , signe ,&
                    temp  , p2    ,&
                    dtemp , dp1   , dp2   ,&
                    pvp0  , pvpm  , pvp   ,&
                    vintm , vintp ,&
                    retcom)
    endif
    if (retcom .ne. 0) then
        goto 30
    endif
!
! - Increment of steam pressure
!
    dpvp = pvp - pvpm
!
! - Evaluation of "middle" saturation (only LIQU_VAPE)
!
    call thmEvalSatuMiddle(hydr , j_mater, pvp-p1,&
                           satur, dsatur , retcom)

    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
!
! ----- Compute porosity with storage coefficient
!
        if (l_emmag) then
            call viemma(nbvari, vintm, vintp,&
                        advico, vicphi,&
                        phi0  , dp1   , dp2 , signe, satur,&
                        em    , phi   , phim)
        endif
!
! ----- Save saturation in internal state variables
!
        call visatu(nbvari, vintp, advico, vicsat, satur)
!
        if (retcom .ne. 0) then
            goto 30
        endif
    endif
!
! ==================================================================================================
!
! Generalized stresses
!
! ==================================================================================================
!
    phids = phi*dsatur
!
! - Compute volumic mass for steam
!
    rho12  = masvol(mamolv, pvp , rgaz, temp )
    rho12m = masvol(mamolv, pvpm, rgaz, temp-dtemp)
    if (ds_thm%ds_elem%l_dof_ther) then
! ----- Compute thermal expansion of liquid
        alp11 = dileau(satur,phi,alphfi,alpliq)
! ----- Compute thermal expansion of steam
        alp12 = dilgaz(satur,phi,alphfi,temp)
! ----- Compute specific heat capacity
        call capaca(rho0, rho11, rho12, rho21, rho22,&
                    satur, phi  ,&
                    csigm, cp11 , cp12 , cp21  , cp22 ,&
                    dalal, temp , coeps, retcom)
        if (retcom .ne. 0) then
            goto 30
        endif
        if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! --------- Update enthalpy of liquid
            congep(adcp11+ndim+1) = congep(adcp11+ndim+1) +&
                                    enteau(dtemp, alpliq, temp,&
                                           rho11, dp2   , dp1 ,dpad,&
                                           signe, cp11)
! --------- Update enthalpy of steam
            congep(adcp12+ndim+1) = congep(adcp12+ndim+1) +&
                                    entgaz(dtemp, cp12)
! --------- Update "reduced" heat Q'
            congep(adcote) = congep(adcote) +&
                             calor(mdal    , temp , dtemp, deps ,&
                                   dp1-dpvp, dpvp , signe,&
                                   alp11   , alp12, coeps, ndim)
        endif
    endif
!
! - Compute derivative of stem pressure by temperature and by liquid pressure
!
    if (option(1:9) .eq. 'RIGI_MECA') then
        dpvpl = rho12m/rho11m
        if (ds_thm%ds_elem%l_dof_ther) then
            dpvpt = rho12m * (congem(adcp12+ndim+1) - congem(adcp11+ ndim+1)) / temp
        endif
    else
        dpvpl = rho12/rho11
        if (ds_thm%ds_elem%l_dof_ther) then
            dpvpt = rho12 * (congep(adcp12+ndim+1) - congep(adcp11+ ndim+1)) / temp
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
        congep(adcp12) = appmas(m12m      ,&
                                phi       , phim       ,&
                                1.d0-satur, 1.d0-saturm,&
                                rho12     , rho12m     ,&
                                epsv      , epsvm)
    endif
!
! ==================================================================================================
!
! Tangent matrix
!
! ==================================================================================================
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (ds_thm%ds_elem%l_dof_ther) then
! --------- Derivative of enthalpy of liquid by capillary pressure
            dsde(adcp11+ndim+1,addep1) = dsde(adcp11+ndim+1,addep1) + &
                                         dhwdp1(signe,alpliq,temp,rho11)
! --------- Derivative of enthalpy of liquid by temperature
            dsde(adcp11+ndim+1,addete) = dsde(adcp11+ndim+1,addete) +&
                                         dhdt(cp11)
! --------- Derivative of enthalpy of steam by temperature
            dsde(adcp12+ndim+1,addete) = dsde(adcp12+ndim+1,addete) +&
                                         dhdt(cp12)
! --------- Derivative of quantity of mass from liquid by liquid pressure
            dsde(adcp11,addete) = dsde(adcp11,addete) +&
                                  dmwdt2(rho11, alp11,phids,satur,cs,dpvpt)
! --------- Derivative of quantity of mass from steam pressure by gaz pressure
            dsde(adcp12,addete) = dsde(adcp12,addete) +&
                                  dmvpd2(rho12, alp12, dpvpt, phi, satur, pvp, phids, cs)
! --------- Derivative of "reduced" heat Q' of steam by temperature
            dsde(adcote,addete) = dsde(adcote,addete) + &
                                  dqvpdt(coeps, alp12, temp, dpvpt)
! --------- Derivative of "reduced" heat Q' of steam by steam pressure
            dsde(adcote,addep1) = dsde(adcote,addep1) + &
                                  dqvpdp(alp11, alp12, temp, dpvpl)
        endif
! ----- Derivative of quantity of mass by liquid pressure
        dsde(adcp11,addep1) = dsde(adcp11,addep1) +&
                              dmwp1v(rho11, phids,satur,cs,dpvpl,phi,cliq)
! ----- Derivative of quantity of mass from steam pressure by liquid pressure
        dsde(adcp12,addep1) = dsde(adcp12,addep1) +&
                              dmvpp1(rho11, rho12,phids,cs,dpvpl,satur,phi,pvp)
    endif
!
 30 continue
!
! - Get new enthalpy of liquid
!
    h11 = congep(adcp11+ndim+1)
!
! - Get new enthalpy of steam
!
    h12 = congep(adcp12+ndim+1)
!
end subroutine
