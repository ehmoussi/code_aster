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
 
use bloc_fe_module, only: prod_bd, prod_sb, prod_bkb, add_fint, add_matr


    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"


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
    aster_logical, parameter               :: grand=ASTER_TRUE
    real(kind=8), parameter                :: tiers = 1.d0/3.d0
    real(kind=8), dimension(6), parameter  :: kron    = (/  1.d0,  1.d0,  1.d0, 0.d0, 0.d0, 0.d0 /)
    real(kind=8), dimension(6), parameter  :: projhyd = (/ tiers, tiers, tiers, 0.d0, 0.d0, 0.d0 /)
    real(kind=8), dimension(6,6), parameter:: projdev = reshape( &
        (/ 2*tiers,  -tiers,  -tiers, 0.d0, 0.d0, 0.d0, &
            -tiers, 2*tiers,  -tiers, 0.d0, 0.d0, 0.d0, &
            -tiers,  -tiers, 2*tiers, 0.d0, 0.d0, 0.d0, &
              0.d0,    0.d0,    0.d0, 1.d0, 0.d0, 0.d0, &
              0.d0,    0.d0,    0.d0, 0.d0, 1.d0, 0.d0, &
              0.d0,    0.d0,    0.d0, 0.d0, 0.d0, 1.d0  /), (/6,6/))
! ----------------------------------------------------------------------
    type(GDLOG_DS):: gdlm,gdlp
    aster_logical :: resi, rigi, axi
    integer       :: g,n,i
    integer       :: xu(ndim,nno),xg(2,nnob),xq(2,nnob)
    integer       :: cod(npg)
    integer       :: nnu,nng,nnq,ndu,ndg,ndq,neu,neg,neq
    real(kind=8)  :: dev(2*ndim,2*ndim),hyd(2*ndim),kr(2*ndim)
    real(kind=8)  :: r,dff(nno,ndim),dffb(nnob,ndim),poids
    real(kind=8)  :: fm(3,3), fp(3,3)
    real(kind=8)  :: bu(2*ndim,ndim,nno),bg(2+ndim,2,nnob),bq(2,2,nnob)
    real(kind=8)  :: dum(ndim,nno),dup(ndim,nno)
    real(kind=8)  :: dgm(2,nnob),dgp(2,nnob)
    real(kind=8)  :: dqm(2,nnob),dqp(2,nnob)
    real(kind=8)  :: epefum(2*ndim),epefgm(2+ndim),epefqm(2)
    real(kind=8)  :: epefup(2*ndim),epefgp(2+ndim),epefqp(2)
    real(kind=8)  :: siefup(2*ndim),siefgp(2+ndim),siefqp(2)
    real(kind=8)  :: eplcm(3*ndim+2),eplcp(3*ndim+2)
    real(kind=8)  :: silcm(3*ndim+2),silcp(3*ndim+2)
    real(kind=8)  :: dsde(3*ndim+2,3*ndim+2)
    real(kind=8)  :: t(2*ndim)
    real(kind=8)  :: dee(2*ndim,2*ndim),deg(2*ndim,2+ndim),dge(2+ndim,2*ndim),dgg(2+ndim,2+ndim)
    real(kind=8)  :: kefuu(2*ndim,2*ndim),kefug(2*ndim,2+ndim),kefuq(2*ndim,2    )
    real(kind=8)  :: kefgu(2+ndim,2*ndim),kefgg(2+ndim,2+ndim),kefgq(2+ndim,2    )
    real(kind=8)  :: kefqu(2     ,2*ndim),kefqg(2     ,2+ndim),kefqq(2     ,2    )
    real(kind=8)  :: rbid=0.d0
    real(kind=8)  :: tbid(6)=(/0.d0,0.d0,0.d0,0.d0,0.d0,0.d0/)
! ----------------------------------------------------------------------


! Remarque sur l'ordre des composantes (cf. grandeurs premieres)
! degres de liberte : DX,DY,DZ,PRES,GONF,VARI,LAG_GV
! Contraintes EF    : SIXX, .., SIYZ, SIGONF, SIP, SIGV_A, SIGV_L, SIGV_GX, ..., SIVG_GZ, 
! Deformations ldc  : R2*EPXX, ..., R2*EPZZ, A, L, GX, ..., GZ 


! --- INITIALISATION ---

    axi  = typmod(1).eq.'AXIS'
    resi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RAPH_MECA'
    rigi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'

    nnu = nno
    nng = nnob
    nnq = nnob
    ndu = ndim
    ndg = 2
    ndq = 2
    neu = 2*ndim
    neg = 2+ndim
    neq = 2
    kr  = kron(1:neu)
    hyd = projhyd(1:neu)
    dev = projdev(1:neu,1:neu)

    call gdlog_init(gdlm,ndu,nnu,axi,rigi)
    call gdlog_init(gdlp,ndu,nnu,axi,rigi)
    if (resi) fint = 0
    if (rigi) matr = 0
    cod = 0  

    ! tableaux de reference bloc (depl,inco,grad) -> numero du ddl
    forall (i=1:ndg,n=1:nng) xg(i,n) = (n-1)*(ndu+ndg+ndq) + ndu + ndq + i
    forall (i=1:ndq,n=1:nnq) xq(i,n) = (n-1)*(ndu+ndg+ndq) + ndu + i
    forall (i=1:ndu,n=1:nng) xu(i,n) = (n-1)*(ndu+ndg+ndq) + i
    forall (i=1:ndu,n=nng+1:nnu) xu(i,n) = (ndu+ndg+ndq)*nng + (n-1-nng)*ndu + i

    ! Decompactage des ddls en t- et t+
    forall (i=1:ndu, n=1:nnu) dum(i,n) = ddlm(xu(i,n))
    forall (i=1:ndg, n=1:nng) dgm(i,n) = ddlm(xg(i,n))
    forall (i=1:ndq, n=1:nnq) dqm(i,n) = ddlm(xq(i,n))
    forall (i=1:ndu, n=1:nnu) dup(i,n) = dum(i,n) + ddld(xu(i,n))
    forall (i=1:ndq, n=1:nnq) dgp(i,n) = dgm(i,n) + ddld(xg(i,n))
    forall (i=1:ndg, n=1:nng) dqp(i,n) = dqm(i,n) + ddld(xq(i,n))

    
    gauss: do g = 1, npg
 
        ! -----------------------!
        !  ELEMENTS CINEMATIQUES !
        ! -----------------------!

        ! Calcul des derivees des fonctions de forme P1 
        call dfdmip(ndim, nnob, axi, geomi, g, iw, vffb(1,g), idffb, r, poids,dffb)

        ! Calcul des derivees des fonctions de forme P2, du rayon r et des poids
        call dfdmip(ndim, nno, axi, geomi, g, iw, vff(1, g), idff, r, poids, dff)

        ! Calcul de la deformation mecanique en t- (fm et epm)
        call nmepsi(ndim, nno, axi, grand, vff(1,g), r, dff, dum, fm, tbid)
        call gdlog_defo(gdlm,fm,epefum,cod(g))
        if (cod(g).ne.0) goto 999

        ! Calcul de la deformation mecanique et des elements cinematiques en t+
        call nmepsi(ndim, nno, axi, grand, vff(1,g),r, dff, dup, fp, tbid)
        call gdlog_defo(gdlp,fp,epefup,cod(g))
        if (cod(g).ne.0) goto 999

        ! Calcul des matrices BU, BG et BQ
        call gdlog_matb(gdlp,r,vff(:,g),dff,bu)
        bg = 0
        bg(1,1,:) = vffb(:,g)
        bg(2,2,:) = vffb(:,g)
        bg(3:neg,1,:) = transpose(dffb)
        bq = 0
        bq(1,1,:) = vffb(:,g)
        bq(2,2,:) = vffb(:,g)

        ! Calcul des deformations non mecaniques  aux points de Gauss
        epefgm = prod_bd(bg,dgm)
        epefgp = prod_bd(bg,dgp)
        epefqm = prod_bd(bq,dqm)
        epefqp = prod_bd(bq,dqp)
       

        ! -----------------------!
        !   LOI DE COMPORTEMENT  !
        ! -----------------------!

        ! Preparation des deformations generalisees de ldc en t- et t+  
        eplcm(1:neu) = matmul(dev,epefum) + epefqm(2)*hyd
        eplcp(1:neu) = matmul(dev,epefup) + epefqp(2)*hyd
        eplcm(neu+1:neu+neg) = epefgm
        eplcp(neu+1:neu+neg) = epefgp

        ! Preparation des contraintes generalisees de ldc en t-
        silcm(1:neu) = vim(lgpg-5:lgpg-6+neu,g)
        silcm(neu+1:neu+neg) = siefm(neu+1:neu+neg,g)

        ! Comportement
        call nmcomp(fami, g, 1, ndim, typmod,&
                    mate, compor, crit, instm, instp,&
                    neu+neg, eplcm, eplcp-eplcm, neu+neg, silcm,&
                    vim(1,g), option, angmas, 1,[rbid],&
                    silcp, vip(1,g), (neu+neg)*(neu+neg), dsde, 1,&
                    [rbid], cod(g))
        if (cod(g) .eq. 1) goto 999

        ! Archivage des contraintes mecaniques en t+ (tau tilda) dans les vi
        if (resi) then
            vip(lgpg-5:lgpg-6+neu,g) = silcp(1:neu)
        end if


        ! ----------------------------------------!
        !   FORCES INTERIEURES ET CONTRAINTES EF  !
        ! ----------------------------------------!

        if (resi) then

            ! Contraintes generalisees EF par bloc
            t = silcp(1:neu)
            siefup = matmul(dev,t) + epefqp(1)*kr
            siefgp = silcp(neu+1:neu+neg)
            siefqp = (/ dot_product(kr,epefup)-epefqp(2), dot_product(hyd,t)-epefqp(1) /)

            ! Forces interieures au point de Gauss g
            call add_fint(fint,xu,poids*prod_sb(siefup,bu))
            call add_fint(fint,xg,poids*prod_sb(siefgp,bg))
            call add_fint(fint,xq,poids*prod_sb(siefqp,bq))
            
            ! Stockage des contraintes generalisees (avec Cauchy au lieu de T)
            siefp(1:neu,g) = gdlog_nice_cauchy(gdlp,siefup)
            siefp(neu+1:neu+neq,g) = siefqp
            siefp(neu+neq+1:neu+neq+neg,g) = siefgp

        endif


        ! -----------------------!
        !    MATRICE TANGENTE    !
        ! -----------------------!
    
        if (rigi) then

            ! Contraintes generalisees EF (bloc mecanique pour la rigidite geometrique)
            if (.not. resi) then
                t = silcm(1:neu)
                siefup = matmul(dev,t) + epefqm(1)*kr
            end if

            ! Rigidite geometrique
            call add_matr(matr,xu,xu,poids*gdlog_rigeo(gdlp,siefup))

            ! Blocs de la matrice tangente du comportement
            dee = dsde(1:neu,1:neu)
            deg = dsde(1:neu,neu+1:neu+neg)
            dge = dsde(neu+1:neu+neg,1:neu)
            dgg = dsde(neu+1:neu+neg,neu+1:neu+neg)

            ! Construction des blocs de la matrice tangente EF
            kefuu = matmul(matmul(dev,dee),dev)
            kefug = matmul(dev,deg)
            kefuq(:,1) = kr
            kefuq(:,2) = matmul(matmul(dev,dee),hyd)
            kefgu = matmul(dge,dev)
            kefgg = dgg
            kefgq(:,1) = 0
            kefgq(:,2) = matmul(dge,hyd)
            kefqu(1,:) = kr
            kefqu(2,:) = matmul(matmul(hyd,dee),dev)
            kefqg(1,:) = 0
            kefqg(2,:) = matmul(hyd,deg)
            kefqq(1,1) = 0
            kefqq(1,2) = -1
            kefqq(2,1) = -1
            kefqq(2,2) = dot_product(matmul(hyd,dee),hyd)

            ! Assemblage des blocs de la matrice EF
            if (.not. matsym) then
                call add_matr(matr,xu,xu,poids*prod_bkb(bu,kefuu,bu))
                call add_matr(matr,xu,xg,poids*prod_bkb(bu,kefug,bg))
                call add_matr(matr,xu,xq,poids*prod_bkb(bu,kefuq,bq))
                call add_matr(matr,xg,xu,poids*prod_bkb(bg,kefgu,bu))
                call add_matr(matr,xg,xg,poids*prod_bkb(bg,kefgg,bg))
                call add_matr(matr,xg,xq,poids*prod_bkb(bg,kefgq,bq))
                call add_matr(matr,xq,xu,poids*prod_bkb(bq,kefqu,bu))
                call add_matr(matr,xq,xg,poids*prod_bkb(bq,kefqg,bg))
                call add_matr(matr,xq,xq,poids*prod_bkb(bq,kefqq,bq))
            else
                ASSERT(.false.)
            end if
        end if

    end do gauss


! - SYNTHESE DES CODES RETOURS ET LIBERATION DES OBJETS
999 continue
    if (resi) call codere(cod, npg, codret)
    call gdlog_delete(gdlm)
    call gdlog_delete(gdlp)

end subroutine
