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
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1306,W1504
!
subroutine nufilg(ndim, nnod, nnop, npg, iw,&
                  vffd, vffp, idff1, vu, vp,&
                  geomi, typmod, option, mate, compor,&
                  lgpg, crit, instm, instp, ddlm,&
                  ddld, angmas, sigm, vim, sigp,&
                  vip, resi, rigi, vect, matr,&
                  matsym, codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/dsde2d.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"
#include "asterfort/nmmalu.h"
#include "asterfort/pmat.h"
#include "asterfort/poslog.h"
#include "asterfort/prelog.h"
#include "asterfort/r8inir.h"
#include "asterfort/tanbul.h"
#include "asterfort/utmess.h"
#include "blas/dcopy.h"
#include "blas/ddot.h"
#include "blas/dscal.h"
    aster_logical :: resi, rigi, matsym
    integer :: ndim, nnod, nnop, npg, iw, idff1, lgpg
    integer :: mate
    integer :: vu(3, 27), vp(27)
    integer :: codret
    real(kind=8) :: vffd(nnod, npg), vffp(nnop, npg)
    real(kind=8) :: instm, instp
    real(kind=8) :: geomi(ndim, nnod), ddlm(*), ddld(*), angmas(*)
    real(kind=8) :: sigm(2*ndim+1, npg), sigp(2*ndim+1, npg)
    real(kind=8) :: vim(lgpg, npg), vip(lgpg, npg)
    real(kind=8) :: vect(*), matr(*)
    real(kind=8) :: crit(*)
    character(len=8) :: typmod(*)
    character(len=16) :: compor(*), option
!-----------------------------------------------------------------------
!          CALCUL DES FORCES INTERNES POUR LES ELEMENTS
!          INCOMPRESSIBLES POUR LES GRANDES DEFORMATIONS
!          3D/D_PLAN/AXIS
!-----------------------------------------------------------------------
! IN  RESI    : CALCUL DES FORCES INTERNES
! IN  RIGI    : CALCUL DE LA MATRICE DE RIGIDITE
! IN  MATSYM  : MATRICE TANGENTE SYMETRIQUE OU NON
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  nnod    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
! IN  nnop    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  IW      : POIDS DES POINTS DE GAUSS
! IN  vffd    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
! IN  vffp    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
! IN  IDFF1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  VU      : TABLEAU DES INDICES DES DDL DE DEPLACEMENTS
! IN  VP      : TABLEAU DES INDICES DES DDL DE PRESSION
! IN  GEOMI   : COORDONEES DES NOEUDS
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  MATE    : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
! IN  INSTM   : INSTANT PRECEDENT
! IN  INSTP   : INSTANT DE CALCUL
! IN  DDLM    : DEGRES DE LIBERTE A L'INSTANT PRECEDENT
! IN  DDLD    : INCREMENT DES DEGRES DE LIBERTE
! IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
! IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
! IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
! OUT VECT    : FORCES INTERNES
! OUT MATR    : MATRICE DE RIGIDITE (RIGI_MECA_TANG ET FULL_MECA)
! OUT CODRET  : CODE RETOUR
!-----------------------------------------------------------------------
!
    aster_logical :: axi, grand
    integer :: g, nddl, ndu
    integer :: ia, na, sa, ib, nb, rb, sb, ja, jb
    integer :: lij(3, 3), vij(3, 3), os, kk
    integer :: viaja, vibjb, vuiana, vpsa
    integer :: cod(27)
    real(kind=8) :: geomm(3*27), geomp(3*27), deplm(3*27), deplp(3*27)
    real(kind=8) :: r, w, wp, dff1(nnod, 4)
    real(kind=8) :: presm(27), presd(27)
    real(kind=8) :: pm, pd, pp
    real(kind=8) :: fm(3, 3), jm, ftm(3, 3), corm, epsml(6)
    real(kind=8) :: fp(3, 3), jp, ftp(3, 3), corp, deps(6)
    real(kind=8) :: gn(3, 3), lamb(3), logl(3)
    real(kind=8) :: tn(6), tp(6), dtde(6, 6)
    real(kind=8) :: pk2(6), pk2m(6)
    real(kind=8) :: taup(6), taudv(6), tauhy, tauldc(6)
    real(kind=8) :: dsidep(6, 6)
    real(kind=8) :: d(6, 6), ddev(6, 6), devd(6, 6), dddev(6, 6)
    real(kind=8) :: iddid
    real(kind=8) :: ftr(3, 3), t1, t2
    real(kind=8) :: idev(6, 6), kr(6)
    real(kind=8) :: tampon(10), id(3, 3), rbid(1)
    real(kind=8) :: sigtr
    real(kind=8) :: alpha, trepst
    real(kind=8) :: dsbdep(2*ndim, 2*ndim)
!
    parameter    (grand = .true._1)
    data         vij  / 1, 4, 5,&
     &                  4, 2, 6,&
     &                  5, 6, 3 /
    data         kr   / 1.d0, 1.d0, 1.d0, 0.d0, 0.d0, 0.d0/
    data         id   / 1.d0, 0.d0, 0.d0,&
     &                  0.d0, 1.d0, 0.d0,&
     &                  0.d0, 0.d0, 1.d0/
    data         idev / 2.d0,-1.d0,-1.d0, 0.d0, 0.d0, 0.d0,&
     &                 -1.d0, 2.d0,-1.d0, 0.d0, 0.d0, 0.d0,&
     &                 -1.d0,-1.d0, 2.d0, 0.d0, 0.d0, 0.d0,&
     &                  0.d0, 0.d0, 0.d0, 3.d0, 0.d0, 0.d0,&
     &                  0.d0, 0.d0, 0.d0, 0.d0, 3.d0, 0.d0,&
     &                  0.d0, 0.d0, 0.d0, 0.d0, 0.d0, 3.d0/
!-----------------------------------------------------------------------
!
! - INITIALISATION
    axi = typmod(1).eq.'AXIS'
    nddl = nnod*ndim + nnop
    ndu = ndim
    if (axi) ndu = 3
!
! - REACTUALISATION DE LA GEOMETRIE ET EXTRACTION DES CHAMPS
    do na = 1, nnod
        do ia = 1, ndim
            geomm(ia+ndim*(na-1)) = geomi(ia,na) + ddlm(vu(ia,na))
            geomp(ia+ndim*(na-1)) = geomm(ia+ndim*(na-1))+ddld(vu(ia, na))
            deplm(ia+ndim*(na-1)) = ddlm(vu(ia,na))
            deplp(ia+ndim*(na-1)) = ddlm(vu(ia,na))+ddld(vu(ia,na))
        end do
    end do
!
    do sa = 1, nnop
        presm(sa) = ddlm(vp(sa))
        presd(sa) = ddld(vp(sa))
    end do
!
    if (resi) call r8inir(nddl, 0.d0, vect, 1)
    if (rigi) then
        if (matsym) then
            call r8inir(nddl*(nddl+1)/2, 0.d0, matr, 1)
        else
            call r8inir(nddl*nddl, 0.d0, matr, 1)
        endif
    endif
!
    call r8inir(36, 0.d0, dsidep, 1)
!
! - CALCUL POUR CHAQUE POINT DE GAUSS
    do g = 1, npg
!
! - CALCUL DES DEFORMATIONS
        call dfdmip(ndim, nnod, axi, geomi, g,&
                    iw, vffd(1, g), idff1, r, w,&
                    dff1)
        call nmepsi(ndim, nnod, axi, grand, vffd(1, g),&
                    r, dff1, deplm, fm)
        call nmepsi(ndim, nnod, axi, grand, vffd(1, g),&
                    r, dff1, deplp, fp)
        call dfdmip(ndim, nnod, axi, geomp, g,&
                    iw, vffd(1, g), idff1, r, wp,&
                    dff1)
!
        call nmmalu(nnod, axi, r, vffd(1, g), dff1,&
                    lij)
!
        jm = fm(1,1)*(fm(2,2)*fm(3,3)-fm(2,3)*fm(3,2)) - fm(2,1)*(fm(1,2)*fm(3,3)-fm(1,3)*fm(3,2)&
             &) + fm(3,1)*(fm(1,2)*fm(2,3)-fm(1,3)*fm(2,2))
        jp = fp(1,1)*(fp(2,2)*fp(3,3)-fp(2,3)*fp(3,2)) - fp(2,1)*(fp(1,2)*fp(3,3)-fp(1,3)*fp(3,2)&
             &) + fp(3,1)*(fp(1,2)*fp(2,3)-fp(1,3)*fp(2,2))
!
        if (jp .le. 0.d0) then
            codret = 1
            goto 999
        endif
!
! - CALCUL DE LA PRESSION ET DU GONFLEMENT AU POINT DE GAUSS
        pm = ddot(nnop,vffp(1,g),1,presm,1)
        pd = ddot(nnop,vffp(1,g),1,presd,1)
        pp = pm+pd
!
! - CALCUL DES DEFORMATIONS ENRICHIES
        corm = (1.d0/jm)**(1.d0/3.d0)
        call dcopy(9, fm, 1, ftm, 1)
        call dscal(9, corm, ftm, 1)
!
        corp = (1.d0/jp)**(1.d0/3.d0)
        call dcopy(9, fp, 1, ftp, 1)
        call dscal(9, corp, ftp, 1)
!
! - APPEL A LA LOI DE COMPORTEMENT
        cod(g) = 0
        call r8inir(36, 0.d0, dtde, 1)
        call r8inir(6, 0.d0, tp, 1)
        call r8inir(6, 0.d0, taup, 1)
!
        call prelog(ndim, lgpg, vim(1, g), gn, lamb,&
                    logl, ftm, ftp, epsml, deps,&
                    tn, resi, cod(g))
!
        call nmcomp('RIGI', g, 1, ndim, typmod,&
                    mate, compor, crit, instm, instp,&
                    6, epsml, deps, 6, tn,&
                    vim(1, g), option, angmas, 10, tampon,&
                    tp, vip(1, g), 36, dtde, 1,&
                    rbid, cod(g))
!
! - DSIDEP = 2dS/dC = dS/dE_GL
        call poslog(resi, rigi, tn, tp, ftm,&
                    lgpg, vip(1, g), ndim, ftp, g,&
                    dtde, sigm(1, g), .false._1, 'RIGI', mate,&
                    instp, angmas, gn, lamb, logl,&
                    sigp( 1, g), dsidep, pk2m, pk2, cod(g))
!
        if (cod(g) .eq. 1) then
            codret = 1
            if (.not. resi) then
                call utmess('F', 'ALGORITH14_75')
            endif
            goto 999
        endif
!
! - CALCUL DE ALPHA ET DE TREPST
        call tanbul(option, ndim, g, mate, compor(1),&
                    resi, .false._1, alpha, dsbdep, trepst)
!
! - CALCUL DE LA FORCE INTERIEURE ET DES CONTRAINTES DE CAUCHY
        if (resi) then
            call dcopy(2*ndim, sigp(1, g), 1, taup, 1)
            call dscal(2*ndim, 1.d0/jp, sigp(1, g), 1)

            sigtr = sigp(1,g)+sigp(2,g)+sigp(3,g)
            do ia = 1, 3
                sigp(ia,g) = sigp(ia,g) + ((pm+pd)/jp-sigtr/3.d0)
            end do
            sigp(2*ndim+1,g) = sigtr/3.d0 - (pm+pd)/jp
!
! - CONTRAINTE HYDROSTATIQUE ET DEVIATEUR
            tauhy = (taup(1)+taup(2)+taup(3))/3.d0
            do ia = 1, 6
                taudv(ia) = taup(ia) - tauhy*kr(ia)
            end do
!
! - VECTEUR FINT:U
            do na = 1, nnod
                do ia = 1, ndu
                    kk = vu(ia,na)
                    t1 = 0.d0
                    do ja = 1, ndu
                        t2 = taudv(vij(ia,ja)) + pp*id(ia,ja)
                        t1 = t1 + t2*dff1(na,lij(ia,ja))
                    end do
                    vect(kk) = vect(kk) + w*t1
                end do
            end do
!
! - VECTEUR FINT:P
            t2 = log(jp) - pp*alpha-trepst
            do sa = 1, nnop
                kk = vp(sa)
                t1 = vffp(sa,g)*t2
                vect(kk) = vect(kk) + w*t1
            end do
        endif
!
! - MATRICE TANGENTE
        if (rigi) then
            if (resi) then
                call dcopy(9, ftp, 1, ftr, 1)
            else
                call dcopy(2*ndim, sigm(1, g), 1, taup, 1)
                call dscal(2*ndim, jm, taup, 1)
                call dcopy(9, ftm, 1, ftr, 1)
            endif
!
! - CALCUL DE L'OPERATEUR TANGENT SYMÉTRISÉ D
            call dsde2d(3, ftr, dsidep, d)
!
            call pmat(6, idev/3.d0, d, devd)
            call pmat(6, d, idev/3.d0, ddev)
            call pmat(6, devd, idev/3.d0, dddev)
!
! - CALCUL DU TENSEUR DE CONTRAINTE : TRACE ET PARTIE DEVIATORIQUE
            tauhy = (taup(1)+taup(2)+taup(3))/3.d0
!
! - CALCUL DE D^DEV:ID ET ID:D^DEV ET ID:D:ID
            iddid = 0.d0
            do ia = 1, 6
                taudv(ia) = taup(ia) - tauhy*kr(ia)
                tauldc(ia) = taup(ia) + (pp-tauhy)*kr(ia)
                do ja = 1, 3
                    iddid = iddid+kr(ia)*d(ia,ja)
                end do
            end do
!
            if (matsym) then
! - MATRICE SYMETRIQUE
! - TERME K:UX
                do na = 1, nnod
                    do ia = 1, ndu
                        vuiana = vu(ia,na)
                        os = (vuiana-1)*vuiana/2
!
! - TERME K:UU      KUU(NDIM,nnod,NDIM,nnod)
                        do nb = 1, nnod
                            do ib = 1, ndu
                                if (vu(ib,nb) .le. vuiana) then
                                    kk = os+vu(ib,nb)
                                    t1 = 0.d0
! - RIGIDITE DE COMPORTEMENT
                                    do ja = 1, ndu
                                        viaja=vij(ia,ja)
                                        do jb = 1, ndu
                                            vibjb=vij(ib,jb)
                                            t2 = dddev(viaja,vibjb)
                                            t2 = t2 + taup(vij(ia,jb))*kr(vij(ib,ja))
                                            t2 = t2 + taup(vij(jb,ja))*kr(vij(ia,ib))
                                            t2 = t2 - 2.d0/3.d0*(&
                                                 taup(viaja)*kr(vibjb)+taup(vibjb)*kr(viaja))
                                            t2 = t2 + 2.d0/3.d0*tauhy*kr(viaja)*kr(vibjb)
                                            t1 = t1+dff1(na,lij(ia,ja))*t2*dff1(nb,lij(ib,jb))
                                        end do
                                    end do
!
! - RIGIDITE GEOMETRIQUE
                                    do jb = 1, ndu
                                        t1 = t1 - dff1(&
                                             na, lij(ia, ib))*dff1(nb,&
                                             lij(ib, jb)) *tauldc(vij(ia, jb)&
                                             )
                                    end do
                                    matr(kk) = matr(kk) + w*t1
                                endif
                            end do
                        end do
!
! - TERME K:UP      KUP(NDIM,nnod,nnop)
                        do sb = 1, nnop
                            if (vp(sb) .lt. vuiana) then
                                kk = os + vp(sb)
                                t1 = dff1(na,lij(ia,ia))*vffp(sb,g)
                                matr(kk) = matr(kk) + w*t1
                            endif
                        end do
                    end do
                end do
!
! - TERME K:PX
                do sa = 1, nnop
                    vpsa = vp(sa)
                    os = (vpsa-1)*vpsa/2
!
! - TERME K:PU      KPU(NDIM,nnop,nnod)
                    do nb = 1, nnod
                        do ib = 1, ndu
                            if (vu(ib,nb) .lt. vpsa) then
                                kk = os + vu(ib,nb)
                                t1 = vffp(sa,g)*dff1(nb,lij(ib,ib))
                                matr(kk) = matr(kk) + w*t1
                            endif
                        end do
                    end do
!
! - TERME K:PP      KPP(nnop,nnop)
                    do rb = 1, nnop
                        if (vp(rb) .le. vpsa) then
                            kk = os + vp(rb)
                            t1 = - vffp(sa,g)*vffp(rb,g)*alpha
                            matr(kk) = matr(kk) + w*t1
                        endif
                    end do
                end do
!
            else
! - MATRICE NON SYMETRIQUE
! - TERME K:UX
                do na = 1, nnod
                    do ia = 1, ndu
                        os = (vu(ia,na)-1)*nddl
!
! - TERME K:UU      KUU(NDIM,nnod,NDIM,nnod)
                        do nb = 1, nnod
                            do ib = 1, ndu
                                kk = os+vu(ib,nb)
                                t1 = 0.d0
! - RIGIDITE DE COMPORTEMENT
                                do ja = 1, ndu
                                    viaja=vij(ia,ja)
                                    do jb = 1, ndu
                                        vibjb=vij(ib,jb)
                                        t2 = dddev(viaja,vibjb)
                                        t2 = t2 + taup(vij(ia,jb))*kr(vij(ib,ja))
                                        t2 = t2 + taup(vij(jb,ja))*kr(vij(ia,ib))
                                        t2 = t2 - 2.d0/3.d0*(&
                                             taup(viaja)*kr(vibjb)+kr(viaja)*taup(vibjb))
                                        t2 = t2 + 2.d0*kr(viaja)*kr(vibjb)*tauhy/3.d0
                                        t1 = t1+dff1(na,lij(ia,ja))*t2*dff1(nb,lij(ib,jb))
                                    end do
                                end do
!
! - RIGIDITE GEOMETRIQUE
                                do jb = 1, ndu
                                    t1 = t1 - dff1(&
                                         na,lij(ia,ib))*dff1(nb,lij(ib,jb)) * tauldc(vij(ia,jb))
                                end do
                                matr(kk) = matr(kk) + w*t1
                            end do
                        end do
!
! - TERME K:UP      KUP(NDIM,nnod,nnop)
                        do sb = 1, nnop
                            kk = os + vp(sb)
                            t1 = dff1(na,lij(ia,ia))*vffp(sb,g)
                            matr(kk) = matr(kk) + w*t1
                        end do
                    end do
                end do
!
! - TERME K:PX
                do sa = 1, nnop
                    os = (vp(sa)-1)*nddl
!
! - TERME K:PU      KPU(NDIM,nnop,nnod)
                    do nb = 1, nnod
                        do ib = 1, ndu
                            kk = os + vu(ib,nb)
                            t1 = vffp(sa,g)*dff1(nb,lij(ib,ib))
                            matr(kk) = matr(kk) + w*t1
                        end do
                    end do
!
! - TERME K:PP      KPP(nnop,nnop)
                    do rb = 1, nnop
                        kk = os + vp(rb)
                        t1 = - vffp(sa,g)*vffp(rb,g)*alpha
                        matr(kk) = matr(kk) + w*t1
                    end do
                end do
            endif
        endif
    end do
!
! - SYNTHESE DES CODES RETOURS
    call codere(cod, npg, codret)
!
999 continue
end subroutine
