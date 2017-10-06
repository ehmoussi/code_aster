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
subroutine calcfh_vf_lvga(option, j_mater, ifa, &
                          t     , p1     , p2 , pvp, pad ,&
                          rho11 , h11    , h12,&
                          satur , dsatur , & 
                          valfac, valcen)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/hmderp.h"
#include "asterfort/utmess.h"
#include "asterfort/thmEvalFickSteam.h"
#include "asterfort/thmEvalFickAir.h"
#include "asterfort/thmEvalPermLiquGaz.h"
!
character(len=16), intent(in) :: option
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
! Compute flux and stress for hydraulic - 'LIQU_AD_GAZ_VAPE'
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
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
    integer, parameter :: con=1
    integer, parameter :: dconp1=2
    integer, parameter :: dconp2=3
    integer, parameter :: diffu=4
    integer, parameter :: ddifp1=5
    integer, parameter :: ddifp2=6
    integer, parameter :: mob=7
    integer, parameter :: dmobp1=8
    integer, parameter :: dmobp2=9
    integer, parameter :: densit=14
    integer, parameter :: wliq=1
    integer, parameter :: wvap=2
    integer, parameter :: airdis=3
    integer, parameter :: airsec=4
    integer, parameter :: rhoga=1
    integer, parameter :: rholq=2
    integer, parameter :: rhoga1=3
    integer, parameter :: rhoga2=4
    integer, parameter :: rholq1=5
    integer, parameter :: rholq2=6
    real(kind=8) :: rgaz, cvp
    real(kind=8) :: permli, dperml
    real(kind=8) :: permgz, dperms, dpermp
    real(kind=8) :: dfickt, dfickg, fick, fickad, dfadt
    real(kind=8) :: rho12, rho21, rho22, masrt, kh
    real(kind=8) :: cliq, alpliq, dficks
    real(kind=8) :: viscl, dviscl, viscg, dviscg
    real(kind=8) :: mamolg, mamolv
    real(kind=8) :: lambd1(5), lambd2(5), fv(5), fa(5)
    aster_logical :: yavp
    real(kind=8) :: gp(3), gc(3)
    real(kind=8) :: gpa(3), gca(3)
    real(kind=8) :: dp11p1, dp11p2, dp11t
    real(kind=8) :: dp21p1, dp21p2, dp21t
    real(kind=8) :: dp22p1, dp22p2, dp22t
    real(kind=8) :: dp12p1, dp12p2, dp12t
    real(kind=8) :: dcvp1, dcvp2, dcvt
    real(kind=8) :: dr11p1, dr11p2, dr11t
    real(kind=8) :: dr12p1, dr12p2, dr12t
    real(kind=8) :: dr22p1, dr22p2, dr22t
    real(kind=8) :: dr21p1, dr21p2, dr21t
    real(kind=8) :: dgpvp1(3), dgpvp2(3), dgpvt(3)
    real(kind=8) :: dgpap1(3), dgpap2(3), dgpat(3)
    real(kind=8) :: dgcvp1(3), dgcvp2(3), dgcvt(3)
    real(kind=8) :: dgcap1(3), dgcap2(3), dgcat(3)
    real(kind=8) :: dgpgp1(2), dgpgp2(2), dgpgt(2)
    real(kind=8) :: dgcgp1(2), dgcgp2(2), dgcgt(2)
    real(kind=8) :: dp1pp1(2), dp2pp1(2), dtpp1(2), dp1pp2(2), dp2pp2(2)
    real(kind=8) :: dtpp2(2), dp1pt(2), dp2pt(2), dtpt(2)
!
! --------------------------------------------------------------------------------------------------
!
    lambd1(:) = 0.d0
    lambd2(:) = 0.d0
    fa(:)     = 0.d0
    fv(:)     = 0.d0
    gc(:)     = 0.d0
    gp(:)     = 0.d0
    gca(:)    = 0.d0
    gpa(:)    = 0.d0
    dp11p1    = 0.d0
    dp11p2    = 0.d0
    dp11t     = 0.d0
    dp21p1    = 0.d0 
    dp21p2    = 0.d0 
    dp21t     = 0.d0
    dp22p1    = 0.d0 
    dp22p2    = 0.d0 
    dp22t     = 0.d0
    dp12p1    = 0.d0 
    dp12p2    = 0.d0 
    dp12t     = 0.d0
    dcvp1     = 0.d0
    dcvp2     = 0.d0 
    dcvt      = 0.d0
    dr11p1    = 0.d0 
    dr11p2    = 0.d0
    dr11t     = 0.d0
    dr12p1    = 0.d0
    dr12p2    = 0.d0 
    dr12t     = 0.d0
    dr22p1    = 0.d0 
    dr22p2    = 0.d0 
    dr22t     = 0.d0
    dr21p1    = 0.d0 
    dr21p2    = 0.d0 
    dr21t     = 0.d0
    dgpvp1(:) = 0.d0
    dgpvp2(:) = 0.d0
    dgpvt(:)  = 0.d0
    dgpap1(:) = 0.d0
    dgpap2(:) = 0.d0
    dgpat(:)  = 0.d0
    dgcvp1(:) = 0.d0
    dgcvp2(:) = 0.d0
    dgcvt(:)  = 0.d0
    dgcap1(:) = 0.d0
    dgcap2(:) = 0.d0
    dgcat(:)  = 0.d0
    dgpgp1(:) = 0.d0
    dgpgp2(:) = 0.d0
    dgpgt(:)  = 0.d0
    dgcgp1(:) = 0.d0
    dgcgp2(:) = 0.d0
    dgcgt(:)  = 0.d0
    dp1pp1(:) = 0.d0
    dp2pp1(:) = 0.d0
    dtpp1(:)  = 0.d0
    dp1pp2(:) = 0.d0
    dp2pp2(:) = 0.d0
    dtpp2(:)  = 0.d0
    dp1pt(:)  = 0.d0
    dp2pt(:)  = 0.d0
    dtpt(:)   = 0.d0
!
! - Evaluate permeability for liquid and gaz
!
    call thmEvalPermLiquGaz(j_mater, satur , p2, t,&
                            permli , dperml,&
                            permgz , dperms, dpermp)
! 
! - Evaluate Fick coefficients for steam in gaz
!
    call thmEvalFickSteam(j_mater,&
                          satur  , p2    , pvp   , t,&
                          fick   , dfickt, dfickg)
! 
! - Evaluate Fick coefficients for air in liquid
!
    call thmEvalFickAir(j_mater,&
                        satur  , pad  , p2-p1, t,&
                        fickad , dfadt)
    dficks = 0.
!
! - Get parameters
!
    rgaz   = ds_thm%ds_material%solid%r_gaz
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    viscl  = ds_thm%ds_material%liquid%visc
    dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    mamolv = ds_thm%ds_material%steam%mass_mol
    viscg  = ds_thm%ds_material%steam%visc
    dviscg = ds_thm%ds_material%steam%dvisc_dtemp
    mamolg = ds_thm%ds_material%gaz%mass_mol
    kh     = ds_thm%ds_material%ad%coef_henry
    rho12  = mamolv*pvp/rgaz/t
    rho21  = mamolg*(p2-pvp)/rgaz/t
    rho22  = mamolg*pad/rgaz/t
    masrt  = mamolg/rgaz/t
    cvp    = pvp/p2
    yavp   = .true.
!
! - Fick
!
    fv(1) = fick
    fv(2) = 0.d0
    fv(3) = 0.d0
    fv(4) = dfickg
    fv(5) = dfickt
    fa(1) = fickad
    fa(2) = 0.d0
    fa(3) = 0.d0
    fa(4) = 0.d0
    fa(5) = dfadt
!
! - Thermic conductivity
!
    lambd2(1) = permgz/viscg
    lambd2(2) = 0.d0
    lambd2(3) = dperms*dsatur/viscg
    lambd2(4) = dpermp/viscg
    lambd2(5) = -permgz/viscg/viscg*dviscg
    lambd1(1) = permli/viscl
    lambd1(2) = 0.d0
    lambd1(3) = dperml*dsatur/viscl
    lambd1(4) = 0.d0
    lambd1(5) = -permli/viscl/viscl*dviscl
!
! - Compute some derivatives
!
    call hmderp(yavp  , t     ,&
                pvp   , pad   ,&
                rho11 , rho12 , h11  , h12,&
                dp11p1, dp11p2, dp11t,&
                dp12p1, dp12p2, dp12t,&
                dp21p1, dp21p2, dp21t,&
                dp22p1, dp22p2, dp22t,&
                dp1pp1, dp2pp1, dtpp1,&
                dp1pp2, dp2pp2, dtpp2,&
                dp1pt , dp2pt , dtpt)
!
! - Pressure gradient (Eq. 5.5.1-7)
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dcvp1 = dp12p1/p2
        dcvp2 = dp12p2/p2-pvp/p2/p2
        if (ds_thm%ds_elem%l_dof_ther) then
            dcvt = dp12t/p2
        endif
    endif
!
! - Volumic mass - Derivative
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dr11p1 = rho11*dp11p1*cliq
        dr11p2 = rho11*dp11p2*cliq
        dr12p1 = rho12/pvp*dp12p1
        dr12p2 = rho12/pvp*dp12p2
        dr21p1 = masrt*dp21p1
        dr21p2 = masrt*dp21p2
        dr22p1 = mamolg/kh*dp21p1
        dr22p2 = mamolg/kh*dp21p2
        if (ds_thm%ds_elem%l_dof_ther) then
            dr11t = rho11*cliq*dp11t-3.d0*alpliq*rho11
            dr12t = rho12*(dp12t/pvp-1.d0/t)
            dr21t = masrt*dp12t-rho21/t
            dr22t = mamolg/kh*dp22t
        endif
    endif
!
    if (ifa .eq. 0) then
! ----- Compute at nodes
        valcen(densit ,rhoga)     = rho12+rho21
        valcen(densit ,rhoga1)    = dr12p1+dr21p1
        valcen(densit ,rhoga2)    = dr12p2+dr21p2
        valcen(densit ,rholq)     = rho11+rho22
        valcen(densit ,rholq1)    = dr11p1+dr22p1
        valcen(densit ,rholq2)    = dr11p2+dr22p2
        valcen(mob    ,wliq)      = rho11*permli/viscl
        valcen(dmobp1,wliq)       = dr11p1*permli/viscl+rho11*dperml*dsatur/viscl
        valcen(dmobp2,wliq)       = dr11p2*permli/viscl
        valcen(mob,wvap)          = rho12*permgz/viscg
        valcen(dmobp1,wvap)       = dr12p1*permgz/viscg+rho12*dperms*dsatur/viscg
        valcen(dmobp2,wvap)       = dr12p2*permgz/viscg+rho12*dpermp/viscg
        valcen(mob,airsec)        = rho21*permgz/viscg
        valcen(dmobp1,airsec)     = dr21p1*permgz/viscg+rho21*dperms*dsatur/viscg
        valcen(dmobp2,airsec)     = dr21p2*permgz/viscg+rho21*dpermp/viscg
        valcen(mob,airdis)        = rho22*permli/viscl
        valcen(dmobp1,airdis)     = dr22p1*permli/viscl+rho22*dperml*dsatur/viscl
        valcen(dmobp2,airdis)     = dr22p2*permli/viscl
! ****************** CONCENTRATIONS*******************
        valcen(con,wvap)          = cvp
        valcen(dconp1,wvap)       = dcvp1
        valcen(dconp2,wvap)       = dcvp2
        valcen(con,airdis)        = rho22
        valcen(dconp1,airdis)     = dr22p1
        valcen(dconp2,airdis)     = dr22p2
        valcen(diffu,wliq)        = 0.d0
        valcen(ddifp1,wliq)       = 0.d0
        valcen(ddifp2,wliq)       = 0.d0
! ****************** DIFFUSIVITES*******************
        valcen(diffu,wvap)        = rho12*(1.d0-cvp)*fick
        valcen(ddifp1,wvap)       = dr12p1*(1.d0-cvp)*fick-&
                                    rho12*dcvp1*fick+&
                                    rho12*(1.d0-cvp)*dficks*dsatur
        valcen(ddifp2,wvap)       = dr12p2*(1.d0-cvp)*fick-&
                                    rho12*dcvp2*fick+&
                                    rho12*(1.d0-cvp)*dfickg
        valcen(diffu,airsec)      = rho21*cvp*fick
        valcen(ddifp1,airsec)     = dr21p1*cvp*fick+&
                                    rho21*dcvp1*fick+&
                                    rho21*cvp*dficks*dsatur
        valcen(ddifp2,airsec)     = dr21p2*cvp*fick+&
                                    rho21*dcvp2*fick+&
                                    rho21*cvp*dfickg+&
                                    rho12*(1.d0-cvp)*dfickg
        valcen(diffu,airdis)      = fickad
        valcen(ddifp1,airdis)     = 0.d0
        valcen(ddifp2,airdis)     = 0.d0
    else
! ----- Compute on faces
! ****************** CONCENTRATIONS*******************
        valfac(ifa,con,wliq)      = 1.d0
        valfac(ifa,dconp1,wliq)   = 0.d0
        valfac(ifa,dconp2,wliq)   = 0.d0
        valfac(ifa,con,wvap)      = cvp
        valfac(ifa,dconp1,wvap)   = dcvp1
        valfac(ifa,dconp2,wvap)   = dcvp2
        valfac(ifa,con,airsec)    = 1.d0-cvp
        valfac(ifa,dconp1,airsec) = -dcvp1
        valfac(ifa,dconp2,airsec) = -dcvp2
        valfac(ifa,con,airdis)    = rho22
        valfac(ifa,dconp1,airdis) = dr22p1
        valfac(ifa,dconp2,airdis) = dr22p2
! ****************** MOBILITES*******************
        valfac(ifa,mob,wliq)      = rho11*permli/viscl
        valfac(ifa,dmobp1,wliq)   = dr11p1*permli/viscl+&
                                    rho11*dperml*dsatur/viscl
        valfac(ifa,dmobp2,wliq)   = dr11p2*permli/viscl
        valfac(ifa,mob,wvap)      = rho12*permgz/viscg
        valfac(ifa,dmobp1,wvap)   = dr12p1*permgz/viscg+&
                                    rho12*dperms*dsatur/viscg
        valfac(ifa,dmobp2,wvap)   = dr12p2*permgz/viscg+&
                                    rho12*dpermp/viscg
        valfac(ifa,mob,airsec)    = rho21*permgz/viscg
        valfac(ifa,dmobp1,airsec) = dr21p1*permgz/viscg+&
                                    rho21*dperms*dsatur/viscg
        valfac(ifa,dmobp2,airsec) = dr21p2*permgz/viscg+&
                                    rho21*dpermp/viscg
        valfac(ifa,mob,airdis)    = rho22*permli/viscl
        valfac(ifa,dmobp1,airdis) = dr22p1*permli/viscl+&
                                    rho22*dperml*dsatur/viscl
        valfac(ifa,dmobp2,airdis) = dr22p2*permli/viscl
! ****************** DIFFUSIVITES*****************
        valfac(ifa,diffu,wliq)    = 0.d0
        valfac(ifa,ddifp1,wliq)   = 0.d0
        valfac(ifa,ddifp2,wliq)   = 0.d0
        valfac(ifa,diffu,wvap)    = rho12*(1.d0-cvp)*fick
        valfac(ifa,ddifp1,wvap)   = dr12p1*(1.d0-cvp)*fick-&
                                    rho12*dcvp1*fick+&
                                    rho12*(1.d0-cvp)*dficks*dsatur
        valfac(ifa,ddifp2,wvap)   = dr12p2*(1.d0-cvp)*fick-&
                                    rho12*dcvp2*fick+&
                                    rho12*(1.d0-cvp)*dfickg
        valfac(ifa,diffu,airsec)  = rho21*cvp*fick
        valfac(ifa,ddifp1,airsec) = dr21p1*cvp*fick+&
                                    rho21*dcvp1*fick+&
                                    rho21*cvp*dficks*dsatur
        valfac(ifa,ddifp2,airsec) = dr21p2*cvp*fick+&
                                    rho21*dcvp2*fick+&
                                    rho21*cvp*dfickg+&
                                    rho12*(1.d0-cvp)*dfickg
        valfac(ifa,diffu,airdis)  = fickad
        valfac(ifa,ddifp1,airdis) = 0.d0
        valfac(ifa,ddifp2,airdis) = 0.d0
    endif
end subroutine
