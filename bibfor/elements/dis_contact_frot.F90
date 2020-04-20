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

subroutine dis_contact_frot(option, nomte, ndim, nbt, nno,&
                       nc, ulm, dul, pgl, iret)
!
! --------------------------------------------------------------------------------------------------
!
!     RELATION DE COMPORTEMENT "DIS_CHOC" : DYNAMIQUE AVEC OU SANS FROTTEMENT
!                                         : STATIQUE SANS FROTTEMENT
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!  IN
!     option   : option de calcul
!     nomte    : nom terme élémentaire
!     ndim     : dimension du problème
!     nbt      : nombre de terme dans la matrice de raideur
!     nno      : nombre de noeuds de l'élément
!     nc       : nombre de composante par noeud
!     ulm      : déplacement moins dans le repère local de l'élément
!     dul      : incrément de déplacement dans le repère local de l'élément
!     pgl      : matrice de passage de global a local
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=*)    :: option, nomte
    integer             :: ndim, nbt, nno, nc, iret
    real(kind=8)        :: ulm(12), dul(12), pgl(3, 3)
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/diraidklv.h"
#include "asterfort/diklvraid.h"
#include "asterfort/ldc_dis_contact_frot.h"
#include "asterfort/infdis.h"
#include "asterfort/jevech.h"
#include "asterfort/pmavec.h"
#include "asterfort/rcadlv.h"
#include "asterfort/rcvala.h"
#include "asterfort/rk5adp.h"
#include "asterfort/tecach.h"
#include "asterfort/ut2mgl.h"
#include "asterfort/ut2mlg.h"
#include "asterfort/ut2vgl.h"
#include "asterfort/ut2vlg.h"
#include "asterfort/utpsgl.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/vecma.h"
#include "blas/dcopy.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jdc, irep, imat, ivarim, ii, ivitp, idepen, iviten, neq, igeom, ivarip
    integer :: iretlc, ifono, imatsym, jtp, jtm, icarcr, iiter, iterat
    integer :: icontm, icontp
!
    real(kind=8)     :: klc(nno*nc*2*nno*nc*2), dvl(nno*nc), dpe(nno*nc), dve(nno*nc)
    real(kind=8)     :: klv(nbt), force(3), fl(nno*nc), raide(6)
    real(kind=8)     :: r8bid
    character(len=8) :: k8bid
    aster_logical    :: rigi, resi, Prediction, Dynamique
! --------------------------------------------------------------------------------------------------
    integer, parameter  :: nbre1=8
    real(kind=8)        :: valre1(nbre1)
    integer             :: codre1(nbre1)
    character(len=8)    :: nomre1(nbre1)
    integer             :: nbpar
    real(kind=8)        :: valpar
    character(len=8)    :: nompar
    integer             :: jadre1, jcodre1
!
    data nomre1 /'RIGI_NOR','RIGI_TAN','AMOR_NOR','AMOR_TAN', &
                 'COULOMB','DIST_1','DIST_2','JEU'/
! --------------------------------------------------------------------------------------------------
!   Pour l'intégration de la loi de comportement
    real(kind=8)            :: temps0, temps1, dtemps
!   Paramètres de la loi :     Kn      Kt    mu     cn     ct     jeu,    ky,    kz
    integer,parameter       :: ikn=1, ikt=2, imu=3, icn=4, ict=5, ijeu=6, iky=7, ikz=8
    integer, parameter      :: nbpara=8
    real(kind=8)            :: ldcpar(nbpara)
    integer                 :: ldcpai(2)
    character(len=8)        :: ldcpac(1)
!   Équations du système
    integer, parameter      :: nbequa=14
    real(kind=8)            :: y0(nbequa), dy0(nbequa), resu(nbequa*2), errmax, ynorme(nbequa)
    integer                 :: nbdecp
!   Variables internes
    integer,parameter       :: nbvari=9, nbcorr=8, idebut=9
    integer                 :: Correspond(nbcorr)
    real(kind=8)            :: varmo(nbvari), varpl(nbvari)

! --------------------------------------------------------------------------------------------------
    integer         :: nbout
    real(kind=8)    :: xl(6), xd(3), rignor, rigtan, coulom, deplac, evoljeu0, evoljeu1, xjeu
    real(kind=8)    :: LgDiscret, Dist12, inst0, inst1
! --------------------------------------------------------------------------------------------------
!
!   RIGI_MECA_TANG ->        DSIDEP        -->  RIGI
!   FULL_MECA      ->  SIGP  DSIDEP  VARP  -->  RIGI  RESI
!   RAPH_MECA      ->  SIGP          VARP  -->        RESI
    rigi = (option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL')
    resi = (option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL')
!
    iret = 0
!   Nombre de degré de liberté
    neq = nno*nc
!   Paramètres en entrée
    call jevech('PCADISK', 'L', jdc)
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PMATERC', 'L', imat)
!   on recupere le no de l'iteration de newton
    call jevech('PITERAT', 'L', iiter)
    iterat = zi(iiter)
!
    call infdis('REPK', irep, r8bid, k8bid)
!   irep = 1 = matrice en repère global ==> passer en local
    if (irep .eq. 1) then
        if (ndim .eq. 3) then
            call utpsgl(nno, nc, pgl, zr(jdc), klv)
        else if (ndim .eq. 2) then
            call ut2mgl(nno, nc, pgl, zr(jdc), klv)
        endif
    else
        call dcopy(nbt, zr(jdc), 1, klv, 1)
    endif
!   Récupération des termes diagonaux : raide = klv(i,i)
    call diraidklv(nomte,raide,klv)
!
!   Champ de vitesse
    Dynamique = ASTER_FALSE
    call tecach('ONO', 'PVITPLU', 'L', iretlc, iad=ivitp)
    if (iretlc .eq. 0) then
        if (ndim .eq. 3) then
            call utpvgl(nno, nc, pgl, zr(ivitp), dvl)
        else if (ndim .eq. 2) then
            call ut2vgl(nno, nc, pgl, zr(ivitp), dvl)
        endif
        Dynamique = ASTER_TRUE
    else
        dvl(:) = 0.0d0
    endif
!   Champ de déplacement d'entrainement
    call tecach('ONO', 'PDEPENT', 'L', iretlc, iad=idepen)
    if (iretlc .eq. 0) then
        if (ndim .eq. 3) then
            call utpvgl(nno, nc, pgl, zr(idepen), dpe)
        else if (ndim .eq. 2) then
            call ut2vgl(nno, nc, pgl, zr(idepen), dpe)
        endif
    else
        dpe(:) = 0.0d0
    endif
!   Champ de vitesse d'entrainement
    call tecach('ONO', 'PVITENT', 'L', iretlc, iad=iviten)
    if (iretlc .eq. 0) then
        if (ndim .eq. 3) then
            call utpvgl(nno, nc, pgl, zr(iviten), dve)
        else if (ndim .eq. 2) then
            call ut2vgl(nno, nc, pgl, zr(iviten), dve)
        endif
    else
        dve(:) = 0.d0
    endif
!
!   Variables internes
    call jevech('PVARIMR', 'L', ivarim)
    do ii = 1, nbvari
        varmo(ii) = zr(ivarim+ii-1)
        varpl(ii) = varmo(ii)
    enddo
!
!   loi de comportement non-linéaire : récupération du temps + et - , calcul de dt
    call jevech('PINSTPR', 'L', jtp)
    call jevech('PINSTMR', 'L', jtm)
    temps0 = zr(jtm)
    temps1 = zr(jtp)
    dtemps = temps1 - temps0
!   contrôle de rk5 : découpage successif, erreur maximale
    call jevech('PCARCRI', 'L', icarcr)
!   nombre d'itérations maxi (ITER_INTE_MAXI=-20 par défaut)
    nbdecp = abs( int(zr(icarcr)) )
!   tolérance de convergence (RESI_INTE_RELA=1.0E-06 par défaut)
    errmax = zr(icarcr+2)
!
! --------------------------------------------------------------------------------------------------
!   Relation de comportement de choc
!
!   Coordonnees du discret dans le repère local
    xl(:) = 0.0
    if (ndim .eq. 3) then
        call utpvgl(nno, 3, pgl, zr(igeom), xl)
    else if (ndim .eq. 2) then
        call ut2vgl(nno, 2, pgl, zr(igeom), xl)
    endif
!
!   Caractéristiques du matériau
!    1          2          3          4          5         6        7        8
!   'RIGI_NOR','RIGI_TAN','AMOR_NOR','AMOR_TAN','COULOMB','DIST_1','DIST_2','JEU'
    valre1(:) = 0.0
    nbpar  = 0
    nompar = ' '
    valpar = 0.d0
!   Si mot_cle RIGI_NOR ==> rignor = valre1(1) sinon rignor = raide(1)
!   Si mot_cle RIGI_TAN ==> rigtan = valre1(2) sinon rigtan = 0.0
    rignor = raide(1)
    rigtan = 0.0
    call rcvala(zi(imat), ' ', 'DIS_CONTACT', nbpar, nompar,&
                [valpar], nbre1, nomre1, valre1, codre1, 0, nan='NON')
!
    if (codre1(1) .eq. 0) rignor = valre1(1)
    if (codre1(2) .eq. 0) rigtan = valre1(2)
    coulom = valre1(5)
!   Paramètres de la loi de comportement
    ldcpar(:) = 0.0d0
    ldcpar(ikn) = rignor
    ldcpar(ikt) = rigtan
    ldcpar(imu) = coulom
    if (codre1(3) .eq. 0) ldcpar(icn) = valre1(3)
    if (codre1(4) .eq. 0) ldcpar(ict) = valre1(4)
    ldcpar(iky) = raide(2)
    ldcpar(ikz) = raide(3)
!   calcul du jeu final
    LgDiscret = 0.0
    if ( nno .eq. 2 ) then
!       Longueur du discret
        xd(1:3)   = xl(1+ndim:2*ndim) - xl(1:ndim)
        LgDiscret  = xd(1)
        Dist12    = -valre1(6) - valre1(7)
    else
        Dist12 = valre1(8) - valre1(6)
    endif
    ldcpar(ijeu) = LgDiscret + Dist12
!   La loi complète
    ldcpai(1)    = 2
!   si raideur (tangente = faible) ou (coulom=0) ==> pas de frottement, pas de seuil
!       juste du contact, avec/sans amortissement normal
    if ( (abs(rigtan)<=r8prem()) .or. (abs(coulom)<=r8prem()) ) then
        ldcpai(1) = 1
    endif
!   Traitement de l'évolution du jeu
    jadre1 = 0; nbout = 0; jcodre1 = 0
    call rcadlv(' ', 1, 1, '+',zi(imat),' ','DIS_CONTACT', 'INST_COMP_INIT', &
                0, [' '], [0.d0], jadre1, nbout, jcodre1, 0)
    if (jcodre1 .eq. 0 .and. nbout .eq. 2) then
        inst0 = zr(jadre1); inst1 = zr(jadre1+1)
        ASSERT( inst0 < inst1 )
        evoljeu0 = min( max(0.0, (temps0-inst0)/(inst1-inst0)), 1.0)
        evoljeu1 = min( max(0.0, (temps1-inst0)/(inst1-inst0)), 1.0)
!
        ldcpai(2) = 1
!       Si le jeu évolue, alors ni frottement, ni amortissement, juste du contact
        if ( abs(evoljeu1-evoljeu0) > r8prem() ) then
            ldcpai(1) = 3
        endif
    else
!       Pas de fonction d'évolution du jeu
        ldcpai(2) = 0
        evoljeu0  = 1.0
        evoljeu1  = 1.0
    endif
!
!   Équations du système :
!              1   2   3   4   5   6   7   8   9   10    11    12   13   14
!       yy   : Ux, Uy, Uz, Fx, Fy, Fz, vx, vy, vz, Uyan, Uzan, Fcy, Fcz, jeu
!       vari :                         5   6   7   3     4     1    2    8
    Correspond(:) = [ 12, 13, 10, 11, 7, 8, 9, 14 ]
    y0(:)  = 0.0
    dy0(:) = 0.0
    do ii=1,nbcorr
        y0(Correspond(ii)) = varmo(ii)
    enddo
!   Les dérivées
    if (nno .eq. 1) then
        y0(1)  = ulm(1) + dpe(1)
        y0(2)  = ulm(2) + dpe(2)
        y0(4)  = zr(icontm)
        y0(5)  = zr(icontm+1)
        dy0(1) = dul(1)/dtemps
        dy0(2) = dul(2)/dtemps
        dy0(7) = (dvl(1) + dve(1) - y0(7))/dtemps
        dy0(8) = (dvl(2) + dve(2) - y0(8))/dtemps
        if (ndim .eq. 3) then
            y0(3)  = ulm(3) + dpe(3)
            y0(6)  = zr(icontm+2)
            dy0(3) = dul(3)/dtemps
            dy0(9) = (dvl(3) + dve(3) - y0(9))/dtemps
        endif
    else
        y0(1)  = (ulm(1+nc) - ulm(1) + dpe(1+nc) - dpe(1))
        y0(2)  = (ulm(2+nc) - ulm(2) + dpe(2+nc) - dpe(2))
        y0(4)  = zr(icontm)
        y0(5)  = zr(icontm+1)
        dy0(1) = (dul(1+nc) - dul(1))/dtemps
        dy0(2) = (dul(2+nc) - dul(2))/dtemps
        dy0(7) = (dvl(1+nc) - dvl(1) + dve(1+nc) - dve(1) - y0(7))/dtemps
        dy0(8) = (dvl(2+nc) - dvl(2) + dve(2+nc) - dve(2) - y0(8))/dtemps
        if (ndim .eq. 3) then
            y0(3)  = (ulm(3+nc) - ulm(3) + dpe(3+nc) - dpe(3))
            y0(6)  = zr(icontm+2)
            dy0(3) = (dul(3+nc) - dul(3))/dtemps
            dy0(9) = (dvl(3+nc) - dvl(3) + dve(3+nc) - dve(3) - y0(9))/dtemps
        endif
    endif
!
!    dy0(14) = lejeu*(evoljeu1-evoljeu0)/dtemps
!   calcul de la vitesse d'évolution du jeu
    if (nint(varmo(idebut)).eq.0) then
        y0(14) = LgDiscret
    endif
    dy0(14) = Dist12*(evoljeu1-evoljeu0)/dtemps
!
    force(:) = 0.0
!   Prédiction en dynamique, on retourne les efforts précédents
    Prediction =               ((iterat.eq.1).and.(option.eq.'FULL_MECA'))
    Prediction = Prediction.or.((iterat.eq.1).and.(option.eq.'RAPH_MECA'))
!
!   Soit on intègre le jeu soit on prend sa valeur
!       ldcpai(2) = 1 : intégration du jeu
!       ldcpai(2) = 0 : valeur finale
    xjeu = y0(14)*ldcpai(2) + ldcpar(ijeu)*(1.0 - ldcpai(2))
!
    if ( Prediction.and.Dynamique.and.(ldcpai(2).eq.0) ) then
        r8bid = y0(1) + dy0(1)*dtemps + xjeu
        raide(1) =  0.0
        if ( r8bid <= 0.0 ) then
            raide(1) =  rignor
            if (option.eq.'RAPH_MECA') then
                force(1:3) = y0(4:6)
                force(1)   = raide(1)*r8bid
            endif
        endif
        goto 888
    endif
!
!   Si le discret est en contact        ==> raideur de contact
!                 n'est pas en contact  ==> raideur nulle
!       mise à jour de la raideur en sortie de la ldc
    if ( y0(1) + xjeu <= 0.0 ) then
        raide(1) =  rignor
    else
        raide(1) = 0.0
    endif
!   Si on a du contact initial : on retourne l'effort de contact
    if ((xjeu<=0.0).and.(nint(varmo(idebut)).eq.0)) then
        y0(4)  = raide(1)*xjeu
    endif
!   Normalisation des équations, par défaut 1
    ynorme(:)   = 1.0
!   On intègre
    iret = 0
    call rk5adp(nbequa, ldcpar, ldcpai, ldcpac, temps0, dtemps, nbdecp,&
                errmax, y0, dy0, ldc_dis_contact_frot, resu, iret, ynorme=ynorme)
!   resu(1:nbequa)              : variables intégrées
!   resu(nbequa+1:2*nbequa)     : d(resu)/d(t) a t+dt
    if (iret .ne. 0) goto 999
!   Les efforts
    force(1:3) = resu(4:6)
!   Les variables internes
    do ii=1,nbcorr
        varpl(ii) = resu(Correspond(ii))
    enddo
    varpl(idebut) = 1.0
!   Les raideurs
    xjeu = resu(14)*ldcpai(2) + ldcpar(ijeu)*(1.0 - ldcpai(2))
    if ( resu(1) + xjeu <= 0.0 ) then
        raide(1) = rignor
        deplac = resu(1) - y0(1)
        if ( abs(deplac) > r8prem() ) then
            raide(1) = min( raide(1), abs((resu(4) - y0(4))/deplac) )
        endif
        deplac = resu(2) - y0(2)
        if ( abs(deplac) > r8prem() ) then
            raide(2) = min( raide(2), abs((resu(5) - y0(5))/deplac) )
        endif
        deplac = resu(3) - y0(3)
        if ( abs(deplac) > r8prem() ) then
            raide(3) = min( raide(3), abs((resu(6) - y0(6))/deplac) )
        endif
    else
        raide(1) = 0.0
        force(1) = 0.0
    endif
!
888 continue
! --------------------------------------------------------------------------------------------------
!   Actualisation de la matrice tangente : klv(i,i) = raide(i)
    call diklvraid(nomte, klv, raide)
    if ( rigi ) then
        call jevech('PMATUUR', 'E', imatsym)
        if (ndim .eq. 3) then
            call utpslg(nno, nc, pgl, klv, zr(imatsym))
        else if (ndim .eq. 2) then
            call ut2mlg(nno, nc, pgl, klv, zr(imatsym))
        endif
    endif
!
!   Calcul des efforts généralisés, des forces nodales et des variables internes
    if ( resi ) then
        call jevech('PVECTUR', 'E', ifono)
        call jevech('PCONTPR', 'E', icontp)
!       Demi-matrice klv transformée en matrice pleine klc
        call vecma(klv, nbt, klc, neq)
!       Calcul de fl = klc.dul (incrément d'effort)
        call pmavec('ZERO', neq, klc, dul, fl)
!       Efforts généralisés aux noeuds 1 et 2 (repère local)
!       On change le signe des efforts sur le premier noeud pour les MECA_DIS_TR_L et MECA_DIS_T_L
        if (nno .eq. 1) then
            do ii = 1, neq
                zr(icontp-1+ii) = fl(ii) + zr(icontm-1+ii)
                fl(ii)          = fl(ii) + zr(icontm-1+ii)
            enddo
        else if (nno .eq. 2) then
            do ii = 1, nc
                zr(icontp-1+ii)    = -fl(ii)    + zr(icontm-1+ii)
                zr(icontp-1+ii+nc) =  fl(ii+nc) + zr(icontm-1+ii+nc)
                fl(ii)             =  fl(ii)    - zr(icontm-1+ii)
                fl(ii+nc)          =  fl(ii+nc) + zr(icontm-1+ii+nc)
            enddo
        endif
        if (nno .eq. 1) then
            zr(icontp-1+1) = force(1)
            zr(icontp-1+2) = force(2)
            fl(1) = force(1)
            fl(2) = force(2)
            if (ndim .eq. 3) then
                zr(icontp-1+3) = force(3)
                fl(3)          = force(3)
            endif
        else if (nno .eq. 2) then
            zr(icontp-1+1)    = force(1)
            zr(icontp-1+1+nc) = force(1)
            zr(icontp-1+2)    = force(2)
            zr(icontp-1+2+nc) = force(2)
            fl(1)    = -force(1)
            fl(1+nc) =  force(1)
            fl(2)    = -force(2)
            fl(2+nc) =  force(2)
            if (ndim .eq. 3) then
                zr(icontp-1+3)    =  force(3)
                zr(icontp-1+3+nc) =  force(3)
                fl(3)             = -force(3)
                fl(3+nc)          =  force(3)
            endif
        endif
!       Forces nodales aux noeuds 1 et 2 (repère global)
        if (nc .ne. 2) then
            call utpvlg(nno, nc, pgl, fl, zr(ifono))
        else
            call ut2vlg(nno, nc, pgl, fl, zr(ifono))
        endif
!       Mise à jour des variables internes
        call jevech('PVARIPR', 'E', ivarip)
        if ( nno .eq. 1 ) then
            do ii = 1, nbvari
                zr(ivarip+ii-1) = varpl(ii)
            enddo
        else
            do ii = 1, nbvari
                zr(ivarip+ii-1)        = varpl(ii)
                zr(ivarip+ii-1+nbvari) = varpl(ii)
            enddo
        endif
    endif
!
999 continue
end subroutine
