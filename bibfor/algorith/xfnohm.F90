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
subroutine xfnohm(fnoevo, deltat, nno, npg, ipoids,&
                  ivf, idfde, geom, congem, b,&
                  dfdi, dfdi2, r, vectu, imate,&
                  mecani, press1, dimcon, nddls, nddlm,&
                  dimuel, nmec, np1, ndim, axi,&
                  dimenr, nnop, nnops, nnopm, igeom,&
                  jpintt, jpmilt, jheavn, lonch, cnset, heavt,&
                  enrmec, enrhyd, nfiss, nfh, jfisno)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/tecach.h"
#include "asterfort/reeref.h"
#include "asterfort/vecini.h"
#include "asterfort/xcabhm.h"
#include "asterfort/xfnoda.h"
#include "asterfort/xlinhm.h"
#include "jeveux.h"
    aster_logical :: fnoevo, axi
    integer :: nno, npg, imate, dimenr, dimcon, nddls, nddlm
    integer :: dimuel, nmec, np1, ndim, ipoids, ivf, kpi, i, n
    integer :: idfde, mecani(5), press1(7)
    integer :: addeme, addep1, nfiss, nfh, jfisno
    real(kind=8) :: poids, dt, deltat
    real(kind=8) :: vectu(dimuel), b(dimenr, dimuel), r(1:dimenr)
!
! DECLARATIONS POUR XFEM
    integer :: nnop, nnopm, nnops, in, j
    integer :: yaenrm, adenme, nse, ise, ino, enrmec(3)
    integer :: yaenrh, enrhyd(3), adenhy, ncomp, ifiss
    integer :: igeom, jpintt, jpmilt, jheavn, iret, jtab(7)
    integer :: lonch(10), cnset(*), heavt(*), fisno(nnop, nfiss)
    integer :: heavn(nnop,5), ig, ncompn
    real(kind=8) :: coorse(81), he(nfiss), xg(ndim), xe(ndim), bid3(ndim)
    real(kind=8) :: ff(nnop), ff2(nnops), geom(ndim, nnop)
    real(kind=8) :: dfdi(nnop, ndim), dfdi2(nnops, ndim)
    real(kind=8) :: congem(*)
    character(len=8) :: elrefp, elref2
! ======================================================================
!     BUT:  CALCUL  DE L'OPTION FORC_NODA EN MECANIQUE
!           DES MILIEUX POREUX AVEC COUPLAGE THM
! ======================================================================
! AXI       AXISYMETRIQUE ?
! TYPMOD    MODELISATION (D_PLAN, AXI, 3D ?)
! MODINT    METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)
! NNO       NB DE NOEUDS DE L'ELEMENT
! NNOS      NB DE NOEUDS SOMMETS DE L'ELEMENT
! NNOM      NB DE NOEUDS MILIEUX DE L'ELEMENT
! NDDLS     NB DE DDL SUR LES SOMMETS
! NDDLM     NB DE DDL SUR LES MILIEUX
! NPI       NB DE POINTS D'INTEGRATION DE L'ELEMENT
! NPG       NB DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
!                 SOMMETS             POUR LUMPEE   (=NPI=NNOS)
!                 POINTS DE GAUSS     POUR REDUITE  (<NPI)
! NDIM      DIMENSION DE L'ESPACE
! DIMUEL    NB DE DDL TOTAL DE L'ELEMENT
! DIMCON    DIMENSION DES CONTRAINTES GENERALISEES ELEMENTAIRES
! DIMDEF    DIMENSION DES DEFORMATIONS GENERALISEES ELEMENTAIRES
! IVF       FONCTIONS DE FORMES QUADRATIQUES
! NFISS     NOMBRE DE FISSURES
! NFH       NOMBRE DE DDL HEAVISIDE PAR NEOUD
!
! OUT DFDI    : DERIVEE DES FCT FORME
! OUT R       : TABLEAU DES RESIDUS
! OUT VECTU   : FORCES NODALES
! ======================================================================
!
!     ON RECUPERE A PARTIR DE L'ELEMENT QUADRATIQUE L'ELEMENT LINEAIRE
!     ASSOCIE POUR L'HYDRAULIQUE (POUR XFEM)
!
    call xlinhm(elrefp, elref2)
!
!     NOMBRE DE COMPOSANTES DE PHEAVTO (DANS LE CATALOGUE)
    call tecach('OOO', 'PHEAVTO', 'L', iret, nval=2,&
                itab=jtab)
    ncomp = jtab(2)
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
! ======================================================================
! --- DETERMINATION DES VARIABLES CARACTERISANT LE MILIEU --------------
! ======================================================================
    addeme = mecani(2)
    addep1 = press1(3)
    yaenrm = enrmec(1)
    adenme = enrmec(2)
    yaenrh = enrhyd(1)
    adenhy = enrhyd(2)
    dt = deltat
! ======================================================================
! --- INITIALISATION DE VECTU ------------------------------------------
! ======================================================================
    do i = 1, dimuel
        vectu(i)=0.d0
    end do
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
!     FONCTION HEAVISIDE CSTE POUR CHAQUE FISSURE SUR LE SS-ELT
        do ifiss = 1, nfiss
            he(ifiss) = heavt(ncomp*(ifiss-1)+ise)
        end do
! ======================================================================
! --- CALCUL POUR CHAQUE POINT DE GAUSS : BOUCLE SUR KPI ---------------
! ======================================================================
        do kpi = 1, npg
! ======================================================================
! --- INITIALISATION DE R ----------------------------------------------
! ======================================================================
            do i = 1, dimenr
                r(i)=0.d0
            end do
!
!     COORDONNÉES DU PT DE GAUSS DANS LE REPÈRE RÉEL : XG
            call vecini(ndim, 0.d0, xg)
            do j = 1, ndim
                do in = 1, nno
                    xg(j)=xg(j)+zr(ivf-1+nno*(kpi-1)+in)* coorse(ndim*&
                    (in-1)+j)
                end do
            end do
!
!     XG -> XE (DANS LE REPERE DE l'ELREFP) ET VALEURS DES FF EN XE
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
! ======================================================================
! --- CALCUL DE LA MATRICE B AU POINT DE GAUSS -------------------------
! ======================================================================
            call xcabhm(nddls, nddlm, nnop, nnops, nnopm,&
                        dimuel, ndim, kpi, ff, ff2,&
                        dfdi, dfdi2, b, nmec,&
                        addeme, addep1, np1, axi,&
                        ivf, ipoids, idfde, poids, coorse,&
                        nno, geom, yaenrm, adenme, dimenr,&
                        he, heavn, yaenrh, adenhy, nfiss, nfh)
! ======================================================================
            call xfnoda(imate, mecani, press1, enrmec, dimenr,&
                        dimcon, ndim, dt, fnoevo, congem(npg*(ise-1)*dimcon+(kpi-1)*dimcon+1),&
                        r, enrhyd, nfh)
! ======================================================================
! --- CONTRIBUTION DU POINT D'INTEGRATION KPI AU RESIDU ----------------
! ======================================================================
            do i = 1, dimuel
                do n = 1, dimenr
                    vectu(i)=vectu(i)+b(n,i)*r(n)*poids
                end do
            end do
        end do
    end do
end subroutine
