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

subroutine te0540(option, nomte)
!
!
! --------------------------------------------------------------------------------------------------
!
!           ELEMENT DE SQUELETTE D'ASSEMBLAGE COMBUSTIBLE (MULTI-POUTRE MULTI-FIBRES)
!
!       OPTION       RAPH_MECA FULL_MECA RIGI_MECA_TANG
!       NOMTE        MECA_POU_D_SQE
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
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
#include "asterfort/jeimpo.h"
#include "asterfort/jevech.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lonele.h"
#include "asterfort/matela.h"
#include "asterfort/matrot.h"
#include "asterfort/moytem.h"
#include "asterfort/pmfasseinfo.h"
#include "asterfort/pmfdgedef.h"
#include "asterfort/pmffftsq.h"
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
#include "asterfort/r8inir.h"
#include "asterfort/tecach.h"
#include "asterfort/utbtab.h"
#include "asterfort/utmess.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/wkvect.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nc, nno, dimklv, npg, iret, codrep
    parameter (nc=9 , dimklv= 2*nc*(2*nc+1)/2 , nno=2 , npg=2)
    real(kind=8) :: fl(2*nc), u(2*nc), du(2*nc)
    real(kind=8) :: klv(dimklv), sk(dimklv)
!
    integer :: i, jcret, npge, iposig, ipomod, jmodfb, jsigfb, iposcp, ifgp
    integer :: igeom, imate, icontm, iorien, icompo, ivarim, iinstp, ipoids
    integer :: icarcr, ideplm, ideplp, iinstm, ivectu, icontp, ivarip, imat
    integer :: jacf, jtab(7), ivarmp, codret, ivf
    integer :: ncomp, nbvalc, isdcom, nbasspou, maxfipoutre
    integer :: kp, j, k, istrxm, istrxp, istrmp, icomax, ico
    real(kind=8) :: ey, ez, gamma, xl, gg, xjx
    real(kind=8) :: e, g, nu, temp, temm, gxjx
    real(kind=8) :: defam(6), defap(6), angp(3)
    real(kind=8) :: pgl(3, 3), matsct(6)
    real(kind=8) :: xi, wi, b(4),vv(18),ve(18),fv(18)
    real(kind=8) :: ang1(3), epsm, sigfib
    real(kind=8) :: alicom, dalico, ss1, hv, he, vs(3), sv(dimklv)
!
    aster_logical :: vecteu, matric, reactu
!
    character(len=4) :: fami
    character(len=8) :: mator
    character(len=24) :: valk(2)
!
    real(kind=8), allocatable :: vfv(:,:),vvp(:,:),skp(:,:)
    integer :: nbfibr, nbgrfi, tygrfi, nbcarm, nug(10)
    integer, pointer :: nbfipoutre(:) => null()
    real(kind=8), pointer :: gxjxpou(:) => null()
!
    real(kind=8), pointer :: yj(:) => null(), zj(:) => null()
    real(kind=8), pointer :: deffibasse(:) => null(), vsigv(:) => null()
    real(kind=8), pointer :: vev(:) => null()
    real(kind=8), pointer :: defmfib(:) => null()
    real(kind=8), pointer :: defpfib(:) => null()
! --------------------------------------------------------------------------------------------------
    integer, parameter :: nb_cara = 3
    real(kind=8) :: vale_cara(nb_cara)
    character(len=8) :: noms_cara(nb_cara)
    data noms_cara /'EY1','EZ1','JX1'/
! --------------------------------------------------------------------------------------------------
!
!
    fami = 'RIGI'
    call elrefe_info(fami=fami, npg=npge, jpoids=ipoids, jvf = ivf)
    ASSERT( npg.ge.npge )
!
    fl(1:2*nc) = 0.0d0
    codret=0
    codrep=0
!
!   booleens pratiques
    matric = option .eq. 'FULL_MECA' .or. option .eq. 'RIGI_MECA_TANG'
    vecteu = option .eq. 'FULL_MECA' .or. option .eq. 'RAPH_MECA'
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
    allocate(vvp(12,nbasspou))
    allocate(skp(78,nbasspou))
!
! --------------------------------------------------------------------------------------------------


!   Nombre de composantes du champs PSTRX?? par points de gauss
!   La 15eme composante ne concerne pas les POU_D_TGM
    ncomp = 21
!   Longueur de l'élément et pointeur sur le géométrie
    xl = lonele(igeom=igeom)
!
!  Paramètres en entrée
!
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

    if (vecteu) then
        call tecach('OOO', 'PVARIMP', 'L', iret, nval=7, itab=jtab)
        ivarmp = jtab(1)
        call jevech('PSTRXMP', 'L', istrmp)
    endif
!
!   verification que c'est bien des multifibres
!
    call jeexin(zk16(icompo-1+7), iret)
    if (iret .eq. 0) then
        call utmess('F', 'ELEMENTS4_14', sk=nomte)
    endif
!   Recuperation de la SD_COMPOR ou le comportement des groupes de fibres est stocke
!   pour chaque groupe : (nom, mater, loi, algo1d, deformation nbfig) dans
!   l'ordre croissant des numeros de groupes
    call jeveuo(zk16(icompo-1+7), 'L', isdcom)
    call jeimpo(6,zk16(icompo-1+7),'COMPOCATA')
    read (zk16(icompo-1+2),'(I16)') nbvalc
!
!   deformations anelastiques
!
    defam(:) = 0.0d0
    defap(:) = 0.0d0
!
!  Paramètres en sortie
!
    if (matric) call jevech('PMATUUR', 'E', imat)

    if (vecteu) then
        call jevech('PVECTUR', 'E', ivectu)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PSTRXPR', 'E', istrxp)
    endif
!
!   Calcul des matrices de changement de repère
!
    if (zk16(icompo+3) .eq. 'COMP_ELAS') then
        call utmess('F', 'ELEMENTS2_90')
    else if ((zk16(icompo+2) .ne. 'PETIT').and.(zk16(icompo+2).ne.'GROT_GDEP')) then
        valk(1) = zk16(icompo+2)
        valk(2) = nomte
        call utmess('F', 'ELEMENTS3_40', nk=2, valk=valk)
    endif
!
!   Géometrie éventuellement reactualisée
!
    reactu = zk16(icompo+2).eq.'GROT_GDEP'
    if (reactu) then
!       recuperation du 3eme angle nautique au temps t-
        gamma = zr(istrxm+18-1)
!       calcul de PGL,XL et ANGP
        call porea1(nno, nc, zr(ideplm), zr(ideplp), zr(igeom+1),&
                    gamma, vecteu, pgl, xl, angp)
!       sauvegarde des angles nautiques
        if (vecteu) then
            zr(istrxp+16-1) = angp(1)
            zr(istrxp+17-1) = angp(2)
            zr(istrxp+18-1) = angp(3)
        endif
    else
        ang1(1) = zr(iorien-1+1)
        ang1(2) = zr(iorien-1+2)
        ang1(3) = zr(iorien-1+3)
        call matrot(ang1, pgl)
    endif
!
!   recuperation des caracteristiques de la section
    call poutre_modloc('CAGNPO', noms_cara, nb_cara, lvaleur=vale_cara)
    ey  = vale_cara(1)
    ez  = vale_cara(2)
    xjx = vale_cara(3)
!
!   coefficient dependant de la temperature moyenne
    call moytem(fami, npg, 1, '+', temp, iret)
    call moytem(fami, npg, 1, '-', temm, iret)
!   caracteristiques elastiques (pas de temperature pour l'instant)
!   on prend le E et NU du materiau torsion (voir op0059)
    call pmfmats(imate, mator)
    ASSERT( mator.ne.' ' )
    call matela(zi(imate), mator, 1, temp, e, nu)
    g = e / (2.d0*(1.d0+nu))
    gxjx = g*xjx
!
!   calcul des deplacements et de leurs increments passage dans le repere local
!
    call utpvgl(nno, nc, pgl, zr(ideplm), u)
    call utpvgl(nno, nc, pgl, zr(ideplp), du)
    epsm = (u(10)-u(1))/xl
!   Mises à zéro
    call r8inir(dimklv, 0.0d+0, klv, 1)
    call r8inir(dimklv, 0.0d+0, sk, 1)
    call r8inir(2*nc, 0.0d+0, ve, 1)
    call r8inir(2*nc, 0.0d+0, fv, 1)
!   On recupère alpha mode incompatible=alico
    alicom=zr(istrxm-1+15)
!   deformatiions moins et increment de deformation pour chaque fibre
    AS_ALLOCATE(vr=defmfib, size=nbfibr)
    AS_ALLOCATE(vr=defpfib, size=nbfibr)
!   nombre de variable interne de la loi de comportement
    read (zk16(icompo-1+2),'(I16)') nbvalc
!   module et contraintes sur chaque fibre (comportement)
    call wkvect('&&TE0540.MODUFIB', 'V V R8', (nbfibr*npg), jmodfb)
    call wkvect('&&TE0540.SIGFIB', 'V V R8', (nbfibr*npg), jsigfb)
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
            call pmfdgedef(3, b, gg, u, alicom, nbfibr, nbcarm, &
                           zr(jacf), nbasspou, maxfipoutre, nbfipoutre, yj, zj, &
                           deffibasse, vfv, defmfib)
!
            call pmfdgedef(3, b, gg, du, dalico, nbfibr, nbcarm, &
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
            call utmess('F', 'ELEMENTS_8')
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
        if (matric) then
            ipomod=jmodfb + nbfibr*(kp-1) 
!           calcul matrice de rigidité
!           Calcul des caracteristiques de section par integration sur les fibres
            call pmfitebkbbts(3, nbfibr, nbcarm, zr(jacf), zr(ipomod), b, wi, gxjx, gxjxpou, &
                              g, gg, nbasspou, maxfipoutre, nbfipoutre, vev, yj, zj, &
                              vfv, skp, sk, vv, vvp)
!
            do i = 1, dimklv
                klv(i) = klv(i)+sk(i)
            enddo
            do i = 1, 2*nc
                fv(i) = fv(i)+vv(i)
            enddo
!
        endif
!
        if (vecteu) then
!           calcul des forces internes
            iposig=jsigfb + nbfibr*(kp-1)
            call pmfitsbts(3, nbfibr, nbcarm, zr(jacf), zr(iposig), b, wi, &
                             nbasspou, yj, zj, maxfipoutre, nbfipoutre, vsigv, vfv, vvp, ve)
            do i = 1, 18
                fl(i) = fl(i)+ve(i)
            enddo
!
        endif
!                  
    enddo
!
!   On modifie la matrice de raideur par condensation statique
    if (matric) then
        call pmffftsq(fv, sv)
        do i = 1, dimklv
            klv(i) = klv(i) - sv(i)/hv
        enddo
    endif
!
!   Torsion a part pour les forces interne
    call pmftorcor(3, nbasspou, gxjx, gxjxpou, u, du, xl, fl)
!
!   Stockage des efforts généralisés et passage des forces en repère local
    if (vecteu) then
!       on sort les contraintes sur chaque fibre
        do kp = 1, 2
            iposcp=icontp + nbfibr*(kp-1)
            iposig=jsigfb + nbfibr*(kp-1)
            do i = 0, nbfibr-1
                zr(iposcp+i) = zr(iposig+i)
            enddo            
            ifgp=ncomp*(kp-1)-1
!           Stockage des forces intégrées
            zr(istrxp+ifgp+1) = fl(9*(kp-1)+1)
            zr(istrxp+ifgp+2) = fl(9*(kp-1)+2)
            zr(istrxp+ifgp+3) = fl(9*(kp-1)+3)
            zr(istrxp+ifgp+4) = fl(9*(kp-1)+4)
            zr(istrxp+ifgp+5) = fl(9*(kp-1)+5)
            zr(istrxp+ifgp+6) = fl(9*(kp-1)+6)
            zr(istrxp+ifgp+19) = fl(9*(kp-1)+7)
            zr(istrxp+ifgp+20) = fl(9*(kp-1)+8)
            zr(istrxp+ifgp+21) = fl(9*(kp-1)+9)
            zr(istrxp+ifgp+15)= alicom+dalico
        enddo
        call utpvlg(nno, nc, pgl, fl, zr(ivectu))
    endif
!
!   On sort la matrice tangente
    if (matric) then
!       Passage local -> global
        call utpslg(nno, nc, pgl, klv, zr(imat))
    endif
!
999 continue
    if (vecteu) then
        call jevech('PCODRET', 'E', jcret)
        zi(jcret) = codret
    endif
!   Deallocation memoire pour tableaux temporaires
    deallocate(vfv)    
    deallocate(skp) 
    deallocate(vvp) 
    AS_DEALLOCATE(vi=nbfipoutre)
    AS_DEALLOCATE(vr=gxjxpou)
    AS_DEALLOCATE(vr=yj)
    AS_DEALLOCATE(vr=zj)
    AS_DEALLOCATE(vr=deffibasse)
    AS_DEALLOCATE(vr=vsigv) 
    AS_DEALLOCATE(vr=vev)
    AS_DEALLOCATE(vr=defmfib)
    AS_DEALLOCATE(vr=defpfib)
    call jedetr('&&TE0540.MODUFIB')
    call jedetr('&&TE0540.SIGFIB')
!
end subroutine
