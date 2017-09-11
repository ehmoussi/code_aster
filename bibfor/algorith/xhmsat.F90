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
! person_in_charge: daniele.colombo at ifpen.fr
!
subroutine xhmsat(yachai, option, ther,&
                  ndim, dimenr,&
                  dimcon, nbvari, yamec, addeme,&
                  adcome, advihy, advico, vihrho, vicphi,&
                  addep1, adcp11, congem, congep, vintm,&
                  vintp, dsde, epsv, depsv, &
                  dp1, phi, rho11,&
                  satur, retcom, tbiot, angl_naut,&
                  yaenrh, adenhy, nfh)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/appmas.h"
#include "asterfort/dmdepv.h"
#include "asterfort/dmwdp1.h"
#include "asterfort/dspdp1.h"
#include "asterfort/inithm.h"
#include "asterfort/sigmap.h"
#include "asterfort/dilata.h"
#include "asterfort/utmess.h"
#include "asterfort/unsmfi.h"
#include "asterfort/viporo.h"
#include "asterfort/virhol.h"
#include "asterfort/tebiot.h"
!
! person_in_charge: daniele.colombo at ifpen.fr
! ROUTINE HMLISA : CETTE ROUTINE CALCULE LES CONTRAINTES GENERALISEES
!   ET LA MATRICE TANGENTE DES GRANDEURS COUPLEES, A SAVOIR CELLES QUI
!   NE SONT PAS DES GRANDEURS DE MECANIQUE PURE OU DES FLUX PURS
!   DANS LE CAS OU THMC = 'LIQU_SATU'
! ======================================================================
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
! COMMENTAIRE DE NMCONV :
!                       = 0 OK
!                       = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTAT
!                       = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
! ======================================================================
!
    integer :: ndim, dimcon, nbvari, yamec
    integer :: adcome, adcp11, vihrho, vicphi, nfh
    integer :: addeme, addep1, advihy, advico, retcom
    real(kind=8) :: congem(dimcon), congep(dimcon)
    real(kind=8) :: vintm(nbvari), vintp(nbvari)
    real(kind=8) :: epsv, depsv, dp1, dt
    real(kind=8) :: phi, rho11, rac2
    real(kind=8) :: angl_naut(3)
    character(len=16) :: option, ther
    aster_logical :: yachai
!
! DECLARATION POUR XFEM
    integer :: dimenr
    real(kind=8) :: dsde(dimcon, dimenr)
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, yaenrh, adenhy, ifh, yate
    real(kind=8) :: epsvm, phim, rho11m, rho110
    real(kind=8) :: tbiot(6), cs, alpha0, alpliq, cliq, satur
    real(kind=8) :: bid, dpad
    real(kind=8) :: dsatur_dp1
    real(kind=8) :: m11m, saturm, mdal(6), dalal, alphfi, cbiot, unsks
    real(kind=8) :: deps(6)
! ======================================================================
! --- DECLARATIONS PERMETTANT DE RECUPERER LES CONSTANTES MECANIQUES ---
! ======================================================================
    real(kind=8) :: dp2, signe, phi0
    real(kind=8) :: dmdeps(6), dsdp1(6), sigmp(6)
!
    aster_logical :: emmag
!
! =====================================================================
! --- BUT : RECUPERER LES DONNEES MATERIAUX THM -----------------------
! =====================================================================
!
    rac2 = sqrt(2.d0)
    yate = 0
    if (ther .ne. 'VIDE') then
        yate = 1
    endif
!
! - Get material parameters
!
    phi0   = ds_thm%ds_parainit%poro_init
    rho110 = ds_thm%ds_material%liquid%rho
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
!
! - Evaluation of initial saturation
!
    satur      = 1.d0
    saturm     = 1.d0
    dsatur_dp1 = 0.d0
! ======================================================================
! --- INITIALISATIONS --------------------------------------------------
! ======================================================================
    emmag = .false.
    dp2 = 0.0d0
    dt = 0.0d0
    dpad = 0.0d0
    signe = -1.0d0

    alpha0 = 0.d0
    alphfi = 0.d0
    m11m = congem(adcp11)
    retcom = 0
    rho11 = vintm(advihy+vihrho) + rho110
    rho11m = vintm(advihy+vihrho) + rho110
    phi = vintm(advico+vicphi) + phi0
    phim = vintm(advico+vicphi) + phi0
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
    if ((option.eq.'RAPH_MECA') .or. (option.eq.'FORC_NODA') .or.&
        (option(1:9).eq.'FULL_MECA')) then
! =====================================================================
! --- CALCUL DE LA VARIABLE INTERNE DE POROSITE SELON FORMULE DOCR ----
! =====================================================================
        if ((yamec.eq.1) .or. yachai) then
            call viporo(nbvari, vintm, vintp, advico, vicphi,&
                        phi0, deps, depsv, alphfi, dt,&
                        dp1, dp2, signe, satur, cs,&
                        tbiot, cbiot, unsks, alpha0, &
                        phi, phim, retcom )
        endif
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
! --- CALCUL SI PAS RIGI_MECA_TANG -------------------------------------
! ======================================================================
    if ((option.eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
! ======================================================================
! --- CALCUL DES CONTRAINTES DE PRESSIONS ------------------------------
! ======================================================================
        if (yamec .eq. 1) then
            call sigmap(satur, signe, tbiot, dp2, dp1, sigmp)
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
! --- CALCUL DES DERIVEES DE SIGMAP ------------------------------------
! ======================================================================
            call dspdp1(signe, tbiot, satur, dsdp1)
            do i = 1, 3
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1) + dsdp1(i)
            end do
!
            do i = 4, 6
                dsde(adcome+6+i-1,addep1)=dsde(adcome+6+i-1,addep1) + dsdp1(i)*rac2
            end do
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! ======================================================================
            call dmdepv(rho11, satur, tbiot, dmdeps)
            do i = 1, 6
                dsde(adcp11,addeme+ndim-1+i) = dsde(adcp11,addeme+ ndim-1+i) + dmdeps(i)
            end do
        endif
        if (yaenrh .eq. 1) then
! ======================================================================
! --- CALCUL DES DERIVEES DE SIGMAP AVEC XFEM --------------------------
! ======================================================================
          do ifh = 1, nfh
            do i = 1, 3
            dsde(adcome+6-1+i,adenhy+(ifh-1)*(ndim+1))=dsde(adcome+6-1+i,adenhy+&
                                                       (ifh-1)*(ndim+1))+dsdp1(i)
            end do
!
            do i = 4, 6
            dsde(adcome+6-1+i,adenhy+(ifh-1)*(ndim+1))=dsde(adcome+6-1+i,adenhy+&
                                                       (ifh-1)*(ndim+1))+dsdp1(i)*rac2
            end do
          end do
        endif
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES ------------------------
! ======================================================================
        dsde(adcp11,addep1) = dsde(adcp11,addep1) +&
                              dmwdp1(rho11, signe,satur,dsatur_dp1,phi,cs,cliq,1.d0, emmag,bid)
        if (yaenrh.eq.1) then
! ======================================================================
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES AVEC XFEM --------------
! ======================================================================
          do ifh = 1, nfh
            dsde(adcp11,adenhy+(ifh-1)*(ndim+1)) = dsde(adcp11,adenhy+(ifh-1)*(ndim+1))+&
                dmwdp1(rho11, signe,satur,dsatur_dp1,phi,cs,cliq,1.d0, emmag,bid)
          end do
        endif
    endif
! ======================================================================
 30 continue
! =====================================================================
end subroutine
