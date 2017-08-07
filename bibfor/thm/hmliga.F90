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
subroutine hmliga(yachai, option, meca, ther, hydr,&
                  imate, ndim, dimdef, dimcon, nbvari,&
                  yamec, yate, addeme, adcome, advihy,&
                  advico, vihrho, vicphi, vicsat, addep1,&
                  adcp11, addep2, adcp21, addete, adcote,&
                  congem, congep, vintm, vintp, dsde,&
                  deps, epsv, depsv, p1, p2,&
                  dp1, dp2, temp, dt, phi,&
                  rho11, satur, retcom, thmc,&
                  crit, tbiot, angmas)
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
#include "asterfort/dhwdp1.h"
#include "asterfort/dhwdp2.h"
#include "asterfort/dilata.h"
#include "asterfort/dileau.h"
#include "asterfort/dilgaz.h"
#include "asterfort/dmasp1.h"
#include "asterfort/dmasp2.h"
#include "asterfort/dmdepv.h"
#include "asterfort/dmwdp1.h"
#include "asterfort/dmwdp2.h"
#include "asterfort/dmwdt.h"
#include "asterfort/dqdeps.h"
#include "asterfort/dqdp.h"
#include "asterfort/dqdt.h"
#include "asterfort/dspdp1.h"
#include "asterfort/dspdp2.h"
#include "asterfort/enteau.h"
#include "asterfort/entgaz.h"
#include "asterfort/inithm.h"
#include "asterfort/masvol.h"
#include "asterfort/netbis.h"
#include "asterfort/nmbarc.h"
#include "asterfort/sigmap.h"
#include "asterfort/thmrcp.h"
#include "asterfort/unsmfi.h"
#include "asterfort/viemma.h"
#include "asterfort/viporo.h"
#include "asterfort/virhol.h"
#include "asterfort/visatu.h"
#include "asterfort/thmEvalSatuInit.h"
!
real(kind=8), intent(in) :: temp
! ======================================================================
! ROUTINE HMLIGA : CETTE ROUTINE CALCULE LES CONTRAINTES GENERALISEES
!   ET LA MATRICE TANGENTE DES GRANDEURS COUPLEES, A SAVOIR CELLES QUI
!   NE SONT PAS DES GRANDEURS DE MECANIQUE PURE OU DES FLUX PURS
!   DANS LE CAS OU THMC = 'LIQU_GAZ'
! ======================================================================
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
! COMMENTAIRE DE NMCONV :
!                       = 0 OK
!                       = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
!                       = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
! ======================================================================
!
    integer :: ndim, dimdef, dimcon, nbvari, imate, yamec, yate, retcom
    integer :: adcome, adcp11, adcp21, adcote, addeme, addep1, addep2
    integer :: addete, advihy, advico, vihrho, vicphi, vicsat
    real(kind=8) :: congem(dimcon), congep(dimcon), vintm(nbvari)
    real(kind=8) :: vintp(nbvari), dsde(dimcon, dimdef), epsv, depsv
    real(kind=8) :: p1, dp1, p2, dp2, dt, phi, rho11, phi0
    real(kind=8) :: angmas(3)
    character(len=16) :: option, meca, ther, hydr, thmc
    aster_logical :: yachai
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i
    real(kind=8) :: saturm, epsvm, phim, rho11m, rho21m, rho110
    real(kind=8) :: tbiot(6), cs, alpliq, cliq
    real(kind=8) :: cp11, cp21, satur, dsatur_dp1, mamolg, rho21, em
    real(kind=8) :: r, rho0, csigm, alp11, alp12, alp21
    real(kind=8) :: eps, mdal(6), dalal, alphfi, cbiot, unsks, alpha0
    parameter  ( eps = 1.d-21 )
    aster_logical :: emmag
! ======================================================================
! --- VARIABLES LOCALES POUR BARCELONE-------------------------------
! ======================================================================
    real(kind=8) :: crit(*)
    real(kind=8) :: dsidp1(6), deps(6)
    real(kind=8) :: dsdeme(6, 6)
!CCC    SIP NECESSAIRE POUR CALCULER LES CONTRAINTES TOTALES
!CCC    ET ENSUITE CONTRAINTES NETTES POUR BARCELONE
    real(kind=8) :: sipm, sipp
! ======================================================================
! --- DECLARATIONS PERMETTANT DE RECUPERER LES CONSTANTES MECANIQUES ---
! ======================================================================
    real(kind=8) :: rbid6, rbid7
    real(kind=8) :: rbid10
    real(kind=8) :: rbid16, rbid17, rbid18, rbid19
    real(kind=8) :: rbid21, rbid22, rbid23, rbid24, rbid25, rbid26
    real(kind=8) :: rbid27, rbid28, rbid29, rbid32(ndim, ndim)
    real(kind=8) :: rbid33(ndim, ndim), rbid34, rbid35, rbid36, rbid37
    real(kind=8) :: rbid39, rbid45, rbid46, rbid47, rbid48, rbid49
    real(kind=8) :: rbid50(ndim, ndim), rbid20, rbid38
    real(kind=8) :: signe, m11m, m21m, coeps, rho12, rho22, dpad, cp12, cp22
    real(kind=8) :: dsdp1(6), dsdp2(6)
    real(kind=8) :: dmdeps(6), p1m
    real(kind=8) :: sigmp(6), dqeps(6), rac2
!
    aster_logical :: net, bishop
!
    rac2 = sqrt(2.d0)
    p1m = p1-dp1
!
! =====================================================================
! --- BUT : RECUPERER LES DONNEES MATERIAUX THM -----------------------
! =====================================================================
    call netbis(meca, net, bishop)
    phi0 = ds_thm%ds_parainit%poro_init
    call thmrcp('INTERMED', imate, thmc, hydr,&
                ther, temp, p1, p1m, rbid6,&
                rbid7, rbid10, r, rho0,&
                csigm, saturm, satur, dsatur_dp1,&
                rbid16, rbid17, rbid18,&
                rbid19, rbid20, rbid21, rbid22, rbid23,&
                rbid24, rbid25, rho110, cliq, alpliq,&
                cp11, rbid26, rbid27, rbid28, rbid29,&
                mamolg, cp21, rbid32, rbid33, rbid34,&
                rbid35, rbid36, rbid37, rbid38, rbid39,&
                rbid45, rbid46, rbid47, rbid48, rbid49,&
                em, rbid50, retcom,&
                angmas, ndim)
!
! - Evaluation of initial saturation
!
    call thmEvalSatuInit(hydr  , imate, p1m       , p1,&
                         saturm, satur, dsatur_dp1, em,&
                         retcom)

! ======================================================================
! --- POUR EVITER DES PB AVEC OPTIMISEUR ON MET UNE VALEUR DANS CES ----
! --- VARIABES POUR QU ELLES AIENT UNE VALEUR MEME DANS LES CAS OU -----
! --- ELLES NE SONT THEOTIQUEMENT PAS UTILISEES ------------------------
! ======================================================================
    emmag = .false.
!
    cp12 = 0.0d0
    cp22 = 0.0d0
    alp11 = 0.0d0
    alp12 = 0.0d0
    alp21 = 0.0d0
    rho12 = 0.0d0
    rho21 = 0.0d0
    rho22 = 0.0d0
    signe = 1.0d0
    dpad = 0.0d0
    retcom = 0
    m11m = congem(adcp11)
    m21m = congem(adcp21)
    rho11 = vintm(advihy+vihrho) + rho110
    rho11m = vintm(advihy+vihrho) + rho110
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
                cs, tbiot, temp, epsv, depsv,&
                epsvm, angmas, mdal, dalal,&
                alphfi, cbiot, unsks, alpha0)
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
        if (emmag) then
            call viemma(nbvari, vintm, vintp, advico, vicphi,&
                        phi0, dp1, dp2, signe, satur,&
                        em, phi, phim, retcom)
        endif
! =====================================================================
! --- CALCUL DE LA VARIABLE INTERNE DE MASSE VOLUMIQUE DU FLUIDE ------
! --- SELON FORMULE DOCR ----------------------------------------------
! =====================================================================
        call virhol(nbvari, vintm, vintp, advihy, vihrho,&
                    rho110, dp1, dp2, dpad, cliq,&
                    dt, alpliq, signe, rho11, rho11m,&
                    retcom)
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
! --- ACTUALISATION DE CS ET ALPHFI -----------------------------------
! =====================================================================
    if (yamec .eq. 1) then
        call dilata(angmas, phi, tbiot, alphfi)
        call unsmfi(imate, phi, temp, tbiot, cs)
    endif
! **********************************************************************
! *** LES CONTRAINTES GENERALISEES *************************************
! **********************************************************************
! ======================================================================
! --- CALCUL DES MASSES VOLUMIQUES DE PRESSION DE VAPEUR ---------------
! ----------------------------------- AIR SEC --------------------------
! ----------------------------------- AIR DISSOUS ----------------------
! ======================================================================
    rho21 = masvol(mamolg,p2 ,r,temp)
    rho21m = masvol(mamolg,p2-dp2,r,temp-dt)
! =====================================================================
! --- CALCULS UNIQUEMENT SI PRESENCE DE THERMIQUE ---------------------
! =====================================================================
    if (yate .eq. 1) then
! =====================================================================
! --- CALCUL DES COEFFICIENTS DE DILATATIONS ALPHA SELON FORMULE DOCR -
! =====================================================================
        alp11 = dileau(satur,phi,alphfi,alpliq)
        alp12 = dilgaz(satur,phi,alphfi,temp)
        alp21 = dilgaz(satur,phi,alphfi,temp)
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
            congep(adcp11+ndim+1) = congep(adcp11+ndim+1) + &
                                    enteau(dt, alpliq,temp,rho11,dp2,dp1,dpad,signe,cp11)
            congep(adcp21+ndim+1) = congep(adcp21+ndim+1) + entgaz(dt, cp21)
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
            call sigmap(net, bishop, satur, signe, tbiot,&
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
        congep(adcp21) = appmas(m21m,phi,phim,1.d0-satur, 1.d0-saturm, rho21,rho21m,epsv,epsvm)
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
        if (yamec .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE MECANIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DE SIGMAP ------------------------------------
! ======================================================================
            call dspdp1(net, bishop, signe, tbiot, satur,&
                        dsdp1)
            call dspdp2(net, bishop, tbiot, dsdp2)
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
                call dmdepv(rho21, 1.0d0-satur, tbiot, dmdeps)
                dsde(adcp21,addeme+ndim-1+i) = dsde(adcp21,addeme+ ndim-1+i) + dmdeps(i)
            end do
        endif
        if (yate .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE THERMIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DES ENTHALPIES -------------------------------
! ======================================================================
            dsde(adcp11+ndim+1,addep2) = dsde(adcp11+ndim+1,addep2) + &
                                         dhwdp2(alpliq,temp,rho11)
            dsde(adcp11+ndim+1,addep1) = dsde(adcp11+ndim+1,addep1) + &
                                         dhwdp1(signe,alpliq,temp,rho11)
            dsde(adcp11+ndim+1,addete) = dsde(adcp11+ndim+1,addete) + dhdt(cp11)
            dsde(adcp21+ndim+1,addete) = dsde(adcp21+ndim+1,addete) + dhdt(cp21)
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIR THERMIQUE ------------------------------
! ======================================================================
            dsde(adcp11,addete) = dsde(adcp11,addete) + dmwdt(rho11, phi,satur,cliq,0.d0,alp11)
            dsde(adcp21,addete) = dsde(adcp21,addete) + dmwdt(rho21, phi,satur,cliq,0.d0,alp21)
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
                              dmwdp1(rho11, signe,satur,dsatur_dp1,phi,cs,cliq,1.d0, emmag,em)
        dsde(adcp11,addep2) = dsde(adcp11,addep2) +&
                              dmwdp2(rho11,satur, phi,cs,cliq,1.d0, emmag,em)
        dsde(adcp21,addep1) = dsde(adcp21,addep1) +&
                              dmasp1(rho11, 0.d0,rho21,satur,dsatur_dp1,phi,cs,1.d0, emmag,em)
        dsde(adcp21,addep2) = dsde(adcp21,addep2) +&
                              dmasp2(rho11, 0.d0,rho21,satur,phi,cs,p2, emmag,em)
    endif
! =====================================================================
! --- TERMES SPECIAL BARCELONE --------------------------------------
! =====================================================================
    if ((yamec.eq.1) .and. (meca.eq.'BARCELONE')) then
        sipm=congem(adcome+6)
        sipp=congep(adcome+6)
        call nmbarc(ndim, imate, crit, satur, tbiot(1),&
                    deps, congem(adcome), vintm,&
                    option, congep(adcome), vintp, dsdeme, p1,&
                    p2, dp1, dp2, dsidp1, sipm,&
                    sipp, retcom)
        if (retcom .eq. 1) goto 30
!
        if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
! --- DSIGM/DEPP1
            do i = 1, 2*ndim
                dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) + dsidp1(i)
            end do
        endif
    endif
! =====================================================================
 30 continue
! =====================================================================
end subroutine
