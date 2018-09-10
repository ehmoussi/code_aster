! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine fluendo3d(xmat,sig0,sigf,deps,&
                     nstrs,var0,varf,nvari,nbelas3d,&
                     teta1,teta2,dt,vrgi,ierr1,&
                     iso,mfr,end3d,fl3d,local,&
                     ndim)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
 
implicit none
#include "asterc/r8prem.h"
#include "asterf_types.h"
#include "asterfort/hydramat3d.h"
#include "asterfort/thermat3d.h"
#include "asterfort/hydravar3d.h"
#include "asterfort/bwpw3d.h"
#include "asterfort/hydracomp3d.h"
#include "asterfort/dflufin3d.h"
#include "asterfort/conso3d.h"
#include "asterfort/matfluag3d.h"
#include "asterfort/couplagf3d.h"
#include "asterfort/gauss3d.h"
#include "asterfort/bgpg3d.h"
#include "asterfort/fludes3d.h"
#include "asterfort/x6x33.h"
#include "asterfort/b3d_valp33.h"
#include "asterfort/transpos1.h"
#include "asterfort/chrep6.h"
#include "asterfort/dflueff3d.h"
#include "asterfort/endo3d.h"
#include "asterfort/criter3d.h"
#include "asterfort/majw3d.h"
#include "asterfort/utmess.h"

     
     real(kind=8) ::  beta, beta00,bg0,biotw,biotw00,brgi,ccmin0,dim3,brgi00
     real(kind=8) ::  ccmin1,cthp,cthp1,cthv,cthv1,cthvm,cwtauk0,cwtauk1,depleqc
     real(kind=8) ::  cwtaukm,delta,delta00,denom,denomin,depleqc_dl
     real(kind=8) ::  dfin0,dfin1,dflu0,dflu1,dfmx,dhydr,dt1,dt80,dteta,dth0
     real(kind=8) ::  dth00,dth1,dther,dtmaxi,dtmaxik, dtmaxim,dvrgi,dvw,ekdc
     real(kind=8) :: epc0,epc00,epc1,epleqc,epleqc0,epleqc00
     real(kind=8) ::  epleqc01,epp1,epser,epsklim1,epsklim2,epsm00
     real(kind=8) ::  epsmin,ept,ept00,ept1,epsklim,hyd00
     integer      :: ipla2
     real(kind=8) :: pg0,rc00,rc1,reduc1,ref00,ref1,rt00,rt1
     real(kind=8) ::  tauk00,tauk1,taum00,teta,treps,trepspg
     real(kind=8) ::  umdt,vrgi00,vrgi1,vrgi2,vsrw,vw,vw1,vw2,we0s,xb1mg00
     real(kind=8) ::  xflu,xk00,xlim00,young00,xm00,xnsat,xnsat00,xpas1
     real(kind=8) ::  xx1,gfr,epeqpc

     integer i,j,k,l,ndim,npas1,nt,ifour
      
!            calcul de l ecoulement visco-elasto-plastique: Sellier mars 2014
        
!            tables de dimension fixe pour resolution des sytemes lineaires
        
!            variable logique pour activer le fluage, l endo, le traitement local
             aster_logical ::  end3d,fl3d,local
        
!            decalage Gauss pour la plasticite en cas de fluage nf0
             integer nf0
        
!            declaration des variables externes
             integer nstrs,nvari,nbelas3d,ierr1,mfr
             real(kind=8) :: xmat(:),sig0(:),sigf(:),deps(:)
             real(kind=8) ::  var0(:),varf(:)
             real(kind=8) ::  dt,vrgi,teta1,teta2
        
!            tableau pour la resolution des systemes lineaires
             integer ngf
             parameter (ngf=22)
             real(kind=8) ::  X(ngf),B(ngf),A(ngf,(ngf+1))
             integer ipzero(ngf)
!            variable de controle d erreur dans methode de gauss
             integer errgauss
        
!            donnes pour test fluage3d
             real(kind=8) ::  epse06(6),epsk06(6),epsm06(6),sig06(6)
             real(kind=8) ::  phi0,we0
             real(kind=8) ::  epse16(6),epsk16(6),epsm16(6),sig16(6)
             real(kind=8) ::  depsk6(6),depsm6(6),depse6(6)
             real(kind=8) ::  depsk6p(6),depsm6p(6),depse6p(6)
             real(kind=8) ::  phi1,we1,psik,epsm11
             real(kind=8) :: taum1
             real(kind=8) ::  souplesse66(6,6),raideur66(6,6)
             real(kind=8) ::  souplesse66p(6,6),raideur66p(6,6)
             real(kind=8) ::  deps6(6)
             real(kind=8) ::  theta,theta1,heta
!            theta : theta methode pour Euler, heta: taux de variation maxi
!            des deformations de fluage  lors d une sous iteration
             parameter(theta=0.5d0,heta=0.1d0)
!            ecrouissage minimal post pic de dP
             real(kind=8) ::  hpla
             parameter(hpla=1.0d-3)
             real(kind=8) ::  young,nu,nu00,lambda,mu
             real(kind=8) ::  rt33(3,3),rtg33(3,3)
             real(kind=8) ::  rt33p(3,3),rtg33p(3,3)
             real(kind=8) ::  ref33(3,3),ref33p(3,3)
             aster_logical ::  iso
!            continuite pour as3d
             real(kind=8) ::  sig133(3,3),sig13(3),vsig133(3,3),vsig133t(3,3)
             real(kind=8) ::  sig16p(6)
             real(kind=8) ::  rt,pglim,bg,phivg,mg,pg,ref,rc,poro
!            deformation plastiques
             real(kind=8) ::  epspt6(6),epspt6p(6)
             real(kind=8) ::  epspg6(6),epspg6p(6)
             real(kind=8) ::  epspc6(6),epspc6p(6)
             real(kind=8) ::  epspt600(6),epspt60(6)
             real(kind=8) ::  epspg600(6),epspg60(6)
             real(kind=8) ::  epspc600(6),epspc60(6)
!            nombres de criteres totaux et actifs
             integer nc
             parameter (nc=10)
!            ig(nc) : correspondance entre n° de critere actif et n° global
!            suivant ordre defini dans criter3d.f
             integer na,ig(nc)
             real(kind=8) ::  fa(nc),dpfa_ds(nc,6),dgfa_ds(nc,6),dpfa_dpg(nc),fg(nc)
             real(kind=8) ::  fglim(nc)
!            derivee de la resistance / multiplicateur plastique
             real(kind=8) ::   dra_dl(nc)
!            matrices de couplage avec le fluage pour la reconstruction de a
             real(kind=8) ::  kveve66(6,6),kvem66(6,6),kmve66(6,6),kmm66(6,6)
             real(kind=8) ::  bve6(6),bm6(6),deltam
             real(kind=8) ::  avean
!            deformations et contraintes init projetees dans base prin actuelle
             real(kind=8) ::  epse06p(6), epsk06p(6),epsm06p(6)
!            derivees de la pression / deformation anelastiques
             real(kind=8) ::  dpg_depsa6(6),dpg_depspg6(6)
!            dissipation et potentiel de fluage
!            increments de deformations plastiques
             real(kind=8) ::  depspt6(6),depspg6(6),depspc6(6)
             real(kind=8) ::  depspt6p(6),depspg6p(6),depspc6p(6)
!            contrainte effective + gel
             real(kind=8) ::  sigf6(6)
!            increment de deformation pour le retour radial
             real(kind=8) ::  deps6r(6)
!            valriable de controle de refermeture de fissure limite
             aster_logical ::  limit1
!            compteur de sous iteration plastique
             integer ipla,imax
!            nombre maxi de sous iterations plastique : imax
             parameter (imax=1000)
!            logique pour le controle de coherence de dissipation par fluage
             aster_logical ::  logic1
!            increment de dissipation directionnel
             real(kind=8) ::  dphi
!            hydratation actuelle et seuil
             real(kind=8) ::  hydr, hyds
             real(kind=8) ::  som1,som2
!            deplacements imposes reduits
             real(kind=8) :: deps6r2(6)
!            complement a un de biot gel
!            inverse du potentiel de fluage
!            dissipation avant hydratation ( a hyd0)
             real(kind=8) ::  phi00,hyd0
!            energie activation du potentiel de fluage
             real(kind=8) ::  nrjm
!            contrainte elastique de l etage de Kelvin
             real(kind=8) ::  sigke06(6),sigke16(6)
!            porosite
             real(kind=8) ::  poro2,poro1,dporo
!            contraintes integrant l effet pickett
!            contrainte caracteristique pour l effet pickett
             real(kind=8) ::  sfld
!            endommagement capillaire du a leau
             real(kind=8) :: pw,bw
!            code d erreur des sous programmes
             integer err1
!            exposant de Van Genuchten
             real(kind=8) ::  mvgn
!            resultante des contraintes intraporeuses
             real(kind=8) ::  sigp
!            endommagement micro mecanique global
!            indicateur de premier pas
             aster_logical ::  ppas
!            coeff pour la prise en compte du fluage de dessiccation sur tauk
             real(kind=8) ::  CWtauk
!            deformation caracteristique pour l ecrouissage et l endo de rgi
!            et pour l endo de traction
             real(kind=8) ::  eprg00
!            energie de fissuration par traction directe
             real(kind=8) ::  gft00,gft
!            longeur de lelement dans la base des direction principales
!            controle des actions de criter3d et stockage des directions d ecoule
             integer irr
!            contraintes endommagees
             real(kind=8) ::  sigf6d(6)
!            matrice pour la gestion de la taille dans castem
             real(kind=8) ::  t33(3,3)
!            indicateur de l activite du critere de refermeture
             aster_logical ::  referm3(3),testtpi
!            facteur de concentration de contrainte pour le gel et module
!            d ecrouissage de la pression avec la deformation permanente
!            de rgi
             real(kind=8) ::  krgi00,krgi,hplg
!            degré de saturation
             real(kind=8) ::  srw
!            table pour la gestion des multiplicateurs negatifs
             integer nsupr,nared,supr(nc)
!            indicateur de reduction du nbr de criteres actifs
             aster_logical ::  indic2
!            derivee fonction seuil / resistance
             real(kind=8) ::  dpfa_dr(nc)
!            histoire des surcharges capillaires dues au variations hydriques
!            sous charge
             real(kind=8) ::  dsw6(6),bw0,pw0
!            influence de la consolidation spherique
!            coeff de consolidation anisotrope
             real(kind=8) :: cc03(3),cc13(3),vcc33(3,3),vcc33t(3,3)
             real(kind=8) ::  vref33(3,3),vref33t(3,3)
!            endommagement isotrope de fluage (asymptotique et effectif)
             real(kind=8) :: ccmax0,ccmax1
             real(kind=8) ::  dfl00,dfl0
             real(kind=8) :: cmp0,cmp1,CWp
!            temperatures de reference et de seuil
             real(kind=8) ::  tetas,tetar
!            coeff THM  / fluage debut de pas
             real(kind=8) ::  CWp0,CthP0,Cthv0,dsw06(6)
!            endommagements et ouvertures de fissures dans leur base principale
             real(kind=8) ::  dt3(3),dr3(3),dgt3(3),dgc3(3),dc,wl3(3)
!            traitement endommagement isotrope prepic
             real(kind=8) ::  xmt,dtr
             aster_logical ::  dtiso
!            avancement de la reaction de gonflement interne (rag par exple)
             real(kind=8) ::  vrgi0,taar,nrjg,srsrag,aar0,aar1,trag,vrag00
             real(kind=8) :: vdef00,def1
             real(kind=8) :: tdef,nrjd,def0,srsdef
             real(kind=8) :: CNa
             real(kind=8) :: nrjp,ttrd,tfid,ttdd
             real(kind=8) :: tdid,exmd,exnd,cnab,cnak,ssad
             real(kind=8) :: At,St,M1,E1,M2,E2,AtF,StF,M1F,E1F,M2F,E2F 
!            valuer fluage debut de pas
             real(kind=8) ::  epsk006(6),epsm006(6)
!            Def thermiques transitoires (si Dtheta sous charge)
             real(kind=8) :: depstt6(6),deps6r3(6)
             real(kind=8) ::  ett600(6),ett60(6)
             real(kind=8) ::  ett61(6)
!            14mai2015: ouvertures de fissures du pas precedent
             real(kind=8) ::  wplt6(6),wplt06(6),wplt006(6)
             real(kind=8) ::  wpltx6(6),wpltx06(6),wpltx006(6)
             real(kind=8) ::  wpl3(3),vwpl33(3,3),vwpl33t(3,3)
             real(kind=8) ::  wplx3(3),vwplx33(3,3),vwplx33t(3,3)
!             taux de cisaillement
             real(kind=8) ::  tauc,depleqc3
    real(kind=8), dimension(2) :: valr
    integer, dimension(3) :: vali

        depstt6(:) = 0.d0
        deps6r2(:) = 0.d0
        deps6r3(:) = 0.d0
        deps6(:) = 0.d0
        deps6r(:) = 0.d0
        sig06(:)=0.d0
        dsw06(:)=0.d0  
        epsklim1=0.d0
        epsklim2=0.d0
        epsklim=0.d0
        denom=0.d0
        denomin=0.d0
        dtmaxi=0.d0
        dphi=0.d0
        vrgi2=0.d0
        err1=0
        ref33(:,:) = 0.d0
        ref33p(:,:) = 0.d0
        rt33(:,:)=0.d0
        sigf6(:)=0.d0       
        sigf6d(:)=0.d0
        souplesse66(:,:)=0.d0
        souplesse66p(:,:)=0.d0
        dsw6(:)=0.d0
        cwp0=0.d0
        cmp0=0.d0
        cthp0=0.d0
        cthv0=0.d0
        epsk06(:)=0.d0
        epsk06p(:)=0.d0
        sig16(:)=0.d0
        epsm16(:)=0.d0
        epsm06(:)=0.d0
        beta=0.d0
     beta00=0.d0
     bg0=0.d0
     biotw=0.d0
     biotw00=0.d0
     brgi=0.d0
     ccmin0=0.d0
     dim3=0.d0
     brgi00=0.d0
     ccmin1=0.d0
     cthp=0.d0
     cthp1=0.d0
     cthv=0.d0
     cthv1=0.d0
     cthvm=0.d0
     cwtauk0=0.d0
     cwtauk1=0.d0
     depleqc=0.d0
     cwtaukm=0.d0
     delta=0.d0
     delta00=0.d0
     denom=0.d0
     denomin=0.d0
     depleqc_dl=0.d0
     dfin0=0.d0
     dfin1=0.d0
     dflu0=0.d0
     dflu1=0.d0
     dfmx=0.d0
     dhydr=0.d0
     dt1=0.d0
     dt80=0.d0
     dteta=0.d0
     dth0=0.d0
     dth00=0.d0
     dth1=0.d0
     dther=0.d0
     dtmaxi=0.d0
     dtmaxik=0.d0
     dtmaxim=0.d0
     dvrgi=0.d0
     dvw=0.d0
     ekdc=0.d0
     epc0=0.d0
     epc00=0.d0
     epc1=0.d0
     epleqc=0.d0
     epleqc0=0.d0
     epleqc00=0.d0
     epleqc01=0.d0
     epp1=0.d0
     epser=0.d0
     epsklim1=0.d0
     epsklim2=0.d0
     epsm00=0.d0
     epsmin=0.d0
     ept=0.d0
     ept00=0.d0
     ept1=0.d0
     epsklim=0.d0
     gfr=0.d0
     hyd00=0.d0
     pg0=0.d0
     rc00=0.d0
     rc1=0.d0
     reduc1=0.d0
     ref00=0.d0
     ref1=0.d0
     rt00=0.d0
     rt1=0.d0
     tauk00=0.d0
     tauk1=0.d0
     taum00=0.d0
     teta=0.d0
     treps=0.d0
     trepspg=0.d0
     umdt=0.d0
     vrgi00=0.d0
     vrgi1=0.d0
     vrgi2=0.d0
     vsrw=0.d0
     vw=0.d0
     vw1=0.d0
     vw2=0.d0
     we0s=0.d0
     xb1mg00=0.d0
     xflu=0.d0
     xk00=0.d0
     xlim00=0.d0
     young00=0.d0
     xm00=0.d0
     xnsat=0.d0
     xnsat00=0.d0
     xpas1=0.d0
     xx1=0.d0
     epeqpc=0.d0
     X(:)=0.d0
     B(:)=0.d0
     A(:,:)=0.d0
     epse06(:)=0.d0
     epsk06(:)=0.d0
     epsm06(:)=0.d0
     sig06(:)=0.d0
     phi0=0.d0
     we0=0.d0
     epse16(:)=0.d0
     epsk16(:)=0.d0
     epsm16(:)=0.d0
     sig16(:)=0.d0
     depsk6(:)=0.d0
     depsm6(:)=0.d0
     depse6(:)=0.d0
     depsk6p(:)=0.d0
     depsm6p(:)=0.d0
     depse6p(:)=0.d0
     phi1=0.d0
     we1=0.d0
     psik=0.d0
     epsm11=0.d0
     taum1=0.d0
     souplesse66(:,:)=0.d0
     raideur66(:,:)=0.d0
     souplesse66p(:,:)=0.d0
     raideur66p(:,:)=0.d0
     deps6(:)=0.d0
     theta1=0.d0
     young=0.d0
     nu=0.d0
     nu00=0.d0
     lambda=0.d0
     mu=0.d0
     rt33(:,:)=0.d0
     rtg33(:,:)=0.d0
     rt33p(:,:)=0.d0
     rtg33p(:,:)=0.d0
     ref33(:,:)=0.d0
     ref33p(:,:)=0.d0
     sig133(:,:)=0.d0
     sig13(:)=0.d0
     vsig133(:,:)=0.d0
     vsig133t(:,:)=0.d0
     sig16p(:)=0.d0
     rt=0.d0
     pglim=0.d0
     bg=0.d0
     phivg=0.d0
     mg=0.d0
     pg=0.d0
     ref=0.d0
     rc=0.d0
     poro=0.d0
     epspt6(:)=0.d0
     epspt6p(:)=0.d0
     epspg6(:)=0.d0
     epspg6p(:)=0.d0
     epspc6(:)=0.d0
     epspc6p(:)=0.d0
     epspt600(:)=0.d0
     epspt60(:)=0.d0
     epspg600(:)=0.d0
     epspg60(:)=0.d0
     epspc600(:)=0.d0
     epspc60(:)=0.d0
     fa(:)=0.d0
     dpfa_ds(:,:)=0.d0
     dgfa_ds(:,:)=0.d0
     dpfa_dpg(:)=0.d0
     fg(:)=0.d0
     fglim(:)=0.d0
     dra_dl(:)=0.d0
     kveve66(:,:)=0.d0
     kvem66(:,:)=0.d0
     kmve66(:,:)=0.d0
     kmm66(:,:)=0.d0
     bve6(:)=0.d0
     bm6(:)=0.d0
     deltam=0.d0
     avean=0.d0
     epse06p(:)=0.d0
     epsk06p(:)=0.d0
     epsm06p(:)=0.d0
     dpg_depsa6(:)=0.d0
     dpg_depspg6(:)=0.d0
     depspt6(:)=0.d0
     depspg6(:)=0.d0
     depspc6(:)=0.d0
     depspt6p(:)=0.d0
     depspg6p(:)=0.d0
     depspc6p(:)=0.d0
     sigf6(:)=0.d0
     deps6r(:)=0.d0
     dphi=0.d0
     hydr=0.d0
     hyds=0.d0
     som1=0.d0
     som2=0.d0
     deps6r2(:)=0.d0
     phi00=0.d0
     hyd0=0.d0
     nrjm=0.d0
     sigke06(:)=0.d0
     sigke16(:)=0.d0
     poro2=0.d0
     poro1=0.d0
     dporo=0.d0
     sfld=0.d0
     pw=0.d0
     bw=0.d0
     mvgn=0.d0
     sigp=0.d0
     cwtauk=0.d0
     eprg00=0.d0
     gft00=0.d0
     gft=0.d0
     sigf6d(:)=0.d0
     t33(:,:)=0.d0
     krgi00=0.d0
     krgi=0.d0
     hplg=0.d0
     srw=0.d0
     dpfa_dr(:)=0.d0
     dsw6(:)=0.d0
     bw0=0.d0
     pw0=0.d0
     cc03(:)=0.d0
     cc13(:)=0.d0
     vcc33(:,:)=0.d0
     vcc33t(:,:)=0.d0
     vref33(:,:)=0.d0
     vref33t(:,:)=0.d0
     ccmax0=0.d0
     ccmax1=0.d0
     dfl00=0.d0
     dfl0=0.d0
     cmp0=0.d0
     cmp1=0.d0
     cwp=0.d0
     tetas=0.d0
     tetar=0.d0
     cwp0=0.d0
     cthp0=0.d0
     cthv0=0.d0
     dsw06(:)=0.d0
     dt3(:)=0.d0
     dr3(:)=0.d0
     dgt3(:)=0.d0
     dgc3(:)=0.d0
     dc=0.d0
     wl3(:)=0.d0
     xmt=0.d0
     dtr=0.d0
     vrgi0=0.d0
     taar=0.d0
     nrjg=0.d0
     srsrag=0.d0
     aar0=0.d0
     aar1=0.d0
     trag=0.d0
     vrag00=0.d0
     vdef00=0.d0
     def1=0.d0
     tdef=0.d0
     nrjd=0.d0
     def0=0.d0
     srsdef=0.d0  
     cna=0.d0
     nrjp=0.d0
     ttrd=0.d0
     tfid=0.d0
     ttdd=0.d0
     tdid=0.d0
     exmd=0.d0
     exnd=0.d0
     cnab=0.d0
     cnak=0.d0
     ssad=0.d0
     At=0.d0
     St=0.d0
     M1=0.d0
     E1=0.d0
     M2=0.d0
     E2=0.d0
     AtF=0.d0
     StF=0.d0
     M1F=0.d0
     E1F=0.d0
     M2F=0.d0
     E2F=0.d0
     epsk006(:)=0.d0
     epsm006(:)=0.d0
     depstt6(:)=0.d0
     deps6r3(:)=0.d0
     ett600(:)=0.d0
     ett60(:)=0.d0
     ett61(:)=0.d0
     wplt6(:)=0.d0
     wplt06(:)=0.d0
     wplt006(:)=0.d0
     wpltx6(:)=0.d0
     wpltx06(:)=0.d0
     wpltx006(:)=0.d0
     wpl3(:)=0.d0
     vwpl33(:,:)=0.d0
     vwpl33t(:,:)=0.d0
     wplx3(:)=0.d0
     vwplx33(:,:)=0.d0
     vwplx33t(:,:)=0.d0
     tauc=0.d0
     depleqc3=0.d0
     valr(:)=0.d0                 
     limit1=.false.
     ppas=.false.
     referm3(:)=.false.
     testtpi=.false.
     indic2=.false.
     logic1=.false.
     dtiso=.false.
     vali(:)=0
     ipla2=0
     i=0
     j=0
     k=0
     l=0
     npas1=0
     nt=0
     ifour=0
     nf0=0
     ipzero(:)=0
     errgauss=0
     na=0
     ig(:)=0
     ipla=0 
     err1=0
     irr=0
     nsupr=0
     nared=0
     supr(:)=0  
    
!***********************************************************************
!     initialisation de matrice identité
       do i=1,3
         do j=1,3
            if(i.eq.j) then
                 vref33(i,j)=1.d0
                 vref33t(i,j)=1.d0
            else
                 vref33(i,j)=0.d0
                 vref33t(i,j)=0.d0 
            end if
        end do
      end do        
         
!     chargement des parametres materiaux
!     l hydratation est considéree en fin de pas pour ne pas avoir
!     a recuperer celle du pas precedent  les exposants de De Shutter
!     sont  E   2/3  gf 1/2 rt 2/3 rc 1  ekfl 2/3  biot 1/2
!     hydratation 
      hydr=xmat(nbelas3d+1) 
!     stockage dans une variable interne pour avoir la vitesse
      if (abs(var0(64)-1.d0).ge.r8prem()) then
!       au 1er passage on suppose hyd0=hydr
        hyd0=hydr
!       on initialise var03d en cas de sous incrementation par fluage        
        var0(48)=hyd0
      else
        hyd0=var0(48)
      end if
      dhydr=hydr-hyd0
      varf(48)=hydr      
!     stockage hydratation initiale pour calcul final de pression
      hyd00=hyd0      
!     hydratation seuil
      hyds=xmat(nbelas3d+2) 
!     Module d young                            
      young00=xmat(1)    
!     coefficient de Poisson      
      nu00=xmat(2)    
!     resistances et pression limite     2/3 
      rt00=xmat(nbelas3d+3)
!     seuil pour la refermeture des fissures
      ref00=xmat(nbelas3d+4)
!     resistance en compression-par cisaillement
      rc00=xmat(nbelas3d+5) 
!     deformation de reference  pour le fluage prise aqu 1/3 de rc
      epser=(rc00/young00)/3.d0      
!     coeff drucker prager
      delta00=xmat(nbelas3d+6)      
!     coeff dilatance de cisaillement
      beta00=xmat(nbelas3d+7) 
!     verif validite de la dilatance
      xx1=dsqrt(3.d0)
      if(beta00.gt.xx1) then
        valr(1) = xx1
        call utmess('E', 'COMPOR3_23', nr=1, valr=valr)
        ierr1=1
        go to 999
      end if        
!     deformation au pic de traction      
      ept00=xmat(nbelas3d+8)      
!     taux d ecrouissage des phases effectives / RGI  
      hplg=xmat(nbelas3d+9)
!      if(hplg.le.0.d0) then
!         call utmess('E', 'COMPOR3_24')
!         ierr1=1
!         go to 999
!      end if       
!     vide accesible au gel      
      phivg=xmat(nbelas3d+10)
!     module biot gel matrice      
      mg=xmat(nbelas3d+11)
!     energie de fissuration en traction directe
      gft00=xmat(nbelas3d+12)
!     deformation caracteristique du potentiel de fluage      
      epsm00=xmat(nbelas3d+13)
!     raideur relative Kelvin / Young      
      psik=xmat(nbelas3d+14)
!     endommagement maximum par fluage      
      xflu=xmat(nbelas3d+15)
!     temps caracteristique pour Kelvin      
      tauk00=xmat(nbelas3d+16)
!     temps caracteristique pour Maxwell      
      taum00=xmat(nbelas3d+17)
!     volume forme par les rgi : vrgi
!     nrj activation du potentiel de fluage
      nrjm=xmat(nbelas3d+18)
!     endommagement thermique a 80°C
      dt80=xmat(nbelas3d+19)
!     donnees pour le calcul hydrique fin de pas
!     coeff de biot pour l eau
      biotw00=xmat(nbelas3d+20)
!     module de biot pour le non sature
      xnsat00=xmat(nbelas3d+21)
!     porosite      
      poro2=xmat(nbelas3d+22)
!     volume maximal de rgi
      vrag00=xmat(nbelas3d+23)
!     volume d eau pour le non sature
      vw2=xmat(nbelas3d+24)
!     initialisation des variables internes associee a la saturation si premier pas
      if (abs(var0(64)-1.d0).ge.r8prem()) then
         var0(58)=vw2
         var0(59)=poro2
      end if
!     calcul de la vitesse de saturation moyenne
      if (fl3d) then
          vsrw=(vw2-var0(58))/(0.5d0*(poro2+var0(59))) 
      end if        
!     contrainte caracteristique pour l endo capillaire
      sfld=xmat(nbelas3d+25)
!     exposant de Van Genuchten pour la pression capillaire
      mvgn=xmat(nbelas3d+26)
!     deformation au pic de compression
      epc0=xmat(nbelas3d+27)
!     verif coherence deformation pic de compression 
      epc1=rc00/young00
!     eps pic comp ne peut pas etre inferieur à rc/E      
      epc00=dmax1(epc0,epc1)
!     deformation plastique au pic de compression      
      epp1=epc00-epc1
!     deformation cracateristique endo de compression
      ekdc=xmat(nbelas3d+28)
!     deformation caracteristique pour l endo de rgi
      eprg00=xmat(nbelas3d+29) 
!     deformation caracteristique pour l endo de traction
      gfr=xmat(nbelas3d+30)    
!     coeff de biot pour les RGI
      brgi00=xmat(nbelas3d+31)
!     coeff de concentration de contrainte des RGI
      krgi00=xmat(nbelas3d+32)      
!     chargement des tailles si l endo est active
      ierr1=0
!     verif des conditions de couplage rgi-traction
      xk00=young00/3.d0/(1.d0-2.d0*nu00)
      xm00=young00/2.d0/(1.d0+nu00)
      xlim00=xk00+(4.d0/3.d0)*xm00
      xb1mg00=brgi00*mg
      if(xb1mg00.gt.xlim00) then
!        une deformation rgi est favorable au critere de traction  
         valr(1) = xb1mg00
         valr(2) = xlim00
         call utmess('E', 'COMPOR3_25', nr=2, valr=valr)
         ierr1=1     
         go to 999 
      end if 
!     temperature de reference des parametres de fluage (celsius)      
      tetar=xmat(nbelas3d+33)       
!     temperature seuil pour l endo thermique (celsisu)      
      tetas=xmat(nbelas3d+34) 
!     endommagement maximum par fluage
      dfmx=xmat(nbelas3d+35)
!     tempas caracterisqtique de la rgi à tref      
      taar=xmat(nbelas3d+36)
!     nrj d'activation de la rgi
      nrjg=xmat(nbelas3d+37)
!     seuil de saturation minimal pour avoir la rgi
      srsrag=xmat(nbelas3d+38) 
!     temperature de reference des parametres de RAG (celsius)  
      trag=xmat(nbelas3d+39)    
!     dimension 3 en 2D
      dim3=xmat(nbelas3d+40)
!     temps cracteristique pour la def      
      tdef=xmat(nbelas3d+41)
!     energie d activation de precipitation de la def
      nrjp=xmat(nbelas3d+42)
!     seuil de saturation pour declancher la def
      srsdef=xmat(nbelas3d+43)
!     quantite maximale de def pouvant etre realise      
      vdef00=xmat(nbelas3d+44)
!     teneur en alcalin pour la def
      cna=xmat(nbelas3d+45)
!     rapport molaire S03 / Al2O3 du ciment      
      ssad=xmat(nbelas3d+46) 
!     concentration caracteristique pour les lois de couplage de la def      
      cnak=xmat(nbelas3d+47)
!     concetration en alcalin de blocage de la def      
      cnab=xmat(nbelas3d+48)
!     exposant de la loi de couplage temperature de dissolution alcalins      
      exnd=xmat(nbelas3d+49)
!     exposant de la loi de couplage precipitation def alcalins     
      exmd=xmat(nbelas3d+50)
!     temperature de reference pour la dissolution de la def
      ttdd=xmat(nbelas3d+51)
!     temps caracteristique pour la dissolution de l ettringite primaire
      tdid=xmat(nbelas3d+52) 
!     temps caracteristique pour la fixation des aluminiums en temperature
      tfid=xmat(nbelas3d+53)
!     energie d activation des processus de dissolution des phases primaires
      nrjd=xmat(nbelas3d+54) 
!     temperature de reference pour la precipitation de la def
      ttrd=xmat(nbelas3d+55)
!       on peut traiter le endommagement pre pic iso de traction
!       si ept > Rt/E
        ept00=dmax1(rt00/young00,ept00)
     
!***********************************************************************      
!     indicateur de premier passage pour hydracomp3d
      if (abs(var0(64)-1.d0).ge.r8prem()) then
         ppas=.true.
      else
         ppas=.false.
      end if         
  
!***********************************************************************
!     chargement de l increment de deformation imposee
      do i=1,nstrs
        deps6(i)=deps(i)
      end do
      if(nstrs.lt.6) then
        do i=nstrs+1,6
          deps6(i)=0.d0
        end do
      end if     

!***********************************************************************      

!     remarque si rt rtg ref et rc dependent de  l ecrouissage
!     il faut les actualiser en fonction de l ecrouissage avant de
!     de passer dans hydramat, il faut egalement que dra_dl soit 
!     parfaitement compatible avec le recalcul en fonction des deformations
!     plastiques (ou bien rajouter des vari pour stocker les resistances)
      rc1=rc00
!     l hydratation n a pas d influence sur la deofrmation plastique
!     caracteristique de cisaillement      
      rt1=rt00
      ept1=ept00
      ref1=ref00
      
!     parametres materiau dependant eventuellement de l hydratation et
!     de l endo de fluage
!     pour le 1er passage la reduction des resistances par fluage est
!     negligee car non utilise pour le tir visco elastique
      call hydramat3d(hyd0,hydr,hyds,young00,young,nu00,nu,rt1,rt,ref1,&
      ref,rc1,rc,delta00,delta,beta00,beta,gft00,gft,ept1,ept,pglim,&
      epsm00,epsm11,xnsat00,xnsat,biotw00,biotw,brgi00,brgi,krgi00,&
      krgi,iso,lambda,mu,rt33,rtg33,ref33,raideur66,souplesse66,xmt,&
      dtiso,err1)     
     
!***********************************************************************
!      influence de la temperature sur les parametres  materiau et
!      actualisation de l endo thermique initial 
       dth00=var0(49)    
       call thermat3d(teta1,nrjm,tetas,tetar,DT80,dth00,&
         dth0,CTHp0,CTHv0)
!      endommagement thermique en fin de pas     
       call thermat3d(teta2,nrjm,tetas,tetar,DT80,dth0,&
         dth1,CTHp1,CTHv1)
       varf(49)=dth1     
     
!***********************************************************************        
!        chargement des variables internes du fluage 
!        (etat du squelette solide)
         do i=1,6
            epsk006(i)=var0(i+6)
            epsm006(i)=var0(i+12)
            sig06(i)=var0(i+18)
            sigke06(i)=var0(i+49)
            dsw06(i)=var0(73+i)             
         end do
!        dissipation visqueuse         
         phi00=var0(25)  
!        endommagement effectif par fluage
         dfl00=var0(27)        
!        endommagement thermique         
         dth00=var0(49)                 
!        deformation plastique equivallente         
         epleqc00=var0(67)
!        pression capillaire          
         bw0=var0(66)
         pw0=var0(56)
!        pression RGI         
         bg0=var0(65)
         pg0=var0(61)         
!        tenseurs de deformations plastique et surpression capillaire        
         do j=1,6        
              epspt600(j)=var0(29+j)
              epspg600(j)=var0(35+j)             
              epspc600(j)=var0(41+j)    
              ett600(j)=var0(96+j) 
!             14mai2015              
              wplt006(j)=var0(102+j)
              wpltx006(j)=var0(67+j)             
         end do
         
      
!***********************************************************************         
!        influence du degre d hydratation sur les variables internes         
         call hydravar3d(hyd0,hydr,hyds,phi00,phi0,dth00,dth0,&
        epleqc00,epleqc0,epspt600,epspt60,&
        epspg600,epspg60,epspc600,epspc60,epsk006,epsk06,&
        epsm006,epsm06,dfl00,dfl0,ett600,ett60,wplt006,wplt06,&
        wpltx006,wpltx06)

!***********************************************************************
!        calcul de la pression capillaire due a leau en fin de pas
         if (fl3d) then
             call bwpw3d(mfr,biotw,poro2,vw2,xnsat,mvgn,pw,bw,srw)
             varf(56)=pw
             varf(66)=bw
!            modif eventuelle des viscosites en fonction de srw         
             CWtauk1=1.d0/srw
             varf(57)=CWtauk1
         end if
         
!*********************************************************************** 
!        reevaluation de la deformation compatible avec l etat
!        de contrainte debut de pas(pour evaluer la sous incrementation)  
         call hydracomp3d(we0,we0s,epse06,souplesse66,sig06,deps6,&
                          deps6r,sigke06,epsk06,psik,fl3d)

!***********************************************************************
!        reevaluation des coeffs de consolidation en debut de pas
         if (fl3d) then
!           effet de l eau          
            CWp0=var0(58)/var0(59)
            CWtauk0=var0(59)/var0(58)                         
!           effet l endo de fluage sur le potentiel de fluage           
            call dflufin3d(sig06,bw0,pw0,bg0,pg0,dsw06,delta,rc,&
                           xflu,dfin0,CMp0,dfmx)
!           effet de la temperature sur le potentiel         
            call conso3d(epsm11,epser,ccmin0,ccmax0,epsm06,&
                         epse06,cc03,vcc33,vcc33t,CWp0,CMp0,CthP0,Cthv0)
         end if

!***********************************************************************     
!       determination de la subdivision eventuelle du pas de temps
        if (fl3d) then 
         dtmaxi=dt
         do i=1,6
!            extremes de epsk         
             epsklim1=epse06(i)/psik
             epsklim2=(epse06(i)+deps6r(i))/psik
!            valeur maximale possible de l increment de deformation de kelvin            
             if(dabs(epsklim1).gt.dabs(epsklim2))  then
                 epsklim=epsklim1
             else
                 epsklim=epsklim2
             end if
!            cas ou epsklim est faible             
             if(epsklim.gt. 1.d-6) then
                 denom=dabs(1.d0-epsk06(i)/epsklim)
             else if (epsklim.lt. -1.d-6) then
                 denom=dabs(1.d0-epsk06(i)/epsklim)
             else 
                 denom=dabs(1.d0-epsk06(i)/1.d-6)
             end if
!            comparaison avec la valeur permettant de franchir dt en 1/heta pas 
             cwtaukm=(CWtauk0+cwtauk1)/2.d0
             cthvm=(cthv0+cthv1)/2.d0             
             if(abs(dt).ge.r8prem()) then
                 denomin=heta*tauk00*CWtaukm/CTHVm/dt
             else
                 denomin=1.d0
             end if
!            comparaison avec les autres composantes de deformation             
             if(denom.le.denomin) then
                denom=denomin
             end if
             dtmaxik=tauk00*CWtaukm/CTHVm/denom
!            cas de la deformation de maxwell             
             dtmaxim=heta*(taum00*ccmin0)
!            choix entre condition maxwell et kelvin             
             dtmaxi=dmin1(dtmaxi,dtmaxim,dtmaxik)
        end do
!       *** subdivision du pas si necessaire  **************************      
        if (dtmaxi.lt.dt) then
            xpas1=dt/dtmaxi
            npas1=int(xpas1)+1
        else
            npas1=1
        end if
       else
!        pas de fluage       
         npas1=1
       end if
!      coeff de reduction de l increment        
       reduc1=1.d0/dble(npas1)
!      reduction des pas d hydratation        
       dhydr=reduc1*(hydr-hyd0)
!      pas de temps reduit        
       dt1=dt*reduc1
!      increment de temperature reduit
       dteta=(teta2-teta1)*reduc1
!      initialisation de la temperature debut de pas        
       teta=teta1
!      increment de volume d eau reduit
       vw1=var0(58)
       dvw=(vw2-vw1)*reduc1    
!      increment de poro capillaire reduite
       poro1=var0(59)
       dporo=(poro2-poro1)*reduc1  
!      increment des potentiels de rgi
       vrgi1=var0(60)
       dvrgi=(vrgi2-vrgi1)*reduc1         
!      increments de deformations reduits, on reduit deps6 et non deps6r
!      car hydracomp est reapplique plus bas        
       if(npas1.ne.1) then
            do i=1,6
                 deps6r(i)=reduc1*deps6(i)
            end do
       else
            do i=1,6
                 deps6r(i)=deps6(i)
            end do
       end if

!***********************************************************************        
!*********************************************************************** 
!       debut du chargement sous-discretise sur le pas de temps
!***********************************************************************
!***********************************************************************
        do nt=1,npas1
!        chargement des variables internes          
         do i=1,6
            epsk006(i)=var0(i+6)
            epsm006(i)=var0(i+12)
            sig06(i)=var0(i+18)
            sigke06(i)=var0(i+49)
            dsw06(i)=var0(73+i) 
         end do
!        pression capillaire          
         bw0=var0(66)
         pw0=var0(56)
!        pression RGI         
         bg0=var0(65)
         pg0=var0(61)         
!        dissipation visqueuse
         phi00=var0(25)
!        recuperation de l endo thermique
         dth00=var0(49)
!        actualisation du degre d hydratation         
         hyd0=var0(48) 
         hydr=hyd0+dhydr        
         varf(48)=hydr
!        actualisation de la temperature
         teta=teta+dteta 
!        actualisation volume deau capillaire
         vw=var0(58)
         vw=vw+dvw
         varf(58)=vw
!        actualisation de la porosite capillaire
         poro=var0(59)
         poro=poro+dporo
         varf(59)=poro          
!        actualisation du volume pour les rgi
         vrgi00=var0(60)
         vrgi00=vrgi00+dvrgi
         varf(60)=vrgi00
!        recuperation de la deformation plastique equivalente de cisaillement
         epleqc00=var0(67)
!        recuperation de la deformation maximale de traction
         do j=1,6         
          epspt600(j)=var0(29+j)
          epspg600(j)=var0(35+j)             
          epspc600(j)=var0(41+j) 
          ett600(j)=var0(96+j)  
          wplt006(j)=var0(102+j)
          wpltx006(j)=var0(67+j)           
         end do
!        recuperation de l endommagement par fluage
         dfl00=var0(27)
!        recuperation de l endommagement thermique
         dth00=var0(49)         

!        prise en compte  hydratation intermediaire si sous-increment                
         call hydravar3d(hyd0,hydr,hyds,phi00,phi0,dth00,dth0,&
        epleqc00,epleqc0,epspt600,epspt60,&
        epspg600,epspg60,epspc600,epspc60,epsk006,epsk06,&
        epsm006,epsm06,dfl00,dfl0,ett600,ett60,wplt006,wplt06,&
        wpltx006,wpltx06)
     
!        stockage de la valeur de la deformation plastique cumulee 
!        modifiee par l hydratation pour mise a jour incrementale
         epleqc01=epleqc0
!        effet de l endommagement de fluage et de l'hydratation sur les
!        parametres materiau         
         call hydramat3d(hyd0,hydr,hyds,young00,young,nu00,nu,rt1,&
        rt,ref1,ref,rc1,rc,delta00,delta,beta00,beta,gft00,&
        gft,ept1,ept,pglim,epsm00,epsm11,xnsat00,xnsat,biotw00,biotw,&
        brgi00,brgi,krgi00,krgi,iso,lambda,mu,rt33,rtg33,ref33,&
        raideur66,souplesse66,xmt,dtiso,err1)

!        influence de la temperature sur les parametres du materiau
!        et calcul de l endommagement thermique
         call thermat3d(teta,nrjm,tetas,tetar,DT80,dth1,DTHER,CTHP,CTHV)
         varf(49)=dth1

!        calcul de la pression capillaire due a leau
         if (fl3d) then
             call bwpw3d(mfr,biotw,poro,vw,xnsat,mvgn,pw,bw,srw)
             varf(56)=pw
             varf(66)=bw         
!        reevaluation des coeffs de consolidation apres increment hydra
!        effet de l eau sur le potentiel de fluage         
             Cwp=Srw           
             CWtauk=1.d0/srw
             varf(57)=CWtauk         
         
!        Modification eventuelle de la viscosite en fonction de Srw         
             tauk1=tauk00*CWtauk/CTHV
         
!        la modif de la viscosite de Maxwell est comprise dans le coeff
!        de consolidation (cf. conso3d)         
             taum1=taum00      
         end if

!        compatibilite des anciennes contraintes avec nouveau materiau
!        deduction de la deformation de solidification de l increment     
         call hydracomp3d(we0,we0s,epse06,souplesse66,sig06,deps6r,&
                          deps6r2,sigke06,epsk06,psik,fl3d)

       
!        coeff theta methode pour tir visco elastique
         theta1=theta 
!***********************************************************************
!        tir visco elastique
!***********************************************************************
 
         if(fl3d) then
         
!            effet du chargement sur le potentiel de fluage           
             call dflufin3d(sig06,bw0,pw0,bg0,pg0,dsw06,delta,rc,&
                            xflu,dfin0,CMp0,dfmx)      
             
!            actualisation coeffs de consolidation             
             call conso3d(epsm11,epser,ccmin0,ccmax0,epsm06,&
                          epse06,cc03,vcc33,vcc33t,CWp,CMp0,CthP,Cthv) 
     
!            prise en compte de la deformation thermique transitoire
             do i=1,6
               varf(96+i)=ett61(i)
               deps6r3(i)=deps6r2(i)-depstt6(i)
             end do
     
!            construction des matrices de couplage ds base fixe         
             call matfluag3d(epse06,epsk06,sig06,&
            psik,tauk1,taum1,&
            deps6r2,dt1,theta1,kveve66,kvem66,kmve66,&
            kmm66,bve6,bm6,deltam,avean,&
            cc03,vcc33,vcc33t,vref33,vref33t)
     
!            assemblage des matrices de couplage de fluage ds base fixe     
             call couplagf3d(A,B,ngf,kveve66,kmm66,&
                             kmve66,kvem66,bve6,bm6)
      
!            resolution du tir visco elastique
             call gauss3d(12,A,X,B,ngf,errgauss,ipzero)
             if(errgauss.eq.1) then
                 ierr1=1
                 call utmess('E', 'COMPOR3_26')
                 go to 999
             end if
         else
!           actualisation pas de deformation pour deps therm transitoire
!           prise en compte de la deformation thermique transitoire
            do i=1,3
                 cc03(i)=1.d0
                 do j=1,3
                    if(i.eq.j) then
                        vcc33(i,j)=1.d0
                        vcc33t(i,j)=1.d0
                    else
                        vcc33(i,j)=0.d0
                        vcc33t(i,j)=0.d0
                    end if
                end do
            end do
!            prise en compte de la deformation thermique transitoire
             do i=1,6
               varf(96+i)=ett61(i)
               deps6r3(i)=deps6r2(i)-depstt6(i)
             end do    
    
!           tir elastique
            x(:)=0.d0
         end if
      
!        recuperation des increments et affectation
         do i=1,6
!           increment deformation kelvin         
            depsk6(i)=x(i)
            epsk16(i)=epsk06(i)+depsk6(i) 
!           ipla deformation maxwell            
            depsm6(i)=x(i+6)
            epsm16(i)=epsm06(i)+depsm6(i)
!           increment deformation elastique            
            depse6(i)=deps6r3(i)-depsm6(i)-depsk6(i)
            epse16(i)=epse06(i)+depse6(i)
         end do
         
!        etat du materiau apres tir visco elastique
         phi1=phi0
         we1=0.d0 
         do i=1,6
             sig16(i)=sig06(i)
             sigke16(i)=sigke06(i)
             do j=1,6
                 sig16(i)=sig16(i)+raideur66(i,j)*depse6(j)
                 sigke16(i)=sigke16(i)+raideur66(i,j)*depsk6(j)*psik
             end do
!            actualisation de la dissipation visqueuse
             dphi=0.5d0*(sig06(i)+sig16(i))*(epsm16(i)-epsm06(i))
             if(dphi.lt.0.d0) then
                 logic1=.true.
             else
                 logic1=.false.
             end if
             phi1=phi1+dphi
!            actualisation du potentiel elastique             
             we1=we1+0.5d0*(sig16(i)*epse16(i))
        end do

!       actualisation de la variation de volume total
        treps=var0(28)
        do i=1,3
           treps=treps+deps6r(i)
        end do        
        varf(28)=treps 

!       chargement des deformations plastiques du pas precedent
!       actualisee par l hydratation
        do j=1,6
!         traction
          epspt6(j)=epspt60(j)
!         rgi
          epspg6(j)=epspg60(j)   
!         compression           
          epspc6(j)=epspc60(j) 
!         chargement des ouvertures de fissures du pas precedent 
          wplt6(j)=wplt06(j)
!         caharegement des ouvertures maxi de fissure          
          wpltx6(j)=wpltx06(j)
!         fin14mai2015:          
        end do        
!       chargement de la def equivalente actualisee par l hydratation        
        epleqc=epleqc0
             
!       recuperation de la variation volumique due a la rgi non 
!       actualisee par l hydratation
        trepspg=var0(29)
        
!***********************************************************************
!       verification des criteres de plasticite et ecoulements
!***********************************************************************
           
!       initialisation du compteur sur la boucle de coherence plastique
        ipla=0
!       initialisation du compteur sur la boucle de retour radial        
        irr=0 
!       initialisation indicateur reduction nbre de criteres actifs
        indic2=.false.  
        
!       *** actualisation du compteur de boucle elasto plastique *******        
  
10 continue
   if(ipla.lt.4) then
   ipla=ipla+1
!       compteur reduction du systeme de couplage
        ipla2=0
!       nombre de lignes a supprimer dans le couplage        
        nsupr=0
!       nbr itermax atteint        
        if(ipla.gt.200) then
            vali(1) = ipla
            call utmess('A', 'COMPOR3_27', ni=1, vali=vali)
        end if  
!       reevaluation de la pression capillaire due a l eau si plasticite
        if (fl3d) then
            call bwpw3d(mfr,biotw,poro,vw,xnsat,mvgn,pw,bw,srw)
            varf(56)=pw
            varf(66)=bw
        end if

!       reevaluation de la pression de rgi si plasticite 
!       vrgi volume effectivement formee pour ce pas
        aar0=var0(62)
        def0=var0(63)
        E1=var0(97)
        M1=var0(98)
        E2=var0(99)
        M2=var0(100)
        At=var0(101)
        St=var0(102)
        vrgi0=var0(60)
!       l avancement est actualisee dans bgpg        
        call bgpg3d(ppas,bg,pg,mg,vrgi,treps,trepspg,epspt6,epspc6,&
        phivg,pglim,brgi,dpg_depsa6,dpg_depspg6,taar,nrjg,tetar,aar0,&
        srw,srsrag,teta,dt1,vrag00,aar1,tdef,nrjd,def0,srsdef,vdef00,&
        def1,cna,nrjp,ttrd,tfid,ttdd,tdid,exmd,exnd,cnab,cnak,ssad,&
        At,St,M1,E1,M2,E2,AtF,StF,M1F,E1F,M2F,E2F,vrgi0)
!       stockage avancement et pression     
        varf(62)=aar1
        varf(63)=def1
        varf(60)=vrgi
        varf(61)=pg
        varf(65)=bg
        varf(97)=E1f
        varf(98)=M1f
        varf(99)=E2f
        varf(100)=M2f
        varf(101)=Atf
        varf(102)=Stf  

!       prise en compte de l'amplification des depressions capillaires
!       sous charge (l effet du chargement sur la pression capillaire
!       est traité explicitement via sig0) 
        do i=1,6
            dsw6(i)=var0(73+i)
        end do       
        bw0=var0(66)
        pw0=var0(56)
        call fludes3d(bw0,pw0,bw,pw,sfld,sig0,dsw6,nstrs)
        do i=1,6
            varf(73+i)=dsw6(i)
        end do        
          
!       possibilite ecoulement plastique couplé au fluage
!       les criteres de Rankine etant definis dans la base principale
!       des contraintes, on se place dans cette base pour la verification
!       des criteres et le retour radial le cas echeant

!       diagonalisation du vecteur des contraintes si 1er passage dans criter3d (irr=0)
        call x6x33(sig16,sig133)         
!       call valp3d(sig133,sig13,vsig133)
        call b3d_valp33(sig133,sig13,vsig133)
!       construction matrice de passage inverse         
        call transpos1(vsig133t,vsig133,3) 

!       si irr.ne.0 on est dans la boucle de sous iteration radiale
!       on garde la base du tir elastique pour le retour        
!       notation pseudo vecteur pour ecoulement plastique 
!       en base principale (en raison des criteres de rankine)
        call chrep6(sig16,vsig133,.false._1,sig16p)

!       passage de la loi de comportement dans la base principale
!       des contraintes
        if(iso) then 
!          cas isotrope : rien a faire
           do k=1,6
             do l=1,6
                raideur66p(k,l)=raideur66(k,l)
                souplesse66p(k,l)=souplesse66(k,l)
             end do
           end do 
        else
!          cas elasticite anisotrope : passge de la loi de comportement
!          en base principale des contraintes necessaire 
           ierr1=1       
           call utmess('F', 'COMPOR3_28')
        end if 

!       passage des resistances et contraintes de refermeture
!       dans la base principale des contraintes
        if(iso) then
!         cas isotrope : rien a faire
          do k=1,3
            do l=1,3
                rt33p(k,l)=rt33(k,l)
                rtg33p(k,l)=rtg33(k,l)
                ref33p(k,l)=ref33(k,l)
            end do
          end do
        else
!         cas anisotrope : changement de base des resistance normales
           call utmess('E', 'COMPOR3_29')
          read*
          ierr1=1
        end if 
        
!       passage des deformations plastiques de traction
!       dans la base principale du tir visco elastique
        call chrep6(epspt6,vsig133,.true._1,epspt6p)
!       passage des deformations plastiques de gel
        call chrep6(epspg6,vsig133,.true._1,epspg6p)
!       passage des deformations plastiques de cisaillement
        call chrep6(epspc6,vsig133,.true._1,epspc6p)       
!       initialisation des increments de deformations
        do j=1,6
             depspt6p(j)=0.d0
             depspg6p(j)=0.d0
             depspc6p(j)=0.d0 
        end do  

!       evaluation des criteres actifs, des derivees et des directions
!       d ecoulement dans la base principale des contraintes
        call criter3d(sig16p,bg,pg,bw,pw,rt33p,rtg33p,ref33p,rc,epc00,&
       epleqc,epspt6p,epspg6p,delta,beta,nc,ig,&
       fg,na,fa,dpfa_ds,dgfa_ds,dpfa_dpg,dra_dl,souplesse66p,err1,&
       depleqc_dl,irr,fglim,krgi,&
       hpla,ekdc,hplg,dpfa_dr,tauc,epeqpc)   
!       stockage taux de cisaillement
!         varf(109)=tauc     

!       reinitalisation de l indicateur de reduction du nbr de critere
        indic2=.false.
        
!       detection d erreur dans les criteres     
        if(err1.eq.1) then
             ierr1=1
             go to 999
        end if
        

!       ****************************************************************
!       controle de la boucle de consitance visco elasto plastique
!       ****************************************************************

!       retour par ecoulement visco-plasticité couplée si au moins
!       un critere est actifs

        if(na.ne.0) then
        
!         *** ecoulement plastique *************************************

!         reconstruction de la matrice de couplage fluage->fluage 
!         dans la base principale actuelle 
          if (fl3d) then 
             call chrep6(epse16,vsig133,.true._1,epse06p)          
             call chrep6(epsk16,vsig133,.true._1,epsk06p)
             call chrep6(epsm16,vsig133,.true._1,epsm06p)
          end if
          
!         pas d increments de deformation pendant la boucle de consistance          
          do i=1,6
            deps6r3(i)=0.d0
          end do
          
!         ****** couplages ds nouvelle base ****************************

          theta1=theta   
          if (fl3d) then
!            actualisation de la matrice de couplage visco plastique

!            effet du chargement sur le potentiel de fluage
!            la surpression hydrique est celle de debit de pas
!            si elle utilise la contrainte totale convergee           
             call dflufin3d(sig16,bw,pw,bg,pg,dsw6,delta,rc,&
                            xflu,dfin1,CMp1,dfmx)          
             
!            actualisation coeffs de consolidation             
             call conso3d(epsm11,epser,ccmin1,ccmax1,epsm16,&
                          epse16,cc13,vcc33,vcc33t,CWp,CMp1,CthP,Cthv)
     
             call matfluag3d(epse06p,epsk06p,sig16p,&
            psik,tauk1,taum1,deps6r3,&
            dt1,theta1,kveve66,kvem66,kmve66,kmm66,bve6,bm6,deltam,&
            avean,cc13,vcc33,vcc33t,vsig133,vsig133t)
     
!            mise a zero des seconds membres de fluage pour le retour radial
             do i=1,6
                 bve6(i)=0.d0
                 bm6(i)=0.d0
             end do
             
!            reinitialisation et reassembalge de 
!            la matrice de couplage : a

!            ****  cas du couplage fluage fluage *********************** 
        
             call couplagf3d(A,B,ngf,kveve66,kmm66,&
                             kmve66,kvem66,bve6,bm6)
     
!            ************* couplage avec la plasticite *****************
     
!            complement de la matrice de couplage pour la plasticite     
!            autres couplages : plasticite -> fluage
             do i=1,6 
                 do j=1,na
!                   couplage plasticite ->  kelvin           
                    a(i,12+j)=avean*dgfa_ds(j,i)
!                   couplage plasticite -> maxwell
!                   attention kmve66 doit être dans la bonne base... 
                    a(i+6,12+j)=dgfa_ds(j,i)*(deltam+kmve66(i,i))
                    do k=1,6
                      if (k.ne.i) then
                        a(i+6,12+j)=a(i+6,12+j)+dgfa_ds(j,k)*kmve66(i,k)
                      end if
                    end do
                 end do
!                mise a zero des seconds membre de fluage (deja fait normalement)
                 b(i)=0.d0
                 b(i+6)=0.d0            
             end do
             
!            **** couplage  fluage -> plasticite ***********************

             do i=1,na          
                do j=1,6
!                couplage kelvin -> plasticite
                 a(12+i,j)=0.d0
                 do k=1,6
                     a(12+i,j)=a(12+i,j)-dpfa_ds(i,k)*raideur66p(k,j)                
                 end do
!                ici les deformation anelastique sont du fluage donc
!                on prend dpg_depsa6 du cas general                
                 a(12+i,j)=a(12+i,j)+dpfa_dpg(i)*dpg_depsa6(j)              
!                couplage maxwell -> plasticite
                 a(12+i,j+6)=a(12+i,j)              
                end do
             end do
          end if
          
!         *** couplage plasticite -> plasticite ************************

          if(fl3d) then
             nf0=12
          else
             nf0=0
          end if
          do i=1,na
            do j=1,na
                som2=0.d0                
                do k=1,6
!                   influence des autres deformations plastiques                
                    som1=0.d0
                    do l=1,6
                      som1=som1-raideur66p(k,l)*dgfa_ds(j,l)
                    end do
                    som2=som2+dpfa_ds(i,k)*som1
!                   influence de la pression intra poreuse                    
                    if((ig(j).ge.7).and.(ig(j).le.9)) then
                      som2=som2+dpfa_dpg(i)*dpg_depspg6(k)*dgfa_ds(j,k)
                    else
                      som2=som2+dpfa_dpg(i)*dpg_depsa6(k)*dgfa_ds(j,k)
                    end if
                end do
                a(nf0+i,nf0+j)=som2
                if(i.eq.j) then
!                  prise en compte de l ecrouissage (dra_dl derivve de 
!                  la resistance par rapport au multiplicateur plastique)
                   a(nf0+i,nf0+j)=a(nf0+i,nf0+j)+dpfa_dr(i)*dra_dl(i)                    
                end if                   
            end do              
          end do
!         second membre de la plasticite : oppose des criteres actifs
          do i=1,na
            b(nf0+i)=-fa(i)
          end do
          
!         *** resolution du retour radial ******************************

20        continue
          call gauss3d((nf0+na),A,X,B,ngf,errgauss,ipzero)
          if(errgauss.eq.1) then
              call utmess('E', 'COMPOR3_30')
              ierr1=1
              go to 999
          end if
          
!         **** verif positivite des multiplicateurs plastiques *********     
          if(na.ne.0) then
            testtpi=.true.
!           initialisation du compteur de nbre de lignes a supprimer            
            nsupr=0             
            do i=(nf0+1),(nf0+na)
!             test positivite des multiplicateurs         
              if((x(i).lt.0.d0).and.(irr.eq.0)) then
!               actualisation des numero de ligne a supprimer
!               pour la mise a zero des multiplicateurs negatifs                
                nsupr=nsupr+1
                supr(nsupr)=i
              end if
            end do
            if(nsupr.gt.0) then
!             indicateur de reduction matrice de couplage
              indic2=.true.               
!             compteur reduction              
              ipla2=ipla2+1
              if(ipla2.le.imax) then
                nared=na
!               reduction du systeme lineaire des couplages
!               on remonte toute les lignes au dessous de celles supprimees
                do i=1,nsupr
!                 decallage vers le haut des lignes du dessous
                  do j=supr(i),nf0+(nared-1)
                    ig(j-nf0)=ig(j-nf0+1)
!                   on boucle sur les colonnes                    
                    do k=1,nf0+nared
                       a(j,k)=a(j+1,k)
                    end do
!                   pareil au second membre  
                    b(j)=b(j+1)
                  end do
!                 decalage des colonnes vers la gauche
                  do j=supr(i),nf0+(nared-1)
                    do k=1,nf0+(nared-1)
                       a(k,j)=a(k,j+1)
                    end do
                  end do 
!                 decalage des derives des fonctions de charge
                  do j=supr(i)-nf0,nf0+(nared-1)-nf0
                    do k=1,6
                       dgfa_ds(j,k)=dgfa_ds(j+1,k)
                    end do
                  end do                   
!                 mise a jour de la taille de la matrice
                  nared=nared-1
!                 mise a jour des numeros de lignes a supprimer 
                  do j=i,nsupr
!                   comme on vient d eliminer une ligne
!                   les lignes restantes sont remontees de 1                  
                    supr(j)=supr(j)-1
                  end do                 
                end do
!               resolution du systeme reduit
                na=nared
                goto 20
              else
                vali(1) = ipla
                call utmess('E', 'COMPOR3_31', ni=1, vali=vali)
                ierr1=1
                go to 999
              end if
            end if               
          end if

!         *** mise a jour des variables dependantes de la plasticite ***
          
!         initialisation de la deformation equivalente de compression
          depleqc=0.d0
!         bouclage sur les criteres possibles
          do j=1,3 
             referm3(j)=.false.
          end do  
          do i=1,na
            do j=1,6              
                if (ig(i).le.6) then   
!                    cas des deformations plastiques de traction 
                     depspt6p(j)=depspt6p(j)+x(nf0+i)*dgfa_ds(i,j)
                     if(ig(i).gt.3) then
!                         indicateur de refermeture active                     
                          referm3(ig(i)-3)=.true.
                     end if
                else if (ig(i).le.9) then
!                   cas des deformations plastiques de gel
                    depspg6p(j)=depspg6p(j)+x(nf0+i)*dgfa_ds(i,j)
                else if (ig(i).le.10) then
!                   cas des deformations plastiques de DP
                    depspc6p(j)=depspc6p(j)+x(nf0+i)*dgfa_ds(i,j)
                else
                    call utmess('E', 'COMPOR3_32')
                    ierr1=1
                    read*
                end if
            end do
            if(ig(i).eq.10) then
!                actualisation de la deformation equivalente de compression
                 depleqc=depleqc_dl*x(nf0+i)
!                si non actif : deja actualise a la valeur init avant la boucle             
            end if            
          end do
          
!         *** limitation des refermetures si necessaire ****************
!         indicateur d'au moins une refermeture forcée
          limit1=.false.
!         déformation minimale admissible          
          epsmin=0.d0
!         test des refermetures          
          do j=1,3
             if(((epspt6p(j)+depspt6p(j)).lt.epsmin).and.referm3(j))&
                 then
                  depspt6p(j)=epsmin-epspt6p(j)
                  limit1=.true.
                  do i=1,6
                     depsk6p(i)=0.d0
                     depsm6p(i)=0.d0
                     if(i.ne.j) then
                         depspt6p(i)=0.d0
                     end if                    
                     depspg6p(i)=0.d0
                     depspc6p(i)=0.d0
                 end do
!                on utilise pas les autres multiplicateurs
!                car la refermeture a été forcée dans une direction                
                 goto 50                 
             end if
          end do

!         recuperation des increments dans la pase principale
!         cas du fluage
          if(fl3d) then
             do i=1,6
!               increment deformation kelvin         
                depsk6p(i)=x(i)
!               increment deformation maxwell            
                depsm6p(i)=x(i+6)
             end do 
          else
             do i=1,6
!               increment deformation kelvin         
                depsk6p(i)=0.d0
!               increment deformation maxwell            
                depsm6p(i)=0.d0
             end do
          end if  
          
!         *** increment deformation elastique en base principale *******
50        continue
          do i=1,6           
            depse6p(i)=-depsm6p(i)-depsk6p(i)&
           -depspt6p(i)-depspg6p(i)-depspc6p(i)
          end do
               
!         *** retour des increments de deformation dans la base fixe ***
!         plasticite traction          
          call chrep6(depspt6p,vsig133t,.true._1,depspt6) 
!         elasticite          
          call chrep6(depse6p,vsig133t,.true._1,depse6)
!         cas des increments remis a zero si refermeture forcee
          if( .not. limit1) then 
            call chrep6(depsk6p,vsig133t,.true._1,depsk6)           
            call chrep6(depsm6p,vsig133t,.true._1,depsm6)          
            call chrep6(depspg6p,vsig133t,.true._1,depspg6) 
            call chrep6(depspc6p,vsig133t,.true._1,depspc6)
           else
!            mise a zero des increments en cas de refermeture forcee           
              do i=1,6
                depsk6(i)=0.d0
                depsm6(i)=0.d0
                depspg6(i)=0.d0
                depspc6(i)=0.d0
              end do
!             actualisation variable ecrouissage isotrope cisaillement
              depleqc=0.d0              
           end if         
         else
         
!         pas d ecoulement plastique
          do i=1,6
            depsk6(i)=0.d0
            depsm6(i)=0.d0
            depse6(i)=0.d0
            depspt6(i)=0.d0
            depspg6(i)=0.d0
            depspc6(i)=0.d0
          end do
          
!         actualisation variable ecrouissage isotrope cisaillement
          depleqc=0.d0

          if(fl3d) then          
!         actualisation endo de fluage
            call dflufin3d(sig16,bw,pw,bg,pg,dsw6,delta,rc,&
                           xflu,dfin1,CMp1,dfmx)          
             
!         actualisation coeffs de consolidation             
            call conso3d(epsm11,epser,ccmin1,ccmax1,epsm16,&
                         epse16,cc13,vcc33,vcc33t,CWp,CMp1,CthP,Cthv)
          end if         
         end if

!        actualisation des deformations (base fixe)
         do i=1,6
!           pour les visco elastique l increment du tir visco elastique
!           a deja ete comptabilise avant l ecoulement et une
!           premiere mise a jour a ete faite         
!           kelvin         
            epsk16(i)=epsk16(i)+depsk6(i)
            varf(i+6)=epsk16(i)           
!           maxwell            
            epsm16(i)=epsm16(i)+depsm6(i)
            varf(i+12)=epsm16(i)
!           elastique            
            epse16(i)=epse16(i)+depse6(i)
            varf(i)=epse16(i)
!           cas des deformations plastiques
!           traction base fixe
            epspt6(i)=epspt6(i)+depspt6(i)
            varf(29+i)=epspt6(i)    
!           gel dans les pores
            epspg6(i)=epspg6(i)+depspg6(i)
            varf(35+i)=epspg6(i)
!           cisaillement et dilatance
            epspc6(i)=epspc6(i)+depspc6(i)            
            varf(41+i)=epspc6(i)           
         end do      
!        *** actualisation deformation equivalente de compression ******
!        comparaison avec calcul direct par la trace
!        par l invariant
         depleqc3=0.d0
         do i=1,6
            if (i.le.3) then
                depleqc3=depleqc3+ depspc6(i)**2  
            else   
!               0.5 car on a des gama dans les depsc            
                depleqc3=depleqc3+ 0.5d0*(depspc6(i)**2)
            end if
         end do
         depleqc3=dsqrt(depleqc3*2.d0/3.d0)         
!        actualisation et stockage  
         epleqc=dmax1(epleqc+depleqc3,epleqc01)       
         varf(67)=epleqc
        
        

!        *** actualisation des ouvertures de fissures ******************
         if(end3d) then
            call majw3d(epspt60,epspt6,t33,&
            wplt06,wplt6,wpltx06,wpltx6,wpl3,vwpl33,vwpl33t,&
            wplx3,vwplx33,vwplx33t,local,dim3,ndim,ifour)
         else
            do j=1,6
               wplt6(j)=0.d0
               wpltx6(j)=0.d0
            end do
         end if
!        tenseur des ouvertures     
         do j=1,6              
             varf(102+j)=wplt6(j)
             varf(67+j)=wpltx6(j)
         end do
         
!        *** actualisation de la dissipation et de l energie elastique *
!        pour calcul consolidation debut de pas suivant         
         phi1=phi0
         we1=0.d0          
         do i=1,6
!            pas de remise a l etat initial on repart
!            du tir visco elastique         
             do j=1,6
                 sig16(i)=sig16(i)+raideur66(i,j)*depse6(j)
                 sigke16(i)=sigke16(i)+raideur66(i,j)*depsk6(j)*psik
             end do
!            actualisation de la dissipation avec l increment fin de de pas
!            et non la correction radiale
             dphi=0.5d0*(sig06(i)+sig16(i))*(epsm16(i)-epsm06(i))
             if(dphi.lt.0.) then
                 logic1=.true.
             else 
                 logic1=.false.
             end if
             phi1=phi1+dphi
!            actualisation du potentiel elastique             
             we1=we1+0.5d0*(sig16(i)*epse16(i))
        end do    
      
!       *** actualisation variation volumique plastique rgi ************
        trepspg=0.d0
        do i=1,3
           trepspg=trepspg+epspg6(i)
        end do 
!       actualisation variation volumique totale dans variable interne
        varf(29)=trepspg         
!       actualisation des contraintes effectives (sans bgpg)
        do i=1,6
          varf(i+18)=sig16(i)
          varf(i+49)=sigke16(i)
        end do
!       dissipation        
        varf(25)=phi1
!       energie elastique        
        varf(26)=we1   
            
!       *** test de consistance apres ecoulement plastique *************
        if((na.ne.0).or.indic2) then
             if(ipla.le.imax) then
!                nouvelle sous iteration de consistance plastique
                 goto 10
             else
!               on vient d atteindre le nbr maxi de sous iteration          
                vali(1) = imax
                vali(2) = ipla
                vali(3) = ipla2
                call utmess('E', 'COMPOR3_33', ni=3, vali=vali)
                ierr1=1
                go to 999
             end if
        end if
end if 
!       fin de la boucle de consistance visco-elasto-plastique
!       **************************************************************** 
!       transfert des variables internes pour la sous iteration 
!       temporelle suivante 
!       si le nbre de sous iteration locale le justifie
        if(npas1.gt.1 ) then
             do i=1,nvari
                var0(i)=varf(i)
             end do
        end if
        
       end do 
!      fin de la boucle de discretisation du pas de temps 
!*********************************************************************** 

!***********************************************************************      
!       reevaluation de la pression de gel en fin de pas pour le calcul
!       des contraintes totales (effective+rgi)
        if(ipla.gt.1) then 
!          la calcul de l avancement de la rgi est inclus dans
!          le sous programme de calcul de pression 
!          vrgi le volume effectif de gel pour le calcul de la pression
           vrgi0=vrgi          
!          dt mis a zero pour forcer la reprise de vrgi0    
           call bgpg3d(ppas,bg,pg,mg,vrgi,treps,trepspg,epspt6,epspc6,&
           phivg,pglim,brgi,dpg_depsa6,dpg_depspg6,taar,nrjg,tetar,aar0,&
           srw,srsrag,teta,0.d0,vrag00,aar1,tdef,nrjd,def0,srsdef,vdef00,&
           def1,cna,nrjp,ttrd,tfid,ttdd,tdid,exmd,exnd,cnab,cnak,ssad,&
           At,St,M1,E1,M2,E2,AtF,StF,M1F,E1F,M2F,E2F,vrgi0)
!          stockage avancement rag    
        end if
!       stockage de la pression RGI
        varf(61)=pg     
        varf(65)=bg
        
!***********************************************************************
!       endommagement de fluage
        if(fl3d) then
            dflu0=var0(27)
            call dflueff3d(ccmax1,dflu0,dflu1,dfin1)
        else
            dflu1=0.d0             
        end if 
        varf(27)=dflu1
        
        
!***********************************************************************
!       contraintes dans solide et rgi en fin de pas avec
!       prise en compte de l endo thermique et de fluage
        umdt=(1.d0-dth1)*(1.d0-dflu1)           
!       resultante des pressions intraporeuses RGI et Capillaire (depression)
        sigp=-bg*pg-bw*pw
!       effet sur la contrainte apparente en non sature        
        do i=1,6
            if(i.le.3) then
!               prise en compte de la pression rgi           
                sigf6(i)=(sig16(i)+sigp+dsw6(i))*umdt
            else
                sigf6(i)=(sig16(i)+dsw6(i))*umdt
            end if
        end do
           
               
!***********************************************************************
!       prise en compte de l'endommagement mécanique
        if(end3d) then 
!            chargement endo traction pre-pic
             dtr=var0(96) 
!            chargement endo localisee pour condition de croissance
             do i=1,3
                dt3(i)=var0(79+i)
             end do
!            calcul des endommagements et ouvertures de fissures   
                  call endo3d(wpl3,vwpl33,vwpl33t,wplx3,vwplx33,vwplx33t,&
                 gft,gfr,iso,sigf6,sigf6d,rt33,ref33,&
                 souplesse66,epspg6,eprg00,a,b,x,ipzero,ngf,&
                 ekdc,epspc6,dt3,dr3,dgt3,dgc3,dc,wl3,xmt,dtiso,rt,dtr,&
                 dim3,ndim,ifour,epeqpc)
!            stockage des endommagements de fissuration et ouverture
             varf(96)=dtr
             do i=1,3
!               endo de traction             
                varf(79+i)=dt3(i)
!               endo refermeture                
                varf(82+i)=dr3(i)
!               endo RGI en traction                
                varf(85+i)=dgt3(i)
!               endo RGI en compression                
                varf(88+i)=dgc3(i)
!               ouverture non visco elastique                
                varf(91+i)=wl3(i)
             end do
!            endommagement de compression             
             varf(95)=dc             
!            traitement erreur endo
             if (err1.eq.1) then
                 call utmess('E', 'COMPOR3_34')
                 ierr1=1     
                 go to 999 
             end if
        else
!           pas d endommagement 
            do i=1,6
                 sigf6d(i)=sigf6(i)
            end do
        end if            
     
!***********************************************************************        
!       affectation dans le tableau de sortie des contraintes
        do i=1,nstrs
           sigf(i)=sigf6d(i)
        end do
999    continue         
end subroutine
