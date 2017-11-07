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

subroutine ngvlog(fami, option, typmod, ndim, nno,nnob,neps,&
                  npg, nddl, iw, vff, vffb, idff,idffb,&
                  geomi, compor, mate, lgpg,&
                  crit, angmas, instm, instp, matsym,&
                  ddlm, ddld, sigmg, vim, sigpg,&
                  vipout, fint,matr, codret)


    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/lcegeo.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"
#include "asterfort/nmgrtg.h"
#include "asterfort/poslog.h"
#include "asterfort/prelog.h"
#include "asterfort/r8inir.h"
#include "asterfort/utmess.h"
#include "asterfort/lggvmb.h"
#include "asterfort/nmfdff.h"
#include "asterfort/deflg2.h"
#include "asterfort/deflg3.h"
#include "asterfort/symt46.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dgemm.h"
#include "blas/dgemv.h"

! aslint: disable=W1504

! -------------------------------------------------------------------------------------------------
    aster_logical    :: matsym
    integer          :: nddl,ndim, nno,nnob,npg,mate,lgpg, codret
    integer          :: iw, idff, idffb,neps
    character(len=8) :: typmod(*)
    character(len=*) :: fami
    character(len=16):: option, compor(*)
    real(kind=8)     :: geomi(ndim,nno), crit(*), instm, instp
    real(kind=8)     :: vff(nno, npg),vffb(nnob, npg)
    real(kind=8)     :: angmas(3), ddlm(nddl), ddld(nddl), sigmg(neps, npg),sigpg(neps, npg)
    real(kind=8)     :: vim(lgpg, npg), vipout(lgpg, npg)
    real(kind=8)     :: fint(nddl)
    real(kind=8)     :: matr(nddl,nddl)
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
! ----------------------------------------------------------------------
    aster_logical, parameter :: grand = ASTER_TRUE
    aster_logical, parameter :: cplan = ASTER_FALSE
! ----------------------------------------------------------------------
    aster_logical:: axi, resi, rigi
    integer      :: g,i,j,n,m,cod(npg),nddl1
    real(kind=8) :: dff(nno,ndim)
    real(kind=8) :: dffb(nnob,ndim)
    real(kind=8) :: dtdeg(neps, neps)
    real(kind=8) :: dtde(6,6)
    real(kind=8) :: epsml(6)
    real(kind=8) :: sigp(2*ndim)
    real(kind=8) :: sigm(2*ndim)
    real(kind=8) :: geomm(ndim,nno), geomp(ndim,nno), fm(3, 3), fp(3, 3),fr(3, 3)
    real(kind=8) :: deplt(nno*ndim), deplm(nno*ndim), depld(nno*ndim)
    real(kind=8) :: r, poids, tm(6), tp(6), deps(6),tmg(neps),tpg(neps)
    real(kind=8) :: gn(3, 3), lamb(3), logl(3), rbid(1), tbid(6)
    real(kind=8) :: dsidep(6,6), pk2(6), pk2m(6),vip(lgpg)
    real(kind=8) :: me(3, 3, 3, 3), xi(3, 3), feta(4), pes(6, 6)
    real(kind=8) :: epmlg(neps), depsg(neps),jp
    real(kind=8) :: fu(nno*ndim)
! ----------------------------------------------------------------------
    real(kind=8), allocatable:: def(:,:,:),pff(:,:,:),deff(:,:),bst(:,:),matuu(:,:),b(:,:),bb(:,:)
! ----------------------------------------------------------------------
#define nu1(n,i)  (n-1)*(ndim+2) + i
#define nu2(n,i)  nnob*2 + (n-1)*ndim + i
#define uu1(n,i)  (n-1)*ndim+i
! ----------------------------------------------------------------------

! Tests de coherence
    ASSERT(nddl.eq.nno*ndim + nnob*2)

! - INITIALISATION 

    axi  = typmod(1).eq.'AXIS'
    resi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RAPH_MECA'
    rigi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'

    nddl1 = nno*ndim
    nddl  = nno*ndim+2*nnob

    allocate (def(2*ndim, nno,ndim))
    allocate (pff(2*ndim, nno, nno))
    allocate (deff(6, nno*ndim))
    allocate (bst(6,nno*ndim))
    allocate (matuu(nno*ndim,nno*ndim))
    allocate (b(neps, nddl))
    allocate (bb(neps, nddl))

    if (resi) fint  = 0
    if (rigi) matr = 0

    matuu = 0
    fu    = 0
    tp    = 0
    deff  = 0
    bst   = 0
    cod   = 0  
    pk2m  = 0
    sigm  = 0
    dtde  = 0
    vip   = 0


!
!------------------------------DEPLACEMENT ET GEOMETRIE-------------
!
!    DETERMINATION DES CONFIGURATIONS EN T- (GEOMM) ET T+ (GEOMP)
    do n = 1, nnob
       call dcopy(ndim, ddlm((ndim+2)*(n-1)+1), 1, deplm(ndim*(n-1)+1), 1)
       call dcopy(ndim, ddld((ndim+2)*(n-1)+1), 1, depld(ndim*(n-1)+1), 1)
    end do
    call dcopy(ndim*(nno-nnob), ddlm((ndim+2)*nnob+1), 1, deplm(ndim*nnob+1), 1)
    call dcopy(ndim*(nno-nnob), ddld((ndim+2)*nnob+1), 1, depld(ndim*nnob+1), 1)

    call dcopy(nddl1, geomi, 1, geomm, 1)
    call daxpy(nddl1, 1.d0, deplm, 1, geomm,1)
    call dcopy(nddl1, geomm, 1, geomp, 1)
    call dcopy(nddl1, deplm, 1, deplt, 1)

    if (resi) then
        call daxpy(nddl1, 1.d0, depld, 1, geomp,1)
        call daxpy(nddl1, 1.d0, depld, 1, deplt,1)
    endif



! ****************************BOUCLE SUR LES POINTS DE GAUSS************

! - CALCUL POUR CHAQUE POINT DE GAUSS

    do g = 1, npg

! ---     CALCUL DE F_N, F_N+1 PAR RAPPORT A GEOMI GEOM INITIAL
        call dfdmip(ndim, nno, axi, geomi, g,iw, vff(1, g), idff, r, poids, dff)
        call dfdmip(ndim, nnob, axi, geomi, g,iw, vffb(1,g), idffb, r, poids,dffb)
        call nmepsi(ndim, nno, axi, grand, vff(1, g),r, dff, deplm, fm, tbid)
        call nmepsi(ndim, nno, axi, grand, vff(1, g),r, dff, deplt, fp, tbid)

        jp = fp(1,1)*(fp(2,2)*fp(3,3)-fp(2,3)*fp(3,2)) &
           - fp(2,1)*(fp(1,2)*fp(3,3)-fp(1,3)*fp(3,2)) & 
           + fp(3,1)*(fp(1,2)*fp(2,3)-fp(1, 3)*fp(2,2))   

        if (jp .le. 0) then
            cod = 1
            goto 999
        endif

        fr = merge(fp,fm,resi)
  
        call nmfdff(ndim, nno, axi, g, r,rigi, matsym, fr, vff, dff,def, pff)     

        do m = 1,2*ndim
            do n =1,nno
                do i = 1,ndim
                    deff(m,(n-1)*ndim+i) = def(m,n,i)
                end do
            end do
       end do


!---     CALCUL de pes : projetcteur de T vers S(Pk2), PES = 2dE/dC              
        call prelog(ndim, lgpg, vim(1, g), gn, lamb,logl, fm, fp, epsml, deps, tm, resi, cod(g))
        if (cod(g) .eq. 1) then
            goto 999
        endif
        call deflg2(gn, lamb, logl, pes, feta, xi, me)    

!-----------------------------------------------------------------------------
! CONSTRUIRE LA MATRICE b(neps,nddl), UTILE POUR CALCULER EPMLG, FINT ET MATR
!-----------------------------------------------------------------------------

        bst = matmul(pes,deff)
        call lggvmb(ndim,nno,nnob,axi,r,&
                    bst,vffb(1,g),dffb,nddl,&
                    neps,b)

!-----------------------------------------------------------------------------
! CALCULER LES DEFORMATIONS GENERALISEES
!-----------------------------------------------------------------------------
        call dgemv('N', neps, nddl, 1.d0, b,neps, ddlm, 1, 0.d0, epmlg,1)   
        call dgemv('N', neps, nddl, 1.d0, b,neps, ddld, 1, 0.d0, depsg,1)

        epmlg = epsml(1:2*ndim)
        depsg = deps(1:2*ndim)

!-----------------------------------------------------------------------------
! COPIER LES CONTRAINTES DANS T- QUI PASSERA DANS LA LOI DE COMPORTEMENT 
!------------------------------------------------------------------------------       
        call dcopy(2*ndim, tm, 1, tmg, 1)
        call dcopy(2+ndim,sigmg(2*ndim+1,g),1,tmg(2*ndim+1),1)
        call dcopy(2*ndim,sigmg(1,g),1,sigm,1)


        if (cod(g) .ne. 0) goto 999
        call r8inir(neps*neps, 0.d0, dtdeg, 1)
        call r8inir(neps, 0.d0, tpg, 1)

        call nmcomp(fami, g, 1, ndim, typmod,&
                    mate, compor, crit, instm, instp,&
                    neps, epmlg, depsg, neps, tmg,&
                    vim(1, g), option, angmas, 1,rbid,&
                    tpg, vip, neps*neps, dtdeg, 1,&
                    rbid, cod(g))


!        TEST SUR LES CODES RETOUR DE LA LOI DE COMPORTEMENT
        if (cod(g) .eq. 1) then
            goto 999
        endif

        call dcopy(2*ndim, tpg, 1, tp, 1)

!-----------------------------------------------------------------------------
! COPIER LA PARTIE "DEPLACEMENT" DANS LA MATRICE TANGENTE
!------------------------------------------------------------------------------    
        do i = 1,ndim*2
            do j = 1, ndim*2
               dtde(i,j) = dtdeg(i,j) 
            end do
        end do

        call poslog(resi, rigi, tm, tp, fm,&
                    lgpg, vip, ndim, fp, g,&
                    dtde, sigm, cplan, fami, mate,&
                    instp, angmas, gn, lamb, logl,&
                    sigp, dsidep, pk2m, pk2, cod(g))
  
        if (cod(g) .eq. 1) then
            goto 999
        endif

!     CALCUL DE LA MATRICE DE RIGIDITE ET DE LA FORCE INTERIEURE
!     CONFG LAGRANGIENNE COMME NMGR3D / NMGR2D

!

! - FORCE INTERIEURE
        if (resi) then          
            call dcopy(2*ndim, sigp, 1, sigpg(1,g), 1)
            call dcopy(2+ndim, tpg(2*ndim+1), 1, sigpg(2*ndim+1,g), 1)
            fint = fint + poids*matmul(transpose(b),tpg)
            vipout(:,g) = vip(:)
        endif


!------------------------------------------------------------------
! - MATRICE TANGENTE
!------------------------------------------------------------------
! - MATRICE : bT.H.b    H = dT/dE, PARTIE DEPLACEMENT NON CORRECTE

        if (rigi) then 
            matr = matr + poids*matmul(transpose(b),matmul(dtdeg,b))
        endif

! - MATRICE TANGENTE PARTIE DEPLACEMENT, EN PROFITANT QU'IL SOIT LE MEME QUE LE MODELE LOCAL
        call nmgrtg(ndim, nno, poids, g, vff,&
                    dff, def, pff, option, axi,&
                    r, fm, fp, dsidep, pk2m,&
                    pk2, matsym, matuu, fu)                 
    end do

 
!- REMPLACER MATUU DANS LA PARTIE DEPLACEMENT DE MATR   
    if (rigi) then
        do i =1, ndim
            do j =1, ndim
                do n = 1,nnob
                    do m =1,nnob
                        matr(nu1(n,i),nu1(m,j)) = matuu(uu1(n,i),uu1(m,j))
                    end do
                    do m =nnob+1, nno
                        matr(nu1(n,i),nu2(m,j)) = matuu(uu1(n,i),uu1(m,j))
                    end do
                end do

                do n = nnob+1,nno
                    do m =1,nnob
                        matr(nu2(n,i),nu1(m,j)) = matuu(uu1(n,i),uu1(m,j))
                    end do
                    do m =nnob+1, nno
                        matr(nu2(n,i),nu2(m,j)) = matuu(uu1(n,i),uu1(m,j))
                    end do
                end do
            end do
        end do
    endif


999  continue
    if (resi) call codere(cod, npg, codret)

    deallocate(def,pff,deff,bst,matuu,b,bb)
end subroutine
