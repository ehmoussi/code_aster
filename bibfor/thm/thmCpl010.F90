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
subroutine thmCpl010(option, hydr,&
                  imate, ndim, dimdef, dimcon, nbvari,&
                  yamec, yate, addeme, adcome, advihy,&
                  advico, vihrho, vicphi, vicpvp, vicsat,&
                  addep1, adcp11, adcp12, addep2, adcp21,&
                  adcp22, addete, adcote, congem, congep,&
                  vintm, vintp, dsde, epsv, depsv,&
                  p1, p2, dp1, dp2, temp,&
                  dt, phi, padp, h11, h12,&
                  kh, rho11, satur, retcom,&
                  tbiot, angl_naut, deps)
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
real(kind=8), intent(in) :: temp
!
! **********************************************************************
! ROUTINE HMLADG : CETTE ROUTINE CALCULE LES CONTRAINTES GENERALISE
!   ET LA MATRICE TANGENTE DES GRANDEURS COUPLEES, A SAVOIR CELLES QUI
!   NE SONT PAS DES GRANDEURS DE MECANIQUE PURE OU DES FLUX PURS
!   DANS LE CAS OU THMC = 'LIQU_AD_GAZ'
! **********************************************************************
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
! COMMENTAIRE DE NMCONV :
!                       = 0 OK
!                       = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
!                       = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
!  VARIABLES IN / OUT
! ======================================================================
!
    integer :: ndim, dimdef, dimcon, nbvari, imate, yamec
    integer :: yate, retcom, adcome, adcp11, adcp12, advihy, advico
    integer :: vihrho, vicphi, vicpvp, vicsat
    integer :: adcp21, adcp22, adcote, addeme, addep1, addep2, addete
    real(kind=8) :: congem(dimcon), congep(dimcon), vintm(nbvari)
    real(kind=8) :: vintp(nbvari), dsde(dimcon, dimdef), epsv, depsv
    real(kind=8) :: p1, dp1, p2, dp2, dt, phi, padp, h11, h12
    real(kind=8) :: rho11, phi0, kh
    real(kind=8) :: angl_naut(3)
    character(len=16) :: option, hydr
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i
    real(kind=8) :: saturm, epsvm, phim, rho11m, rho21m, rho22m
    real(kind=8) :: tbiot(6), cs, alpliq, cliq, rho110
    real(kind=8) :: cp11, cp12, cp21, satur, dsatur_dp1, mamolg
    real(kind=8) :: r, rho0, coeps, csigm, alp11, alp12, alp21
    real(kind=8) :: dp11t, dp11p1, dp11p2
    real(kind=8) :: dp21t, dp21p1, dp21p2
    real(kind=8) :: rho12, rho21, cp22
    real(kind=8) :: padm, rho22, em, cbiot, unsks, alpha0
    real(kind=8) :: mdal(6), dalal, alphfi, deps(6)
    aster_logical :: l_emmag
    real(kind=8) :: signe, dpad, pas
    real(kind=8) :: m11m, m21m, m22m
    real(kind=8) :: dsdp1(6), dsdp2(6)
    real(kind=8) :: dqeps(6)
    real(kind=8) :: sigmp(6), dmdeps(6), p1m
    real(kind=8), parameter :: zero = 0.d0
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!
! - Get initial parameters
!
    phi0 = ds_thm%ds_parainit%poro_init
!
! - Compute pressures
!
    p1m  = p1-dp1
!
! - Get material parameters
!
    r      = ds_thm%ds_material%solid%r_gaz
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
! - Evaluation of initial saturation
!
    call thmEvalSatuInit(hydr  , imate, p1m       , p1    ,&
                         saturm, satur, dsatur_dp1, retcom)
!
! - Storage coefficient
!
    l_emmag = ds_thm%ds_material%hydr%l_emmag
    em      = ds_thm%ds_material%hydr%emmag

! ======================================================================
! --- INITIALISATIONS --------------------------------------------------
! ======================================================================
!    LA VARIABLE INTERNE DE PRESSION DE VAPEUR EST 0
    vintp(advico+vicpvp) = zero
    alp11 = 0.0d0
    alp12 = 0.0d0
    alp21 = 0.0d0
    signe = 1.0d0
    m11m = congem(adcp11)
    m21m = congem(adcp21)
    m22m = congem(adcp22)
    rho11 = vintm(advihy+vihrho) + rho110
    rho11m = vintm(advihy+vihrho) + rho110
    phi = vintm(advico+vicphi) + phi0
    phim = vintm(advico+vicphi) + phi0
    retcom = 0
!
! - Prepare initial parameters for coupling law
!
    call inithm(angl_naut, tbiot , phi0 ,&
                epsv     , depsv ,&
                epsvm    , cs    , mdal , dalal,&
                alpha0   , alphfi, cbiot, unsks)
!
! *********************************************************************
! *** LES VARIABLES INTERNES ******************************************
! *********************************************************************
    if ((option.eq.'RAPH_MECA') .or. (option.eq.'FORC_NODA') .or.&
        (option(1:9).eq.'FULL_MECA')) then
! =====================================================================
! --- CALCUL DE LA VARIABLE INTERNE DE POROSITE SELON FORMULE DOCR ----
! =====================================================================
        if ((yamec.eq.1)) then
            call viporo(nbvari, vintm, vintp, advico, vicphi,&
                        phi0, deps, depsv, alphfi, dt,&
                        dp1, dp2, signe, satur, cs,&
                        tbiot, cbiot, unsks, alpha0, &
                        phi, phim, retcom )
        endif
! ----- Compute porosity with storage coefficient
        if (l_emmag) then
            call viemma(nbvari, vintm, vintp,&
                        advico, vicphi,&
                        phi0  , dp1   , dp2 , signe, satur,&
                        em    , phi   , phim)
        endif
! =====================================================================
! --- MISE A JOUR DE LA PRESSION D AIR DISSOUS SELON FORMULE DOCR -----
! =====================================================================
        call majpad(p2, zero, r, temp, kh,&
                    dp2, zero, dt, padp, padm,&
                    dpad)
! ----- Compute volumic mass for water
        if (yate .eq. 1) then
            call virhol(nbvari, vintm , vintp ,&
                        advihy, vihrho,&
                        dt    , dp1   , dp2   , dpad,& 
                        cliq  , alpliq, signe ,&
                        rho110, rho11 , rho11m,&
                        retcom)
        else
            call virhol(nbvari, vintm , vintp ,&
                        advihy, vihrho,&
                        dt    , dp1   , dp2   , dpad,& 
                        cliq  , 0.d0  , signe ,&
                        rho110, rho11 , rho11m,&
                        retcom)
        endif
! =====================================================================
! --- RECUPERATION DE LA VARIABLE INTERNE DE SATURATION ---------------
! =====================================================================
        call visatu(nbvari, vintp, advico, vicsat, satur)
    else
! =====================================================================
! --- MISE A JOUR DE LA PRESSION D AIR DISSOUS SELON FORMULE DOCR -----
! =====================================================================
        call majpad(p2, zero, r, temp, kh,&
                    dp2, zero, dt, padp, padm,&
                    dpad)
    endif
! =====================================================================
! --- PROBLEME DANS LE CALCUL DES VARIABLES INTERNES ? ----------------
! =====================================================================
    if (retcom .ne. 0) then
        goto 30
    endif
! =====================================================================
! --- ACTUALISATION DE CS ET ALPHFI -----------------------------------
! =====================================================================
    if (yamec .eq. 1) then
        call dilata(angl_naut, phi, tbiot, alphfi)
        call unsmfi(phi, tbiot, cs)
    endif
! **********************************************************************
! *** LES CONTRAINTES GENERALISEES *************************************
! **********************************************************************
! ======================================================================
! --- CALCUL DES MASSES VOLUMIQUES DE PRESSION DE VAPEUR ---------------
! ----------------------------------- AIR SEC --------------------------
! ----------------------------------- AIR DISSOUS ----------------------
! ======================================================================
    rho12 = zero
    rho21 = masvol(mamolg,p2 ,r,temp)
    rho21m = masvol(mamolg,p2-dp2,r,temp-dt)
    rho22 = masvol(mamolg,padp ,r,temp)
    rho22m = masvol(mamolg,padm ,r,temp-dt)
    pas = majpas(p2,zero)
! =====================================================================
! --- CALCULS UNIQUEMENT SI PRESENCE DE THERMIQUE ---------------------
! =====================================================================
    if (yate .eq. 1) then
! =====================================================================
! --- CALCUL DES COEFFICIENTS DE DILATATIONS ALPHA SELON FORMULE DOCR -
! =====================================================================
        alp11 = dileau(satur,phi,alphfi,alpliq)
        alp12 = zero
        alp21 = dilgaz(satur,phi,alphfi,temp)
        h11 = congem(adcp11+ndim+1)
        h12 = congem(adcp12+ndim+1)
! ======================================================================
! --- CALCUL DE LA CAPACITE CALORIFIQUE SELON FORMULE DOCR -------------
! ======================================================================
        call capaca(rho0, rho11, rho12, rho21, rho22,&
                    satur, phi, csigm, cp11, cp12,&
                    cp21, cp22, dalal, temp, coeps,&
                    retcom)
! =====================================================================
! --- PROBLEME LORS DU CALCUL DE COEPS --------------------------------
! =====================================================================
        if (retcom .ne. 0) then
            goto 30
        endif
! ======================================================================
! --- CALCUL DES ENTHALPIES SELON FORMULE DOCR -------------------------
! ======================================================================
        if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
            congep(adcp11+ndim+1) = congep(adcp11+ndim+1) +&
                                    enteau(dt, alpliq,temp,rho11,dp2,dp1,dpad,signe,cp11)
            congep(adcp12+ndim+1) = zero
            congep(adcp21+ndim+1) = congep(adcp21+ndim+1) + entgaz(dt, cp21)
            congep(adcp22+ndim+1) = congep(adcp22+ndim+1) + entgaz(dt, cp22)
            h11 = congep(adcp11+ndim+1)
            h12 = congep(adcp12+ndim+1)
! ======================================================================
! --- CALCUL DE LA CHALEUR REDUITE Q' SELON FORMULE DOCR ---------------
! ======================================================================
            congep(adcote) = congep(adcote) + &
                             calor(mdal,temp,dt,deps, dp1,dp2,signe,alp11,alp12,coeps,ndim)
        endif
    endif
! ======================================================================
! --- CALCUL SI PAS RIGI_MECA_TANG -------------------------------------
! ======================================================================
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! ======================================================================
! --- CALCUL DES CONTRAINTES DE PRESSIONS ------------------------------
! ======================================================================
        if (yamec .eq. 1) then
            call sigmap(satur, signe, tbiot,&
                        dp2, dp1, sigmp)
            do i = 1, 3
                congep(adcome+6+i-1)=congep(adcome+6+i-1)+sigmp(i)
            end do
            do i = 4, 6
                congep(adcome+6+i-1)=congep(adcome+6+i-1)+sigmp(i)*rac2
            end do
        endif
! ======================================================================
! --- CALCUL DES APPORTS MASSIQUES SELON FORMULE DOCR ------------------
! ======================================================================
        congep(adcp11) = appmas(m11m,phi,phim,satur,saturm,rho11, rho11m, epsv,epsvm)
        congep(adcp12) = zero
        congep(adcp21) = appmas(m21m,phi,phim,1.d0-satur, 1.d0-saturm, rho21,rho21m,epsv,epsvm)
        congep(adcp22) = appmas(m22m,phi,phim,satur,saturm,rho22, rho22m, epsv,epsvm)
    endif
!
! **********************************************************************
! *** CALCUL DES DERIVEES **********************************************
! **********************************************************************
! ======================================================================
! --- CALCUL DES DERIVEES PARTIELLES DES PRESSIONS SELON FORMULES DOCR -
! --- UNIQUEMENT POUR LES OPTIONS RIGI_MECA ET FULL_MECA ---------------
! ======================================================================
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        call dpladg(yate, rho11, rho12, r, temp,&
                    kh, congem, dimcon, adcp11, ndim,&
                    padp, dp11p1, dp11p2, dp21p1, dp21p2,&
                    dp11t, dp21t)
        if (yamec .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE MECANIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DE SIGMAP ------------------------------------
! ======================================================================
            call dspdp1(signe, tbiot, satur, dsdp1)
            call dspdp2(tbiot, dsdp2)
            do i = 1, 3
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1) + dsdp1(i)
                dsde(adcome+6+i-1,addep2)=dsde(adcome+6+i-1,addep2) + dsdp2(i)
            end do
            do i = 4, 6
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1) + dsdp1(i)*rac2
                dsde(adcome+6+i-1,addep2)=dsde(adcome+6+i-1,addep2) + dsdp2(i)*rac2
            end do
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIE MECANIQUE ------------------------------
! ======================================================================
            do i = 1, 6
                call dmdepv(rho11, satur, tbiot, dmdeps)
                dsde(adcp11,addeme+ndim-1+i) = dsde(adcp11,addeme+ ndim-1+i) + dmdeps(i)
            end do
            do i = 1, 6
                call dmdepv(rho21, 1.d0-satur, tbiot, dmdeps)
                dsde(adcp12,addeme+ndim-1+i) =zero
                dsde(adcp21,addeme+ndim-1+i) = dsde(adcp21,addeme+ ndim-1+i) + dmdeps(i)
            end do
            do i = 1, 6
                call dmdepv(rho22, satur, tbiot, dmdeps)
                dsde(adcp22,addeme+ndim-1+i) = dsde(adcp22,addeme+ ndim-1+i) + dmdeps(i)
            end do
        endif
        if (yate .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE THERMIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DES ENTHALPIES -------------------------------
! ======================================================================
            dsde(adcp11+ndim+1,addep2) = dsde(adcp11+ndim+1,addep2) +&
                                         dhw2p2(dp11p2,alpliq,temp,rho11)
            dsde(adcp11+ndim+1,addep1) = dsde(adcp11+ndim+1,addep1) + &
                                         dhw2p1(signe,dp11p1,alpliq,temp,rho11)
            dsde(adcp11+ndim+1,addete) = dsde(adcp11+ndim+1,addete) + &
                                         dhw2dt(dp11t,alpliq,temp,rho11,cp11)
            dsde(adcp12+ndim+1,addete) = zero
            dsde(adcp21+ndim+1,addete) = dsde(adcp21+ndim+1,addete) + &
                                         dhdt(cp21)
            dsde(adcp22+ndim+1,addete) = dsde(adcp22+ndim+1,addete) + &
                                         dhdt(cp22)
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIR THERMIQUE ------------------------------
! ======================================================================
            dsde(adcp11,addete) = dsde(adcp11,addete) + &
                                  dmwdt(rho11, phi,satur,cliq,dp11t,alp11)
            dsde(adcp22,addete) = dsde(adcp22,addete) + &
                                  dmadt(rho22, satur,phi,mamolg,dp21t,kh,alphfi)
            dsde(adcp12,addete) = zero
            dsde(adcp21,addete) = dsde(adcp21,addete) + &
                                  dmasdt(rho12, rho21,satur,phi,pas,h11,h12,temp,alp21)
! ======================================================================
! --- CALCUL DE LA DERIVEE DE LA CHALEUR REDUITE Q' --------------------
! ======================================================================
            dsde(adcote,addete) = dsde(adcote,addete) + dqdt(coeps)
            dsde(adcote,addep1) = dsde(adcote,addep1) + dqdp(signe,alp11,temp)
            dsde(adcote,addep2) = dsde(adcote,addep2) - dqdp(signe,alp11+alp12,temp)
! ======================================================================
! --- CALCUL DE LA DERIVEE DE LA CHALEUR REDUITE Q' --------------------
! --- UNIQUEMENT POUR LA PARTIE MECANIQUE ------------------------------
! ======================================================================
            if (yamec .eq. 1) then
                call dqdeps(mdal, temp, dqeps)
                do i = 1, 6
                    dsde(adcote,addeme+ndim-1+i) = dsde(adcote,addeme+ ndim-1+i) + dqeps(i)
                end do
            endif
        endif
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- POUR LES AUTRES CAS ----------------------------------------------
! ======================================================================
        dsde(adcp11,addep1) = dsde(adcp11,addep1) +&
                              dmwdp1(rho11, signe,satur,dsatur_dp1,phi,cs,cliq,-dp11p1, l_emmag,em)
        dsde(adcp11,addep2) = dsde(adcp11,addep2) +&
                              dmwdp2(rho11,satur, phi,cs,cliq,dp11p2, l_emmag,em)
        dsde(adcp22,addep1) = dsde(adcp22,addep1) +&
                              dmadp1(rho22,satur, dsatur_dp1,phi,cs,mamolg,kh,dp21p1, l_emmag,em)
        dsde(adcp22,addep2) = dsde(adcp22,addep2) +&
                              dmadp2(rho22,satur, phi,cs,mamolg,kh,dp21p2, l_emmag,em)
        dsde(adcp12,addep1) = zero
        dsde(adcp12,addep2) = zero
        dsde(adcp21,addep1) = dsde(adcp21,addep1) +&
                              dmasp1(rho11, rho12,rho21,satur,dsatur_dp1,phi,cs,p2, l_emmag,em)
        dsde(adcp21,addep2) = dsde(adcp21,addep2) +&
                              dmasp2(rho11, rho12,rho21,satur,phi,cs,pas, l_emmag,em)
    endif
! ======================================================================
 30 continue
! ======================================================================
end subroutine
