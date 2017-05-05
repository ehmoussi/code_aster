subroutine connor(melflu, typflu, freq, base, nuor,&
                  amoc, carac, masg, lnoe, nbm,&
                  vite, rho, abscur)
!
! aslint: disable=W1306 
    implicit none
! ======================================================================
! COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
!  CALCUL DES VITESSES EFFICACES ET CRITIQUES PAR LA METHODE DE CONNORS
!  IN : MELFLU : NOM DU CONCEPT DE TYPE MELASFLU PRODUIT
!  IN : TYPFLU : NOM DU CONCEPT DE TYPE TYPE_FLUI_STRU DEFINISSANT LA
!                CONFIGURATION ETUDIEE
!  IN : FREQ   : LISTE DES FREQUENCES ETUDIES
!  IN : NUOR   : LISTE DES NUMEROS D'ORDRE DES MODES SELECTIONNES POUR
!                LE COUPLAGE (PRIS DANS LE CONCEPT MODE_MECA)
!  IN : AMOR   : LISTE DES AMORTISSEMENTS REDUITS MODAUX
!  IN : AMOC   : LISTE DES AMORTISSEMENTS REDUITS MODAUX DE CONNORS
!  IN : CARAC  : CARACTERISTIQUES GEOMETRIQUES DU TUBE
!  IN : MASG   : MASSES GENERALISEES DES MODES PERTURBES, SUIVANT LA
!                DIRECTION CHOISIE PAR L'UTILISATEUR
!  IN : LNOE   : NOMBRE DE NOEUDS
!  IN : NBM    : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
!  IN : VITE   : LISTE DES VITESSES D'ECOULEMENT ETUDIEES
!  IN : RHO    : MASSE VOLUMIQUE DU TUBE
!  IN : ABSCUR : ABSCISSE CURVILIGNE DES NOEUDS
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
! -------------------------
!
! ARGUMENTS
! ---------
#include "jeveux.h"
#include "asterc/r8pi.h"
#include "asterc/r8prem.h"
#include "asterfort/dismoi.h"
#include "asterfort/extmod.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtdscr.h"
#include "asterfort/rsadpa.h"
#include "asterfort/wkvect.h"
!
    character(len=19) :: melflu
    character(len=8) :: typflu, base
    integer :: nbm
    integer :: nuor(nbm), lnoe
    real(kind=8) :: amoc(nbm), masg(nbm), carac(2), freq(nbm)
    real(kind=8) :: vite(lnoe), abscur(lnoe), epsi
    real(kind=8) :: rho(2*lnoe)
!
! VARIABLES LOCALES
! -----------------
    real(kind=8) :: coef(nbm), delta(nbm), rhotub, rhos
    integer :: imode, im, ifsvr, ifsvi, nbma, nbzex, nmamin, nmamax
    integer :: iener, ima, izone, ivcn, iven, icste, modul, nbval, i, j
    integer :: jconn, modul2, k,  ifsvk, ide, neq, idep
    integer :: ldepl(6), lmasg, increm, id, irap
    real(kind=8) :: di, de, mastub, ltube, numera(nbm), denomi
    real(kind=8) :: pas, correl, a, b, c, d, e, f, mphi2(nbm)
    real(kind=8) :: modetr(3*lnoe*nbm), mode(lnoe*nbm)
    real(kind=8) :: coeff1, coeff2, coeff3, coeff4, coeff5, coeff6
    real(kind=8) :: rhoeq
    real(kind=8) :: mass(nbm)
    character(len=8) :: depla(3), depl, k8b
    character(len=14) :: numddl
    character(len=19) :: masse
    character(len=24) :: fsvr, fsvi, fsvk
    integer, pointer :: tempo(:) => null()
    data depla  /'DX      ','DY      ','DZ      '/
    data ldepl  /1,2,3,4,5,6/

!-----------------------------------------------------------------------
! Curvilinear abscissa
#define x abscur(ima)
#define x1 abscur(ima+1)
#define dx (x1-x)
!-----------------------------------------------------------------------
! Fluid (cross-flow) velocity
#define v vite(ima)
#define dv (vite(ima+1)-v)
!-----------------------------------------------------------------------
! Modal deformation extracted along cross-flow direction
#define phi mode(lnoe*(im-1)+ima)
#define dphi (mode(lnoe*(im-1)+ima+1)-phi)
!-----------------------------------------------------------------------
! Internal (primary) fluid density
#define rho_i rho(lnoe+ima)
#define rho_i1 rho(lnoe+ima+1)
#define drho_i (rho_i1-rho_i)
!-----------------------------------------------------------------------
! External (secondary) fluid density
#define rho_e rho(ima)
#define rho_e1 rho(ima+1)
#define drho_e (rho_e1-rho_e)
!===========================================================================
! 1d : Gevibus method (filtered modes along cross-flow direction)
! 3d : Alternative method using all 3 (x,y,z) components of the modes combined
!      with the *scalar* flow velocity
#define rho_v2_phi2_1d(izone,im) zr(iener-1+nbzex*(im-1)+izone)
#define rho_v2_phi2_3d(izone,im) zr(iener-1+nbzex*(im-1)+izone+nbzex*nbm)
!-----------------------------------------------------------------------
! ven : Mean entraining velocity for mode "im"
! vcr : Critical velocity for mode "im" and connor's constant "i"
! rap : Instability ratio for mode "im" and connor's constant "i"
#define ven_1d(im) zr(iven-1+im)
#define vcr_1d(im,i) zr(ivcn-1+(im-1)*nbval+i)
#define rap_1d(im,i) zr(irap-1+(im-1)*nbval+i)
!-----------------------------------------------------------------------
#define ven_3d(im) zr(iven-1+nbm+im)
#define vcr_3d(im,i) zr(ivcn-1+(im-1)*nbval+i+nbm*nbval)
#define rap_3d(im,i) zr(irap-1+(im-1)*nbval+i+nbm*nbval)
!-----------------------------------------------------------------------
! ki : Connor's constant per zone
! conn_min, conn_max : Connor's constants range
#define ki(izone) zr(icste-1+izone)
#define conn_min zr(ifsvr+3+2*(j-1))
#define conn_max zr(ifsvr+3+2*(j-1)+1)
#define nbdisc(izone) zi(ifsvi+1+nbzex+izone)
!-----------------------------------------------------------------------

    call jemarq()
    epsi = r8prem()
!
!     CALCUL DES CONSTANTES INDEPENDANTES DE L ABSCISSE CURVILIGNE
!     ------------------------------------------------------------
!
    fsvr = typflu//'           .FSVR'
    call jeveuo(fsvr, 'L', ifsvr)
!
    fsvi = typflu//'           .FSVI'
    call jeveuo(fsvi, 'L', ifsvi)
!
    fsvk = typflu//'           .FSVK'
    call jeveuo(fsvk, 'L', ifsvk)
!
    call jeveuo('&&MDCONF.TEMPO', 'L', vi=tempo)
!
    de     = carac(1)
    di     = carac(1)-2*carac(2)
    correl = zr(ifsvr)
    pas    = zr(ifsvr+1)
    rhotub = zr(ifsvr+2)
    nbma   = lnoe-1
    nbzex  = zi(ifsvi+1)
!
    nbval = 1
    do izone = 1, nbzex
        nbval = nbval*nbdisc(izone)
    end do
!
! ==================================================================
!   VECTEUR DE TRAVAIL CONTENANT POUR CHAQUE MODE ET CHAQUE ZONE
!   LA VALEUR DE L ENERGIE DU AU FLUIDE
!   PAR ORDRE ON DONNE POUR LE MODE 1 LES VALEURS SUR CHAQUE ZONE
!   PUIS LE MODE 2 ET ETC
!
    call wkvect('&&CONNOR.ENERGI', 'V V R', 2*nbzex*nbm, iener)
    call wkvect('&&CONNOR.CSTE', 'V V R', nbzex, icste)
!
    call wkvect(melflu(1:8)//'.VCN', 'G V R', 2*nbval*nbm, ivcn)
    call wkvect(melflu(1:8)//'.VEN', 'G V R', 2*nbm, iven)
    call wkvect(melflu(1:8)//'.MASS', 'V V R', 2, jconn)
    call wkvect(melflu(1:8)//'.RAP', 'G V R', 2*nbval*nbm, irap)
!
    mastub = 0.d0
    rhos   = 0.d0
    ltube  = abscur(lnoe)-abscur(1)
!
!
!   DIRECTION DANS LAQUELLE AGISSENT LES FORCES FLUIDELASTIQUES
    idep = 0
    depl = zk8(ifsvk+1)
    do ide = 1, 3
        if (depla(ide) .eq. depl) idep = ide
    end do
!   ============================================================
!   DEFORMEES MODALES
!   ============================================================
    call dismoi('REF_MASS_PREM', base, 'RESU_DYNA', repk=masse)
    call mtdscr(masse)
    call dismoi('NOM_NUME_DDL', masse, 'MATR_ASSE', repk=numddl)
    call dismoi('NB_EQUA', masse, 'MATR_ASSE', repi=neq)
!
!     EXTRACTION DE LA COMPOSANTE SELON LA DIRECTION DE L ECOULEMENT DES
!     DIFFERENTS MODES (Gevibus method - 1d)
    call extmod(base, numddl, nuor, nbm, mode,&
                neq, lnoe, [idep], 1)
!
!     EXTRACTION DES COMPOSANTES DE TRANSLATION DES  DIFFERENTS MODES
!     (Alternative methode translation 3d)
    call extmod(base, numddl, nuor, nbm, modetr,&
                neq, lnoe, ldepl, 3)
!   ============================================================

    rhoeq = 0.d0
    do ima = 1, nbma
        rhoeq = rhoeq + dx*(rhotub+(di**2/(de**2-di**2))*((rho_i+rho_i1)/2) + &
                            (2*correl/r8pi())*(de**2/(de**2-di**2))*((rho_e+rho_e1)/2))
        rhos  = rhos  + dx*((rho_e+rho_e1)/2)
    end do
!
    mastub     = ((r8pi()/4)*(de**2-di**2)*rhoeq)/ltube
    rhos       = rhos/ltube
    zr(jconn ) = mastub
    zr(jconn+1)= rhos
!
!
!
!     1)  METHODE GEVIBUS
!         ===============
!
!     CALCUL DE LA VITESSE CRITIQUE INTER TUBES POUR CHAQUE COMBINAISON
!     DES CONSTANTES DE CONNORS ET POUR CHAQUE MODE
!
!   ----------------------------------------------------------------------
!   ------ Calculation of rho_v2_phi2_1d(izone,im) : per mode and per zone
!   ----------------------------------------------------------------------
    do im = 1, nbm

!
        imode=nuor(im)
!       LES LIGNES COMMENTARISEES CORRESPONDENT A
!       UN AMORTISSEMENT MODAL CALCULE PAR LA FORMULE :
!       AMORTISSEMENT/(4*PI*(MASSE GENERALISE*FREQUENCE)
!
!       AMORED(IMODE)=AMOC(IMODE)/(4*R8PI()*MASG(IMODE)*FREQ(IMODE))
!       DELTA(IMODE)=(2*R8PI()*AMORED(IMODE))/SQRT(1-AMORED(IMODE)**2)
!
        delta(im) = (2*r8pi()*amoc(im))/sqrt(1-amoc(im)**2)
        coef(im)  = freq(imode)*sqrt(mastub*delta(im)/rhos)
!
        do izone = 1, nbzex
!
            nmamin=tempo(1+2*(izone-1)+1)
            nmamax=tempo(1+2*(izone-1)+2)-1

!           RHO EST DE LA FORME A*S+B
!           V   EST DE LA FORME C*S+D
!           PHI EST DE LA FORME E*S+F
            do ima = nmamin, nmamax
                a = drho_e/dx
                b = rho_e-a*x
!
                c = dv/dx
                d = v-c*x
!
                e = dphi/dx
                f = phi-e*x
!
!               COEFFICIENT DU POLYNOME DU 5 DEGRES RESULTAT DE RHO*V**2*PHI**2
!
                coeff1 = a*c**2*e**2
                coeff2 = 2*a*e*f*(c**2)+2*a*(e**2)*c*d+(c**2)*(e**2)*b
                coeff3 = a*(f**2)*(c**2)+4*a*e*f*c*d+a*(e**2)*(d**2)+&
                         2*e*f*(c**2)*b+2*(e**2)*c*d*b
                coeff4 = 2*a*c*d*(f**2)+2*a*e*f*(d**2)+(f**2)*(c**2)*b+&
                         4*e*f*c*d*b+(e**2)*(d**2)*b
                coeff5 = 2*c*d*(f**2)*b+2*e*f*(d**2)*b+(d**2)*(f**2)*a
                coeff6 = (d**2)*(f**2)*b
!
                rho_v2_phi2_1d(izone,im) = rho_v2_phi2_1d(izone,im) + &
                                 (coeff1*(x1**6-x**6))/6 + &
                                 (coeff2*(x1**5-x**5))/5 + &
                                 (coeff3*(x1**4-x**4))/4 + &
                                 (coeff4*(x1**3-x**3))/3 + &
                                 (coeff5*(x1**2-x**2))/2 + &
                                  coeff6*dx
            end do
        end do
    end do
!
!   --- For each combination (across zones) of connor's constants
    do i = 1, nbval
        modul=1
!
!       --- Calculate Ki, connor's constant per zone
        do j = 1, nbzex
            modul=1
            do k = (j+1), nbzex
                modul=modul*nbdisc(k)
            end do
            if (j .eq. 1) then
                pas=dble((i-1)/modul)
            else
                modul2=modul*nbdisc(j)
                pas=dble(mod(i-1,modul2)/modul)
            endif
            ki(j) = conn_min + pas*(conn_max-conn_min)/(nbdisc(j)-1)
        end do
!
        do im = 1, nbm
            numera(im)=0.d0
            denomi=0.d0
            do izone = 1, nbzex
                numera(im) = numera(im) + rho_v2_phi2_1d(izone,im)
                denomi = denomi+ki(izone)**(-2)*rho_v2_phi2_1d(izone,im)
            end do
            if ((numera(im) .lt. epsi)) then
                denomi = 0.d0
                do izone = 1, nbzex
                    denomi = denomi + ki(izone)**(-2)
                end do
                vcr_1d(im,i) = sqrt((nbzex*1.d0)/denomi)*coef(im) 
            else
                vcr_1d(im,i) = sqrt(numera(im)/denomi)*coef(im)
            end if
        end do
    end do
!
!    CALCUL DE LA VITESSE EFFICACE POUR CHAQUE MODE PROPRE
!
    do im = 1, nbm
!
!    LA MASSE LINEIQUE DU TUBE EST DE LA FORME A*S+B
!    LE MODE PROPRE DU TUBE EST DE LA FORME C*S+D
!
        mphi2(im)=0.d0
        do ima = 1, nbma
!
            a = 0.5d0*r8pi()*(di**2) * drho_i + &
                correl*(de**2)*drho_e/(2*dx)

            b = r8pi()*rhotub*(de**2-di**2)/4        + &
                r8pi()*(di**2)/4*(rho_i-drho_i/dx*x) + &
                correl*(de**2)/2*(rho_e-drho_e/dx*x)
!
            c = dphi/dx
            d = phi-c*x
!
            coeff1 = a*(c**2)
            coeff2 = 2*c*d*a+(c**2)*b
            coeff3 = (d**2)*a+2*c*d*b
            coeff4 = (d**2)*b

            mphi2(im) = mphi2(im) + (coeff1*(x1**4-x**4))/4 + &
                                    (coeff2*(x1**3-x**3))/3 + &
                                    (coeff3*(x1**2-x**2))/2 + &
                                     coeff4*dx
!
        end do
!
        if (numera(im) .lt. epsi) then
            ven_1d(im) = 0.d0
        else 
            ven_1d(im) = sqrt((numera(im)*mastub) / (mphi2(im)*rhos))
        end if
        print *,"  >>vitesse entrainement = ", ven_1d(im)
        do i = 1, nbval
            rap_1d(im,i) = ven_1d(im)/vcr_1d(im,i)
            print *,"  >>rapport d'instabilité, connor's constant # : ",i, " value =", rap_1d(im,i)
        end do
    end do
!
!
!
!
!     2)  FORMULATION ALTERNATIVE
!         ===============
!
!     CALCUL DE LA VITESSE CRITIQUE INTER TUBES POUR CHAQUE COMBINAISON
!     DES CONSTANTE DE CONNORS ET POUR CHAQUE MODE
!

!   ----------------------------------------------------------------------
!   ------ Calculation of rho_v2_phi2_3d(izone,im) : per mode and per zone
!   ----------------------------------------------------------------------
    do im = 1, nbm
!
        imode=nuor(im)
!       LES LIGNES COMMENTARISEES CORRESPONDENT A
!       UN AMORTISSEMENT MODAL CALCULE PAR LA FORMULE :
!       AMORTISSEMENT/(4*PI*(MASSE GENERALISE*FREQUENCE)
!
!       AMORED(IMODE)=AMOC(IMODE)/(4*R8PI()*MASG(IMODE)*FREQ(IMODE))
!       DELTA(IMODE)=(2*R8PI()*AMORED(IMODE))/SQRT(1-AMORED(IMODE)**2)
!
        do izone = 1, nbzex
!
            nmamin=tempo(1+2*(izone-1)+1)
            nmamax=tempo(1+2*(izone-1)+2)-1

!           RHO EST DE LA FORME A*S+B
!           V   EST DE LA FORME C*S+D
!           PHI EST DE LA FORME E*S+F
            do ima = nmamin, nmamax
                a=drho_e/dx
                b=rho_e-a*x
!
                c=dv/dx
                d=v-c*x
!
                coeff1=0.d0
                coeff2=0.d0
                coeff3=0.d0
                coeff4=0.d0
                coeff5=0.d0
                coeff6=0.d0
!
! PRISE EN COMPTE DES DDL DE TRANSLATION
!
                do id = 1, 3
                    increm = (lnoe*(im-1)+ima-1)*3+id
                    e = (modetr(increm+3)-modetr(increm)) /  dx
                    f =  modetr(increm)-e*x
!
!    COEFFICIENT DU POLYNOME DU 5 DEGRES RESULTAT DE RHO*V**2*PHI**2
!
                    coeff1 = coeff1 + a*c**2*e**2
                    coeff2 = coeff2 + 2*a*e*f*(c**2) + 2*a*(e**2)*c*d + (c**2)*(e**2)*b
                    coeff3 = coeff3 + a*(f**2)*(c**2) + 4*a*e*f*c*d+a*(e**2)*(d**2) + &
                                      2*e*f*(c**2)*b + 2*(e**2)*c*d*b
                    coeff4 = coeff4 + 2*a*c*d*(f**2) + 2*a*e*f*(d**2) + (f**2)*(c**2)*b + &
                                      4*e*f*c*d*b+(e**2)*(d**2)*b
                    coeff5 = coeff5 + 2*c*d*(f**2)*b + 2*e*f*(d**2)*b + (d**2)*(f**2)*a
                    coeff6 = coeff6 + (d**2)*(f**2)*b
                end do
!
                rho_v2_phi2_3d(izone,im) = rho_v2_phi2_3d(izone,im) + &
                                 (coeff1*(x1**6-x**6))/6 +&
                                 (coeff2*(x1**5-x**5))/5 +&
                                 (coeff3*(x1**4-x**4))/4 +&
                                 (coeff4*(x1**3-x**3))/3 +&
                                 (coeff5*(x1**2-x**2))/2 +&
                                  coeff6*dx
            end do
        end do
    end do
!
!
    do i = 1, nbval
        modul=1
!
!       --- Calculate Ki, connor's constant per zone
        do j = 1, nbzex
            modul=1
            do k = (j+1), nbzex
                modul=modul*nbdisc(k)
            end do
            if (j .eq. 1) then
                pas=dble((i-1)/modul)
            else
                modul2=modul*nbdisc(j)
                pas=dble(mod(i-1,modul2)/modul)
            endif
            ki(j) = conn_min + pas*(conn_max-conn_min)/(nbdisc(j)-1)
        end do
!
        do im = 1, nbm
            numera(im)= 0.d0
            denomi    = 0.d0
            do izone = 1, nbzex
                numera(im) = numera(im)+ rho_v2_phi2_3d(izone,im)
                denomi     = denomi    + ki(izone)**(-2) * rho_v2_phi2_3d(izone,im)
            end do

            if ((numera(im) .lt. epsi)) then
                denomi = 0.d0
                do izone = 1, nbzex
                    denomi = denomi + ki(izone)**(-2)
                end do
                vcr_3d(im,i) = sqrt(nbzex*1.d0/denomi)*coef(im) 
            else
                vcr_3d(im,i) = sqrt(numera(im)/denomi)*coef(im)
            end if
            
        end do
    end do
!
!    CALCUL DE LA VITESSE EFFICACE POUR CHAQUE MODE PROPRE
!
    do im = 1, nbm
!
!       --- Modal (generalized) mass for mode "im"
        call rsadpa(base, 'L', 1, 'MASS_GENE', nuor(im),&
                    0, sjv=lmasg, styp=k8b)
        mass(im) = zr(lmasg)

        ven_3d(im) = sqrt((numera(im)*mastub) / (mass(im)*rhos))
        print *,"  >>vitesse entrainement = ", ven_3d(im)
        do i = 1, nbval
            rap_3d(im,i) = ven_3d(im)/vcr_3d(im,i)
            print *,"  >>rapport d'instabilité, connor's constant : ",i, " value =", rap_3d(im,i)
        end do
    end do
!
!
!
    call jedema()
end subroutine
