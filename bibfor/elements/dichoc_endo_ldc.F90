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

subroutine dichoc_endo_ldc(option, nomte, ndim, nbt, nno,&
                         nc, ulm, dul, pgl, iret)
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!        COMPORTEMENT GRILLE ASSEMBLAGE COMBUSTIBLE
!
! --------------------------------------------------------------------------------------------------
!
!  IN
!     option   : option de calcul
!     nomte    : nom terme élémentaire
!     ndim     : dimension du problème
!     nbt      : nombre de terme dans la matrice de raideur
!     nno      : nombre de noeuds de l'élément
!     nc       : nombre de composante par noeud
!     ulm      : déplacement moins
!     dul      : incrément de déplacement
!     pgl      : matrice de passage de global à local
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=*) :: option, nomte
    integer :: ndim, nbt, nno, nc, iret
    real(kind=8) :: ulm(12), dul(12), pgl(3, 3)
!
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/diraidklv.h"
#include "asterfort/diklvraid.h"
#include "asterfort/infdis.h"
#include "asterfort/jevech.h"
#include "asterfort/ldc_dichoc_endo.h"
#include "asterfort/pmavec.h"
#include "asterfort/rcvala.h"
#include "asterfort/rk5adp.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvlg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/vecma.h"
#include "blas/dcopy.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: imatri, ivarim, irep, ifono, icontp, ivarip, iadzi, iazk24, iiter, iterat
    integer :: icarcr, idf, ipi, imate, jmater, nbmater
    integer :: ii, neq, kk
    character(len=24) :: messak(6)

    integer             :: icompo, imater, igeom, icontm, jdc, ivitp, idepen, iviten, jtm, jtp
    integer             :: iretlc
    real(kind=8)        :: klc(nno*nc*2*nno*nc*2), dvl(nno*nc), dpe(nno*nc), dve(nno*nc)
    real(kind=8)        :: klv(nbt), fl(nno*nc), raide(6), force(1)
    real(kind=8)        :: r8bid
    character(len=8)    :: k8bid
    aster_logical       :: rigi, resi, Prediction, Dynamique
! --------------------------------------------------------------------------------------------------
!   Pour le matériau
    integer, parameter  :: nbre1=3
    real(kind=8)        :: valre1(nbre1)
    integer             :: codre1(nbre1)
    character(len=16)   :: materiau
! --------------------------------------------------------------------------------------------------
!   Pour l'intégration de la loi de comportement
    real(kind=8)            :: temps0, temps1, dtemps
!   Paramètres de la loi :     jeu
    integer,parameter       :: ijeu=1
    integer, parameter      :: nbpara=1, nbpain= 2*3 + 3
    real(kind=8)            :: ldcpar(nbpara)
    integer                 :: ldcpai(nbpain)
    character(len=8)        :: ldccar(1)
!   Équations du système
    integer, parameter      :: nbequa=6
    real(kind=8)            :: y0(nbequa), dy0(nbequa), resu(nbequa*2), errmax, ynorme(nbequa)
    integer                 :: nbdecp
!   Variables internes
    integer,parameter       :: nbvari=5, nbcorr=4, idebut=nbvari
    integer                 :: Correspond(nbcorr)
    real(kind=8)            :: varmo(nbvari), varpl(nbvari)
! --------------------------------------------------------------------------------------------------
    real(kind=8)    :: xl(6), xd(3), rignor, deplac, evoljeu0, evoljeu1, xjeu
    real(kind=8)    :: LongDist, Dist12, forceref, rigidref, deplaref
! --------------------------------------------------------------------------------------------------
!   Paramètres associés au matériau codé
    integer, parameter  :: lmat = 9 , lfct = 10
! --------------------------------------------------------------------------------------------------
!   RIGI_MECA_TANG ->        DSIDEP        -->  RIGI
!   FULL_MECA      ->  SIGP  DSIDEP  VARP  -->  RIGI  RESI
!   RAPH_MECA      ->  SIGP          VARP  -->        RESI
    rigi = (option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL')
    resi = (option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL')
! --------------------------------------------------------------------------------------------------
    call jevech('PCOMPOR', 'L', icompo)
!   Seulement en 3D, sur un segment, avec seulement de la translation
    if ((nomte(1:12).ne.'MECA_DIS_T_L').or.(ndim.ne.3).or.(nno.ne.2).or.(nc.ne.3)) then
        messak(1) = nomte
        messak(2) = option
        messak(3) = zk16(icompo+3)
        messak(4) = zk16(icompo)
        call tecael(iadzi, iazk24)
        messak(5) = zk24(iazk24-1+3)
        call utmess('F', 'DISCRETS_22', nk=5, valk=messak)
    endif
! --------------------------------------------------------------------------------------------------
    iret = 0
!   Nombre de degré de liberté
    neq = nno*nc
!   Paramètres en entrée
    call jevech('PMATERC', 'L', imater)
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PCADISK', 'L', jdc)
!   on recupere le no de l'iteration de newton
    call jevech('PITERAT', 'L', iiter)
    iterat = zi(iiter)
!   Seulement en repère local : irep = 2
    call infdis('REPK', irep, r8bid, k8bid)
    if (irep .ne. 2) then
        messak(1) = nomte
        messak(2) = option
        messak(3) = zk16(icompo+3)
        messak(4) = zk16(icompo)
        call tecael(iadzi, iazk24)
        messak(5) = zk24(iazk24-1+3)
        call utmess('F', 'DISCRETS_5', nk=5, valk=messak)
    endif
!   les caractéristiques sont toujours dans le repère local. on fait seulement une copie
    call dcopy(nbt, zr(jdc), 1, klv, 1)
!   Récupère les termes diagonaux de la matrice de raideur
    call diraidklv(nomte,raide,klv)
! --------------------------------------------------------------------------------------------------
!   Champ de vitesse
    Dynamique = ASTER_FALSE
    call tecach('ONO', 'PVITPLU', 'L', iretlc, iad=ivitp)
    if (iretlc .eq. 0) then
        call utpvgl(nno, nc, pgl, zr(ivitp), dvl)
        Dynamique = ASTER_TRUE
    else
        dvl(:) = 0.0d0
    endif
!   Champ de déplacement d'entrainement
    call tecach('ONO', 'PDEPENT', 'L', iretlc, iad=idepen)
    if (iretlc .eq. 0) then
        call utpvgl(nno, nc, pgl, zr(idepen), dpe)
    else
        dpe(:) = 0.0d0
    endif
!   Champ de vitesse d'entrainement
    call tecach('ONO', 'PVITENT', 'L', iretlc, iad=iviten)
    if (iretlc .eq. 0) then
        call utpvgl(nno, nc, pgl, zr(iviten), dve)
    else
        dve(:) = 0.d0
    endif
! --------------------------------------------------------------------------------------------------
!   Variables internes
    call jevech('PVARIMR', 'L', ivarim)
    do ii = 1, nbvari
        varmo(ii) = zr(ivarim+ii-1)
        varpl(ii) = varmo(ii)
    enddo
! --------------------------------------------------------------------------------------------------
!   Coordonnees du discret dans le repère local
    xl(:) = 0.0
    call utpvgl(nno, 3, pgl, zr(igeom), xl)
! --------------------------------------------------------------------------------------------------
!   Adresse de la SD mater
    jmater = zi(imater)
!   Nombre de matériau sur la maille : 1 seul autorisé
    nbmater=zi(jmater)
    ASSERT(nbmater.eq.1)
!   Adresse du matériau codé
    imate = jmater+zi(jmater+nbmater+1)
!   Recherche du matériau dans la SD compor
    materiau = 'DIS_CHOC_ENDO'
    ipi = 0
    do kk = 1, zi(imate+1)
        if ( zk32(zi(imate)+kk-1)(1:16) .eq. materiau ) then
            ipi = zi(imate+2+kk-1)
            goto 10
        endif
    enddo
!   Le matériau n'est pas trouvé
    messak(1) = nomte
    messak(2) = option
    messak(3) = zk16(icompo+3)
    messak(4) = materiau
    call tecael(iadzi, iazk24)
    messak(5) = zk24(iazk24-1+3)
    call utmess('F', 'DISCRETS_7', nk=5, valk=messak)
10  continue
! --------------------------------------------------------------------------------------------------
!   Le bloc d'instruction précédent permet de déterminer : ipi
    ldcpai(:) = -1
    idf = zi(ipi)+zi(ipi+1)
!   Pour les fonctions :
!       Nombre de point     : zi(ii)
!       Adresse des valeurs : zi(ii+2)
    do kk = 1, zi(ipi+2)
        if      ('FXP   ' .eq. zk16(zi(ipi+3)+idf+kk-1)) then
            ii = ipi+lmat-1+lfct*(kk-1)
            ldcpai(1) = zi(ii)
            ldcpai(2) = zi(ii+2)
        else if ('RIGIP ' .eq. zk16(zi(ipi+3)+idf+kk-1)) then
            ii = ipi+lmat-1+lfct*(kk-1)
            ldcpai(3) = zi(ii)
            ldcpai(4) = zi(ii+2)
        else if ('AMORP ' .eq. zk16(zi(ipi+3)+idf+kk-1)) then
            ii = ipi+lmat-1+lfct*(kk-1)
            ldcpai(5) = zi(ii)
            ldcpai(6) = zi(ii+2)
        endif
    enddo
    ASSERT( (ldcpai(1).eq.ldcpai(3)).and.(ldcpai(1).eq.ldcpai(5)) )
    if ( ldcpai(1).lt. 5 ) then
        messak(1) = materiau
        messak(2) = '[FXP|RIGIP|AMORP]'
        call utmess('F', 'DISCRETS_64', nk=2, valk=messak)
    endif
! --------------------------------------------------------------------------------------------------
!   Le premier point de FXP     : forceref
!                       RIGIP   : rigidref
!   Le déplacement de référence : deplaref = forceref/rigidref
    forceref = zr( ldcpai(1) + ldcpai(2) )
    rigidref = zr( ldcpai(3) + ldcpai(4) )
    deplaref = forceref/rigidref
! --------------------------------------------------------------------------------------------------
!   loi de comportement non-linéaire : récupération du temps + et - , calcul de dt
    call jevech('PINSTPR', 'L', jtp)
    call jevech('PINSTMR', 'L', jtm)
    temps0 = zr(jtm)
    temps1 = zr(jtp)
    dtemps = temps1 - temps0
!   contrôle de rk5 : découpage successif, erreur maximale
    call jevech('PCARCRI', 'L', icarcr)
!   nombre d'itérations maxi (ITER_INTE_MAXI=-20 par défaut)
    nbdecp = abs( nint(zr(icarcr)) )
!   tolérance de convergence (RESI_INTE_RELA=1.0E-06 par défaut)
    errmax = zr(icarcr+2)
!
! --------------------------------------------------------------------------------------------------
!   Paramètres de la loi de comportement
    valre1(:) = 0.0
    call rcvala(jmater, ' ', 'DIS_CHOC_ENDO', 0, ' ',&
                [0.0d0], 3, ['DIST_1   ','DIST_2   ','CRIT_AMOR'], valre1, codre1, 1)
!   Calcul du jeu final
!   Longueur du discret
    xd(1:3)   = xl(1+ndim:2*ndim) - xl(1:ndim)
    LongDist  = xd(1)
    Dist12    = -valre1(1) -valre1(2)
!   Amortissement dans le critère ou pas : 1 ou 2
    ldcpai(9) = nint( valre1(3) )
!
    ldcpar(ijeu) = LongDist + Dist12
!   Loi complète
    ldcpai(7) = 1
!
!   Traitement de l'évolution du jeu
!   Pour l'instant ce n'est pas utile
!       ldcpai(8) = 0 Pas de fonction d'évolution du jeu
!                   1 fonction d'évolution du jeu
!       ldcpai(7) = 1 Loi complète
!                 = 2 Loi sans frottement, ni amortissement
    ldcpai(8) = 0
    evoljeu0  = 1.0
    evoljeu1  = 1.0
! --------------------------------------------------------------------------------------------------
!
!   équations du système :
!              1   2   3   4     5    6
!       y0   : ux  fx  vx  pcum  uxan jeu
!       vari :         3   1     2    4
!
    Correspond(:) = [ 4, 5, 3, 6]
    y0(:)  = 0.0; dy0(:) = 0.0
    do ii=1,nbcorr
        y0(Correspond(ii)) = varmo(ii)
    enddo
!   Les grandeurs et leurs dérivées
    y0(1)  = (ulm(1+nc) - ulm(1) + dpe(1+nc) - dpe(1))
    y0(2)  = zr(icontm)
    dy0(1) = (dul(1+nc) - dul(1))/dtemps
    dy0(3) = (dvl(1+nc) - dvl(1) + dve(1+nc) - dve(1) - y0(3))/dtemps
!   calcul de la vitesse d'évolution du jeu
    if (nint(varmo(idebut)).eq.0) then
        y0(6) = LongDist
    endif
    dy0(6) = Dist12*(evoljeu1-evoljeu0)/dtemps
!   RIGIP est obligatoire Kp( y0(4) ) = raideur
!       La fonction raideur et sa dérivée
!   Traitement de l'évolution du jeu
    valre1(:) = 0.0
    call rcvala(jmater, ' ', 'DIS_CHOC_ENDO', 1, 'PCUM', [y0(4)], &
                1, ['RIGIP'], valre1, codre1, 0, nan='NON')
    rignor = valre1(1)
!
    force(:) = 0.0
!   Prédiction en dynamique, on retourne les efforts précédents
    Prediction =((iterat.eq.1).and.resi.and.Dynamique)
!
!   Soit on intègre le jeu soit on prend sa valeur
!       ldcpai(8) = 1 : intégration du jeu
!       ldcpai(8) = 0 : valeur finale
    xjeu = y0(6)*ldcpai(8) + ldcpar(ijeu)*(1.0 - ldcpai(8))
!
    if ( Prediction.and.(ldcpai(8).eq.0) ) then
        r8bid = y0(1) + dy0(1)*dtemps + xjeu - y0(5)
        raide(1) =  0.0
        if ( r8bid <= 0.0 ) then
            raide(1) =  rignor
            if (option.eq.'RAPH_MECA') then
                force(1) = raide(1)*r8bid
            endif
        endif
        goto 888
    endif
!
!   Norme pour le critère d'erreur
    ynorme(1) = deplaref
    ynorme(2) = forceref
    ynorme(3) = deplaref/dtemps
    ynorme(4) = deplaref
    ynorme(5) = deplaref
    ynorme(6) = deplaref
!
    call rk5adp(nbequa, ldcpar, ldcpai, ldccar, temps0, dtemps, nbdecp,&
                errmax, y0, dy0, ldc_dichoc_endo, resu, iret, ynorme)
!   resu(1:nbeq)            : variables intégrées
!   resu(nbeq+1:2*nbeq)     : d(resu)/d(t) a t+dt
    if (iret .ne. 0) goto 999
!
!   Les variables internes
    do ii=1,nbcorr
        varpl(ii) = resu(Correspond(ii))
    enddo
    varpl(idebut) = 1.0
!
    call rcvala(jmater, ' ', 'DIS_CHOC_ENDO', 1, 'PCUM',[resu(4)], &
                1, ['RIGIP'], valre1, codre1, 0, nan='NON')
    raide(1) = valre1(1)
!
    deplac   = resu(1) - y0(1)
    force(1) = min(0.0, resu(2))
    if ( abs(deplac) > r8prem() ) then
        raide(1) = min( raide(1), abs((force(1) - y0(2))/deplac) )
    endif
!
888 continue
! --------------------------------------------------------------------------------------------------
!   Actualisation de la matrice tangente : klv(i,i) = raide(i)
    call diklvraid(nomte, klv, raide)
!   Actualisation de la matrice quasi-tangente
    if ( rigi ) then
        call jevech('PMATUUR', 'E', imatri)
        call utpslg(nno, nc, pgl, klv, zr(imatri))
    endif
!
!   Calcul des efforts généralisés, des forces nodales et des variables internes
    if ( resi ) then
        call jevech('PVECTUR', 'E', ifono)
        call jevech('PCONTPR', 'E', icontp)
!       demi-matrice klv transformée en matrice pleine klc
        call vecma(klv, nbt, klc, neq)
!       calcul de fl = klc.dul (incrément d'effort)
        call pmavec('ZERO', neq, klc, dul, fl)
!       efforts généralisés aux noeuds 1 et 2 (repère local)
!       on change le signe des efforts sur le premier noeud pour les MECA_DIS_TR_L et MECA_DIS_T_L
        do ii = 1, nc
            zr(icontp-1+ii)    = -fl(ii)    + zr(icontm-1+ii)
            zr(icontp-1+ii+nc) =  fl(ii+nc) + zr(icontm-1+ii+nc)
            fl(ii)             =  fl(ii)    - zr(icontm-1+ii)
            fl(ii+nc)          =  fl(ii+nc) + zr(icontm-1+ii+nc)
        enddo
        zr(icontp-1+1)    =  force(1)
        zr(icontp-1+1+nc) =  force(1)
        fl(1)             = -force(1)
        fl(1+nc)          =  force(1)
!       forces nodales aux noeuds 1 et 2 (repère global)
        call utpvlg(nno, nc, pgl, fl, zr(ifono))
!       mise à jour des variables internes
        call jevech('PVARIPR', 'E', ivarip)
        do ii = 1, nbvari
            zr(ivarip+ii-1)        = varpl(ii)
            zr(ivarip+ii-1+nbvari) = varpl(ii)
        enddo
    endif
!
999 continue
end subroutine
