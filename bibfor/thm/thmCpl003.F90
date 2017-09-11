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
subroutine thmCpl003(option, hydr,&
                  imate, ndim, dimdef, dimcon, nbvari,&
                  yate, advihy,&
                  advico, vihrho, vicphi, vicpvp, vicsat,&
                  addep1, adcp11, adcp12, addete, adcote,&
                  congem, congep, vintm, vintp, dsde,&
                  epsv, depsv, p1, dp1, temp,&
                  dt, phi, pvp, h11, h12,&
                  rho11, satur, retcom,&
                  tbiot, angl_naut, deps)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8maem.h"
#include "asterfort/appmas.h"
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
real(kind=8), intent(in) :: temp
!
! ======================================================================
! ROUTINE HMLIVA : CETTE ROUTINE CALCULE LES CONTRAINTES GENERALISEES
!   ET LA MATRICE TANGENTE DES GRANDEURS COUPLEES, A SAVOIR CELLES QUI
!   NE SONT PAS DES GRANDEURS DE MECANIQUE PURE OU DES FLUX PURS
!   DANS LE CAS OU THMC = 'LIQU_VAPE'
! ======================================================================
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
! COMMENTAIRE DE NMCONV :
!                       = 0 OK
!                       = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
!                       = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
! ======================================================================
!
    integer :: ndim, dimdef, dimcon, nbvari, imate, yate, retcom
    integer :: adcp11, adcp12, adcote, addep1, addete
    integer :: advihy, advico, vihrho, vicphi, vicpvp, vicsat
    real(kind=8) :: congem(dimcon), congep(dimcon)
    real(kind=8) :: vintm(nbvari), vintp(nbvari)
    real(kind=8) :: dsde(dimcon, dimdef)
    real(kind=8) :: epsv, depsv, p1, dp1, dt
    real(kind=8) :: phi, pvp, h11, h12, rho11
    real(kind=8) :: phi0, pvp0
    real(kind=8) :: ums, phids, angl_naut(3)
    character(len=16) :: option, hydr
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    real(kind=8) :: saturm, epsvm, phim, rho11m, rho12m, pvpm, rho110, dpvp
    real(kind=8) :: dpvpt, dpvpl, tbiot(6), cs, alpliq, cliq
    real(kind=8) :: cp11, cp12, satur, dsatur_dp1, mamolv, em
    real(kind=8) :: r, rho0, csigm, alp11, alp12, rho12, alpha0
    real(kind=8) :: deps(6), mdal(6), dalal, alphfi, cbiot, unsks
    aster_logical :: l_emmag
    real(kind=8) :: m11m, m12m, coeps, pinf, dp2, cp21, cp22, rho21
    real(kind=8) :: rho22, dpad, signe, p1m
!
! - Get initial parameters
!
    phi0   = ds_thm%ds_parainit%poro_init
    pvp0   = ds_thm%ds_parainit%prev_init
!
! - Compute pressures
!
    pvp    = vintm(advico+vicpvp) + pvp0
    pvpm   = vintm(advico+vicpvp) + pvp0
    p1m    = pvpm-p1+dp1
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
    mamolv = ds_thm%ds_material%steam%mass_mol
    cp12   = ds_thm%ds_material%steam%cp
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
! --- POUR EVITER DES PB AVEC OPTIMISEUR ON MET UNE VALEUR DANS CES ----
! --- VARIABES POUR QU ELLES AIENT UNE VALEUR MEME DANS LES CAS OU -----
! --- ELLES NE SONT THEOTIQUEMENT PAS UTILISEES ------------------------
! ======================================================================
    dpvp = 0.0d0
    dpvpl = 0.0d0
    dpvpt = 0.0d0
    signe = -1.0d0
    dp2 = 0.0d0
    dpad = 0.0d0
    rho21 = 0.0d0
    rho22 = 0.0d0
    cp21 = 0.0d0
    cp22 = 0.0d0
    retcom = 0
    rho11 = vintm(advihy+vihrho) + rho110
    rho11m = vintm(advihy+vihrho) + rho110
    phi = vintm(advico+vicphi) + phi0
    phim = vintm(advico+vicphi) + phi0
    h11 = congem(adcp11+ndim+1)
    h12 = congem(adcp12+ndim+1)
    m11m = congem(adcp11)
    m12m = congem(adcp12)
!
! - Prepare initial parameters for coupling law
!
    call inithm(angl_naut, tbiot , phi0 ,&
                epsv     , depsv ,&
                epsvm    , cs    , mdal , dalal,&
                alpha0   , alphfi, cbiot, unsks)
! *********************************************************************
! *** LES VARIABLES INTERNES ******************************************
! *********************************************************************
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
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
! --- EN LIQU_VAPE CALCUL DE RHO11, DES ENTHALPIES DE PVP ET RHOVP ----
! =====================================================================
        pinf = r8maem()
        if (yate .eq. 1) then
            call vipvp1(nbvari, vintm, vintp, advico, vicpvp,&
                        dimcon, pinf, congem, adcp11, adcp12,&
                        ndim, pvp0, dp1, dp2, temp,&
                        dt, mamolv, r, rho11, signe,&
                        cp11, cp12, yate, pvp, pvpm,&
                        retcom)
        else
            call vipvp1(nbvari, vintm, vintp, advico, vicpvp,&
                        dimcon, pinf, congem, adcp11, adcp12,&
                        ndim, pvp0, dp1, dp2, temp,&
                        dt, mamolv, r, rho11, signe,&
                        0.d0, cp12, yate, pvp, pvpm,&
                        retcom)
        endif
! =====================================================================
! --- PROBLEME DANS LE CALCUL DES VARIABLES INTERNES ? ----------------
! =====================================================================
        if (retcom .ne. 0) then
            goto 30
        endif
    endif
    dpvp = pvp - pvpm
!
! - Evaluation of "middle" saturation (only LIQU_VAPE)
!
    call thmEvalSatuMiddle(hydr , imate     , pvp-p1,&
                           satur, dsatur_dp1, retcom)

    if ((option.eq.'RAPH_MECA') .or. (option.eq.'FORC_NODA') .or.&
        (option(1:9).eq.'FULL_MECA')) then
! =====================================================================
! --- CALCUL DE LA VARIABLE INTERNE DE POROSITE SELON FORMULE DOCR ----
! =====================================================================
!        if ((yamec.eq.1)) then
! =====================================================================
! --- ON POSE ICI P2 = PVP ET P1 = - (PVP - PW) (ON CHANGE LE SIGNE ---
! --- CAR ON MULTIPLIE DANS VIPORO PAR -1) ----------------------------
! =====================================================================
!        endif
! ----- Compute porosity with storage coefficient
        if (l_emmag) then
            call viemma(nbvari, vintm, vintp,&
                        advico, vicphi,&
                        phi0  , dp1   , dp2 , signe, satur,&
                        em    , phi   , phim)
        endif
! =====================================================================
! --- RECUPERATION DE LA VARIABLE INTERNE DE SATURATION ---------------
! =====================================================================
        call visatu(nbvari, vintp, advico, vicsat, satur)
! =====================================================================
! --- PROBLEME DANS LE CALCUL DES VARIABLES INTERNES ? ----------------
! =====================================================================
        if (retcom .ne. 0) then
            goto 30
        endif
    endif
! =====================================================================
! --- QUELQUES INITIALISATIONS ----------------------------------------
! =====================================================================
    ums = 1.d0 - satur
    phids = phi*dsatur_dp1
! **********************************************************************
! *** LES CONTRAINTES GENERALISEES *************************************
! **********************************************************************
! ======================================================================
! --- CALCUL DES MASSES VOLUMIQUES DE PRESSION DE VAPEUR ---------------
! ----------------------------------- AIR SEC --------------------------
! ----------------------------------- AIR DISSOUS ----------------------
! ======================================================================
    rho12 = masvol(mamolv,pvp ,r,temp )
    rho12m = masvol(mamolv,pvpm,r,temp-dt)
! =====================================================================
! --- CALCULS UNIQUEMENT SI PRESENCE DE THERMIQUE ---------------------
! =====================================================================
    if (yate .eq. 1) then
! =====================================================================
! --- CALCUL DES COEFFICIENTS DE DILATATIONS ALPHA SELON FORMULE DOCR -
! =====================================================================
        alp11 = dileau(satur,phi,alphfi,alpliq)
        alp12 = dilgaz(satur,phi,alphfi,temp)
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
            congep(adcp12+ndim+1) = congep(adcp12+ndim+1) +&
                                    entgaz(dt, cp12)
            h11 = congep(adcp11+ndim+1)
            h12 = congep(adcp12+ndim+1)
! ======================================================================
! --- CALCUL DE LA CHALEUR REDUITE Q' SELON FORMULE DOCR ---------------
! =====================================================================
! --- ON POSE ICI P2 = PVP ET P1 = - (PVP - PW) (ON CHANGE LE SIGNE ---
! --- CAR ON MULTIPLIE DANS VIPORO PAR -1) ----------------------------
! ======================================================================
            congep(adcote) = congep(adcote) +&
                             calor(mdal,temp,dt,deps, dp1-dpvp,dpvp,signe,alp11,alp12,coeps, ndim)
        endif
    endif
! =====================================================================
! --- DPVPL DERIVEE PRESSION DE VAPEUR / PRESSION DE LIQUIDE ----------
! --- DPVPT DERIVEE PRESSION DE VAPEUR / TEMP -------------------------
! =====================================================================
    if (option(1:9) .eq. 'RIGI_MECA') then
        dpvpl = rho12m/rho11m
        if (yate .eq. 1) then
            dpvpt = rho12m * (congem(adcp12+ndim+1) - congem(adcp11+ ndim+1)) / temp
        endif
    else
        dpvpl = rho12/rho11
        if (yate .eq. 1) then
            dpvpt = rho12 * (congep(adcp12+ndim+1) - congep(adcp11+ ndim+1)) / temp
        endif
    endif
! ======================================================================
! --- CALCUL SI PAS RIGI_MECA_TANG -------------------------------------
! ======================================================================
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! ======================================================================
! --- CALCUL DES CONTRAINTES DE PRESSIONS : PAS D ACTUALITE TANT QUE
!      PAS COUPLE
! ======================================================================
! ======================================================================
! --- CALCUL DES APPORTS MASSIQUES SELON FORMULE DOCR ------------------
! ======================================================================
        congep(adcp11) = appmas(m11m,phi,phim,satur,saturm,rho11, rho11m, epsv,epsvm)
        congep(adcp12) = appmas(m12m,phi,phim,1.0d0-satur, 1.0d0-saturm, rho12,rho12m,epsv,epsvm)
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
!        if (yamec .eq. 1) then
!        endif
        if (yate .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE THERMIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DES ENTHALPIES -------------------------------
! ======================================================================
            dsde(adcp11+ndim+1,addep1) = dsde(adcp11+ndim+1,addep1) + &
                                         dhwdp1(signe,alpliq,temp,rho11)
            dsde(adcp11+ndim+1,addete) = dsde(adcp11+ndim+1,addete) + dhdt(cp11)
            dsde(adcp12+ndim+1,addete) = dsde(adcp12+ndim+1,addete) + dhdt(cp12)
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIR THERMIQUE ------------------------------
! ======================================================================
            dsde(adcp11,addete) = dsde(adcp11,addete) +&
                                  dmwdt2(rho11, alp11,phids,satur,cs,dpvpt)
            dsde(adcp12,addete) = dsde(adcp12,addete) +&
                                  dmvpd2(rho12, alp12,dpvpt,phi,ums,pvp,phids,cs)
! ======================================================================
! --- CALCUL DE LA DERIVEE DE LA CHALEUR REDUITE Q' --------------------
! ======================================================================
            dsde(adcote,addete) = dsde(adcote,addete) + dqvpdt(coeps,alp12,temp,dpvpt)
            dsde(adcote,addep1) = dsde(adcote,addep1) + dqvpdp(alp11,alp12,temp,dpvpl)
! ======================================================================
! --- CALCUL DE LA DERIVEE DE LA CHALEUR REDUITE Q' --------------------
! --- UNIQUEMENT POUR LA PARTIE MECANIQUE : AUJOURD'HUI NON PREVUE 
! ======================================================================
!            if (yamec .eq. 1) then
!    a completer le cas echeant
!            endif
        endif
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- POUR LES AUTRES CAS ----------------------------------------------
! ======================================================================
        dsde(adcp11,addep1) = dsde(adcp11,addep1) +&
                              dmwp1v(rho11, phids,satur,cs,dpvpl,phi,cliq)
        dsde(adcp12,addep1) = dsde(adcp12,addep1) +&
                              dmvpp1(rho11, rho12,phids,ums,cs,dpvpl,satur,phi,pvp)
    endif
! =====================================================================
 30 continue
! =====================================================================
end subroutine
