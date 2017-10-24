subroutine nglgic(fami, option, typmod, ndim, nno,nnob,neps,&
                  npg, nddl, iw, vff, vffb, idff,idffb,&
                  geomi, compor, mate, lgpg,&
                  crit, angmas, instm, instp, matsym,&
                  ddlm, ddld, sigmg, vim, sigpg,&
                  vip, fint,matr, codret)
! ======================================================================
! COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
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
! ----------------------------------------------------------------------
!     BUT:  CALCUL  DES OPTIONS RIGI_MECA_*, RAPH_MECA ET FULL_MECA_*
!           EN GRANDES DEFORMATIONS 2D (D_PLAN ET AXI) ET 3D 
!          A GRADIENT DE VARIABLE INTERNE : XXXX_GRAD_VARI
! ----------------------------------------------------------------------
! IN  FAMI    : FAMILLE DE POINTS DE GAUSS
! IN  OPTION  : OPTION DE CALCUL
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  NNO     : NOMBRE DE NOEUDS STANDARDS D'UN ELEMENT
! IN  NNOB    : NOMBRE DE NOEUDS ENRICHIS D'UN ELEMENT
! IN  NEPS    : DIMENSION DE DEFORMATION GENERALISEE 
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

    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/lcegeo.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"
! #include "asterfort/nmgrtg.h"
#include "asterfort/poslog.h"
#include "asterfort/prelog.h"
#include "asterfort/r8inir.h"
#include "asterfort/utmess.h"
#include "asterfort/lgvicb.h"
#include "asterfort/nmfdff.h"
#include "asterfort/deflog.h"
#include "asterfort/deflg2.h"
#include "asterfort/deflg3.h"
#include "asterfort/symt46.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dgemm.h"
#include "blas/ddot.h"
#include "blas/dgemv.h"
#include "blas/dscal.h"

    aster_logical :: grand, axi, resi, rigi, matsym, cplan
    parameter (grand = .true._1)
    integer :: g,i,j,n,m,k,nddl
    integer :: ndim, nno,nnob,npg,mate,lgpg, codret, iw, idff, idffb,nepg,neps,nddl1
    character(len=8) :: typmod(*)
    character(len=*) :: fami
    character(len=16) :: option, compor(*)
    real(kind=8) :: geomi(ndim,nno), dff(nno,ndim),dffb(nnob,ndim), crit(*), instm, instp
    real(kind=8) :: vff(nno, npg),vffb(nnob, npg), dtdeg(neps, neps),dtde(6,6)
    real(kind=8) :: angmas(3), ddlm(nddl), ddld(nddl), sigmg(neps, npg),sigpg(neps, npg), epsml(6)
    real(kind=8) :: vim(lgpg, npg), sigp(2*ndim),sigm(2*ndim), vip(lgpg, npg)
    real(kind=8) :: matr(nddl,nddl),dfint(nddl)
    real(kind=8) :: geomm(ndim,nno), geomp(ndim,nno), fm(3, 3), fp(3, 3),fr(3, 3), deplt(nno*ndim), deplm(nno*ndim), depld(nno*ndim)
    real(kind=8) :: r, poids, elgeom(10, 27), tm(6), tp(6), deps(6),tmg(neps),tpg(neps)
    real(kind=8) :: gn(3, 3), lamb(3), logl(3), rbid(1), tbid(6)
    real(kind=8) :: def(2*ndim, nno,ndim), pff(2*ndim, nno, nno),deff(6, nno*ndim)
    real(kind=8) :: dsidep(6,6), pk2(6), pk2m(6)
    real(kind=8) :: me(3, 3, 3, 3), xi(3, 3), feta(4), pes(6, 6),bst(6,nno*ndim)
    real(kind=8) :: epmlg(neps), depsg(neps),rac2
    real(kind=8) :: temp1(neps,nddl),dmatr1(nddl,nddl),temp2(2*ndim,nno*ndim),temp(nno*ndim,nno*ndim)
    real(kind=8) :: tptem(2*ndim),tl(3,3,3,3),tls(6,6)
    real(kind=8) :: matuu(nno*ndim,nno*ndim), fu(nno*ndim)
    real(kind=8) :: fint(nddl),id2(2*ndim),id3(2*ndim), idid(3,3)
    real(kind=8) :: b(3*ndim+4, nddl),jm,jp,presm(nnob),presd(nnob),gonfm(nnob),gonfd(nnob),anodm(nnob),anodd(nnob),lambm(nnob),lambd(nnob)
    real(kind=8) :: gm,gd,gp,pm,pd,pp,am,ad,lm,ld,corm,corp,ftm(3, 3), ftp(3, 3),gam(ndim),gad(ndim),ebid(6)
    real(kind=8) :: ttra,tdev(6),idev(6, 6),kr(6),id(3, 3),sigint(neps+2), dtdegt(neps+2, neps+2)
    real(kind=8) :: pk2ref(6), pk2ref2(6),furef(nno*ndim),furef2(nno*ndim),dfuref2(nno*ndim),bb(neps, nddl)
    real(kind=8) :: tmps0(6,6),tmps1(2*ndim),tmps2(2*ndim),tmps3(2*ndim),tmps4(2*ndim),tmps5,dtddeth(6)
    real(kind=8) :: tpp(6),tls2(2*ndim,2*ndim),sigpp(6),dmatr2(ndim*nno,ndim*nno),matr2(ndim*nno,ndim*nno)
    integer :: nu1,nu2,uu1,iret,cod(npg)
    nu1(n,i) = (n-1)*(ndim+4) + i
    nu2(n,i) = nnob*4 + (n-1)*ndim + i
    uu1(n,i) = (n-1)*ndim+i

    data         kr   / 1.d0, 1.d0, 1.d0, 0.d0, 0.d0, 0.d0/
    data         id   / 1.d0, 0.d0, 0.d0,&
     &                    0.d0, 1.d0, 0.d0,&
     &                    0.d0, 0.d0, 1.d0/
!     data         idev / 2.d0,-1.d0,-1.d0, 0.d0, 0.d0, 0.d0,&
!      &                   -1.d0, 2.d0,-1.d0, 0.d0, 0.d0, 0.d0,&
!      &                   -1.d0,-1.d0, 2.d0, 0.d0, 0.d0, 0.d0,&
!      &                    0.d0, 0.d0, 0.d0, 3.d0, 0.d0, 0.d0,&
!      &                    0.d0, 0.d0, 0.d0, 0.d0, 3.d0, 0.d0,&
!      &                    0.d0, 0.d0, 0.d0, 0.d0, 0.d0, 3.d0/
! ----------------------------------------------------------------------

!
! -----------------------------INITIALISATION-----------------------------

    nddl1 = nno*ndim
    matr = 0.
    matuu = 0.
    matr2 = 0.
    fint = 0.
    dfint = 0.
    jm= 0.
    jp= 0.
    fu = 0.
    tp = 0.
    sigp = 0.
    pk2m= 0.
    sigm= 0.
    sigpg = 0.
    deff = 0.
    dmatr2= 0.
    tls = 0.
    tl = 0.
    bst = 0.
    tpg = 0.
    dtde = 0.
    dtdeg = 0.  
    dtdegt = 0.
    idev= 0.
    idev(1:3,1:3) = -1.d0
    do i = 1, ndim*2
        idev(i,i) = idev(i,i) + 3.d0
    end do    

!     AFFECTATION DES VARIABLES LOGIQUES  OPTIONS ET MODELISATION
    axi = typmod(1).eq.'AXIS'
    resi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RAPH_MECA'
    rigi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'
    id2 = 0. 
    id2(1:3) = 1.
    idid = 1.
    rac2 = sqrt(2.d0)
    cod = 0  
!
!------------------------------DEPLACEMENT ET GEOMETRIE-------------
!
!    DETERMINATION DES CONFIGURATIONS EN T- (GEOMM) ET T+ (GEOMP)
    do 20 n = 1, nnob
       call dcopy(ndim, ddlm((ndim+4)*(n-1)+1), 1, deplm(ndim*(n-1)+1), 1)
       call dcopy(ndim, ddld((ndim+4)*(n-1)+1), 1, depld(ndim*(n-1)+1), 1)

       presm(n) = ddlm((ndim+4)*(n-1)+ndim+1)       
       presd(n) = ddld((ndim+4)*(n-1)+ndim+1)

       gonfm(n) = ddlm((ndim+4)*(n-1)+ndim+2)
       gonfd(n) = ddld((ndim+4)*(n-1)+ndim+2)

       anodm(n) = ddlm((ndim+4)*(n-1)+ndim+3)       
       anodd(n) = ddld((ndim+4)*(n-1)+ndim+3)

       lambm(n) = ddlm((ndim+4)*(n-1)+ndim+4)       
       lambd(n) = ddld((ndim+4)*(n-1)+ndim+4)
20  end do
!     print*, 'anodm = ', anodm
!     print*, 'anodd = ', anodd
     
    call dcopy(ndim*(nno-nnob), ddlm((ndim+4)*nnob+1), 1, deplm(ndim*nnob+1), 1)
    call dcopy(ndim*(nno-nnob), ddld((ndim+4)*nnob+1), 1, depld(ndim*nnob+1), 1)

    call dcopy(nddl1, geomi, 1, geomm, 1)
    call daxpy(nddl1, 1.d0, deplm, 1, geomm,1)
    call dcopy(nddl1, geomm, 1, geomp, 1)
!     DEPLT : DEPLACEMENT TOTAL ENTRE CONF DE REF ET INSTANT T_N+1
    call dcopy(nddl1, deplm, 1, deplt, 1)
!     print*, 'ddlm =', ddlm
!     print*, 'ddld =', ddld
    if (resi) then
        call daxpy(nddl1, 1.d0, depld, 1, geomp,1)
        call daxpy(nddl1, 1.d0, depld, 1, deplt,1)
    endif


    
!****************************BOUCLE SUR LES POINTS DE GAUSS************
!
! - CALCUL POUR CHAQUE POINT DE GAUSS

    do 10 g = 1, npg
 
!---     CALCUL DE F_N, F_N+1 PAR RAPPORT A GEOMI GEOM INITIAL
        call dfdmip(ndim, nno, axi, geomi, g,iw, vff(1, g), idff, r, poids, dff)
        call dfdmip(ndim, nnob, axi, geomi, g,iw, vffb(1,g), idffb, r, poids,dffb)
        call nmepsi(ndim, nno, axi, grand, vff(1, g),r, dff, deplm, fm, tbid)
        call nmepsi(ndim, nno, axi, grand, vff(1, g),r, dff, deplt, fp, tbid)
         jp=0.d0
!          print*,'jp=',jp
!---     CALCUL DE JACOBIEN
        jm = fm(1,1)*(fm(2,2)*fm(3,3)-fm(2,3)*fm(3,2)) - fm(2,1)*(fm( 1,2)*fm(3,3)-fm(1,3)*fm(3,2&
             &)) + fm(3,1)*(fm(1,2)*fm(2,3)-fm(1, 3)*fm(2,2))
        jp = fp(1,1)*(fp(2,2)*fp(3,3)-fp(2,3)*fp(3,2)) - fp(2,1)*(fp( 1,2)*fp(3,3)-fp(1,3)*fp(3,2&
             &)) + fp(3,1)*(fp(1,2)*fp(2,3)-fp(1, 3)*fp(2,2))   

        if (jp .le. 0.d0) then
            cod = 1
            print*,'jp=',jp
            goto 9999
        endif 
!       print*,'jm=',jm

!         pm = ddot(nnob,vffb(1,g),1,presm,1)
!         pd = ddot(nnob,vffb(1,g),1,presd,1)
!         pp = pm+pd

        pm = dot_product(vffb(:,g),presm)
        pd = dot_product(vffb(:,g),presd)
        pp = pm+pd

!         gm = ddot(nnob,vffb(1,g),1,gonfm,1)
!         gd = ddot(nnob,vffb(1,g),1,gonfd,1)
!         gp = gm+gd

        gm = dot_product(vffb(:,g),gonfm)
        gd = dot_product(vffb(:,g),gonfd)
        gp = gm+gd

!         print*,'gp = ',gp 


!         am = ddot(nnob,vffb(1,g),1,anodm,1)
!         ad = ddot(nnob,vffb(1,g),1,anodd,1)
        am = dot_product(vffb(:,g),anodm)
        ad = dot_product(vffb(:,g),anodd)

!         lm = ddot(nnob,vffb(1,g),1,lambm,1)
!         ld = ddot(nnob,vffb(1,g),1,lambd,1)   
        lm = dot_product(vffb(:,g),lambm)
        ld = dot_product(vffb(:,g),lambd)
       
!         do 11 i = 1, ndim 
!             gam(i) = ddot(nnob,dffb(:,i),1,anodm,1)
!             gad(i) = ddot(nnob,dffb(:,i),1,anodd,1)
! 11      end do



        gam = matmul(anodm,dffb)

        gad = matmul(anodm+anodd,dffb) - gam

        corm = (exp(gm)/jm)**(1.d0/3.d0)
        ftm = fm*corm 
        corp = (exp(gp)/jp)**(1.d0/3.d0)
        ftp = fp*corp

!         print*,'jp=',jp
!       
        call prelog(ndim, lgpg, vim(1, g), gn, lamb,logl, ftm, ftp, epsml, deps, tm, resi, cod(g))
        if (cod(g) .ne. 0) then
            print*,'prelog wrong!'
            PRINT*,'CODg=',cod(g)
        endif 
! 
! !---     CALCUL de pes : projetcteur de T vers S(Pk2), PES = 2dE/dC
!         call deflg2(gn, lamb, logl, pes, feta, xi, me)    
! !-------------------------------------------
! ! pour construire la matrice b(neps,nddl)
! !-------------------------------------------
! 
!         bst = matmul(pes,deff)
! !         call lggvmb(ndim,nno,nnob,npg,g,axi,r,&
! !                     bst,vffb(1,g),dffb,nddl,&
! !                     neps,b,poids)
! !         call dgemv('N', neps, nddl, 1.d0, b,neps, ddlm, 1, 0.d0, epmlg,1)   
! !         call dgemv('N', neps, nddl, 1.d0, b,neps, ddld, 1, 0.d0, depsg,1)

        do 12 i = 1, 2*ndim
            epmlg(i) = epsml(i)
            depsg(i) = deps(i)        
12      end do

        epmlg(2*ndim+1) = am
        depsg(2*ndim+1) = ad

        epmlg(2*ndim+2) = lm
        depsg(2*ndim+2) = ld
        
        call dcopy(ndim,gam,1,epmlg(2*ndim+3),1)
        call dcopy(ndim,gad,1,depsg(2*ndim+3),1)       

        call dcopy(2*ndim, tm, 1, tmg, 1)
        call dcopy(2+ndim,sigmg(2*ndim+1,g),1,tmg(2*ndim+1),1)
        call dcopy(2*ndim,sigmg(1,g),1,sigm,1)
!         print*,'sigp=',sigp
!         do 123 i = 4, 2*ndim
!             tmg(i) = tmg(i)*rac2
! 123     end do
        if (cod(g) .ne. 0) goto 9999
        call nmcomp(fami, g, 1, ndim, typmod,&
                    mate, compor, crit, instm, instp,&
                    neps, epmlg, depsg, neps, tmg,&
                    vim(1, g), option, angmas, 1,rbid,&
                    tpg, vip(1, g), neps*neps, dtdeg, 1,&
                    rbid, cod(g))


!          print*,'MnmLG = ',dtdeg
!        TEST SUR LES CODES RETOUR DE LA LOI DE COMPORTEMENT
!         if (cod(g) .eq. 1) goto 9999
        if (cod(g) .ne. 0) then
            print*,'nmcomp wrong!'
            PRINT*,'CODg=',cod(g)
        endif 
        call dcopy(2*ndim, tpg, 1, tp, 1)
!         print*,'tp=',tp
        do 14 i = 1,ndim*2
            do 13 j = 1, ndim*2
               dtde(i,j) = dtdeg(i,j) 
13          end do
14      end do



        call poslog(resi, rigi, tm, tp, ftm,&
                    lgpg, vip(1, g), ndim, ftp, g,&
                    dtde, sigm, cplan, fami, mate,&
                    instp, angmas, gn, lamb, logl,&
                    sigp, dsidep, pk2m, pk2, cod(g))
        if (cod(g) .ne. 0) then
            print*,'prelog wrong!'
            PRINT*,'CODg=',cod(g)
        endif 

        if (resi) then
            call dscal(2*ndim, exp(gp), sigp, 1)
!         print*,'sigp1=',sigp
!             call dcopy(2*ndim, sigp, 1, taup, 1)
             call dscal(2*ndim, 1.d0/jp, sigp, 1)  

!         sigp = sigp*exp(gp)/jp
!         print*,'jp=',jp
             sigpg(1:2*ndim,g) = sigp(1:2*ndim)
             sigpg(2*ndim+1:neps,g) = tpg(2*ndim+1:neps)
        endif
!         print*,'sigjp=',sigp(1:2*ndim)*jp
!         print*,'jp=',jp
!         if(resi) then
!             do 321 i = 4, 2*ndim
!                 sigpg(i,g) = sigpg(i,g)/rac2
! 321         end do
!         end if
        if (cod(g) .eq. 1) goto 9999
        
!     CALCUL DE LA MATRICE DE RIGIDITE ET DE LA FORCE INTERIEURE
!     CONFG LAGRANGIENNE COMME NMGR3D / NMGR2D
! 
!   CONSTRUCTION DE LA MATRICE GEOMETIQUE B
! ---     CALCUL de deff = trans(F)*(derive fonction de forme)
   
        if (resi) then
            call dcopy(9, fp, 1, fr, 1)
        else
            call dcopy(9, fm, 1, fr, 1)
        endif    
   
        call nmfdff(ndim, nno, axi, g, r,rigi, matsym, fr, vff, dff,def, pff)     
        do 333 m = 1,2*ndim
            do 111 n =1,nno
                do 222 i = 1,ndim
                    deff(m,(n-1)*ndim+i) = def(m,n,i)
222             end do
111         end do
333     end do

!         call prelog(ndim, lgpg, vim(1, g), gn, lamb,logl, fm, fp, ebid, ebid, ebid, resi, cod(g))
        

!
        if (resi) then
            call deflog(ndim, fp, ebid, gn, lamb,logl, iret)
        else 
            call deflog(ndim, fm, ebid, gn, lamb,logl, iret)
        endif
!---     CALCUL de pes : projetcteur de T vers S(Pk2), PES = 2dE/dC
        call deflg2(gn, lamb, logl, pes, feta, xi, me)    

! !
!        
!-------------------------------------------
! pour construire la matrice b(neps,nddl)
!-------------------------------------------

        bst = matmul(pes,deff)
        call lgvicb(ndim,nno,nnob,npg,g,axi,r,&
                    bst,vffb(1,g),dffb,nddl,b)
        ttra = (tpg(1)+tpg(2)+tpg(3))/3.d0
        tdev = tpg - ttra*kr
! - FORCE INTERIEURE
        if (resi) then
!            CONSTRUCTION DE CONTRAINTE POUR CALCULER LA FORCE INTERIEUR 

      
            do i = 1, 2*ndim
                sigint(i) = tdev(i)+ pp*kr(i)
            end do

            sigint(2*ndim+1) = log(jp) - gp
!             print*,'lnj-the=',sigint(2*ndim+1)         
            sigint(2*ndim+2) = ttra-pp
            sigint(2*ndim+3:3*ndim+4) = tpg(2*ndim+1:3*ndim+2)
!             print*,'sint=',sigint
! !      FINT = SOMME(G) WG.BT.SIGMA
!             print*,'b8=',b(:,8) 

!Pénalisation si l'élément est trop déformé 
!	if (jp < 0.3) then 
!	    sigint(1:2*ndim) = sigint(1:2*ndim)-200 / jp * id2
!	endif	
            dfint = matmul(transpose(b),sigint)
            fint = fint + dfint*poids
!             if (maxval(fint)>1.E5) then
!                 print*,'545fint=',fint
!                 print*,'545dfint=',dfint
!                 print*,'545sigint=',sigint
!                 print*,'poids = ',poids
!                 print*,'resi=',resi,'rigi=',rigi
!                 print*,'sigpg=',sigpg(:,3)
!                 print*,'gonf=',gp, 'lnJ=',log(jp)   
!                 print*,'sigp=',sigp
!                 print*,'tpg=',tpg      
!                 print*,'pp=',pp
!                 print*,'tm=',tm
!                 print*,'sigmg=',sigmg
!                 print*,'fm=',fm
!                 print*,'fp=',fp
!                 print*,'ddlm=',ddlm
!                 print*,'ddld=',ddld
!                 print*,'VIM6=',vim(6,g)
!                 print*,'========'
!             endif
        endif

! - MATRICE TANGENTE



        if (rigi) then 
! CONSTRUCTION DE LA MATRICE (DT/DE) GENERALISE TOTAL
! dEdE  PARTIE UNE      
            tmps0 = matmul(matmul(idev/3.0,dtde),idev/3.0)
!Pénalisation si l'élément est trop déformé 
!	    if (jp < 0.3) then 
!	        print*,'tres deforme'
!	        tmps0(1:3,1:3) = tmps0(1:3,1:3)+ 200/jp * idid
!	    endif	
            dtdegt(1:2*ndim,1:2*ndim) = tmps0(1:2*ndim,1:2*ndim)
!dEdp
            dtdegt(1:2*ndim, 2*ndim+1) = id2
!dEdtheta
            dtddeth = matmul(matmul(idev/3.0,dtde),kr/3.0)
            dtdegt(1:2*ndim, 2*ndim+2) = dtddeth(1:2*ndim)
! dEda   
            tmps1 = dtdeg(1:2*ndim,2*ndim+1)
            dtdegt(1:2*ndim, 2*ndim+3) = tmps1-id2*ddot(ndim*2,tmps1,1,id2,1)/3.0

! dEdl
            tmps2 = dtdeg(1:2*ndim,2*ndim+2)
            dtdegt(1:2*ndim, 2*ndim+4) = tmps2-id2*ddot(ndim*2,tmps2,1,id2,1)/3.0
!dpdE
            dtdegt(2*ndim+1,1:2*ndim) = id2

!dpdtheta  
            dtdegt(2*ndim+1,2*ndim+2) = -1.

!dthetadE
            dtddeth = matmul(kr/3.0,matmul(dtde,idev/3.0))
            dtdegt(2*ndim+2,1:2*ndim) = dtddeth(1:2*ndim)
!dthetadp            
            dtdegt(2*ndim+2,2*ndim+1) = -1.
!dthetadtheta 
            dtdegt(2*ndim+2,2*ndim+2) = ddot(6,kr/3.0,1,matmul(kr/3.0,dtde),1)
!dthetada 
            dtdegt(2*ndim+2,2*ndim+3) = ddot(ndim*2,id2,1,tmps1,1)/3.0 
!dthetadl
            dtdegt(2*ndim+2,2*ndim+4) = ddot(ndim*2,id2,1,tmps2,1)/3.0 


!dadE
            tmps3 = dtdeg(2*ndim+1,1:2*ndim)
            dtdegt(2*ndim+3,1:2*ndim) = tmps3-id2*ddot(ndim*2,tmps3,1,id2,1)/3.0
!dadtheta
            dtdegt(2*ndim+3,2*ndim+2) =  ddot(ndim*2,tmps3,1,id2,1)/3.0
!dada
            dtdegt(2*ndim+3,2*ndim+3) =  dtdeg(2*ndim+1,2*ndim+1)
!dadl
            dtdegt(2*ndim+3,2*ndim+4) =  dtdeg(2*ndim+1,2*ndim+2)





!dldE
            tmps4 = dtdeg(2*ndim+2,1:2*ndim)            
            dtdegt(2*ndim+4,1:2*ndim) = tmps4-id2*ddot(ndim*2,tmps4,1,id2,1)/3.0
!dldtheta
            dtdegt(2*ndim+4,2*ndim+2) =  ddot(ndim*2,tmps4,1,id2,1)/3.0
!dlda            
            dtdegt(2*ndim+4,2*ndim+3) =  dtdeg(2*ndim+2,2*ndim+1)
!dldl
            dtdegt(2*ndim+4,2*ndim+4) =  dtdeg(2*ndim+2,2*ndim+2)
!             print*,'dtdegt(2*ndim+4,2*ndim+4)=',   dtdegt(2*ndim+4,2*ndim+4)
!dgradadgrada
            do 16 i = 1, ndim
                dtdegt(2*ndim+4+i,2*ndim+4+i) =  dtdeg(2*ndim+2+i,2*ndim+2+i)    
16          end do
! - MATRICE TANGENTE parite I : bT.H.b    H = dT/dE
!              print*,'dtdegt = ',dtdegt
!             temp1 = matmul(dtdegt,b)
            dmatr1 = matmul(matmul(transpose(b),dtdegt),b)
!             print*,'dmatr144=',dmatr1(4,4) 
!              dmatr1 = matmul(transpose(b),matmul(dtdegt,b))
!             print*,'dmatr1 = ',dmatr1
            matr = matr + poids*dmatr1
!             print*,'poids=', poids

!         call nmgrtg(ndim, nno, poids, g, vff,&
!                     dff, def, pff, option, axi,&
!                     r, fm, fp, dsidep, pk2m,&
!                     pk2, matsym, matuu, fu) 
! tpp = Tdev + p  
            tpp = 0.
            tpp(1:2*ndim) = tdev(1:2*ndim)+pp*kr(1:2*ndim)
            call deflg3(gn, feta, xi, me, tpp, tl)
            call symt46(tl, tls)
!             tls2(1:2*ndim,1:2*ndim) = tls(1:2*ndim,1:2*ndim) 
            dmatr2 = matmul(matmul(transpose(deff),tls),deff)
            matr2 = matr2 + poids*dmatr2

            sigpp = matmul(tpp,pes)
            
!           do 160 n = 1, nno
!               do 150 i = 1, ndim
!                   do 140 j =1, ndim
!                       do 130 m = 1, nno
!                           tmps5 = 0.d0
!                           if(j .eq. i) then
!                               do 131 k = 1, 2*ndim
!                                   tmps5 = pff(k,n,m)*sigpp(k) + tmps5
! 131                           end do
! !                           TERME DE CORRECTION AXISYMETRIQUE
!                               if (axi .and. i .eq. 1) then
!                                   tmps5=tmps5+vff(n,g)* vff(m,g)/(r*r)*sigpp(3)
!                               endif
!                           endif
!                           matr2((n-1)*ndim+i,(m-1)*ndim+j) = matr2((n-1)*ndim+i,(m-1)*ndim+j) + (tmps5)*poids
! 130                   continue
! 140               continue
! 150            continue
! 160        continue

            do 160 n = 1, nno
                do 150 i = 1, ndim
                    do 130 m = 1, nno
                        tmps5 = 0.d0
                        do 131 j = 1, 2*ndim
                            tmps5 = pff(j,n,m)*sigpp(j) + tmps5
131                     end do
    !                       TERME DE CORRECTION AXISYMETRIQUE
                        if (axi .and. i .eq. 1) then
                            tmps5=tmps5+vff(n,g)* vff(m,g)/(r*r)*sigpp(3)
                        endif
                        matr2((n-1)*ndim+i,(m-1)*ndim+i) = matr2((n-1)*ndim+i,(m-1)*ndim+i) + (tmps5)*poids
130                  end do
150             end do
160         end do
        
        endif

10  end do

!       print*,'matr_44=',matr(4,4)
!     print*,'ma1=',matr
!     print*,'ma2=',matr2


!             print*, 'bngv=',btot
    if (rigi) then
!       print*,'step-11'
        do 700 i =1, ndim
            do 710 j =1, ndim
                do 500 n = 1,nnob
                    do 510 m =1,nnob
                        matr(nu1(n,i),nu1(m,j)) = matr(nu1(n,i),nu1(m,j)) + matr2(uu1(n,i),uu1(m,j))
510                 end do
                    do 520 m =nnob+1, nno
                        matr(nu1(n,i),nu2(m,j)) = matr(nu1(n,i),nu2(m,j)) + matr2(uu1(n,i),uu1(m,j))
520                 end do
500             end do

                do 600 n = nnob+1,nno
                    do 610 m =1,nnob
                        matr(nu2(n,i),nu1(m,j)) = matr(nu2(n,i),nu1(m,j)) + matr2(uu1(n,i),uu1(m,j))
610                 end do
                    do 620 m =nnob+1, nno
                        matr(nu2(n,i),nu2(m,j)) = matr(nu2(n,i),nu2(m,j)) + matr2(uu1(n,i),uu1(m,j))
620                 end do
600             end do
710         end do
700     end do
    endif



      
! - SYNTHESE DES CODES RETOURS
!     print*, "étape 20"
!         print*, 'MgL=',matr 
!         print*, 'FgL=',fint 

!        print*, 'matr133=', matr(4,5)
!        print*, 'fint=',fint
!        print*, 'matr_tt2=',matr
!         print*, 'fint545=',fint
!       print*, 'fu=',fu
! !     print*, 'cod = ', cod
9999  continue
    call codere(cod, npg, codret)


!    if (abs(sigmg(1,3)-93.80922489903)<0.0001) then
!        print*,'TROUVE'
!        print*,'5f = ',fint
!        print*,'nddl=',nddl
!        print*,'ndim=',ndim
!        print*,'nno=',nno
!        print*,'nnob=',nnob
!        print*,'szMatr=',size(matr)
!        print*,'ddld=',ddld
!        print*,'5M=',matr
!     endif
!      if (resi) then
!        write (6,*) 'FINT RAPH_MECA = ',fint
!      end if
! print*,'sigpg =',sigpg
! print*,'fint545=',fint
! print*,'ddlm545=',ddlm+ddld
! print*,'pp545=',pp
! print*,'ttr545=',ttra

end subroutine
