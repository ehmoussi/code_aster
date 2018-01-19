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

subroutine lggvfc(refe,ndim, nno, nnob, npg, nddl, axi, &
                  geom,ddl, vff, vffb, idff, idffb,&
                  iw, sief,fint)

use bloc_fe_module, only: prod_sb, add_fint

    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmbeps.h"
#include "blas/dgemv.h"
    aster_logical :: refe,axi
    integer       :: ndim, nno, nnob, npg, nddl, idff, idffb, iw
    real(kind=8)  :: geom(ndim,nno),ddl(nddl),vff(nno, npg), vffb(nnob, npg)
    real(kind=8)  :: sief(3*ndim+2,npg)
    real(kind=8)  :: fint(nddl)
! ----------------------------------------------------------------------
!  CALCUL DES ELEMENTS CINEMATIQUES POUR LA MODELISATION GRAD_VARI_INCO
! ----------------------------------------------------------------------
! IN  REFE   .true. si REFE_FORC_NODA, .false. si FORC_NODA
! IN  NDIM   DIMENSION DE L'ESPACE
! IN  NNO1   NOMBRE DE NOEUDS TOTAL (SUPPORT DES DEPLACEMENTS)
! IN  NNO2   NOMBRE DE NOEUDS SOMMETS (SUPPORT DE VI ET LAGRANGE)
! IN  NPG    NOMBRE DE POINTS DE GAUSS
! IN  AXI    .TRUE. SI MODELISATION AXIS
! IN  GEOM   COORDONNEES DES NOEUDS
! IN  VFF1   VALEUR DE LA FAMILLE DE FONCTIONS DE FORME NO 1
! IN  VFF2   VALEUR DE LA FAMILLE DE FONCTIONS DE FORME NO 2
! IN  IDFDE1 POINTEUR SUR LES DER. REFERENCE FAMILLE FCT FORME NO 1
! IN  IDFDE2 POINTEUR SUR LES DER. REFERENCE FAMILLE FCT FORME NO 2
! IN  IW     POINTEUR SUR LES POIDS DES PTS DE GAUSS DE REFERENCE
! OUT NDDL   NOMBRE DE DDL / ELEMENT
! OUT NEPS   NBR DE COMPOSANTE DE DEFORMATION (GENERALISEE)
! OUT B      MATRICE CINEMATIQUE EPS = B.U
! OUT W      POIDS DES POINTS DE GAUSS REELS
! OUT NI2LDC CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (AVEC RAC2)
! ----------------------------------------------------------------------
    real(kind=8), parameter :: vrac2(6) = (/ 1.d0,1.d0,1.d0,sqrt(2.d0),sqrt(2.d0),sqrt(2.d0) /)
! ----------------------------------------------------------------------
    integer       :: g,n,i
    integer       :: nnu,nng,ndu,ndg,neu,neg
    integer       :: xu(ndim,nno),xg(2,nnob)
    real(kind=8)  :: depl(ndim,nno)
    real(kind=8)  :: dffb(nnob,ndim)
    real(kind=8)  :: r_ini,r_def,dff_ini(nno,ndim),dff_def(nno,ndim),poids_ini,poids_def
    real(kind=8)  :: bu(2*ndim,ndim,nno),bg(2+ndim,2,nnob)
    real(kind=8)  :: siefu(2*ndim),siefg(2+ndim)
    real(kind=8)  :: rbid=0.d0

! ----------------------------------------------------------------------

!   Tests de coherence
    ASSERT(nddl.eq.nno*ndim + nnob*2)

!   Initialisation
    nnu = nno
    nng = nnob
    ndu = ndim
    ndg = 2
    neu = 2*ndim
    neg = 2+ndim

    fint = 0

    ! tableaux de reference bloc (depl,inco,grad) -> numero du ddl
    forall (i=1:ndg,n=1:nng) xg(i,n) = (n-1)*(ndu+ndg) + ndu + i
    forall (i=1:ndu,n=1:nng) xu(i,n) = (n-1)*(ndu+ndg) + i
    forall (i=1:ndu,n=nng+1:nnu) xu(i,n) = (ndu+ndg)*nng + (n-1-nng)*ndu + i

    ! Decompactage du deplacement
    forall (i=1:ndu, n=1:nnu) depl(i,n) = ddl(xu(i,n))


    gauss: do g = 1,npg

        ! Calcul des derivees des fonctions de forme P1 (geometrie initiale)
        call dfdmip(ndim, nnob, axi, geom, g, iw, vffb(1,g), idffb, rbid, rbid,dffb)

        ! Calcul du poids d'integration (geometrie initiale)
        call dfdmip(ndim, nno, axi, geom, g, iw, vff(1, g), idff, r_ini, poids_ini, dff_ini)

        ! Calcul des derivees des fonctions de forme P2, du rayon et du poids (geometrie deformee)
        call dfdmip(ndim, nno, axi, geom+depl, g, iw, vff(1, g), idff, r_def, poids_def, dff_def)

        ! Calcul de la matrice BU (geometrie deformee)
        call nmbeps(axi,r_def,vff(:,g),dff_def,bu)

        ! Matrice BG (geometrie initiale)
        bg = 0
        bg(1,1,:) = vffb(:,g)
        bg(2,2,:) = vffb(:,g)
        bg(3:neg,1,:) = transpose(dffb)

        ! Extraction des blocs de contraintes generalisees (dont contrainte mecanique de Cauchy)
        siefu = sief(1:neu,g)*vrac2(1:neu)
        siefg = sief(neu+1:neu+neg,g)

        ! Matrices corrigees si REFE_FORC_NODA
        if (refe) then
            bu = abs(bu)
            bg = abs(bg)
        end if

        ! Calcul des contributions aux forces interieures
        call add_fint(fint,xu,poids_def*prod_sb(siefu,bu))
        call add_fint(fint,xg,poids_ini*prod_sb(siefg,bg))


    end do gauss

end subroutine
