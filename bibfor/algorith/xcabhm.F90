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
subroutine xcabhm(nddls, nddlm, nnop, nnops, nnopm,&
                  dimuel, ndim, kpi, ff, ff2,&
                  dfdi, dfdi2, b, nmec,&
                  addeme, addep1, np1, axi,&
                  ivf, ipoids, idfde, poids, coorse,&
                  nno, geom, yaenrm, adenme, dimenr,&
                  he, heavn, yaenrh, adenhy, nfiss, nfh)
!
use THM_type
use THM_module
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/matini.h"
#include "asterfort/assert.h"
#include "asterfort/xcalc_code.h"
#include "asterfort/xcalc_heav.h"
!
! ======================================================================
!     BUT:  CALCUL  DE LA MATRICE B EN MODE D'INTEGRATION MIXTE
!           AVEC ELEMENTS P2P1 EN MECANIQUE DES MILIEUX POREUX
!           AVEC COUPLAGE HM EN XFEM
! ======================================================================
! AXI       AXISYMETRIQUE?
! TYPMOD    MODELISATION (D_PLAN, AXI, 3D ?)
! MODINT    METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)
! NNOP      NB DE NOEUDS DE L'ELEMENT PARENT
! NNOPS     NB DE NOEUDS SOMMETS DE L'ELEMENT PARENT
! NNOPM     NB DE NOEUDS MILIEUX DE L'ELEMENT PARENT
! NDDLS     NB DE DDL SUR LES SOMMETS
! NDDLM     NB DE DDL SUR LES MILIEUX
! NPI       NB DE POINTS D'INTEGRATION DE L'ELEMENT
! NPG       NB DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
!                 SOMMETS             POUR LUMPEE   (=NPI=NNOS)
!                 POINTS DE GAUSS     POUR REDUITE  (<NPI)
! NDIM      DIMENSION DE L'ESPACE
! DIMUEL    NB DE DDL TOTAL DE L'ELEMENT
! DIMCON    DIMENSION DES CONTRAINTES GENERALISEES ELEMENTAIRES
! DIMENR    DIMENSION DES DEFORMATIONS GENERALISEES ELEMENTAIRES ENRICHI
! NFISS     NOMBRE DE FISSURES
! NFH       NOMBRE DE DDL HEAVISIDE PAR NOEUD
!
!                              sommets                    |            milieux
!           u v w p H1X H1Y H1Z H1PRE1 H2X H2Y H2Z H2PRE1  u v w H1X H1Y H1Z H2X H2Y H2Z
!          -----------------------------------------------------------------------------
!        u|                                               |                             |
!        v|               Fonctions de forme              |                             |
!        w|                                               |                             |
!        E|                       P2                      |              P2             |
!          -----------------------------------------------------------------------------
!        P|                                               |                             |
!       DP|                       P1                      |               0             |
!          -----------------------------------------------------------------------------
!      H1X|                                               |                             |
!      H1Y|                       P2                      |              P2             |
!      H1Z|                                               |                             |
!          -----------------------------------------------------------------------------
!   H1PRE1|                       P1                      |                             |
!          -----------------------------------------------------------------------------
!      H2X|                                               |                             |
!      H2Y|                       P2                      |              P2             |
!      H2Z|                                               |                             |
!          -----------------------------------------------------------------------------
!   H2PRE1|                       P1                      |                             |
!          -----------------------------------------------------------------------------

!
! =====================================================================================
! =====================================================================================

    aster_logical :: axi
    integer :: nddls, nddlm, nmec, np1, ndim, nnop, i, n, kk
    integer :: nnops, nnopm, kpi, dimuel, heavn(nnop,5)
    integer :: addeme, addep1
    integer :: yaenrm, adenme, dimenr
    integer :: yaenrh, adenhy, nfiss, nfh, ifh
    integer :: ipoids, idfde, ivf, nno, hea_se
    real(kind=8) :: dfdi(nnop, ndim), dfdi2(nnops, ndim)
    real(kind=8) :: ff(nnop), ff2(nnops)
    real(kind=8) :: b(dimenr, dimuel), rac, r, geom(ndim, nnop)
    real(kind=8) :: rbid1(nno), rbid2(nno), rbid3(nno)
    real(kind=8) :: he(nfiss) , poids, coorse(81)
! ======================================================================
! --- CALCUL DE CONSTANTES UTILES --------------------------------------
! ======================================================================
    rac= sqrt(2.d0)
    hea_se=xcalc_code(nfiss, he_real=[he])
! ======================================================================
! --- INITIALISATION DE LA MATRICE B -----------------------------------
! ======================================================================
    call matini(dimenr, dimuel, 0.d0, b)
! ======================================================================
! --- CALCUL DU JACOBIEN DE LA TRANSFORMATION SSTET-> SSTET REF --------
! --- AVEC LES COORDONNEES DES SOUS-ELEMENTS ---------------------------
! ======================================================================
    ASSERT((ndim .eq. 2) .or. (ndim .eq. 3))
    if (ndim .eq. 2) then
        call dfdm2d(nno, kpi, ipoids, idfde, coorse,&
                    poids, rbid1, rbid2)
    else if (ndim .eq. 3) then
        call dfdm3d(nno, kpi, ipoids, idfde, coorse,&
                    poids, rbid1, rbid2, rbid3)
    endif
! ======================================================================
! --- MODIFICATION DU POIDS POUR LES MODELISATIONS AXIS ----------------
! ======================================================================
    if (axi) then
        kk = (kpi-1)*nnop
        r = 0.d0
        do n = 1, nnop
            r = r + zr(ivf+n+kk-1)*geom(1,n)
        end do
    endif
! ======================================================================
! --- REMPLISSAGE DE L OPERATEUR B -------------------------------------
! ======================================================================
! --- ON COMMENCE PAR LA PARTIE GAUCHE DE B CORRESPONDANT --------------
! --- AUX NOEUDS SOMMETS -----------------------------------------------
! ======================================================================
    do n = 1, nnops
! ======================================================================
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, ndim
                b(addeme-1+i,(n-1)*nddls+i) = b(addeme-1+i,(n-1)*nddls+i)+ff(n)
            end do
! ======================================================================
! --- CALCUL DE DEPSX, DEPSY, DEPSZ (DEPSZ INITIALISE A 0 EN 2D) -------
! ======================================================================
            do i = 1, ndim
                b(addeme+ndim-1+i,(n-1)*nddls+i) = b(addeme+ndim-1+i,(n-1)*nddls+i)+dfdi(n,i)
            end do
! ======================================================================
! --- CALCUL DE EPSXY --------------------------------------------------
! ======================================================================
            b(addeme+ndim+3,(n-1)*nddls+1) = b(addeme+ndim+3,(n-1)*nddls+1)+dfdi(n,2)/rac
            b(addeme+ndim+3,(n-1)*nddls+2) = b(addeme+ndim+3,(n-1)*nddls+2)+dfdi(n,1)/rac
            if (ndim .eq. 3) then
! ======================================================================
! --- CALCUL DE EPSXZ --------------------------------------------------
! ======================================================================
               b(addeme+ndim+4,(n-1)*nddls+1)= b(addeme+ndim+4,(n-1)*nddls+1)+dfdi(n,3)/rac
               b(addeme+ndim+4,(n-1)*nddls+3)= b(addeme+ndim+4,(n-1)*nddls+3)+dfdi(n,1)/rac
! ======================================================================
! --- CALCUL DE EPSYZ --------------------------------------------------
! ======================================================================
               b(addeme+ndim+5,(n-1)*nddls+2)= b(addeme+ndim+5,(n-1)*nddls+2)+dfdi(n,3)/rac
               b(addeme+ndim+5,(n-1)*nddls+3)= b(addeme+ndim+5,(n-1)*nddls+3)+dfdi(n,2)/rac
            endif
        endif
! ======================================================================
! --- TERMES HYDRAULIQUES (FONCTIONS DE FORMES P1) ---------------------
! ======================================================================
! --- SI PRESS1 --------------------------------------------------------
! ======================================================================
        if (ds_thm%ds_elem%l_dof_pre1) then
            b(addep1,(n-1)*nddls+nmec+1)= b(addep1,(n-1)*nddls+nmec+1)+ff2(n)
            do i = 1, ndim
                b(addep1+i,(n-1)*nddls+nmec+1)= b(addep1+i,(n-1)*nddls+nmec+1)+dfdi2(n,i)
            end do
        endif
! ======================================================================
! --- TERMES ENRICHIS PAR FONCTIONS HEAVISIDE (XFEM) -------------------
! ======================================================================
! --- SI ENRICHISSEMENT MECANIQUE (FONCTIONS DE FORME P2) --------------
! ======================================================================
        if (yaenrm .eq. 1) then
            do ifh = 1, nfh
                do i = 1, ndim
                    b(adenme-1+(ifh-1)*(ndim+1)+i,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+i)= &
                        b(adenme-1+(ifh-1)*(ndim+1)+i,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+i)+&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*ff(n)
                end do
                do i = 1, ndim
                    b(addeme-1+ndim+i,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+i) =&
                        b(addeme-1+ndim+i,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+i)+&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi(n,i)
                end do
                if (axi) then
                    b(addeme+4,(n-1)*nddls+nmec+np1+1)=&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*ff(n)/r
                endif
                b(addeme+ndim+3,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+1) = &
                    b(addeme+ndim+3,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+1)+&
                    xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi(n,2)/rac
                b(addeme+ndim+3,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+2) =&
                    b(addeme+ndim+3,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+2)+&
                    xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi(n,1)/rac
                if (ndim .eq. 3) then
                    b(addeme+ndim+4,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+1) =&
                        b(addeme+ndim+4,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+1)+&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi(n,3)/rac
                    b(addeme+ndim+4,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+3) =&
                        b(addeme+ndim+4,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+3)+&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi(n,1)/rac
                    b(addeme+ndim+5,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+2) =&
                        b(addeme+ndim+5,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+2)+&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi(n,3)/rac
                    b(addeme+ndim+5,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+3) =&
                        b(addeme+ndim+5,(n-1)*nddls+nmec+np1+(ifh-1)*(ndim+1)+3)+&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi(n,2)/rac
                endif
            end do
        endif
! ======================================================================
! --- SI ENRICHISSEMENT HYDRAULIQUE (FONCTIONS DE FORME P1) ------------
! ======================================================================
        if (yaenrh.eq.1) then
            do ifh = 1, nfh
                b(adenhy+(ifh-1)*(ndim+1),(n-1)*nddls+nmec+np1+ifh*(ndim+1))=&
                    b(adenhy+(ifh-1)*(ndim+1),(n-1)*nddls+nmec+np1+ifh*(ndim+1))+&
                    xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*ff2(n)
                do i=1,ndim
                    b(addep1+i,(n-1)*nddls+nmec+np1+ifh*(ndim+1))=&
                        b(addep1+i,(n-1)*nddls+nmec+np1+ifh*(ndim+1))+&
                        xcalc_heav(heavn(n,ifh),hea_se,heavn(n,5))*dfdi2(n,i)
                end do
            end do
        endif
    end do
! ======================================================================
! --- ON REMPLIT MAINTENANT LE COIN SUPERIEUR DROIT DE B CORRESPONDANT -
! --- AUX NOEUDS MILIEUX (MECANIQUE - FONCTIONS DE FORMES P2) ----------
! ======================================================================
    do n = 1, nnopm
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, ndim
                b(addeme-1+i,nnops*nddls+(n-1)*nddlm+i)=&
                    b(addeme-1+i,nnops*nddls+(n-1)*nddlm+i)+ff(n+nnops)
            end do
! ======================================================================
! --- CALCUL DE DEPSX, DEPSY, DEPSZ (DEPSZ INITIALISE A 0 EN 2D) -------
! ======================================================================
            do i = 1, ndim
                b(addeme+ndim-1+i,nnops*nddls+(n-1)*nddlm+i)=&
                    b(addeme+ndim-1+i,nnops*nddls+(n-1)*nddlm+i) +dfdi(n+nnops,i)
            end do
! ======================================================================
! --- TERME U/R DANS EPSZ EN AXI ---------------------------------------
! ======================================================================
            if (axi) then
                b(addeme+4,nnops*nddls+(n-1)*nddlm+1)=ff(n+nnops)/r
            endif
! ======================================================================
! --- CALCUL DE EPSXY POUR LES NOEUDS MILIEUX --------------------------
! ======================================================================
            b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+1)=&
                b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+1) + dfdi(n+nnops,2)/rac
            b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+2)=&
                b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+2) + dfdi(n+nnops,1)/rac
            if (ndim .eq. 3) then
! ======================================================================
! --- CALCUL DE EPSXZ POUR LES NOEUDS MILIEUX --------------------------
! ======================================================================
                b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+1)=&
                    b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+1) + dfdi(n+nnops,3)/rac
                b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+3)=&
                    b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+3) + dfdi(n+nnops,1)/rac
! ======================================================================
! --- CALCUL DE EPSYZ POUR LES NOEUDS MILIEUX --------------------------
! ======================================================================
                b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+2)=&
                    b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+2) +dfdi(n+nnops,3)/rac
                b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+3)=&
                    b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+3) +dfdi(n+nnops,2)/rac
            endif
        endif
! ======================================================================
! --- TERMES ENRICHIS PAR FONCTIONS HEAVISIDE (XFEM) -------------------
! ======================================================================
        if (yaenrm .eq. 1) then
            do ifh = 1, nfh
                do i = 1, ndim
                    b(adenme-1+(ifh-1)*(ndim+1)+i,nnops*nddls+(n-1)*nddlm+nmec*ifh+i)= &
                        b(adenme-1+(ifh-1)*(ndim+1)+i,nnops*nddls+(n-1)*nddlm+nmec*ifh+i)+&
                        xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*ff(n+nnops)
                end do
                do i = 1, ndim
                    b(addeme-1+ndim+i,nnops*nddls+(n-1)*nddlm+nmec*ifh+i)=&
                        b(addeme-1+ndim+i,nnops*nddls+(n-1)*nddlm+nmec*ifh+i)+&
                        xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*dfdi(n+nnops,i)
                end do
                if (axi) then
                    b(addeme+4,nnops*nddls+(n-1)*nddlm+nmec*ifh+1)=&
                        xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*ff(n+nnops)/r
                endif
                b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+nmec*ifh+1)=&
                    b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+nmec*ifh+1) +&
                    xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*dfdi(n+nnops,2)/rac
                b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+nmec*ifh+2)=&
                    b(addeme+ndim+3,nnops*nddls+(n-1)*nddlm+nmec*ifh+2) +&
                    xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*dfdi(n+nnops,1)/rac
                if (ndim .eq. 3) then
                    b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+nmec*ifh+1)=&
                        b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+nmec*ifh+1) +&
                        xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*dfdi(n+nnops,3)/rac
                    b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+nmec*ifh+3)=&
                        b(addeme+ndim+4,nnops*nddls+(n-1)*nddlm+nmec*ifh+3) +&
                        xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*dfdi(n+nnops,1)/rac
                    b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+nmec*ifh+2)=&
                        b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+nmec*ifh+2) +&
                        xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*dfdi(n+nnops,3)/rac
                    b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+nmec*ifh+3)=&
                        b(addeme+ndim+5,nnops*nddls+(n-1)*nddlm+nmec*ifh+3) +&
                        xcalc_heav(heavn(n+nnops,ifh),hea_se,heavn(n+nnops,5))*dfdi(n+nnops,2)/rac
                endif
            end do
        endif
    end do
end subroutine
