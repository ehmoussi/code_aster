! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1003
subroutine te0535(option, nomte)
!
!
! --------------------------------------------------------------------------------------------------
!
!     Calcul des options FULL_MECA ou RAPH_MECA ou RIGI_MECA_TANG
!     pour les éléments de poutre 'MECA_POU_D_EM'
!
!     'MECA_POU_D_EM' : poutre droite d'EULER multifibre
!
! --------------------------------------------------------------------------------------------------
!
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
character(len=16) :: option, nomte
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jevech.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lcsovn.h"
#include "asterfort/lonele.h"
#include "asterfort/matela.h"
#include "asterfort/matrot.h"
#include "asterfort/pmfasseinfo.h"
#include "asterfort/pmfdge.h"
#include "asterfort/pmfdgedef.h"
#include "asterfort/pmffft.h"
#include "asterfort/pmfinfo.h"
#include "asterfort/pmfite.h"
#include "asterfort/pmfitebkbbts.h"
#include "asterfort/pmfitg.h"
#include "asterfort/pmfits.h"
#include "asterfort/pmfitsbts.h"
#include "asterfort/pmfmats.h"
#include "asterfort/pmfmcf.h"
#include "asterfort/pmfpti.h"
#include "asterfort/pmftorcor.h"
#include "asterfort/porea1.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/ptkg00.h"
#include "asterfort/r8inir.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/wkvect.h"
#include "asterfort/Behaviour_type.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nno, nc, nd, nk
    parameter  (nno=2,nc=6,nd=nc*nno,nk=nd*(nd+1)/2)
!
    integer :: igeom, icompo, imate, iorien, iret
    integer :: icarcr, icontm, ideplm, ideplp, imatuu
    integer :: ivectu, icontp, ivarim, ivarip, i
    integer :: jmodfb, jsigfb, jacf, nbvalc
    integer :: jtab(7), ivarmp, istrxp, istrxm
    integer :: kp, jcret, codret, codrep
    integer :: iposcp, iposig, ipomod, iinstp, iinstm
    integer :: icomax, ico, isdcom, ncomp
    integer :: npg, nnoel, ipoids, ivf
!
    real(kind=8) :: e, nu, g, xl, xjx, gxjx, epsm
    real(kind=8) :: pgl(3, 3), fl(nd), klv(nk), sk(nk), rgeom(nk)
    real(kind=8) :: deplm(12), deplp(12), matsct(6)
    real(kind=8) :: xi, wi, b(4), gg, vs(3), ve(12)
    real(kind=8) :: defam(6), defap(6)
    real(kind=8) :: alicom, dalico, ss1, hv, he
    real(kind=8) :: vv(12), fv(12), sv(78)
    real(kind=8) :: gamma, angp(3), sigma(nd), cars1(6)
    real(kind=8) :: a, xiy, xiz, ey, ez
!
    aster_logical :: reactu
    aster_logical :: lVect, lMatr, lVari, lSigm
    character(len=8) :: mator
    character(len=16) :: rela_comp, defo_comp, mult_comp, rigi_geom
!
    real(kind=8), pointer :: defmfib(:) => null()
    real(kind=8), pointer :: defpfib(:) => null()
    real(kind=8), pointer :: gxjxpou(:) => null()
    real(kind=8), pointer :: yj(:) => null(), zj(:) => null()
    real(kind=8), pointer :: deffibasse(:) => null(), vsigv(:) => null()
    real(kind=8), pointer :: vev(:) => null()
!
    real(kind=8), allocatable :: vfv(:,:), matsecp(:,:), vvp(:,:), skp(:,:)

    integer :: nbfibr, nbgrfi, tygrfi, nbcarm, nug(10)

    integer :: nbasspou,maxfipoutre
    integer, pointer :: nbfipoutre(:) => null()
!
! --------------------------------------------------------------------------------------------------
    integer, parameter :: nb_cara = 3
    real(kind=8) :: vale_cara(nb_cara)
    character(len=8), parameter :: noms_cara(nb_cara) = (/'EY1','EZ1','JX1'/)
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', nno=nnoel, npg=npg, jpoids=ipoids, jvf=ivf)
    ASSERT(nno.eq.nnoel)
!
    codret=0
    codrep=0
!
! --------------------------------------------------------------------------------------------------
!   Récupération des caractéristiques des fibres
    call pmfinfo(nbfibr,nbgrfi,tygrfi,nbcarm,nug,jacf=jacf,nbassfi=nbasspou)
    AS_ALLOCATE(vi= nbfipoutre, size=nbasspou)
    AS_ALLOCATE(vr= gxjxpou, size=nbasspou)
    call pmfasseinfo(tygrfi,nbfibr,nbcarm,zr(jacf),maxfipoutre, nbfipoutre, gxjxpou)
    AS_ALLOCATE(vr=yj, size=nbasspou)
    AS_ALLOCATE(vr=zj, size=nbasspou)
    AS_ALLOCATE(vr=deffibasse, size=maxfipoutre)
    AS_ALLOCATE(vr=vsigv, size=maxfipoutre)
    AS_ALLOCATE(vr=vev, size=maxfipoutre)

    allocate(vfv(7,maxfipoutre))
    allocate(matsecp(6,nbasspou))
    allocate(vvp(12,nbasspou))
    allocate(skp(78,nbasspou))
!
! --------------------------------------------------------------------------------------------------


!   Nombre de composantes du champs PSTRX?? par points de gauss
    ncomp = 18
!   Longueur de l'élément
    xl = lonele()
!
!  Paramètres en entrée
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
    call jevech('PMATERC', 'L', imate)
    call jevech('PCAORIE', 'L', iorien)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PSTRXMR', 'L', istrxm)
!   la presence du champ de deplacement a l instant t+ devrait etre conditionne  par l'option
!   (avec rigi_meca_tang ca n a pas de sens). Ce champ est initialise a 0 par la routine nmmatr.
    call jevech('PDEPLPR', 'L', ideplp)
!
    call tecach('OOO', 'PCONTMR', 'L', iret, nval=7, itab=jtab)
    icontm = jtab(1)
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    ivarim = jtab(1)

!   Pour matric=(RIGI_MECA_TANG) : valeurs "+" égalent valeurs "-"
    icontp = icontm
    ivarip = ivarim
    istrxp = istrxm
    ivarmp = ivarim
!
! - Properties of behaviour
    rela_comp = zk16(icompo-1+RELA_NAME)
    defo_comp = zk16(icompo-1+DEFO)
    mult_comp = zk16(icompo-1+MULTCOMP)
    rigi_geom = zk16(icompo-1+RIGI_GEOM)
    read (zk16(icompo-1+NVAR),'(I16)') nbvalc
!
! - Select objects to construct from option name
    call behaviourOption(option, zk16(icompo),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
!   verification que c'est bien des multifibres
!
    
    call jeexin(mult_comp, iret)
    if (iret .eq. 0) then
        call utmess('F', 'POUTRE0_14', sk=nomte)
    endif
!   Recuperation de la SD_COMPOR ou le comportement des groupes de fibres est stocke
!   pour chaque groupe : (nom, mater, loi, algo1d, deformation nbfig) dans
!   l'ordre croissant des numeros de groupes
    call jeveuo(mult_comp, 'L', isdcom)
!
!   deformations anelastiques
!
    defam = 0.0d0
    defap = 0.0d0
!
!  Paramètres en sortie
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', imatuu)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PCODRET', 'E', jcret)
    endif
    if (lVari) then
        call tecach('OOO', 'PVARIMP', 'L', iret, nval=7, itab=jtab)
        ivarmp = jtab(1)
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PSTRXPR', 'E', istrxp)
    endif
!
    if (rigi_geom .eq. 'OUI') then
        call utmess('F', 'POUTRE0_16', sk = defo_comp)
    endif
!
!   Calcul des matrices de changement de repère
!
    if ((defo_comp .ne. 'PETIT').and.(defo_comp.ne.'GROT_GDEP')) then
        call utmess('F', 'POUTRE0_40', sk = defo_comp)
    endif
!
!   Géometrie éventuellement reactualisée
!
    reactu = defo_comp .eq. 'GROT_GDEP'
    if (reactu) then
!       recuperation du 3eme angle nautique au temps t-
        gamma = zr(istrxm+18-1)
!       calcul de PGL,XL et ANGP
        call porea1(nno, nc, zr(ideplm), zr(ideplp), zr(igeom),&
                    gamma, lVect, pgl, xl, angp)
!       sauvegarde des angles nautiques
        if (lVect) then
            zr(istrxp+16-1) = angp(1)
            zr(istrxp+17-1) = angp(2)
            zr(istrxp+18-1) = angp(3)
        endif
    else
        call matrot(zr(iorien), pgl)
    endif
!
!   recuperation des caracteristiques de la section
    call poutre_modloc('CAGNPO', noms_cara, nb_cara, lvaleur=vale_cara)
    ey  = vale_cara(1)
    ez  = vale_cara(2)
    xjx = vale_cara(3)
!   caracteristiques elastiques (pas de temperature pour l'instant)
!   on prend le E et NU du materiau torsion (voir op0059)
    call pmfmats(imate, mator)
    ASSERT( mator.ne.' ' )
    call matela(zi(imate), mator, 0, 0.d0, e, nu)
    g = e / (2.d0*(1.d0+nu))
    gxjx = g*xjx
!
!   calcul des deplacements et de leurs increments passage dans le repere local
!
    call utpvgl(nno, nc, pgl, zr(ideplm), deplm)
    call utpvgl(nno, nc, pgl, zr(ideplp), deplp)
    epsm = (deplm(7)-deplm(1))/xl
!   Mises à zéro
    call r8inir(nk, 0.0d+0, klv, 1)
    call r8inir(nk, 0.0d+0, sk, 1)
    call r8inir(12, 0.0d+0, fl, 1)
    call r8inir(12, 0.0d+0, ve, 1)
    call r8inir(12, 0.0d+0, fv, 1)
!   On recupère alpha mode incompatible=alico
    alicom=zr(istrxm-1+15)
!   deformatiions moins et increment de deformation pour chaque fibre
    AS_ALLOCATE(vr=defmfib, size=nbfibr)
    AS_ALLOCATE(vr=defpfib, size=nbfibr)
!   module et contraintes sur chaque fibre (comportement)
    call wkvect('&&TE0535.MODUFIB', 'V V R8', (nbfibr*2), jmodfb)
    call wkvect('&&TE0535.SIGFIB', 'V V R8', (nbfibr*2), jsigfb)
!
!   boucle sur les points de gauss

!
!   Boucle pour calculer le alpha mode incompatible : alico
    ss1=0.0d+0
    dalico=0.0d+0
!
    icomax=100; ico = 0
    cico: do
        ico = ico + 1
        if (ico .gt. icomax) then
!           Non convergence sur le mode incompatible, sortie immédiate
            codret = 1
            goto 999
        endif
!
        he=0.0d+0
        hv=0.0d+0

        do kp = 1, npg
!
            call pmfpti(kp, zr(ipoids), zr(ivf), xl, xi, wi, b, gg)
            call pmfdgedef(tygrfi, b, gg, deplm, alicom, nbfibr, nbcarm, &
                           zr(jacf), nbasspou, maxfipoutre, nbfipoutre, yj, zj, &
                           deffibasse, vfv, defmfib)
!
            call pmfdgedef(tygrfi, b, gg, deplp, dalico, nbfibr, nbcarm, &
                           zr(jacf), nbasspou, maxfipoutre, nbfipoutre, yj, zj, &
                           deffibasse, vfv, defpfib)
!
            iposig=jsigfb + nbfibr*(kp-1) 
            ipomod=jmodfb + nbfibr*(kp-1)
            call pmfmcf(kp, nbgrfi, nbfibr, nug, zk24(isdcom), &
                        zr(icarcr), option, zr(iinstm), zr(iinstp), zi(imate), &
                        nbvalc, defam, defap, zr(ivarim), zr(ivarmp), &
                        zr(icontm), defmfib, defpfib, epsm, zr(ipomod),&
                        zr(iposig), zr(ivarip), codrep)
            if (codrep .ne. 0) then
                codret = codrep
!               code 3: on continue et on le renvoie a la fin, autre codes sortie immediate
                if (codrep .ne. 3) goto 999
            endif
!           calcul matrice section
            call pmfite(tygrfi, nbfibr, nbcarm, zr(jacf), zr(ipomod), matsct)
!           Integration des contraintes sur la section
            call pmfits(tygrfi, nbfibr, nbcarm, zr(jacf), zr(iposig), vs)
!           Calculs mode incompatible hv=int(gt ks g), he=int(gt fs)
            hv = hv+wi*gg*gg*matsct(1)
            he = he+wi*gg*vs(1)
!
        end do
!
        if (abs(hv) .le. r8prem()) then
            call utmess('F', 'POUTRE0_15')
        endif
!       Correction de la position du noeud bulle
        dalico = dalico-he/hv
        if (ico .eq. 1) then
            if (abs(vs(1)) .le. 1.0D-06) then
                exit cico
            else
                ss1 = abs(vs(1))
            endif
        endif
        if ((abs(he) .le. (ss1*1.0D-06)).or.(abs(he) .le. 1.0D-09)) then
            exit cico
        endif
    enddo cico
!   Fin boucle calcul alico
    do kp = 1, npg
!
        call pmfpti(kp, zr(ipoids), zr(ivf), xl, xi, wi, b, gg)
        if (lMatr) then
            ipomod=jmodfb + nbfibr*(kp-1)
!           calcul matrice de rigidité
!           Calcul des caracteristiques de section par integration sur les fibres
            call pmfitebkbbts(tygrfi, nbfibr, nbcarm, zr(jacf), zr(ipomod), b, wi, gxjx, gxjxpou, &
                              g, gg, nbasspou, maxfipoutre, nbfipoutre, vev, yj, zj, &
                              vfv, skp, sk, vv, vvp)
!
            do i = 1, nk
                klv(i) = klv(i)+sk(i)
            enddo
            do i = 1, 12
                fv(i) = fv(i)+vv(i)
            enddo
!
        endif
!
        if (lVect) then
!           calcul des forces internes
            iposig=jsigfb + nbfibr*(kp-1)
            call pmfitsbts(tygrfi, nbfibr, nbcarm, zr(jacf), zr(iposig), b, wi, &
                           nbasspou, yj, zj, maxfipoutre, nbfipoutre, vsigv, vfv, vvp, ve)
            do i = 1, 12
                fl(i) = fl(i)+ve(i)
            enddo
!
        endif
!
    enddo
!
!   On modifie la matrice de raideur par condensation statique
    if (lMatr) then
        call pmffft(fv, sv)
        do i = 1, nk
            klv(i) = klv(i) - sv(i)/hv
        enddo
    endif
!
!   Torsion a part pour les forces interne
    call pmftorcor(tygrfi, nbasspou, gxjx, gxjxpou, deplm, deplp, xl, fl)
!
!   Stockage des efforts généralisés et passage des forces en repère local
    if (lSigm) then
!       on sort les contraintes sur chaque fibre
        do kp = 1, 2
            iposcp=icontp + nbfibr*(kp-1)
            iposig=jsigfb + nbfibr*(kp-1)
            do i = 0, nbfibr-1
                zr(iposcp+i) = zr(iposig+i)
            enddo
!           Stockage des forces intégrées
            zr(istrxp-1+ncomp*(kp-1)+1) = fl(6*(kp-1)+1)
            zr(istrxp-1+ncomp*(kp-1)+2) = fl(6*(kp-1)+2)
            zr(istrxp-1+ncomp*(kp-1)+3) = fl(6*(kp-1)+3)
            zr(istrxp-1+ncomp*(kp-1)+4) = fl(6*(kp-1)+4)
            zr(istrxp-1+ncomp*(kp-1)+5) = fl(6*(kp-1)+5)
            zr(istrxp-1+ncomp*(kp-1)+6) = fl(6*(kp-1)+6)
            zr(istrxp-1+ncomp*(kp-1)+15)= alicom+dalico
        enddo
    endif
    if (lVect) then
        call utpvlg(nno, nc, pgl, fl, zr(ivectu))
    endif
!
!   Calcul de la matrice de rigidité géométrique
    if (lMatr .and. reactu) then
        do i = 1, nc
            sigma(i) = - zr(istrxp+i-1)
            sigma(i+nc) = zr(istrxp+ncomp+i-1)
        enddo
        call r8inir(nk, 0.0d+0, rgeom, 1)
        call pmfitg(tygrfi, nbfibr, nbcarm, zr(jacf), cars1)
        a   = cars1(1)
        xiy = cars1(5)
        xiz = cars1(4)
        call ptkg00(sigma, a, a, xiz, xiz, xiy, xiy, xl, ey, ez, rgeom)
        call lcsovn(nk, klv, rgeom, klv)
    endif
!
!   On sort la matrice tangente
    if (lMatr) then
!       Passage local -> global
        call utpslg(nno, nc, pgl, klv, zr(imatuu))
    endif
!
999 continue
    if (lSigm) then
        zi(jcret) = codret
    endif
!   Deallocation memoire pour tableaux temporaires
    deallocate(vfv)
    deallocate(skp)
    deallocate(vvp)
    deallocate(matsecp)
    AS_DEALLOCATE(vi=nbfipoutre)
    AS_DEALLOCATE(vr=gxjxpou)
    AS_DEALLOCATE(vr=yj)
    AS_DEALLOCATE(vr=zj)
    AS_DEALLOCATE(vr=deffibasse)
    AS_DEALLOCATE(vr=vsigv)
    AS_DEALLOCATE(vr=vev)
    AS_DEALLOCATE(vr=defmfib)
    AS_DEALLOCATE(vr=defpfib)
    call jedetr('&&TE0535.MODUFIB')
    call jedetr('&&TE0535.SIGFIB')
!
end subroutine
