! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine te0096(option, nomte)
!
! FONCTION REALISEE:
!
!   TAUX DE RESTITUTION D'ENERGIE ELEMENTAIRE EN ELASTICITE
!                                             EN ELASTICITE NON LINEAIRE
!                                             EN GRANDS DEPLACEMENTS
!
!   ELEMENTS ISOPARAMETRIQUES 2D
!
!   OPTION : 'CALC_G'     (G AVEC CHARGES REELLES)
!            'CALC_G_F'   (G AVEC CHARGES FONCTIONS)
!
! ----------------------------------------------------------------------
! CORPS DU PROGRAMME
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
!
! DECLARATION PARAMETRES D'APPELS
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/tecael.h"
#include "asterc/r8prem.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmelnl.h"
#include "asterfort/nmgeom.h"
#include "asterfort/nmplru.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
!
!
! DECLARATION VARIABLES LOCALES
!
    integer :: icodre(1), kpg, spt
    character(len=4) :: fami
    character(len=8) :: nompar(3), typmod(2), famil, poum
    character(len=16) :: compor(4), oprupt, phenom
!
    real(kind=8) :: epsref(6), e(1), mu
    real(kind=8) :: epsi, rac2, crit(13)
    real(kind=8) :: dfdi(27), f(3, 3), sr(3, 3), sigl(6), sigin(6), dsigin(6, 3)
    real(kind=8) :: eps(6), epsin(6), depsin(6, 3), epsp(6)
    real(kind=8) :: epsino(36), fno(18)
    real(kind=8) :: thet, tn(20), tgdm(3), prod, prod1, prod2, divt
    real(kind=8) :: valpar(3), tcla, tthe, tfor, tini, poids, r, rbid, dsidep(6, 6)
    real(kind=8) :: energi(2), rho(1), om, omo
    real(kind=8) :: dtdm(3, 5), der(6), dfdm(3, 5), dudm(3, 4), dvdm(3, 4)
    real(kind=8) :: vepscp
    real(kind=8) :: ecin, prod3, prod4, nu(1), accele(3)
!
    integer :: ipoids, ivf, idfde
    integer :: icomp, igeom, itemps, idepl, imate
    integer :: iepsr, iepsf, isigi, isigm
    integer :: iforc, iforf, ithet, igthet, irota, ipesa, ier
    integer :: ivites, iaccel, j1, j2
    integer :: nno, nnos, ncmp, jgano
    integer :: i, j, k, kk, l, m, kp, ndim, compt, nbvari
    integer :: ij, ij1, matcod, i1, iret, iret1, npg1
    type(Behaviour_Integ) :: BEHinteg
!
    aster_logical :: grand, axi, cp, fonc, incr, epsini
!
! =====================================================================
! INITIALISATIONS
! =====================================================================
    fami = 'RIGI'
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg1,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    epsi = r8prem()
    rac2 = sqrt(2.d0)
    oprupt = 'RUPTURE'
    axi = .false.
    cp = .false.
    epsini = .false.
    typmod(2) = ' '
    famil='FPG1'
    kpg=1
    spt=1
    poum='+'
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
        axi = .true.
    else if (lteatt('C_PLAN','OUI')) then
        typmod(1) = 'C_PLAN'
        cp = .true.
    else if (lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN'
    endif
!
! NOMBRE DE COMPOSANTES DES TENSEURS
    ncmp = 2*ndim
!
! INIT. POUR LE CALCUL DE G
    tcla = 0.d0
    tthe = 0.d0
    tfor = 0.d0
    tini = 0.d0
    call jevech('PGTHETA', 'E', igthet)
    call jevech('PTHETAR', 'L', ithet)
!
    ivites = 0
    iaccel = 0
!
! TEST SUR LA NULLITE DE THETA_FISSURE
    compt = 0
    do i = 1, nno
        thet = 0.d0
        do j = 1, ndim
            thet = thet + abs(zr(ithet+ndim*(i-1)+j-1))
        end do
        if (thet .lt. epsi) compt = compt+1
    end do
    if (compt .eq. nno) goto 999
!
! =====================================================================
! RECUPERATION DES CHAMPS LOCAUX
! =====================================================================
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PDEPLAR', 'L', idepl)
    call jevech('PMATERC', 'L', imate)
    call jevech('PCOMPOR', 'L', icomp)
    matcod = zi(imate)
    do i = 1, 4
        compor(i)= zk16(icomp+i-1)
    end do
!
! RECUPERATION DU CHAMP LOCAL (CARTE) ASSOCIE AU PRE-EPSI
! CE CHAMP EST ISSU D UN CHARGEMENT PRE-EPSI
    if (option .eq. 'CALC_G_F' ) then
        fonc = .true.
        call jevech('PFFVOLU', 'L', iforf)
        call jevech('PTEMPSR', 'L', itemps)
        nompar(1) = 'X'
        nompar(2) = 'Y'
        nompar(3) = 'INST'
        valpar(3) = zr(itemps)
        call tecach('ONO', 'PEPSINF', 'L', iret, iad=iepsf)
        if (iepsf .ne. 0) epsini = .true.
    else
        fonc = .false.
        call jevech('PFRVOLU', 'L', iforc)
        call tecach('ONO', 'PEPSINR', 'L', iret, iad=iepsr)
        if (iepsr .ne. 0) epsini = .true.
    endif
!
!
!   LOI DE COMPORTEMENT
    grand = compor(3).eq.'GROT_GDEP'
    incr = compor(4)(1:9).eq.'COMP_INCR'
    read(zk16(icomp+1),'(I16)') nbvari
    if (incr) then
        call jevech('PCONTRR', 'L', isigm)
    endif
    call tecach('ONO', 'PPESANR', 'L', iret, iad=ipesa)
    call tecach('ONO', 'PROTATR', 'L', iret, iad=irota)
    call tecach('ONO', 'PSIGINR', 'L', iret, iad=isigi)
    if (option .eq. 'CALC_G' .or. option .eq. 'CALC_G_F') then
        call tecach('ONO', 'PVITESS', 'L', iret, iad=ivites)
        call tecach('ONO', 'PACCELE', 'L', iret, iad=iaccel)
    endif
!
    do i = 1, ncmp*nno
        epsino(i) = 0.d0
    end do
!
! =====================================================================
! MESSAGES D'ERREURS
! =====================================================================
!
! ON NE PEUT AVOIR SIMULTANEMENT PRE-DEFORMATIONS ET CONTRAINTES INIT.
    if ((isigi.ne.0) .and. epsini) then
        call utmess('F', 'RUPTURE1_20')
    endif
!
! =====================================================================
! RECUPERATION DES CHARGES ET PRE-DEFORMATIONS (CHARGEMENT PRE-EPSI)
! =====================================================================
    if (fonc) then
        do i = 1, nno
            i1 = i-1
            ij = igeom+ndim*i1-1
            do j = 1, ndim
                valpar(j) = zr(ij+j)
            end do
            do j = 1, ndim
                kk = ndim*i1+j
                call fointe('FM', zk8(iforf+j-1), 3, nompar, valpar,&
                            fno( kk), ier)
            end do
            if (epsini) then
                do j = 1, ncmp
                    kk = ncmp*i1+j
                    call fointe('FM', zk8(iepsf+j-1), 3, nompar, valpar,&
                                epsino(kk), ier)
                end do
            endif
        end do
    else
        do i = 1, nno
            i1 = i-1
            ij = ndim*i1
            ij1 = iforc+ij-1
            do j = 1, ndim
                fno(ij+j)= zr(ij1+j)
            end do
            if (epsini) then
                ij = ncmp*i1
                ij1 = iepsr+ij-1
                do j = 1, 3
                    epsino(ij+j) = zr(ij1+j)
                end do
                epsino(ij+4) = zr(ij1+4)*rac2
            endif
        end do
    endif
!
    if (ivites .ne. 0) then
        call rccoma(matcod, 'ELAS', 1, phenom, icodre(1))
        call rcvalb(famil, kpg, spt, poum, matcod,&
                    ' ', phenom, 1, ' ', [rbid],&
                    1, 'RHO', rho, icodre(1), 1)
        call rcvalb(famil, kpg, spt, poum, matcod,&
                    ' ', phenom, 1, ' ', [rbid],&
                    1, 'NU', nu(1), icodre(1), 1)
    endif
!
! CORRECTION DES FORCES VOLUMIQUES
    if ((ipesa.ne.0) .or. (irota.ne.0)) then
        call rccoma(matcod, 'ELAS', 1, phenom, icodre(1))
        call rcvalb(famil, kpg, spt, poum, matcod,&
                    ' ', phenom, 1, ' ', [rbid],&
                    1, 'RHO', rho, icodre(1), 1)
        if (ipesa .ne. 0) then
            do i = 1, nno
                ij = ndim*(i-1)
                do j = 1, ndim
                    kk = ij + j
                    fno(kk)=fno(kk)+rho(1)*zr(ipesa)*zr(ipesa+j)
                end do
            end do
        endif
        if (irota .ne. 0) then
            om = zr(irota)
            do i = 1, nno
                omo = 0.d0
                ij = ndim*(i-1)
                do j = 1, ndim
                    omo = omo + zr(irota+j)* zr(igeom+ij+j-1)
                end do
                do j = 1, ndim
                    kk = ij + j
                    fno(kk)=fno(kk)+rho(1)*om*om*(zr(igeom+kk-1)-omo*zr(&
                    irota+j))
                end do
            end do
        endif
    endif
!
!
! ======================================================================
! CALCUL DE LA TEMPERATURE AUX NOEUDS ET RECUPERATION DE LA TEMPERATURE
! DE REFERENCE
! ======================================================================
!
    do kp = 1, nno
        call rcvarc(' ', 'TEMP', '+', 'NOEU', kp, 1, tn(kp), iret1)
    end do
!
! ======================================================================
! BOUCLE PRINCIPALE SUR LES POINTS DE GAUSS
! ======================================================================
!
    do kp = 1, npg1
!
! INITIALISATIONS
        l = (kp-1)*nno
        do i = 1, 3
            tgdm(i) = 0.d0
            accele(i) = 0.d0
            do j = 1, 3
                sr(i,j) = 0.d0
            end do
            do j = 1, 4
                dudm(i,j) = 0.d0
                dvdm(i,j) = 0.d0
                dtdm(i,j) = 0.d0
                dfdm(i,j) = 0.d0
            end do
            dfdm(i,5) = 0.d0
            dtdm(i,5) = 0.d0
        end do
        do i = 1, 6
            sigl (i) = 0.d0
            sigin(i) = 0.d0
            epsin(i) = 0.d0
            epsp(i) = 0.d0
            eps(i) = 0.d0
            epsref(i)= 0.d0
            do j = 1, 3
                dsigin(i,j) = 0.d0
                depsin(i,j) = 0.d0
            end do
        end do
!
! ===========================================
! CALCUL DES ELEMENTS GEOMETRIQUES
! ===========================================
!
        call nmgeom(ndim, nno, axi, grand, zr(igeom),&
                    kp, ipoids, ivf, idfde, zr(idepl),&
                    .true._1, poids, dfdi, f, eps,&
                    r)
! - CALCULS DES GRADIENTS DE U (DUDM), DE THETA FISSURE (DTDM) ET DE
!   LA FORCE VOLUMIQUE (DFDM),
!   DE LA TEMPERATURE AUX POINTS DE GAUSS (TG) ET SON GRADIENT (TGDM)
        do i = 1, nno
            i1 = i-1
            der(1) = dfdi(i)
            der(2) = dfdi(i+nno)
            der(4) = zr(ivf+l+i1)
            if (iret1 .eq. 0) then
                do j = 1, ndim
                    tgdm(j) = tgdm(j) + tn(i)*der(j)
                end do
            endif
            do j = 1, ndim
                ij1 = ndim*i1+j
                ij = ij1 - 1
                do k = 1, ndim
                    dudm(j,k) = dudm(j,k) + zr(idepl+ij)*der(k)
                    dtdm(j,k) = dtdm(j,k) + zr(ithet+ij)*der(k)
                    dfdm(j,k) = dfdm(j,k) + fno(ij1)*der(k)
                end do
                if (ivites .ne. 0) then
                    do k = 1, ndim
                        dvdm(j,k) = dvdm(j,k) + zr(ivites+ij)*der(k)
                    end do
                    dvdm(j,4) = dvdm(j,4) + zr(ivites+ij)*der(4)
                    accele(j) = accele(j) + zr(iaccel+ij)*der(4)
                    if (cp) then
                        vepscp = -nu(1)/(1.d0-nu(1))*(dvdm(1,1)+dvdm(2,2))
                    endif
                endif
                dudm(j,4) = dudm(j,4) + zr(idepl+ij)*der(4)
                dtdm(j,4) = dtdm(j,4) + zr(ithet+ij)*der(4)
                dfdm(j,4) = dfdm(j,4) + fno(ij1)*der(4)
            end do
        end do
!
! =======================================================
! PRE DEFORMATIONS ET LEUR GRADIENT DEPSIN
! (seule intervenant dans le calcul de G)
! =======================================================
!
        if (epsini) then
            do i = 1, nno
                i1 = i-1
                der(1) = dfdi(i)
                der(2) = dfdi(i+nno)
                der(3) = 0.d0
                der(4) = zr(ivf+l+i1)
                ij = ncmp*i1
                do j = 1, ncmp
                    epsin(j) = epsin(j)+ epsino(ij+j)*der(4)
                end do
                do j = 1, ncmp
                    ij1 = ij+j
                    do k = 1, ndim
                        depsin(j,k) = depsin(j,k)+epsino(ij1)*der(k)
                    end do
                end do
            end do
            do i = 1, ncmp
                eps(i) = eps(i)-epsin(i)
            end do
        endif
!
! =======================================================
! CALCUL DES CONTRAINTES LAGRANGIENNES SIGL ET DE L'ENERGIE LIBRE
! =======================================================
!
        if (incr) then
! BESOIN GARDER APPEL NMPLRU POUR LE CALCUL DE L'ENERGIE EN PRESENCE 
! D'ETAT INITIAL MAIS NETTOYAGE A COMPLETER
            call nmplru(fami, kp, 1, '+', ndim,&
                        typmod, matcod, compor, rbid, eps,&
                        epsp, rbid, energi)
            do i = 1, 3
                sigl(i)= zr(isigm+ncmp*(kp-1)+i-1)
            end do
            sigl(4)= zr(isigm+ncmp*(kp-1)+3)*rac2
        else
            crit(1) = 300
            crit(2) = 0.d0
            crit(3) = 1.d-3
            crit(9) = 300
            crit(8) = 1.d-3
            call nmelnl(BEHinteg,&
                        fami, kp, 1, '+',&
                        ndim, typmod, matcod, compor, crit,&
                        oprupt, eps, sigl, rbid, dsidep,&
                        energi)
!
            call tecach('NNO', 'PCONTGR', 'L', iret, iad=isigm)
            if (iret .eq. 0) then
                call jevech('PCONTGR', 'L', isigm)
                do i = 1, 3
                    sigl(i)= zr(isigm+ncmp*(kp-1)+i-1)
                end do
                sigl(4)= zr(isigm+ncmp*(kp-1)+3)*rac2
            endif
        endif
!
! =======================================================
! DIVERS (DIVERGENCE, MODELISATION...)
! =======================================================
!
! TRAITEMENTS DEPENDANT DE LA MODELISATION
        if (cp) then
            dudm(3,3)= eps(3)
            if (ivites .ne. 0) then
                dvdm(3,3)= vepscp
            endif
        endif
        if (axi) then
            dudm(3,3)= dudm(1,4)/r
            dtdm(3,3)= dtdm(1,4)/r
            dfdm(3,3)= dfdm(1,4)/r
            if (ivites .ne. 0) then
                dvdm(3,3)= dvdm(1,4)/r
            endif
        endif
!
! CALCUL DE LA DIVERGENCE DU THETA FISSURE (DIVT)
        divt = 0.d0
        do i = 1, 3
            divt = divt + dtdm(i,i)
        end do
!
!
! =======================================================
! CORRECTIONS LIEES A LA CONTRAINTE INITIALE (SIGM DE CALC_G)
! CONTRAINTE, DEFORMATION DE REFERENCE, ENERGIE ELASTIQUE
! =======================================================
!
        if (isigi .ne. 0) then
            do i = 1, nno
                i1 = i-1
                der(1) = dfdi(i)
                der(2) = dfdi(i+nno)
                der(3) = 0.d0
                der(4) = zr(ivf+l+i1)
!
! CALCUL DE SIGMA INITIAL
                ij = isigi+ncmp*i1-1
                do j = 1, ncmp
                    sigin(j) = sigin(j)+ zr(ij+j)*der(4)
                end do
!
! CALCUL DU GRADIENT DE SIGMA INITIAL
                do j = 1, ncmp
                    do k = 1, ndim
                        dsigin(j,k)=dsigin(j,k)+zr(ij+j)*der(k)
                    end do
                end do
            end do
!
! TRAITEMENTS PARTICULIERS DES TERMES CROISES
            do i = 4, ncmp
                sigin(i) = sigin(i)*rac2
                do j = 1, ndim
                    dsigin(i,j) = dsigin(i,j)*rac2
                end do
            end do
!
! CALCUL DE LA DEFORMATION DE REFERENCE
            call rccoma(matcod, 'ELAS', 1, phenom, icodre(1))
            call rcvalb(fami, kp, 1, '+', matcod,&
                     ' ', phenom, 0, ' ', [0.d0],&
                     1, 'E', e(1), icodre(1), 1)
            call rcvalb(fami, kp, 1, '+', matcod,&
                     ' ', phenom, 0, ' ', [0.d0],&
                     1, 'NU', nu(1), icodre(1), 1)
!
            mu = e(1)/(2.d0*(1.d0+nu(1)))
!
            epsref(1)=-(1.d0/e(1))*(sigin(1)-(nu(1)*(sigin(2)+sigin(3))))
            epsref(2)=-(1.d0/e(1))*(sigin(2)-(nu(1)*(sigin(3)+sigin(1))))
            epsref(3)=-(1.d0/e(1))*(sigin(3)-(nu(1)*(sigin(1)+sigin(2))))
            epsref(4)=-(1.d0/mu)*sigin(4)
!
! ENERGIE ELASTIQUE (expression WADIER)
!
            do i = 1, ncmp
                energi(1) = energi(1) + (eps(i)-0.5d0*epsref(i))* sigin(i)
            end do
        endif
!
!
!
!
! =======================================================
! STOCKAGE DE SIGMA ET TRAITEMENTS DES TERMES CROISES
! =======================================================
        sr(1,1)= sigl(1)
        sr(2,2)= sigl(2)
        sr(3,3)= sigl(3)
        sr(1,2)= sigl(4)/rac2
        sr(2,1)= sr(1,2)
        sr(1,3)= sigl(5)/rac2
        sr(3,1)= sr(1,3)
        sr(2,3)= sigl(6)/rac2
        sr(3,2)= sr(2,3)
!
! CALCUL DE G
!
! =======================================================
! TERME THERMOELASTIQUE CLASSIQUE F.SIG:(GRAD(U).GRAD(THET))-ENER*DIVT
! REMARQUE : POUR LA DERIVEE, TCLA EST INUTILE.
!            MAIS ON A BESOIN DE PROD2 SI TSENUL EST FAUX.
! =======================================================
        ecin = 0.d0
        prod3 = 0.d0
        prod4 = 0.d0
        if (ivites .ne. 0) then
            do j1 = 1, ndim
                ecin = ecin + dvdm(j1,4)*dvdm(j1,4)
            end do
            do j1 = 1, ndim
                do j2 = 1, ndim
                    prod3 = prod3 + accele(j1)*dudm(j1,j2)*dtdm(j2,4)
                    prod4 = prod4 + dvdm(j1,4)*dvdm(j1,j2)*dtdm(j2,4)
                end do
            end do
            ecin = 0.5d0*rho(1)*ecin
            prod3 = rho(1)*prod3
            prod4 = rho(1)*prod4
        endif
!
        prod = 0.d0
        prod2 = 0.d0
        do i = 1, 3
            do j = 1, 3
                do k = 1, 3
                    do m = 1, 3
                        prod =prod+f(i,j)*sr(j,k)*dudm(i,m)*dtdm(m,k)
                    end do
                end do
            end do
        end do
        prod = prod - ecin*divt + prod3 - prod4
        prod2 = poids*( prod - energi(1)*divt)
!
        tcla = tcla + prod2
!
! =======================================================
! TERME THERMIQUE :   -(D(ENER)/DT)(GRAD(T).THETA)
! =======================================================
        if (iret1 .eq. 0) then
            prod = 0.d0
            prod2 = 0.d0
            do i = 1, ndim
                prod = prod + tgdm(i)*dtdm(i,4)
            end do
            prod2 = - poids*prod*energi(2)
            tthe = tthe + prod2
        else
            tthe = 0.d0
        endif
! =======================================================
! TERME FORCE VOLUMIQUE
! REMARQUE : POUR LA DERIVEE, TFOR EST INUTILE.
!            MAIS ON A BESOIN DE PROD2 SI TSENUL EST FAUX.
! =======================================================
!
        prod2 = 0.d0
        do i = 1, ndim
            prod=0.d0
            do j = 1, ndim
                prod = prod + dfdm(i,j)*dtdm(j,4)
            end do
            prod2 = prod2 + dudm(i,4)*(prod+dfdm(i,4)*divt)*poids
        end do
!
        tfor = tfor + prod2
!
! =======================================================
! TERME INITIAL:PROD1 LIE A LA CONTRAINTE (EPS-EPSREF):GRAD(SIGIN).THETA
!               PROD2 LIE A LA PREDEFORMATION SIG:GRAD(EPSIN).THETA
! =======================================================
!
        if ((isigi.ne.0) .or. epsini) then
            prod1=0.d0
            prod2=0.d0
            if (isigi .ne. 0) then
                do i = 1, ncmp
                    do j = 1, ndim
                        prod1=prod1-(eps(i)-epsref(i))*dsigin(i,j)*&
                        dtdm(j,4)
                    end do
                end do
            else if (epsini) then
                do i = 1, ncmp
                    do j = 1, ndim
                        prod2=prod2+sigl(i)*depsin(i,j)*dtdm(j,4)
                    end do
                end do
            endif
            tini = tini + (prod1+prod2)*poids

        endif

! ==================================================================
! FIN DE BOUCLE PRINCIPALE SUR LES POINTS DE GAUSS
! ==================================================================
    end do
!
! EXIT EN CAS DE THETA FISSURE NUL PARTOUT
999 continue
!
! ASSEMBLAGE FINAL DES TERMES DE G OU DG
    
    zr(igthet) = tthe + tcla + tfor + tini
!
end subroutine
