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
! aslint: disable=W1306, W1504
! person_in_charge: sylvie.granet at edf.fr
!
subroutine hmgazp(yachai, option, meca, thmc, ther,&
                  hydr, imate, ndim, dimdef, dimcon,&
                  nbvari, yamec, yate, addeme, adcome,&
                  advico, vicphi, addep1, adcp11, addete,&
                  adcote, congem, congep, vintm, vintp,&
                  dsde, epsv, depsv, p1, dp1,&
                  t, dt, phi, rho11, &
                  satur, retcom, tbiot, rinstp, angmas,&
                  deps)
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
#include "asterfort/dilata.h"
#include "asterfort/dilgaz.h"
#include "asterfort/dmasp2.h"
#include "asterfort/dmdepv.h"
#include "asterfort/dmwdt.h"
#include "asterfort/dqdeps.h"
#include "asterfort/dqdp.h"
#include "asterfort/dqdt.h"
#include "asterfort/dspdp2.h"
#include "asterfort/entgaz.h"
#include "asterfort/inithm.h"
#include "asterfort/masvol.h"
#include "asterfort/netbis.h"
#include "asterfort/sigmap.h"
#include "asterfort/thmrcp.h"
#include "asterfort/unsmfi.h"
#include "asterfort/viporo.h"
#include "asterfort/thmEvalSatuInit.h"
!
    integer :: ndim, dimdef, dimcon, nbvari, imate, yamec, yate
    integer :: adcome, adcp11, adcote
    integer :: addeme, addep1, addete, advico, vicphi, retcom
    real(kind=8) :: congem(dimcon), congep(dimcon)
    real(kind=8) :: vintm(nbvari), vintp(nbvari)
    real(kind=8) :: dsde(dimcon, dimdef), epsv, depsv, p1, dp1, t, dt
    real(kind=8) :: phi, rho11, rac2
    real(kind=8) :: angmas(3)
    character(len=16) :: option, meca, ther, hydr, thmc
    aster_logical :: yachai
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i
    real(kind=8) :: epsvm, phim
    real(kind=8) :: tbiot(6), cs, cp12, satur, mamolg
    real(kind=8) :: mdal(6), dalal, alphfi, cbiot, unsks, alpha0
    real(kind=8) :: r, rho0, csigm, alp11, em, p1m, dsatur
    real(kind=8) :: eps, rinstp, deps(6)
    parameter  ( eps = 1.d-21 )
    aster_logical :: emmag
! ======================================================================
! --- DECLARATIONS PERMETTANT DE RECUPERER LES CONSTANTES MECANIQUES ---
! ======================================================================
    real(kind=8) :: rbid6, rbid7
    real(kind=8) :: rbid10, saturm, dsatur_dp1, rbid14(3)
    real(kind=8) :: rbid16, rbid17, rbid18, rbid19
    real(kind=8) :: rbid21, rbid22, rbid23, rbid24, rbid25, rbid26
    real(kind=8) :: rbid27, rbid28, rbid29, rbid32(ndim, ndim)
    real(kind=8) :: rbid33(ndim, ndim), rbid34, rbid35, rbid36, rbid37
    real(kind=8) :: rbid39, rbid40, rbid41, rbid42, rbid43, rbid44
    real(kind=8) :: rbid45, rbid46, rbid47, rbid48, rbid49, rbid50(ndim, ndim)
    real(kind=8) :: rbid20, rbid38, dsdp2(6)
    real(kind=8) :: signe, dp2, cliq, coeps, rho12, alp21, rho21, rho21m
    real(kind=8) :: cp21, p2, satm, rho22, cp11, cp22, m11m, dmdeps(6)
    real(kind=8) :: dqeps(6)
    real(kind=8) :: sigmp(6), phi0
!
    aster_logical :: net, bishop
!
    rac2 = sqrt(2.d0)
!
! =====================================================================
! --- BUT : RECUPERER LES DONNEES MATERIAUX THM -----------------------
! --- DANS LE CALCUL ON LAISSE LES INDICES 11 POUR LE STOCKAGE DES ----
! --- VARIABLES. EN REVANCHE POUR UNE MEILLEURE COMPREHENSION PAR -----
! --- RAPPORT A LA DOC R7.01.11 ON NOTE LES INDICES 21 POUR LES -------
! --- VARIABLES DE CALCUL ---------------------------------------------
! =====================================================================
    emmag = .false.
    call netbis(meca, net, bishop)
    phi0 = ds_thm%ds_parainit%poro_init
    call thmrcp('INTERMED', imate, thmc, hydr,&
                ther, t, p1, rbid6, rbid44,&
                rbid7, rbid10, r, rho0,&
                csigm, saturm, satur, dsatur_dp1,&
                rbid14, rbid16, rbid17, rbid18,&
                rbid19, rbid20, rbid21, rbid22, rbid23,&
                rbid24, rbid25, rbid43, rbid40, rbid41,&
                rbid42, rbid26, rbid27, rbid28, rbid29,&
                mamolg, cp21, rbid32, rbid33, rbid34,&
                rbid35, rbid36, rbid37, rbid38, rbid39,&
                rbid45, rbid46, rbid47, rbid48, rbid49,&
                em, rbid50,  rinstp, retcom,&
                angmas, ndim)
!
! - Evaluation of initial saturation
!
    p1m = 0.d0
    call thmEvalSatuInit(hydr  , imate, p1m   , p1,&
                         saturm, satur, dsatur, em,&
                         retcom)

! ======================================================================
! --- POUR EVITER DES PB AVEC OPTIMISEUR ON MET UNE VALEUR DANS CES ----
! --- VARIABES POUR QU ELLES AIENT UNE VALEUR MEME DANS LES CAS OU -----
! --- ELLES NE SONT THEOTIQUEMENT PAS UTILISEES ------------------------
! =====================================================================
! --- ON INVERSE POSE DP2 = DP1 ET DP1 = 0 POUR CONFOMITE A LA FORMULE-
! =====================================================================
    retcom = 0
    signe = 1.0d0
    p2 = p1
    dp2 = dp1
    dp1 = 0.0d0
    satur = 0.0d0
    satm = 0.0d0
    alp11 = 0.0d0
    rho11 = 0.0d0
    rho21 = 0.0d0
    rho22 = 0.0d0
    cp11 = 0.0d0
    cp12 = 0.0d0
    cp22 = 0.0d0
    cliq = 0.0d0
    m11m = congem(adcp11)
    phi = vintm(advico+vicphi) + phi0
    phim = vintm(advico+vicphi) + phi0
! =====================================================================
! --- RECUPERATION DES COEFFICIENTS MECANIQUES ------------------------
! =====================================================================
    if ((em.gt.eps) .and. (yamec.eq.0)) then
        emmag = .true.
    endif
!
    call inithm(imate, yachai, yamec, phi0, em,&
                cs, tbiot, t, epsv, depsv,&
                epsvm, angmas, mdal, dalal,&
                alphfi, cbiot, unsks, alpha0)
!
! *********************************************************************
! *** LES VARIABLES INTERNES ******************************************
! *********************************************************************
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! =====================================================================
! --- CALCUL DE LA VARIABLE INTERNE DE POROSITE SELON FORMULE DOCR ----
! =====================================================================
        if ((yamec.eq.1) .or. emmag) then
            call viporo(nbvari, vintm, vintp, advico, vicphi,&
                        phi0, deps, depsv, alphfi, dt,&
                        dp1, dp2, signe, satur, cs,&
                        tbiot, cbiot, unsks, alpha0, &
                        phi, phim, retcom )
        else if (yamec .eq. 2) then
            phi = vintp(advico+vicphi)
        endif
! =====================================================================
! --- PROBLEME DANS LE CALCUL DES VARIABLES INTERNES ? ----------------
! =====================================================================
        if (retcom .ne. 0) then
            goto 30
        endif
    endif
! =====================================================================
! --- ACTUALISATION DE CS ET ALPHFI -----------------------------------
! =====================================================================
    if (yamec .eq. 1) then
        call dilata(angmas, phi, tbiot, alphfi)
        call unsmfi(imate, phi, t, tbiot, cs)
    endif
! =====================================================================
! --- CALCUL DE LA MASSE VOLUMIQUE DU GAZ AUX INSTANT PLUS ET MOINS ---
! =====================================================================
    rho21 = masvol(mamolg,p2 ,r,t )
    rho21m = masvol(mamolg,p2-dp2,r,t-dt)
!
! =====================================================================
! --- CALCULS UNIQUEMENT SI PRESENCE DE THERMIQUE ---------------------
! =====================================================================
    if (yate .eq. 1) then
! =====================================================================
! --- CALCUL DES COEFFICIENTS DE DILATATIONS ALPHA SELON FORMULE DOCR -
! =====================================================================
        alp21 = dilgaz(satur,phi,alphfi,t)
! ======================================================================
! --- CALCUL DE LA CAPACITE CALORIFIQUE SELON FORMULE DOCR -------------
! ======================================================================
        call capaca(rho0, rho11, rho12, rho21, rho22,&
                    satur, phi, csigm, cp11, cp12,&
                    cp21, cp22, dalal, t, coeps,&
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
        if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
            congep(adcp11+ndim+1)=congep(adcp11+ndim+1)+entgaz(dt,&
            cp21)
! ======================================================================
! --- CALCUL DE LA CHALEUR REDUITE Q' SELON FORMULE DOCR ---------------
! ======================================================================
            congep(adcote) = congep(adcote) +&
                             calor(mdal,t,dt,deps, dp1,dp2,signe,alp11,alp21, coeps,ndim)
        endif
    endif
! ======================================================================
! --- CALCUL SI PAS RIGI_MECA_TANG -------------------------------------
! ======================================================================
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! ======================================================================
! --- CALCUL DES CONTRAINTES DE PRESSIONS ------------------------------
! ======================================================================
        if (yamec .eq. 1) then
            call sigmap(net, bishop, satur, signe, tbiot,&
                        dp2, dp1, sigmp)
            do 10 i = 1, 3
                congep(adcome+6+i-1)=congep(adcome+6+i-1)+sigmp(i)
 10         continue
            do 14 i = 4, 6
                congep(adcome+6+i-1)=congep(adcome+6+i-1)+sigmp(i)*&
                rac2
 14         continue
        endif
! ======================================================================
! --- CALCUL DES APPORTS MASSIQUES SELON FORMULE DOCR ------------------
! ======================================================================
        congep(adcp11) = appmas(m11m,phi,phim,1.0d0-satur, 1.0d0-satm, rho21,rho21m,epsv,epsvm)
    endif
!
! **********************************************************************
! *** CALCUL DES DERIVEES **********************************************
! **********************************************************************
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (yamec .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE MECANIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DE SIGMAP ------------------------------------
! ======================================================================
            call dspdp2(net, bishop, tbiot, dsdp2)
            do 11 i = 1, 3
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1)+&
                dsdp2(i)
 11         continue
            do 22 i = 4, 6
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1)+&
                dsdp2(i)*rac2
 22         continue
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIE MECANIQUE ------------------------------
! ======================================================================
            call dmdepv(rho21, 1.0d0-satur, tbiot, dmdeps)
            do 12 i = 1, 6
                dsde(adcp11,addeme+ndim-1+i) = dsde(adcp11,addeme+ ndim-1+i) + dmdeps(i)
 12         continue
        endif
        if (yate .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE THERMIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DES ENTHALPIES -------------------------------
! ======================================================================
            dsde(adcp11+ndim+1,addete)=dsde(adcp11+ndim+1,addete)&
            + dhdt(cp21)
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIR THERMIQUE ------------------------------
! ======================================================================
            dsde(adcp11,addete) = dsde(adcp11,addete) + dmwdt(rho21, phi,satur,cliq,0.0d0,alp21)
! ======================================================================
! --- CALCUL DE LA DERIVEE DE LA CHALEUR REDUITE Q' --------------------
! ======================================================================
            dsde(adcote,addete)=dsde(adcote,addete)+dqdt(coeps)
            dsde(adcote,addep1)=dsde(adcote,addep1)-dqdp(signe,alp21,&
            t)
! ======================================================================
! --- CALCUL DE LA DERIVEE DE LA CHALEUR REDUITE Q' --------------------
! --- UNIQUEMENT POUR LA PARTIE MECANIQUE ------------------------------
! ======================================================================
            if (yamec .eq. 1) then
                call dqdeps(mdal, t, dqeps)
                do 20 i = 1, 6
                    dsde(adcote,addeme+ndim-1+i) = dsde(adcote,addeme+ ndim-1+i) + dqeps(i)
 20             continue
            endif
        endif
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- POUR LES AUTRES CAS ----------------------------------------------
! ======================================================================
        dsde(adcp11,addep1) = dsde(adcp11,addep1) +&
                              dmasp2(1.0d0,0.0d0,rho21,satur,phi,cs,p2,emmag,em)
    endif
! =====================================================================
! --- MISE A JOUR DES VARIABLES P1 ET DP1 POUR CONFOMITE AUX FORMULES -
! =====================================================================
    p1 = p2
    dp1 = dp2
    rho11 = rho21
! =====================================================================
 30 continue
! =====================================================================
end subroutine
