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
! aslint: disable=W1504,W1306
! person_in_charge: daniele.colombo at ifpen.fr
!
subroutine xasshm(nno, npg, npi, ipoids, ivf,&
                  idfde, igeom, geom, crit, deplm,&
                  deplp, contm, contp, varim, varip,&
                  defgem, defgep, drds, drdsr, dsde,&
                  b, dfdi, dfdi2, r, sigbar,&
                  c, ck, cs, matuu, vectu,&
                  rinstm, rinstp, option, j_mater, mecani,&
                  press1, press2, tempe, dimdef, dimcon,&
                  dimuel, nbvari, nddls, nddlm, nmec,&
                  np1, ndim, compor, axi, modint,&
                  codret, nnop, nnops, nnopm, enrmec,&
                  dimenr, heavt, lonch, cnset, jpintt,&
                  jpmilt, jheavn, angmas,dimmat, enrhyd,&
                  nfiss, nfh, jfisno, work1, work2)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/lceqvn.h"
#include "asterfort/matini.h"
#include "asterfort/pmathm.h"
#include "asterc/r8prem.h"
#include "asterfort/rcvala.h"
#include "asterfort/reeref.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/vecini.h"
#include "asterfort/xcabhm.h"
#include "asterfort/xdefhm.h"
#include "asterfort/xequhm.h"
#include "asterfort/xlinhm.h"
#include "asterfort/thmGetParaBehaviour.h"
#include "asterfort/thmGetBehaviour.h"
#include "asterfort/thmGetParaCoupling.h"
#include "asterfort/thmGetParaInit.h"
    integer :: dimmat, npg, dimuel
!     DIMENSION DE LA MATRICE DE RIGIDITE DIMMAT=NDDLS*NNOP
!    parameter    (dimmat=8*5)
    integer :: npi, ipoids, ivf, idfde, j_mater, dimdef, dimcon, nnop
    integer :: nbvari, nddls, nddlm, nmec, np1, ndim, codret
    integer :: mecani(5), press1(7), press2(7), tempe(5)
    integer :: yamec, yap1, nfiss, nfh, jfisno
    integer :: addeme, addep1, ii, jj, in, jheavn
    integer :: kpi, ipi
    integer :: i, j, n, k, kji, nvim, nbcomp
    real(kind=8) :: geom(ndim, nnop), crit(*), poids
    real(kind=8) :: deplp(dimuel), deplm(dimuel)
    real(kind=8) :: matuu(dimuel*dimuel), matri(dimmat, dimmat)
    real(kind=8) :: rinstp, rinstm, vectu(dimuel)
    real(kind=8) :: defgem(dimdef), defgep(dimdef)
    real(kind=8) :: dt, ta, ta1
    real(kind=8) :: angmas(3)
    aster_logical :: axi
    character(len=3) :: modint
    character(len=16) :: option, compor(*), thmc
!
! DECLARATION POUR XFEM
    integer :: nnops, nnopm
    integer :: nno, ncomp
    integer :: heavt(*), enrmec(3), dimenr, enrhyd(3)
    integer :: ise, yaenrm, adenme, nse
    integer :: adenhy, yaenrh, ifiss, fisno(nnop, nfiss)
    integer :: lonch(10), ino, cnset(*)
    integer :: jpintt, jpmilt, igeom, iret , jtab(7)
    integer :: heavn(nnop,5), ig, ncompn
    real(kind=8) ::  coorse(81), xg(ndim), xe(ndim), bid3(ndim)
    real(kind=8) :: dfdi(nnop, ndim), dfdi2(nnops, ndim)
    real(kind=8) :: ff(nnop), ff2(nnops), he(nfiss), congem(dimcon)
    real(kind=8) :: degem1(dimenr), degep1(dimenr), congep(dimcon)
    real(kind=8) :: drds(dimenr, dimcon), drdsr(dimenr, dimcon)
    real(kind=8) :: dsde(dimcon, dimenr), b(dimenr, dimuel)
    real(kind=8) :: r(dimenr), sigbar(dimenr), c(dimenr)
    real(kind=8) :: ck(dimenr), cs(dimenr)
    real(kind=8) :: contm(*), contp(*), vintm(nbvari) , vintp(nbvari)
    real(kind=8) :: varim(*), varip(*), temp
    real(kind=8) :: work1(dimcon, dimuel), work2(dimenr, dimuel)
    character(len=8) :: elrefp, elref2
!
! =====================================================================
!     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
!           EN MECANIQUE DES MILIEUX POREUX (AVEC XFEM)
! =====================================================================
! IN AXI       AXISYMETRIQUE?
! IN TYPMOD    MODELISATION (D_PLAN, AXI, 3D ?)
! IN MODINT    METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)
! IN NNO       NB DE NOEUDS DE L'ELEMENT
! IN NNOS      NB DE NOEUDS SOMMETS DE L'ELEMENT
! IN NNOM      NB DE NOEUDS MILIEUX DE L'ELEMENT
! IN NDDLS     NB DE DDL SUR LES SOMMETS
! IN NDDLM     NB DE DDL SUR LES MILIEUX
! IN NPI       NB DE POINTS D'INTEGRATION DE L'ELEMENT
! IN NPG       NB DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
!                    SOMMETS             POUR LUMPEE   (=NPI=NNOS)
!                    POINTS DE GAUSS     POUR REDUITE  (<NPI)
! IN NDIM      DIMENSION DE L'ESPACE
! IN DIMUEL    NB DE DDL TOTAL DE L'ELEMENT
! IN DIMCON    DIMENSION DES CONTRAINTES GENERALISEES ELEMENTAIRES
! IN DIMDEF    DIMENSION DES DEFORMATIONS GENERALISEES ELEMENTAIRES
! IN IVF       FONCTIONS DE FORMES QUADRATIQUES
! IN NFISS     NOMBRE DE FISSURES
! IN NFH       NOMBRE DE DDL HEAVISIDE PAR NOEUD
! =====================================================================
! IN  GEOM    : COORDONNEES DES NOEUDS
! IN  OPTION  : OPTION DE CALCUL
! IN  COMPOR  : COMPORTEMENT
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX + THETA
! IN  DEPLP   : DEPLACEMENT A L INSTANT PLUS
! IN  DEPLM   : DEPLACEMENT A L INSTANT MOINS
! IN  RINSTM  : INSTANT PRECEDENT
! IN  RINSTP  : INSTANT COURANT
! IN  NFISS   : NOMBRE DE FISSURES
! IN  NFH     : NOMBRE DE FISSURES
! OUT CODRET  : CODE RETOUR LOIS DE COMPORTEMENT
! OUT DFDI    : DERIVEE DES FCT FORME
! OUT CONTP   : CONTRAINTES
! OUT VARIP   : VARIABLES INTERNES
! OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
! OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
!......................................................................
!
    ASSERT(nddls*nnop .le. dimmat)
    ASSERT(dimuel .le. dimmat)

!     ON RECUPERE A PARTIR DE L'ELEMENT QUADRATIQUE L'ELEMENT LINEAIRE
!     ASSOCIE POUR L'HYDRAULIQUE (POUR XFEM)
!
    call xlinhm(elrefp, elref2)
!
! =====================================================================
! --- DETERMINATION DES VARIABLES CARACTERISANT LE MILIEU -------------
! =====================================================================
    yamec = mecani(1)
    addeme = mecani(2)
    yap1 = press1(1)
    addep1 = press1(3)
    yaenrm = enrmec(1)
    adenme = enrmec(2)
    yaenrh = enrhyd(1)
    adenhy = enrhyd(2)
! =====================================================================
! --- CALCUL DE CONSTANTES TEMPORELLES --------------------------------
! =====================================================================
    dt = rinstp-rinstm
    ta= crit(4)
    ta1 = 1.d0-ta
! =====================================================================
! --- CREATION DES MATRICES DE SELECTION ------------------------------
! --- (MATRICES DIAGONALES) C,CS --------------------------------------
! --- CES MATRICES SELECTIONNENT LES COMPOSANTES UTILES POUR ----------
! --- POUR CHAQUE TYPE DE POINT D'INTEGRATION -------------------------
! =====================================================================
! --- POUR LES METHODES CLASSIQUE ET LUMPEE ---------------------------
! --- C NE COMPORTENT QUE DES 1 ---------------------------------------
! =====================================================================
! --- INITIALISATION --------------------------------------------------
! =====================================================================
    c(1:dimenr)  = 1.d0
    cs(1:dimenr) = 1.d0
! =====================================================================
! --- SI INTEGRATION REDUITE, ON MET A 0 CERTAINS COEFFICIENTS --------
! =====================================================================
    if (modint .eq. 'RED') then
        if (yamec .eq. 1) then
            do i = 1, ndim
                cs(addeme-1+i) = 0.d0
            end do
            do i = 1, 6
                cs(addeme-1+ndim+i) = 0.d0
            end do
        endif
        if (yap1 .eq. 1) then
            c(addep1) = 0.d0
            do i = 1, ndim
                cs(addep1-1+1+i) = 0.d0
            end do
        endif
    endif
! ======================================================================
! --- FIN CALCUL C,CS --------------------------------------------------
! ======================================================================
! --- INITIALISATION DE VECTU, MATUU A 0 SUIVANT OPTION ----------------
! ======================================================================
    if (option(1:9) .ne. 'RIGI_MECA') then
        do i = 1, dimuel
            vectu(i)=0.d0
        end do
    endif
! ======================================================================
! --- INITIALISATION DF(MATUU) ET MATRI --------------------------------
! ======================================================================
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, dimuel*dimuel
            matuu(i)=0.d0
        end do
        call matini(dimmat, dimmat, 0.d0, matri)
    endif
! 
! - Get behaviours parameters from COMPOR field
!
    call thmGetParaBehaviour(compor, thmc_ = thmc)
!
! - Get parameters for behaviour
!
    call thmGetBehaviour(compor)
!
! - Get parameters for coupling
!
    temp = 0.d0
    call thmGetParaCoupling(j_mater, temp)
!
! - Get initial parameters (THM_INIT)
!
    call thmGetParaInit(j_mater, compor)
!
!     RECUPERATION DE LA CONNECTIVITÃ~I FISSURE - DDL HEAVISIDES
!     ATTENTION !!! FISNO PEUT ETRE SURDIMENTIONNÃ~I
    if (nfiss .eq. 1) then
        do ino = 1, nnop
            fisno(ino,1) = 1
        end do
    else
        do i = 1, nfh
!    ON REMPLIT JUSQU'A NFH <= NFISS
            do ino = 1, nnop
                fisno(ino,i) = zi(jfisno-1+(ino-1)*nfh+i)
            end do
        end do
    endif
!
! =====================================================================
! --- MISE EN OEUVRE DE LA METHODE XFEM -------------------------------
! =====================================================================
!     RÉCUPÉRATION DE LA SUBDIVISION DE L'ÉLÉMENT EN NSE SOUS ELEMEN
    nse=lonch(1)
!     RECUPERATION DE LA DEFINITION DES DDLS HEAVISIDES
    call tecach('OOO', 'PHEA_NO', 'L', iret, nval=7,&
                itab=jtab)
    ncompn = jtab(2)/jtab(3)
    ASSERT(ncompn.eq.5)
    do in = 1, nnop
      do ig = 1 , ncompn
        heavn(in,ig) = zi(jheavn-1+ncompn*(in-1)+ig)
      enddo
    enddo
!
!     BOUCLE D'INTEGRATION SUR LES NSE SOUS-ELEMENTS
    do 510 ise = 1, nse
!
!     BOUCLE SUR LES 4/3 SOMMETS DU SOUS-TETRA/TRIA
        do 511 in = 1, nno
            ino=cnset(nno*(ise-1)+in)
            do 512 j = 1, ndim
                if (ino .lt. 1000) then
                    coorse(ndim*(in-1)+j)=zr(igeom-1+ndim*(ino-1)+j)
                else if (ino.gt.1000 .and. ino.lt.2000) then
                    coorse(ndim*(in-1)+j)=zr(jpintt-1+ndim*(ino-1000-&
                    1)+j)
                else if (ino.gt.2000 .and. ino.lt.3000) then
                    coorse(ndim*(in-1)+j)=zr(jpmilt-1+ndim*(ino-2000-&
                    1)+j)
                else if (ino.gt.3000) then
                    coorse(ndim*(in-1)+j)=zr(jpmilt-1+ndim*(ino-3000-&
                    1)+j)
                endif
512         continue
511     continue
!
!     FONCTION HEAVYSIDE CSTE POUR CHAQUE FISSURE SUR LE SS-ELT
        call tecach('OOO', 'PHEAVTO', 'L', iret, nval=7,&
                    itab=jtab)
        ncomp = jtab(2)
        do ifiss = 1, nfiss
            he(ifiss) = heavt(ncomp*(ifiss-1)+ise)
        end do
! =====================================================================
! --- BOUCLE SUR LES POINTS D'INTEGRATION -----------------------------
! =====================================================================
        do 10 ipi = 1, npi
            kpi = ipi
!
!     COORDONNÉES DU PT DE GAUSS DANS LE REPÈRE RÉEL : XG
            call vecini(ndim, 0.d0, xg)
            do 621 j = 1, ndim
                do 611 in = 1, nno
                    xg(j)=xg(j)+zr(ivf-1+nno*(ipi-1)+in)* coorse(ndim*&
                    (in-1)+j)
611             continue
621         continue
!
!     XG -> XE (DANS LE REPERE DE l'ELREFPe ET VALEURS DES FF EN XE
            call vecini(ndim, 0.d0, xe)
!
!     CALCUL DES FF ET DES DERIVEES DFDI POUR L'ELEMENT PARENTS
!     QUDRATIQUE (MECANIQUE)
            call reeref(elrefp, nnop, zr(igeom), xg, ndim,&
                        xe, ff, dfdi)
!
!     CALCUL DES FF2 ET DES DERIVEES DFDI2 POUR L'ELEMENT LINEAIRE
!     ASSOCIE A ELREFP (HYDRAULIQUE)
            call reeref(elref2, nnops, zr(igeom), xg, ndim,&
                        bid3, ff2, dfdi2)
! =====================================================================
! --- CALCUL DE LA MATRICE B AU POINT D'INTEGRATION -------------------
! =====================================================================
            call xcabhm(nddls, nddlm, nnop, nnops, nnopm,&
                        dimuel, ndim, kpi, ff, ff2,&
                        dfdi, dfdi2, b, nmec, yamec,&
                        addeme, yap1, addep1, np1, axi,&
                        ivf, ipoids, idfde, poids, coorse,&
                        nno, geom, yaenrm, adenme, dimenr,&
                        he, heavn, yaenrh, adenhy, nfiss, nfh)
! =====================================================================
! --- CALCUL INTERMEDIAIRE POUR LES DEF GENERALISEES AVEC XFEM --------
! =====================================================================
            do 108 i = 1, dimenr
                degem1(i)=0.d0
                degep1(i)=0.d0
                do 109 n = 1, dimuel
                    degem1(i)=degem1(i)+b(i,n)*deplm(n)
                    degep1(i)=degep1(i)+b(i,n)*deplp(n)
109             continue
108         continue
! =====================================================================
! --- CALCUL DES DEFORMATIONS GENERALISEES ----------------------------
! =====================================================================
            call xdefhm(dimdef, dimenr, addeme, adenme, addep1,&
                        ndim, degem1, degep1, defgem, defgep, adenhy, nfh)
! ======================================================================
! --- APPEL A LA ROUTINE EQUTHM ----------------------------------------
! ======================================================================
! --- CALCUL DES CONTRAINTES (VIRTUELLES ET GENERALISEES) --------------
! --- ET DE LEURS DERIVEES EN CHAQUE POINT DE GAUSS DU SOUS ------------
! --- ELEMENT COURANT ISE ----------------------------------------------
! ======================================================================
            do i = 1, nbvari
                vintm(i) = varim(npi*(ise-1)*nbvari+(kpi-1)*nbvari+i)
                vintp(i) = varip(npi*(ise-1)*nbvari+(kpi-1)*nbvari+i)
            end do
            do i = 1, dimcon
                congem(i) = contm(npi*(ise-1)*dimcon+(kpi-1)*dimcon+i)
                congep(i) = contp(npi*(ise-1)*dimcon+(kpi-1)*dimcon+i)
            end do
            call xequhm(j_mater, option, ta, ta1, ndim,&
                        compor, kpi, npg, dimenr, enrmec,&
                        dimdef, dimcon, nbvari, defgem, congem,&
                        vintm, defgep, congep,&
                        vintp, mecani, press1, press2, tempe,&
                        rinstp, dt, r, drds, dsde,&
                        codret, angmas, enrhyd, nfh)
            do i = 1, nbvari
                varim(npi*(ise-1)*nbvari+(kpi-1)*nbvari+i)=vintm(i)
                varip(npi*(ise-1)*nbvari+(kpi-1)*nbvari+i)=vintp(i)
            end do
            do i = 1, dimcon
                contm(npi*(ise-1)*dimcon+(kpi-1)*dimcon+i)=congem(i)
                contp(npi*(ise-1)*dimcon+(kpi-1)*dimcon+i)=congep(i)
            end do
! ======================================================================
! --- ATTENTION CI-DESSOUS IL N'Y A PAS D'IMPACT DE CALCUL -------------
! --- ON RECOPIE POUR LA METHODE D'INTEGRATION SELECTIVE LES CONTRAINTES
! --- CALCULEES AUX POINTS DE GAUSS SUR LES NOEUDS POUR DES QUESTIONS DE
! --- POST-TRAITEMENT --------------------------------------------------
! ======================================================================
! --- POUR LES VARIABLES INTERNES ON PASSE PAR COMPOR POUR RECUPERER ---
! --- L'INFORMATION SUR LE NOMBRE DE VI DE LA LOI MECA CORRESPONDANTE --
! --- CETTE IDENTIFICATION SE FAIT NORMALEMENT AU NIVEAU DE NVITHM -----
! --- ATTENTION : NBCOMP EST LE NOMBRE DE VARIABLES DANS LA CARTE COMPOR
! --- DE GRANDEUR_SIMPLE AVANT LA DEFINITION DU NOMBRE DE VARIABLES ----
! --- INTERNES ASSOCIEES AUX RELATIONS DE COMPORTEMENT POUR LA THM -----
! --- SA VALEUR EST A REPRENDRE A L'IDENTIQUE DE LA ROUTINE NVITHM -----
! --- A CE JOUR ELLE VAUT : PARAMETER ( NBCOMP = 7 + 9 ) ---------------
! ======================================================================
            if (mecani(1) .eq. 1) then
                if (kpi .gt. npg) then
                    do 110 i = 1, 6
                        contp((kpi-1)*dimcon+i)=contp((kpi-npg-1)*&
                        dimcon+i)
110                 continue
                    nbcomp = 9 + 7
                    read (compor(nbcomp+4),'(I16)') nvim
                    do 112 i = 1, nvim
                        varip((kpi-1)*nbvari+i) = varip((kpi-npg-1)* nbvari+i)
112                 continue
                endif
            endif
            if (codret .ne. 0) then
                goto 900
            endif
! ======================================================================
! --- CONTRIBUTION DU POINT D'INTEGRATION KPI A LA MATRICE TANGENTE ET -
! --- AU RESIDU --------------------------------------------------------
! ----------------------------------------------------------------------
! --- MATRICE TANGENTE : REMPLISSAGE EN NON SYMETRIQUE -----------------
! ======================================================================
! --- CHOIX DU JEU DE MATRICES ADAPTE AU POINT D'INTEGRATION -----------
! --- SI KPI<NPG ALORS ON EST SUR UN POINT DE GAUSS: CK = C  -----------
! --- SINON ON EST SUR UN SOMMET                   : CK = CS -----------
! ======================================================================
            if (kpi .le. npg) then
                call lceqvn(dimenr, c, ck)
            else
                call lceqvn(dimenr, cs, ck)
            endif
! ======================================================================
! --- CALCUL DE MATUU (MATRI) ------------------------------------------
! ======================================================================
            if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
                do 199 i = 1, dimenr
                    do 198 j = 1, dimcon
                        drdsr(i,j)=drds(i,j)
198                 continue
199             continue
! ======================================================================
! --- ON ASSEMBLE: DF=BT.CK.DRDSR.DSDE.B.POIDS -------------------------
! ======================================================================
                call pmathm(dimmat, dimenr, dimcon, dimuel, dsde,&
                            drdsr, ck, b, poids, work1, work2, matri)
            endif
! ======================================================================
! --- CALCUL DE VECTUU -------------------------------------------------
! ======================================================================
! --- ON SELECTIONNE LES COMPOSANTES UTILES DE R POUR CE PI ------------
! ======================================================================
            if ((option(1:9).eq.'FULL_MECA' .or. option(1:9) .eq.'RAPH_MECA')) then
                do 20 i = 1, dimenr
                    sigbar(i) = ck(i)*r(i)
 20             continue
! ======================================================================
! --- ON ASSEMBLE R=BT.SIGBAR.POIDS ------------------------------------
! ======================================================================
                do 117 i = 1, dimuel
                    do 118 k = 1, dimenr
                        vectu(i)=vectu(i)+b(k,i)*sigbar(k)*poids
118                 continue
117             continue
            endif
 10     continue
! ======================================================================
! --- SORTIE DE BOUCLE SUR LES POINTS D'INTEGRATION --------------------
! ======================================================================
! 888           CONTINUE
!
        if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
            kji=1
            do 115 ii = 1, dimuel
                do 116 jj = 1, dimuel
                    matuu(kji) = matri(ii,jj)
                    kji= kji + 1
116             continue
115         continue
        endif
! ======================================================================
900     continue
! ======================================================================
510 continue
end subroutine
