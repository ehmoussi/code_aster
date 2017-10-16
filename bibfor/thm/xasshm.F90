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
                  idfde, igeom, geom, carcri, deplm,&
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
use THM_type
use THM_module
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
#include "asterfort/thmGetBehaviourVari.h"
#include "asterfort/thmGetBehaviour.h"
#include "asterfort/thmGetParaCoupling.h"
#include "asterfort/thmGetParaInit.h"
#include "asterfort/thmGetBehaviourChck.h"
#include "asterfort/Behaviour_type.h"
    integer :: dimmat, npg, dimuel
    integer :: npi, ipoids, ivf, idfde, j_mater, dimdef, dimcon, nnop
    integer :: nbvari, nddls, nddlm, nmec, np1, ndim, codret
    integer :: mecani(5), press1(7), press2(7), tempe(5)
    integer ::  nfiss, nfh, jfisno
    integer :: addeme, addep1, ii, jj, in, jheavn
    integer :: kpi, ipi
    integer :: i, j, n, k, kji, nb_vari_meca
    real(kind=8) :: geom(ndim, nnop), carcri(*), poids
    real(kind=8) :: deplp(dimuel), deplm(dimuel)
    real(kind=8) :: matuu(dimuel*dimuel), matri(dimmat, dimmat)
    real(kind=8) :: rinstp, rinstm, vectu(dimuel)
    real(kind=8) :: defgem(dimdef), defgep(dimdef)
    real(kind=8) :: dt, parm_theta, ta1
    real(kind=8) :: angmas(3)
    aster_logical :: axi
    character(len=3) :: modint
    character(len=16) :: option, compor(*)
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
    addeme = mecani(2)
    addep1 = press1(3)
    yaenrm = enrmec(1)
    adenme = enrmec(2)
    yaenrh = enrhyd(1)
    adenhy = enrhyd(2)
! =====================================================================
! --- CALCUL DE CONSTANTES TEMPORELLES --------------------------------
! =====================================================================
    dt = rinstp-rinstm
    parm_theta  = carcri(PARM_THETA_THM)
    ta1 = 1.d0-parm_theta
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
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, ndim
                cs(addeme-1+i) = 0.d0
            end do
            do i = 1, 6
                cs(addeme-1+ndim+i) = 0.d0
            end do
        endif
        if (ds_thm%ds_elem%l_dof_pre1) then
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
! - Get parameters for behaviour
!
    call thmGetBehaviour(compor)
!
! - Get parameters for internal variables
!
    call thmGetBehaviourVari()
!
! - Some checks between behaviour and model
!
    call thmGetBehaviourChck()
!
! - Get parameters for coupling
!
    temp = 0.d0
    call thmGetParaCoupling(j_mater, temp)
!
! - Get initial parameters (THM_INIT)
!
    call thmGetParaInit(j_mater, l_check_ = ASTER_TRUE)
!
!     RECUPERATION DE LA CONNECTIVITE FISSURE - DDL HEAVISIDES
!     ATTENTION !!! FISNO PEUT ETRE SURDIMENTIONNE
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
    do ise = 1, nse
!
!     BOUCLE SUR LES 4/3 SOMMETS DU SOUS-TETRA/TRIA
        do in = 1, nno
            ino=cnset(nno*(ise-1)+in)
            do j = 1, ndim
                if (ino .lt. 1000) then
                    coorse(ndim*(in-1)+j)=zr(igeom-1+ndim*(ino-1)+j)
                else if (ino.gt.1000 .and. ino.lt.2000) then
                    coorse(ndim*(in-1)+j)=zr(jpintt-1+ndim*(ino-1000-1)+j)
                else if (ino.gt.2000 .and. ino.lt.3000) then
                    coorse(ndim*(in-1)+j)=zr(jpmilt-1+ndim*(ino-2000-1)+j)
                else if (ino.gt.3000) then
                    coorse(ndim*(in-1)+j)=zr(jpmilt-1+ndim*(ino-3000-1)+j)
                endif
            end do
        end do
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
        do ipi = 1, npi
            kpi = ipi
!
!     COORDONNÉES DU PT DE GAUSS DANS LE REPÈRE RÉEL : XG
            call vecini(ndim, 0.d0, xg)
            do j = 1, ndim
                do in = 1, nno
                    xg(j)=xg(j)+zr(ivf-1+nno*(ipi-1)+in)* coorse(ndim*&
                    (in-1)+j)
                end do
            end do
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
                        dfdi, dfdi2, b, nmec, &
                        addeme, addep1, np1, axi,&
                        ivf, ipoids, idfde, poids, coorse,&
                        nno, geom, yaenrm, adenme, dimenr,&
                        he, heavn, yaenrh, adenhy, nfiss, nfh)
! =====================================================================
! --- CALCUL INTERMEDIAIRE POUR LES DEF GENERALISEES AVEC XFEM --------
! =====================================================================
            do i = 1, dimenr
                degem1(i)=0.d0
                degep1(i)=0.d0
                do n = 1, dimuel
                    degem1(i)=degem1(i)+b(i,n)*deplm(n)
                    degep1(i)=degep1(i)+b(i,n)*deplp(n)
                end do
            end do
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
            call xequhm(j_mater, option, parm_theta, ta1, ndim,&
                        kpi, npg, dimenr, enrmec,&
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
                    do i = 1, 6
                        contp((kpi-1)*dimcon+i)=contp((kpi-npg-1)*&
                        dimcon+i)
                    end do
                    nb_vari_meca = ds_thm%ds_behaviour%nb_vari_meca
                    do i = 1, nb_vari_meca
                        varip((kpi-1)*nbvari+i) = varip((kpi-npg-1)* nbvari+i)
                    end do
                endif
            endif
            if (codret .ne. 0) then
                goto 99
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
                do i = 1, dimenr
                    do j = 1, dimcon
                        drdsr(i,j)=drds(i,j)
                    end do
                end do
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
                do i = 1, dimenr
                    sigbar(i) = ck(i)*r(i)
                end do
! ======================================================================
! --- ON ASSEMBLE R=BT.SIGBAR.POIDS ------------------------------------
! ======================================================================
                do i = 1, dimuel
                    do k = 1, dimenr
                        vectu(i)=vectu(i)+b(k,i)*sigbar(k)*poids
                    end do
                end do
            endif
        end do
! ======================================================================
! --- SORTIE DE BOUCLE SUR LES POINTS D'INTEGRATION --------------------
! ======================================================================
        if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
            kji=1
            do ii = 1, dimuel
                do jj = 1, dimuel
                    matuu(kji) = matri(ii,jj)
                    kji= kji + 1
                end do
            end do
        endif
! ======================================================================
99      continue
! ======================================================================
    end do
end subroutine
