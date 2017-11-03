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

subroutine pmfcom(kpg, debsp, option, compor, crit,&
                  nf, instam, instap, icdmat, nbvalc,&
                  defam, defap, varim, varimp, contm,&
                  defm, ddefp, epsm, modf, sigf,&
                  varip, codret)
!
!
! aslint: disable=W1504
! --------------------------------------------------------------------------------------------------
!
!        COMPORTEMENT DES ELEMENTS DE POUTRE MULTIFIBRE
!
! --------------------------------------------------------------------------------------------------
!
!   IN
!       kpg     : numero de point de gauss
!       debsp   : numero de sous-point de la premiere fibre du groupe
!       option  :
!       compor  : nom du comportement
!       crit    : criteres de convergence locaux
!       nf      : nombre de fibres du groupe
!       instam  : instant du calcul precedent
!       instap  : instant du calcul
!       icdmat  : code materiau
!       nbvalc  : nombre de variable internes
!       defam   : deformations anelastiques a l'instant precedent
!       defap   : deformations anelastiques a l'instant du calcul
!       varim   : variables internes moins
!       varimp  : variables internes iteration precedente (pour deborst)
!       contm   : contraintes moins par fibre
!       defm    : deformation  a l'instant du calcul precedent
!       ddefp   : increment de deformation
!       epsm    : deformation a l'instant precedent
!
!   OUT
!       modf    : module tangent des fibres
!       sigf    : contrainte a l'instant actuel des fibres
!       varip   : variables internes a l'instant actuel
!       codret :
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "asterf_types.h"
#include "asterfort/comp1d.h"
#include "asterfort/mazu1d.h"
#include "asterfort/nm1dci.h"
#include "asterfort/nm1dco.h"
#include "asterfort/nm1dis.h"
#include "asterfort/nm1dpm.h"
#include "asterfort/nm1vil.h"
#include "asterfort/paeldt.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcexistvarc.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
#include "asterfort/verift.h"
#include "asterfort/vmci1d.h"
#include "blas/dcopy.h"
!
    integer :: nf, icdmat, nbvalc, kpg, debsp, codret
    real(kind=8) :: contm(nf), defm(nf), ddefp(nf), modf(nf), sigf(nf)
    real(kind=8) :: varimp(nbvalc*nf), varip(nbvalc*nf), varim(nbvalc*nf)
    real(kind=8) :: instam, instap, epsm
    real(kind=8) :: crit(*), defap(*), defam(*)
!
    character(len=16) :: option
    character(len=24) :: compor(*)
!
! --------------------------------------------------------------------------------------------------
!
    integer , parameter :: nbval=12
    integer :: icodre(nbval)
    real(kind=8) :: valres(nbval)

    integer :: nbvari, codrep, ksp, i, ivari, iret
    real(kind=8) :: ep, em, depsth, tref, tempm, tempp, sigx, epsx, depsx,tempplus
    real(kind=8) :: cstpm(13), angmas(3), depsm, nu, bendo, kdess, valsech, valsechref, valhydr
    character(len=4) :: fami
    character(len=8) :: nompim(12), mazars(8), materi
    character(len=16) :: compo, algo, nomres(2)
    character(len=30) :: valkm(3)
    aster_logical :: istemp, ishydr, issech
!
    data nompim /'SY', 'EPSI_ULT', 'SIGM_ULT', 'EPSP_HAR', 'R_PM',&
                 'EP_SUR_E', 'A1_PM', 'A2_PM', 'ELAN', 'A6_PM', 'C_PM', 'A_PM'/
    data mazars /'EPSD0', 'K', 'AC', 'BC', 'AT', 'BT', 'SIGM_LIM', 'EPSI_LIM'/
!
! --------------------------------------------------------------------------------------------------
    codret = 0
    codrep = 0
    fami = 'RIGI'
    materi = compor(1)(1:8)
    compo  = compor(2)(1:16)
    algo   = compor(3)(1:16)
!
!   TEMP ou pas ?
    istemp = rcexistvarc('TEMP')
!
    if (.not.istemp) then
        nomres(1) = 'E'
        nomres(2) = 'NU'
        call rcvalb(fami, 1, 1, '+', icdmat, materi, 'ELAS', 0, '', [0.d0],&
                    2, nomres, valres, icodre, 1)
        ep = valres(1)
        nu = valres(2)
        em=ep
        depsth=0.d0
    endif
!   angle du MOT_CLEF massif (AFFE_CARA_ELEM) initialise à 0.D0 (on ne s'en sert pas)
    call r8inir(3, 0.d0, angmas, 1)
!
! --------------------------------------------------------------------------------------------------
    if (compo .eq. 'ELAS') then
        nomres(1) = 'E'
        do i = 1, nf
            if (istemp) then
                ksp=debsp-1+i
                call paeldt(kpg, ksp, fami, 'T', icdmat, materi, em, ep, nu, depsth)
            endif
            modf(i) = ep
            sigf(i) = ep*(contm(i)/em + ddefp(i) - depsth)
        enddo
!
! --------------------------------------------------------------------------------------------------
    else if (compo.eq.'MAZARS_GC') then
!       Y a-t-il de HYDR ou SECH
!       Par défaut c'est nul
        bendo = 0.0
        kdess = 0.0
!       Valeur des champs : par défaut on considère qu'ils sont nuls
        valhydr = 0.0
        valsech = 0.0
        valsechref = 0.0
!
        ishydr = rcexistvarc('HYDR')
        issech = rcexistvarc('SECH')
        if ( ishydr .or. issech ) then
            nomres(1)='B_ENDOGE'
            nomres(2)='K_DESSIC'
            valres(1:2) = 0.0
            call rcvala(icdmat, ' ', 'ELAS', 0, ' ', [0.d0], 2, nomres, valres, icodre,0)
            bendo = valres(1)
            kdess = valres(2)
            if ((icodre(1).eq.0).and.(.not.ishydr)) then
                valkm(1)='MAZARS_GC'
                valkm(2)='ELAS/B_ENDOGE'
                valkm(3)='HYDR'
                call utmess('F', 'COMPOR1_74', nk=3, valk=valkm)
            endif
            if ((icodre(2).eq.0).and.(.not.issech)) then
                valkm(1)='MAZARS_GC'
                valkm(2)='ELAS/K_DESSIC'
                valkm(3)='SECH'
                call utmess('F', 'COMPOR1_74', nk=3, valk=valkm)
            endif
        endif
!
!       On récupère les paramètres matériau si pas de variable de commande ==> ils sont constants
        call r8inir(nbval, 0.d0, valres, 1)
        call rcvalb(fami, 1, 1, '+', icdmat, materi, 'MAZARS', 0, ' ', [0.0d0],&
                    8, mazars, valres, icodre, 1)
        if (icodre(7)+icodre(8) .ne. 0) then
            valkm(1)='MAZARS_GC'
            valkm(2)=mazars(7)
            valkm(3)=mazars(8)
            call utmess('F', 'COMPOR1_76', nk=3, valk=valkm)
        endif
!
!       boucle comportement sur chaque fibre
        do i = 1, nf
            ivari = nbvalc*(i-1) + 1
            ksp=debsp-1+i
            if (istemp) then
                call verift(fami, kpg, ksp, '+', icdmat, materi, epsth_=depsth, temp_curr_=tempplus)
!               Mémorise la température maximale atteinte
                if ( varim(ivari+7-1) .lt. tempplus ) then
                    varip(ivari+7-1) = tempplus
                endif
                nomres(1) = 'E'
                nomres(2) = 'NU'
                call rcvalb(fami, kpg, ksp, '+', icdmat, materi, 'ELAS', &
                            1, 'TEMP', varip(ivari+7-1), 2, nomres, valres, icodre, 1)
                ep = valres(1)
                nu = valres(2)
            endif
            if ( ishydr ) then
                call rcvarc('F', 'HYDR', '+',   fami, kpg, ksp, valhydr, iret)
            endif
            if ( issech ) then
                call rcvarc('F', 'SECH', '+',   fami, kpg, ksp, valsech, iret)
                call rcvarc('F', 'SECH', 'REF', fami, kpg, ksp, valsechref, iret)
            endif
            epsm = defm(i) - depsth - kdess*(valsech-valsechref) + bendo*valhydr
!           On récupère les paramètres matériau s'il y a une variable de commande.
!           Elles sont ELGA et peuvent donc être différentes d'un sous point à l'autre.
            if ( istemp .or. ishydr .or. issech ) then
                if ( istemp ) then
                    call rcvalb(fami, kpg, ksp, '+', icdmat, materi, 'MAZARS', &
                                1, 'TEMP', varip(ivari+7-1), 8, mazars, valres, icodre, 1)
                else
                    call rcvalb(fami, kpg, ksp, '+', icdmat, materi, 'MAZARS', &
                                0, ' ', [0.0d0], 8, mazars, valres, icodre, 1)
                endif
            endif
!           Ajout de NU dans VALRES
            valres(9) = nu
            call mazu1d(ep, valres, contm(i), varim(ivari), epsm, &
                        ddefp(i), modf(i), sigf(i), varip(ivari), option)
        enddo
!
! --------------------------------------------------------------------------------------------------
    else if (compo.eq.'VMIS_CINE_GC') then
!       boucle sur chaque fibre
        do i = 1, nf
            ivari = nbvalc*(i-1) + 1
            ksp=debsp-1+i
            if (istemp) then
                call paeldt(kpg, ksp, fami, 'T', icdmat, materi, em, ep, nu, depsth)
            endif
            depsm = ddefp(i)-depsth
            call vmci1d('RIGI', kpg, ksp, icdmat, em,&
                        ep, contm(i), depsm, varim(ivari), option,&
                        materi, sigf(i), varip(ivari), modf(i))
        enddo
!
! --------------------------------------------------------------------------------------------------
    else if (compo.eq.'PINTO_MENEGOTTO') then
!       on récupère les paramètres matériau
        call r8inir(nbval, 0.d0, valres, 1)
        call rcvalb(fami, 1, 1, '-', icdmat,&
                    materi, 'PINTO_MENEGOTTO', 0, ' ', [0.0d0],&
                    12, nompim, valres, icodre, 0)
        if (icodre(7) .ne. 0) valres(7) = -1.0d0
        cstpm(1) = ep
        do i = 1, 12
            cstpm(i+1) = valres(i)
        enddo
        do i = 1, nf
            ivari = nbvalc*(i-1) + 1
            if (istemp) then
                ksp=debsp-1+i
                call paeldt(kpg, ksp, fami, 'T', icdmat, materi, em, ep, nu, depsth)
                cstpm(1) = ep
            endif
            depsm = ddefp(i)-depsth
            call nm1dpm('RIGI', kpg, i, icdmat, option,&
                        nbvalc, 13, cstpm, contm(i), varim(ivari),&
                        depsm, varip(ivari), sigf(i), modf(i))
        enddo
!
! --------------------------------------------------------------------------------------------------
    else if (compo.eq.'VMIS_CINE_LINE') then
        do i = 1, nf
            ivari = nbvalc* (i-1) + 1
            if (istemp) then
                ksp=debsp-1+i
                call paeldt(kpg, ksp, fami, 'T', icdmat, materi, em, ep, nu, depsth)
            endif
            depsm = ddefp(i)-depsth
            call nm1dci('RIGI', kpg, i, icdmat, em,&
                        ep, contm(i), depsm, varim(ivari), option,&
                        materi, sigf(i), varip(ivari), modf(i))
        enddo
!
! --------------------------------------------------------------------------------------------------
    else if ((compo.eq.'VMIS_ISOT_LINE').or.(compo.eq.'VMIS_ISOT_TRAC')) then
        do i = 1, nf
            ivari = nbvalc* (i-1) + 1
            if (istemp) then
                ksp=debsp-1+i
                call paeldt(kpg, ksp, fami, 'T', icdmat, materi, em, ep, nu, depsth)
            endif
            depsm = ddefp(i)-depsth
            call nm1dis('RIGI', kpg, i, icdmat, em,&
                        ep, contm(i), depsm, varim(ivari), option,&
                        compo, materi, sigf(i), varip(ivari), modf(i))
        enddo
!
! --------------------------------------------------------------------------------------------------
    else if (compo.eq.'CORR_ACIER') then
        do i = 1, nf
            ivari = nbvalc* (i-1) + 1
            if (istemp) then
                ksp=debsp-1+i
                call paeldt(kpg, ksp, fami, 'T', icdmat, materi, em, ep, nu, depsth)
            endif
            call nm1dco('RIGI', kpg, i, option, icdmat,&
                        materi, ep, contm(i), epsm, ddefp(i),&
                        varim(ivari), sigf(i), varip(ivari), modf(i), crit,&
                        codret)
            if (codret .ne. 0) goto 999
        enddo
!
! --------------------------------------------------------------------------------------------------
    else if ((compo.eq.'GRAN_IRRA_LOG').or.(compo.eq.'VISC_IRRA_LOG')) then
        if (algo(1:10) .eq. 'ANALYTIQUE') then
            if (.not. istemp) then
                call utmess('F', 'COMPOR5_40',sk=compo)
            endif
            do i = 1, nf
                ivari = nbvalc* (i-1) + 1
                if (istemp) then
                    ksp=debsp-1+i
                    call paeldt(kpg, ksp, fami, 'T', icdmat, materi, em, ep, nu, depsth,&
                                tmoins=tempm, tplus=tempp, trefer=tref)
                endif
                depsm = ddefp(i)-depsth
                call nm1vil('RIGI', kpg, i, icdmat, materi,&
                            crit, instam, instap, tempm, tempp,&
                            tref, depsm, contm(i), varim(ivari), option,&
                            defam(1), defap(1), angmas, sigf(i), varip( ivari),&
                            modf(i), codret, compo, nbvalc)
                if (codret .ne. 0) goto 999
            enddo
        else
            if ((option(1:9).eq.'FULL_MECA') .or. (option(1:9) .eq.'RAPH_MECA')) then
                nbvari = nbvalc*nf
                call dcopy(nbvari, varimp, 1, varip, 1)
            endif
            do i = 1, nf
                ivari = nbvalc* (i-1) + 1
                sigx = contm(i)
                epsx = defm(i)
                depsx = ddefp(i)
!               attention, que pour 1 matériau par élément !!!!!
                call comp1d('RIGI', kpg, i, option, sigx,&
                            epsx, depsx, angmas, varim(ivari), varip(ivari),&
                            sigf(i), modf(i), codrep)
                if (codrep .ne. 0) then
                    codret=codrep
!                   code 3: on continue et on le renvoie à la fin. Autres codes: sortie immédiate
                    if (codrep .ne. 3) goto 999
                endif
            enddo
        endif
!
! --------------------------------------------------------------------------------------------------
    else if (compo.eq.'BETON_GRANGER') then
!       Appel à comp1d pour bénéficier des comportements AXIS: méthode de DEBORST
!           La LDC doit retourner le module tangent
        if ((algo(1:7).ne.'DEBORST') .and. (compo(1:4).ne.'SANS')) then
            valkm(1) = compo
            valkm(2) = 'DEFI_COMPOR/MULTIFIBRE'
            call utmess('F', 'ALGORITH6_81', nk=2, valk=valkm)
        else
            if ((option(1:9).eq.'FULL_MECA') .or. (option(1:9) .eq.'RAPH_MECA')) then
                nbvari = nbvalc*nf
                call dcopy(nbvari, varimp, 1, varip, 1)
            endif
            do i = 1, nf
                ivari = nbvalc* (i-1) + 1
                sigx = contm(i)
                epsx = defm(i)
                depsx = ddefp(i)
!               attention, que pour 1 matériau par élément !!!!!
                call comp1d('RIGI', kpg, i, option, sigx,&
                            epsx, depsx, angmas, varim(ivari), varip(ivari),&
                            sigf(i), modf(i), codrep)
                if (codrep .ne. 0) then
                    codret=codrep
!                   code 3: on continue et on le renvoie à la fin. Autre codes: sortie immédiate
                    if (codrep .ne. 3) goto 999
                endif
            enddo
        endif
    else
        call utmess('F', 'ELEMENTS2_39', sk=compo)
    endif
!
999 continue
end subroutine
