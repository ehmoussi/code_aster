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

subroutine nglgic(fami, option, typmod, ndim, nno, &
                    nnob,npg, nddl, iw, vff, &
                    vffb, idff,idffb,geomi, compor, &
                    mate, lgpg,crit, angmas, instm, &
                    instp, matsym,ddlm, ddld, siefm, &
                    vim, siefp,vip, fint, matr, &
                    codret)

use gdlog_module, only: GDLOG_DS, gdlog_init, gdlog_defo, gdlog_matb,  &
                        gdlog_rigeo, gdlog_nice_cauchy, gdlog_delete
 
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"
#include "blas/dgemv.h"
#include "blas/dgemm.h"

! aslint: disable=W1504

    aster_logical,intent(in)       :: matsym
    character(len=8),intent(in)    :: typmod(*)
    character(len=*),intent(in)    :: fami
    character(len=16),intent(in)   :: option, compor(*)
    integer,intent(in)             :: ndim,nno,nnob,npg,nddl,lgpg
    integer,intent(in)             :: mate,iw,idff,idffb
    real(kind=8),intent(in)        :: geomi(ndim,nno), crit(*), instm, instp
    real(kind=8),intent(in)        :: vff(nno, npg),vffb(nnob, npg)
    real(kind=8),intent(in)        :: angmas(3), ddlm(nddl), ddld(nddl), siefm(3*ndim+4, npg)
    real(kind=8),intent(in)        :: vim(lgpg, npg)
    real(kind=8),intent(out)       :: fint(nddl),matr(nddl,nddl),siefp(3*ndim+4, npg),vip(lgpg,npg)
    integer,intent(out)            :: codret



! ----------------------------------------------------------------------
!     BUT:  CALCUL  DES OPTIONS RIGI_MECA_*, RAPH_MECA ET FULL_MECA_*
!           EN GRANDES DEFORMATIONS 2D (D_PLAN ET AXI) ET 3D 
!          A GRADIENT DE VARIABLE INTERNE : XXXX_GRAD_INCO
! ----------------------------------------------------------------------
! IN  FAMI    : FAMILLE DE POINTS DE GAUSS
! IN  OPTION  : OPTION DE CALCUL
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  NNO     : NOMBRE DE NOEUDS STANDARDS D'UN ELEMENT
! IN  NNOB    : NOMBRE DE NOEUDS ENRICHIS D'UN ELEMENT
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  NDDL    : DEGRES DE LIBERTE D'UN ELEMENT ENRICHI
! IN  IW      : PTR. POIDS DES POINTS DE GAUSS
! IN  VFF     : VALEUR  DES FONCTIONS DE FORME DE DEPLACEMENT
! IN  VFFB    : VALEUR  DES FONCTIONS DE FORME DE A ET LAMBDA 
! IN  IDFF    : PTR. DERIVEE DES FONCTIONS DE FORME DE DEPLACEMENT ELEMENT DE REF.
! IN  IDFFB   : PTR. DERIVEE DES FONCTIONS DE FORME DE A ET LAMBDA ELEMENT DE REF.
! IN  GEOMI   : COORDONNEES DES NOEUDS (CONFIGURATION INITIALE)
! IN  COMPOR  : COMPORTEMENT
! IN  MATE    : MATERIAU CODE
! IN  LGPG    : DIMENSION DU VECTEUR DES VAR. INTERNES POUR 1 PT GAUSS
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
! IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
! IN  INSTM   : VALEUR DE L'INSTANT T-
! IN  INSTP   : VALEUR DE L'INSTANT T+
! IN  MATSYM  : .TRUE. SI MATRICE SYMETRIQUE
! IN  DDLM    : DDL AU PAS T-
! IN  DDLD    : INCREMENT DE DDL ENTRE T- ET T+
! IN  SIGMG    : CONTRAINTES GENERALISEES EN T-
!                SIGMG(1:2*NDIM) CAUCHY
!                SIGMG(2*NDIM,NPES) : SIG_A, SIG_LAM
! IN  VIM     : VARIABLES INTERNES EN T-
! OUT SIGPG    : CONTRAINTES GENERALIEES (RAPH_MECA ET FULL_MECA_*)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA_*)
! OUT FINT    : FORCES INTERIEURES (RAPH_MECA ET FULL_MECA_*)
! OUT MATR   : MATR. DE RIGIDITE NON SYM. (RIGI_MECA_* ET FULL_MECA_*)
! OUT CODRET  : CODE RETOUR DE L'INTEGRATION DE LA LDC
!! MEM DFF,DFFB: ESPACE MEMOIRE POUR LA DERIVEE DES FONCTIONS DE FORME
!               DIM :(NNO,3) EN 3D, (NNO,4) EN AXI, (NNO,2) EN D_PLAN


! ----------------------------------------------------------------------
    aster_logical, parameter              :: grand=ASTER_TRUE
    real(kind=8), dimension(6), parameter :: kron = (/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
! ----------------------------------------------------------------------
    aster_logical:: resi, rigi, axi
    type(GDLOG_DS):: gdl

    integer:: kpg,n,i,m,j,kl,pq
    integer:: ndimsi,nelc
    integer:: larg,indu(ndim),indg(2),indi(2)
    integer:: xu(ndim,nno),xg(2,nnob),xi(2,nnob)
    integer:: cod(npg)

    real(kind=8) :: kr(2*ndim),rbid,tbid(6)
    real(kind=8) :: r,dff(nno,ndim),dffb(nnob,ndim),poids
    real(kind=8) :: deplm(ndim,nno), deplp(ndim,nno)
    real(kind=8) :: geomm(ndim,nno), geomp(ndim,nno)
    real(kind=8) :: incom(2,nnob), incop(2,nnob)
    real(kind=8) :: gradm(2,nnob), gradd(2,nnob)
    real(kind=8) :: fm(3, 3), fp(3, 3), logjm, logjp
    real(kind=8) :: epsm(2*ndim),epsp(2*ndim),etim(2*ndim),etip(2*ndim)
    real(kind=8) :: elcm(3*ndim+2),elcd(3*ndim+2)
    real(kind=8) :: gm,gp,pm,pp,am,ad,lm,ld,gam(ndim),gad(ndim)
    real(kind=8) :: slcm(3*ndim+2),slcp(3*ndim+2), t(1:2*ndim)
    real(kind=8) :: bu(2*ndim,ndim,nno)
    real(kind=8) :: sigu(2*ndim),sigi(2),sigg(2+ndim)
    real(kind=8) :: fu(ndim,nno),fi(2,nnob),fg(2+ndim,nnob)

    real(kind=8) :: dsde_lc(3*ndim+2,3*ndim+2)
    real(kind=8) :: dee(2*ndim,2*ndim),hdee(2*ndim),deeh(2*ndim)
    real(kind=8) :: pdeep(2*ndim,2*ndim),pdeeh(2*ndim),hdeep(2*ndim),hdeeh
    real(kind=8) :: kuu(ndim,nno,ndim,nno)
    real(kind=8) :: dei(2*ndim,2), budei(2,ndim,nno),kui(ndim,nno,2,nnob)
    real(kind=8) :: deg(2*ndim,2), budeg(2,ndim,nno),kug(ndim,nno,2,nnob)
    real(kind=8) :: kii(2,nnob,2,nnob)
    real(kind=8) :: hdeg(2),kig(2,nnob,2,nnob)
    real(kind=8) :: dgg(2,2),dnn(ndim,ndim),kgg(2,nnob,2,nnob)
    real(kind=8) :: die(2,2*ndim),diebu(2,ndim,nno),kiu(2,nnob,ndim,nno)
    real(kind=8) :: dge(2,2*ndim),dgebu(2,ndim,nno),kgu(2,nnob,ndim,nno)
    real(kind=8) :: dgeh(2),kgi(2,nnob,2,nnob)
! ----------------------------------------------------------------------


! --- INITIALISATION ---

    ndimsi = 2*ndim
    nelc = 3*ndim+2
    kr = kron(1:ndimsi)

    fint = 0
    matr = 0

    rbid = 0
    tbid = 0

    ! tableaux de reference bloc (depl,inco,grad) -> numero du ddl
    indu = (/ (i, i=1,ndim) /)
    indi = (/ ndim+1, ndim+2 /)
    indg = (/ ndim+3, ndim+4 /)
    larg = ndim+4
    do n = 1,nnob
        xu(:,n) = indu + (n-1)*larg
        xi(:,n) = indi + (n-1)*larg
        xg(:,n) = indg + (n-1)*larg
    end do
    do n = nnob+1,nno
        xu(:,n) = indu + larg*nnob + ndim*(n-nnob-1)
    end do

    axi  = typmod(1).eq.'AXIS'
    resi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RAPH_MECA'
    rigi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'
    cod = 0  

    call gdlog_init(gdl,ndim,nno,axi,rigi)



    ! Decompactage des ddls en t- et t+
    forall (i=1:ndim, n=1:nno)  deplm(i,n) = ddlm(xu(i,n))
    forall (i=1:2,    n=1:nnob) incom(i,n) = ddlm(xi(i,n))
    forall (i=1:2,    n=1:nnob) gradm(i,n) = ddlm(xg(i,n))
    geomm = geomi + deplm

    forall (i=1:ndim, n=1:nno)  deplp(i,n) = deplm(i,n) + ddld(xu(i,n))
    forall (i=1:2,    n=1:nnob) incop(i,n) = incom(i,n) + ddld(xi(i,n))
    forall (i=1:2,    n=1:nnob) gradd(i,n) = ddld(xg(i,n))
    geomp = geomi + deplp

    

    do kpg = 1, npg
 
        ! -----------------------!
        !  ELEMENTS CINEMATIQUES !
        ! -----------------------!

        ! Calcul des derivees des fonctions de forme P1 
        call dfdmip(ndim, nnob, axi, geomi, kpg, iw, vffb(1,kpg), idffb, r, poids,dffb)

        ! Calcul des derivees des fonctions de forme P2, du rayon r et des poids
        call dfdmip(ndim, nno, axi, geomi, kpg, iw, vff(1, kpg), idff, r, poids, dff)

        ! Calcul de la deformation en t- (fm et epm)
        call nmepsi(ndim, nno, axi, grand, vff(1,kpg), r, dff, deplm, fm, tbid)
        call gdlog_defo(gdl,fm,epsm,cod(kpg))
        if (cod(kpg).ne.0) goto 999
        logjm =  sum(epsm(1:3))   

        ! Calcul des elements cinematiques en t+
        call nmepsi(ndim, nno, axi, grand, vff(1,kpg),r, dff, deplp, fp, tbid)
        call gdlog_defo(gdl,fp,epsp,cod(kpg))
        if (cod(kpg).ne.0) goto 999
        logjp =  sum(epsp(1:3))   
        call gdlog_matb(gdl,r,vff(:,kpg),dff,bu)


        ! Calcul des champs P,G,A, grad(A) et L aux points de Gauss
        pm = dot_product(vffb(:,kpg),incom(1,:))
        pp = dot_product(vffb(:,kpg),incop(1,:))
        gm = dot_product(vffb(:,kpg),incom(2,:))
        gp = dot_product(vffb(:,kpg),incop(2,:))
        am = dot_product(vffb(:,kpg),gradm(1,:))
        ad = dot_product(vffb(:,kpg),gradd(1,:))
        lm = dot_product(vffb(:,kpg),gradm(2,:))
        ld = dot_product(vffb(:,kpg),gradd(2,:))
        gam = matmul(gradm(1,:),dffb)
        gad = matmul(gradd(1,:),dffb) 
       

        ! Deformation corrigee du gonflement (e tilda)
        etim(1:3) = epsm(1:3) + (gm-sum(epsm(1:3)))/3
        etip(1:3) = epsp(1:3) + (gp-sum(epsp(1:3)))/3



        ! -----------------------!
        !   LOI DE COMPORTEMENT  !
        ! -----------------------!

        ! Preparation des deformations generalisees de ldc en t- et Dt
        elcm(1:ndimsi) = etim
        elcm(ndimsi+1) = am
        elcm(ndimsi+2) = lm
        elcm(ndimsi+3:3*ndim+2) = gam        

        elcd(1:ndimsi) = etip-etim
        elcd(ndimsi+1) = ad
        elcd(ndimsi+2) = ld
        elcd(ndimsi+3:3*ndim+2) = gad        


        ! Preparation des contraintes generalisees T en t-
        slcm(1:ndimsi) = vim(lgpg-5:lgpg-6+ndimsi,kpg)
        slcm(ndimsi+1:3*ndim+2) = siefm(ndimsi+3:3*ndim+4,kpg)


        ! Comportement
        call nmcomp(fami, kpg, 1, ndim, typmod,&
                    mate, compor, crit, instm, instp,&
                    nelc, elcm, elcd, nelc, slcm,&
                    vim(1,kpg), option, angmas, 1,[rbid],&
                    slcp, vip(1,kpg), nelc*nelc, dsde_lc, 1,&
                    [rbid], cod(kpg))
        if (cod(kpg) .eq. 1) goto 999

        ! Archivage des contraintes mecaniques en t+ (tau tilda) dans les vi
        if (resi) then
            vip(lgpg-5:lgpg-6+ndimsi,kpg) = slcp(1:ndimsi)
        end if



        ! -----------------------!
        !   FORCES INTERIEURES   !
        ! -----------------------!

        if (resi) then

            ! Contraintes generalisees EF
            t = slcp(1:ndimsi)
            sigi = (/ logjp-gp, sum(t)/3-pp /)
            sigu = t - sigi(2)*kr
            sigg = slcp(ndimsi+1:)

            ! Forces interieures au point de Gauss kpg
            call dgemv('t',ndimsi,ndim*nno,1.d0,bu,ndimsi,t,1,0.d0,fu,1)
            fi(1,:) = sigi(1)*vffb(:,kpg)
            fi(2,:) = sigi(2)*vffb(:,kpg)
            fg(1,:) = sigg(1)*vffb(:,kpg) + matmul(dffb,sigg(3:2+ndim))
            fg(2,:) = sigg(2)*vffb(:,kpg)

            ! Somme des contributions aux forces interieures
            forall (i=1:ndim, n=1:nno)  fint(xu(i,n)) = fint(xu(i,n)) + poids*fu(i,n)
            forall (i=1:2,    n=1:nnob) fint(xi(i,n)) = fint(xi(i,n)) + poids*fi(i,n)
            forall (i=1:2,    n=1:nnob) fint(xg(i,n)) = fint(xg(i,n)) + poids*fg(i,n)

            ! Stockage des contraintes generalisees Cauchy
            siefp(1:ndimsi,kpg) = gdlog_nice_cauchy(gdl,sigu)
            siefp(ndimsi+1:ndimsi+2,kpg) = sigi
            siefp(ndimsi+3:3*ndimsi+4,kpg) = sigg

        endif



        ! -----------------------!
        !    MATRICE TANGENTE    !
        ! -----------------------!
    
        


        if (rigi) then

            ! Contraintes generalisees EF (si resi: deja calculee dans Fint)
            if (.not. resi) then
                t = slcm(1:ndimsi)
                sigi = (/ logjm-gm, sum(t)/3-pm /)
                sigu = t - sigi(2)*kr
                sigg = slcm(ndimsi+1:)
            end if

            ! Projection de Kee (dt/de)
            dee  = dsde_lc(1:ndimsi,1:ndimsi)
            hdee = sum(dee(1:3,:),dim=1)/3
            deeh = sum(dee(:,1:3),dim=2)/3
            hdeeh = sum(hdee(1:3))/3
            hdeep = hdee - hdeeh*kr
            pdeeh = deeh - hdeeh*kr
            forall(kl=1:ndimsi,pq=1:ndimsi) pdeep(kl,pq)= &
                dee(kl,pq) - pdeeh(kl)*kr(pq) - kr(kl)*hdeep(pq) - hdeeh*kr(kl)*kr(pq)

            ! Kuu
            kuu = gdlog_rigeo(gdl,sigu) + prod_bb(bu,prod_kb(pdeep,bu))

            ! Kui
            dei(:,1)=kr
            dei(:,2)=pdeeh
            budei = prod_kb(transpose(dei),bu)
            forall (i=1:ndim,n=1:nno,j=1:2,m=1:nnob) kui(i,n,j,m) = budei(j,i,n)*vffb(m,kpg)

            ! Kug
            deg(:,1) = dev(dsde_lc(1:ndimsi,ndimsi+1))
            deg(:,2) = dev(dsde_lc(1:ndimsi,ndimsi+2))
            budeg = prod_kb(transpose(deg),bu)
            forall (i=1:ndim,n=1:nno,j=1:2,m=1:nnob) kui(i,n,j,m) = budeg(j,i,n)*vffb(m,kpg)

            ! Kii
            forall (n=1:nnob,m=1:nnob) kii(1,n,1,m) = 0
            forall (n=1:nnob,m=1:nnob) kii(1,n,2,m) = -vffb(n,kpg)*vffb(m,kpg)
            forall (n=1:nnob,m=1:nnob) kii(2,n,1,m) = -vffb(n,kpg)*vffb(m,kpg)
            forall (n=1:nnob,m=1:nnob) kii(2,n,2,m) = hdeeh*vffb(n,kpg)*vffb(m,kpg)

            ! Kig
            hdeg(1) = sum(dsde_lc(1:3,ndimsi+1))/3
            hdeg(2) = sum(dsde_lc(1:3,ndimsi+2))/3
            forall (n=1:nnob,m=1:nnob,j=1:2) kig(1,n,j,m) = 0
            forall (n=1:nnob,m=1:nnob,j=1:2) kig(2,n,j,m) = hdeg(j)*vffb(n,kpg)*vffb(m,kpg)
            
            ! Kgg
            dgg = dsde_lc(ndimsi+1:ndimsi+2,ndimsi+1:ndimsi+2)
            forall (i=1:2,n=1:nnob,j=1:2,m=1:nnob) kgg(i,n,j,m) = vffb(n,kpg)*dgg(i,j)*vffb(m,kpg)
            dnn = dsde_lc(ndimsi+3:ndimsi+2+ndim,ndimsi+3:ndimsi+2+ndim)
            kgg(1,:,1,:) = kgg(1,:,1,:) + matmul( matmul(dffb,dnn), transpose(dffb) )

            if (matsym) goto 200

            ! Kiu
            die(1,:)=kr
            die(2,:)=hdeep
            diebu = prod_kb(die,bu)
            forall (i=1:ndim,n=1:nno,j=1:2,m=1:nnob) kiu(i,n,j,m) = vffb(n,kpg)*diebu(i,j,m)
            
            ! Kgu
            dge(1,:)=dev(dsde_lc(ndimsi+1,1:ndimsi))
            dge(2,:)=dev(dsde_lc(ndimsi+2,1:ndimsi))
            dgebu = prod_kb(dge,bu)
            forall (i=1:ndim,n=1:nno,j=1:2,m=1:nnob) kgu(i,n,j,m) = vffb(n,kpg)*dgebu(i,j,m)
            
            ! Kgi
            dgeh(1) = sum(dsde_lc(ndimsi+1,1:3))/3
            dgeh(2) = sum(dsde_lc(ndimsi+2,1:3))/3
            forall (i=1:ndim,n=1:nno,m=1:nnob) kgi(i,n,1,m) = 0
            forall (i=1:ndim,n=1:nno,m=1:nnob) kgi(i,n,2,m) = dgeh(i)*vffb(n,kpg)*vffb(m,kpg)

200         continue

            ! Stockage dans la matrice globale
            if (.not. matsym) then
                forall (i=1:ndim,n=1:nno,j=1:ndim,m=1:nno) matr(xu(j,m),xu(i,n)) = &
                    matr(xu(j,m),xu(i,n)) + kuu(i,n,j,m)*poids

                forall (i=1:ndim,n=1:nno,j=1:2,m=1:nnob) matr(xi(j,m),xu(i,n)) = &
                    matr(xi(j,m),xu(i,n)) + kui(i,n,j,m)*poids

                forall (i=1:ndim,n=1:nno,j=1:2,m=1:nnob) matr(xg(j,m),xu(i,n)) = &
                    matr(xg(j,m),xu(i,n)) + kug(i,n,j,m)*poids

                forall (i=1:2,n=1:nnob,j=1:ndim,m=1:nno) matr(xu(j,m),xi(i,n)) = &
                    matr(xu(j,m),xi(i,n)) + kiu(i,n,j,m)*poids

                forall (i=1:2,n=1:nnob,j=1:2,m=1:nnob) matr(xi(j,m),xi(i,n)) = &
                    matr(xi(j,m),xi(i,n)) + kii(i,n,j,m)*poids

                forall (i=1:2,n=1:nnob,j=1:2,m=1:nnob) matr(xg(j,m),xi(i,n)) = &
                    matr(xg(j,m),xi(i,n)) + kig(i,n,j,m)*poids

                forall (i=1:2,n=1:nnob,j=1:ndim,m=1:nno) matr(xu(j,m),xg(i,n)) = &
                    matr(xu(j,m),xg(i,n)) + kgu(i,n,j,m)*poids

                forall (i=1:2,n=1:nnob,j=1:2,m=1:nnob) matr(xi(j,m),xg(i,n)) = &
                    matr(xi(j,m),xg(i,n)) + kgi(i,n,j,m)*poids

                forall (i=1:2,n=1:nnob,j=1:2,m=1:nnob) matr(xg(j,m),xg(i,n)) = &
                    matr(xg(j,m),xg(i,n)) + kgg(i,n,j,m)*poids

            else
                ASSERT(.false.)
            end if

        end if
            


    end do 



      
! - SYNTHESE DES CODES RETOURS
999 continue
    call codere(cod, npg, codret)
    call gdlog_delete(gdl)



contains

function prod_sb(s,b) result(sb)
    implicit none
    real(kind=8)::s(:),b(:,:,:)
    real(kind=8)::sb(size(b,2),size(b,3))
    ! -------------------------------------------------------------------------
    integer:: ndim,nno,ndimsi
    ! -------------------------------------------------------------------------
    ndim = size(b,2)
    nno  = size(b,3)
    ndimsi = size(s)
    ASSERT(ndimsi.eq.size(b,1))
    call dgemv('t',ndimsi,ndim*nno,1.d0,b,ndimsi,s,1,0.d0,sb,1)
end function prod_sb


function prod_kb(k,b) result(kb)
    implicit none
    real(kind=8)::k(:,:),b(:,:,:)
    real(kind=8)::kb(size(k,1),size(b,2),size(b,3))
    ! -------------------------------------------------------------------------
    integer:: ndim,nno
    ! -------------------------------------------------------------------------
    ndim = size(b,2)
    nno  = size(b,3)
    ASSERT(size(k,2).eq.size(b,1))
    call dgemm('n','n',size(k,1),ndim*nno,size(k,2),1.d0,k,size(k,1),b,size(b,1),0.d0,kb,size(k,1))
end function prod_kb


function prod_bb(b1,b2) result(bb)
    implicit none
    real(kind=8)::b1(:,:,:),b2(:,:,:)
    real(kind=8)::bb(size(b1,2),size(b1,3),size(b2,2),size(b2,3))
    ! -------------------------------------------------------------------------
    integer:: ndno1,ndno2,ndimsi
    ! -------------------------------------------------------------------------
    ndno1  = size(b1,2)*size(b1,3)
    ndno2  = size(b2,2)*size(b2,3)
    ndimsi = size(b1,1)
    ASSERT(size(b2,1).eq.ndimsi)
    call dgemm('t','n',ndno1,ndno2,ndimsi,1.d0,b1,ndimsi,b2,ndimsi,0.d0,bb,ndno1)
end function prod_bb







function dev(tns)
    implicit none
    real(kind=8)::tns(:)
    real(kind=8)::dev(size(tns))
    dev = tns - sum(tns(1:3))/3*kr
end function dev

end subroutine
