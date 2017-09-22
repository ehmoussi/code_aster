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
subroutine thmCpl006(yachai, option, hydr,&
                  imate, ndim, dimdef, dimcon, nbvari,&
                  yamec, yate, addeme, adcome, advihy,&
                  advico, vihrho, vicphi, vicsat, addep1,&
                  adcp11, addete, adcote, congem, congep,&
                  vintm, vintp, dsde, epsv, depsv,&
                  p1, dp1, temp, dt, phi,&
                  rho11, satur, retcom,&
                  tbiot, angmas, deps)
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
#include "asterfort/dilata.h"
#include "asterfort/dileau.h"
#include "asterfort/dmdepv.h"
#include "asterfort/dmwdp1.h"
#include "asterfort/dmwdt.h"
#include "asterfort/dqdeps.h"
#include "asterfort/dqdp.h"
#include "asterfort/dqdt.h"
#include "asterfort/dspdp1.h"
#include "asterfort/enteau.h"
#include "asterfort/inithm.h"
#include "asterfort/sigmap.h"
#include "asterfort/unsmfi.h"
#include "asterfort/viemma.h"
#include "asterfort/viporo.h"
#include "asterfort/virhol.h"
#include "asterfort/visatu.h"
#include "asterfort/thmEvalSatuInit.h"
!
real(kind=8), intent(in) :: temp

! ======================================================================
! ROUTINE HMLGAT : CETTE ROUTINE CALCULE LES CONTRAINTES GENERALISEE
!   ET LA MATRICE TANGENTE DES GRANDEURS COUPLEES, A SAVOIR CELLES QUI
!   NE SONT PAS DES GRANDEURS DE MECANIQUE PURE OU DES FLUX PURS
!   DANS LE CAS OU THMC = 'LIQU_GAZ_ATM'
! ======================================================================
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
! COMMENTAIRE DE NMCONV :
!                       = 0 OK
!                       = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
!                       = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
! ======================================================================

    integer :: ndim, dimdef, dimcon, nbvari, imate, retcom, yamec
    integer :: yate, adcome, adcp11, adcote, addeme, addep1, addete
    integer :: advihy, advico, vihrho, vicphi, vicsat
    real(kind=8) :: congem(dimcon), congep(dimcon), vintm(nbvari)
    real(kind=8) :: vintp(nbvari), dsde(dimcon, dimdef), epsv, depsv
    real(kind=8) :: p1, dp1, dt, phi, rho11, phi0
    real(kind=8) :: angmas(3)
    character(len=16) :: option, hydr
    aster_logical :: yachai
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i
    real(kind=8) :: saturm, epsvm, phim, rho11m, rho110, tbiot(6), cs
    real(kind=8) :: alpliq, cliq, cp11, satur, dsatur_dp1, rho0, csigm
    real(kind=8) :: alp11, rho12, rho21
    real(kind=8) :: em, mdal(6), dalal, alphfi, cbiot, unsks, alpha0
    real(kind=8) :: deps(6)
    aster_logical :: l_emmag
    real(kind=8) :: dp2, signe, dpad, coeps, cp21, m11m, rho22, alp12, cp12
    real(kind=8) :: dqeps(6), p1m
    real(kind=8) :: dsdp1(6), sigmp(6)
    real(kind=8) :: dmdeps(6), cp22
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!
! - Get initial parameters
!
    phi0 = ds_thm%ds_parainit%poro_init
!
! - Compute pressures
!
    p1m    = p1-dp1
!
! - Get material parameters
!
    rho0   = ds_thm%ds_material%solid%rho
    csigm  = ds_thm%ds_material%solid%cp
    rho110 = ds_thm%ds_material%liquid%rho
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    cp11   = ds_thm%ds_material%liquid%cp
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
!
! ======================================================================
! --- POUR EVITER DES PB AVEC OPTIMISEUR ON MET UNE VALEUR DANS CES ----
! --- VARIABES POUR QU ELLES AIENT UNE VALEUR MEME DANS LES CAS OU -----
! --- ELLES NE SONT THEOTIQUEMENT PAS UTILISEES ------------------------
! ======================================================================
    cp12 = 0.0d0
    cp21 = 0.0d0
    cp22 = 0.0d0
    alp11 = 0.0d0
    alp12 = 0.0d0
    rho12 = 0.0d0
    rho21 = 0.0d0
    rho22 = 0.0d0
    signe = 1.0d0
    dp2 = 0.0d0
    dpad = 0.0d0
    retcom = 0
    m11m = congem(adcp11)
    rho11 = vintm(advihy+vihrho) + rho110
    rho11m = vintm(advihy+vihrho) + rho110
    phi = vintm(advico+vicphi) + phi0
    phim = vintm(advico+vicphi) + phi0
!
    call inithm(imate, yachai, yamec, phi0, em,&
                cs, tbiot, temp, epsv, depsv,&
                epsvm, angmas, mdal, dalal,&
                alphfi, cbiot, unsks, alpha0)
!
! *********************************************************************
! *** LES VARIABLES INTERNES ******************************************
! *********************************************************************
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA') .or.&
        (option.eq.'FORC_NODA')) then
! =====================================================================
! --- CALCUL DE LA VARIABLE INTERNE DE POROSITE SELON FORMULE DOCR ----
! =====================================================================
        if (yamec .eq. 1) then
            call viporo(nbvari, vintm, vintp, advico, vicphi,&
                        phi0, deps, depsv, alphfi, dt,&
                        dp1, dp2, signe, satur, cs,&
                        tbiot, cbiot, unsks, alpha0, &
                        phi, phim, retcom )
        endif
! ----- Compute porosity with storage coefficient
        if (l_emmag) then
            call viemma(nbvari, vintm , vintp,&
                        advico, vicphi,&
                        phi0  , dp1   , dp2  , signe, satur,&
                        em    , phi   , phim)
        endif
! =====================================================================
! --- CALCUL DE LA VARIABLE INTERNE DE MASSE VOLUMIQUE DU FLUIDE ------
! --- SELON FORMULE DOCR ----------------------------------------------
! =====================================================================
        if (yate .eq. 1) then
            call virhol(nbvari, vintm, vintp, advihy, vihrho,&
                        rho110, dp1, dp2, dpad, cliq,&
                        dt, alpliq, signe, rho11, rho11m,&
                        retcom)
        else
            call virhol(nbvari, vintm, vintp, advihy, vihrho,&
                        rho110, dp1, dp2, dpad, cliq,&
                        dt, 0.d0, signe, rho11, rho11m,&
                        retcom)
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
! --- ACTUALISATION DE CS ET ALPHFI -----------------------------------
! =====================================================================
    if (yamec .eq. 1) then
        call dilata(angmas, phi, tbiot, alphfi)
        call unsmfi(imate, phi, temp, tbiot, cs)
    endif
! **********************************************************************
! *** LES CONTRAINTES GENERALISEES *************************************
! **********************************************************************
! =====================================================================
! --- CALCULS UNIQUEMENT SI PRESENCE DE THERMIQUE ---------------------
! =====================================================================
    if (yate .eq. 1) then
! =====================================================================
! --- CALCUL DES COEFFICIENTS DE DILATATIONS ALPHA SELON FORMULE DOCR -
! =====================================================================
        alp11 = dileau(satur,phi,alphfi,alpliq)
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
! ======================================================================
! --- CALCUL DE LA CHALEUR REDUITE Q' SELON FORMULE DOCR ---------------
! ======================================================================
            congep(adcote) = congep(adcote) +&
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
            call dspdp1(signe, tbiot, satur, dsdp1)
            do i = 1, 3
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1) + dsdp1(i)
            end do
            do i = 4, 6
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1) + dsdp1(i)*rac2
            end do
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIE MECANIQUE ------------------------------
! ======================================================================
            call dmdepv(rho11, satur, tbiot, dmdeps)
            do i = 1, 6
                dsde(adcp11,addeme+ndim-1+i) = dsde(adcp11,addeme+ ndim-1+i) + dmdeps(i)
            end do
        endif
        if (yate .eq. 1) then
! ======================================================================
! --- CALCUL UNIQUEMENT EN PRESENCE DE THERMIQUE -----------------------
! ======================================================================
! --- CALCUL DES DERIVEES DES ENTHALPIES -------------------------------
! ======================================================================
            dsde(adcp11+ndim+1,addep1) = dsde(adcp11+ndim+1,addep1) +&
                                         dhwdp1(signe,alpliq,temp,rho11)
            dsde(adcp11+ndim+1,addete) = dsde(adcp11+ndim+1,addete) +&
                                         dhdt(cp11)
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! --- UNIQUEMENT POUR LA PARTIR THERMIQUE ------------------------------
! ======================================================================
            dsde(adcp11,addete) = dsde(adcp11,addete) +&
                                  dmwdt(rho11, phi,satur,cliq,0.d0,alp11)
! ======================================================================
! --- CALCUL DE LA DERIVEE DE LA CHALEUR REDUITE Q' --------------------
! ======================================================================
            dsde(adcote,addete) = dsde(adcote,addete)+dqdt(coeps)
            dsde(adcote,addep1) = dsde(adcote,addep1)+dqdp(signe,alp11,temp)
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
                              dmwdp1(rho11, signe,satur,dsatur_dp1,phi,cs,cliq,1.d0, l_emmag,em)
    endif
! =====================================================================
 30 continue
! =====================================================================
!
end subroutine
