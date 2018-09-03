! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine mmtppe(typmae, typmam, ndim, nne, nnm,&
                  nnl, nbdm, iresog, laxis, ldyna,&
                  jeusup, ffe, ffm, dffm,ddffm, ffl,&
                  jacobi, wpg, jeu, djeut, dlagrc,&
                  dlagrf, norm, tau1, tau2, mprojn,&
                  mprojt, mprt1n, mprt2n, gene11, gene21,&
                  gene22, kappa, h, vech1, vech2,&
                  a, ha, hah, mprt11, mprt21,&
                  mprt22,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2,l_previous,granglis)
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
! aslint: disable=W1504
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/mmdepm.h"
#include "asterfort/mmform.h"
#include "asterfort/mmgeom.h"
#include "asterfort/mmlagm.h"
#include "asterfort/mmmjac.h"
#include "asterfort/mmmjeu.h"
#include "asterfort/mmreac.h"
#include "asterfort/mmcalg.h"
!
!
    character(len=8) :: typmae, typmam
!
    integer :: ndim, nne, nnm, nnl, nbdm
!
    integer :: iresog,granglis
    aster_logical :: laxis, ldyna,l_previous
!
    real(kind=8) :: jeusup
    real(kind=8) :: jacobi, wpg
    real(kind=8) :: dlagrc, dlagrf(2)
    real(kind=8) :: jeu, djeu(3), djeut(3)
!
    real(kind=8) :: ffe(9), ffm(9), ffl(9)
    real(kind=8) :: dffm(2, 9)
!
    real(kind=8) :: norm(3), tau1(3), tau2(3)
!
    real(kind=8) :: mprojn(3, 3), mprojt(3, 3)
    real(kind=8) :: mprt1n(3, 3), mprt2n(3, 3)
    real(kind=8) :: mprt11(3, 3), mprt21(3, 3), mprt22(3, 3)
!
    real(kind=8) :: gene11(3, 3), gene21(3, 3), gene22(3, 3)
!
    real(kind=8) :: kappa(2, 2), a(2, 2), h(2, 2), ha(2, 2), hah(2, 2)
!
    real(kind=8) :: vech1(3), vech2(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! PREPARATION DES CALCULS DES MATRICES - CALCUL DES QUANTITES
! CAS POIN_ELEM
!
! ----------------------------------------------------------------------
!
!
! IN  TYPMAE : NOM DE LA MAILLE ESCLAVE
! IN  TYPMAM : NOM DE LA MAILLE MAITRE
! IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  NNL    : NOMBRE DE NOEUDS PORTANT UN LAGRANGE DE CONTACT/FROTT
! IN  NBDM   : NOMBRE DE COMPOSANTES/NOEUD DES DEPL+LAGR_C+LAGR_F
! IN  IRESOG : ALGO. DE RESOLUTION POUR LA GEOMETRIE
!              0 - POINT FIXE
!              1 - NEWTON
! IN  LAXIS  : .TRUE. SI AXISYMETRIE
! IN  LDYNA  : .TRUE. SI DYNAMIQUE
! IN  JEUSUP : JEU SUPPLEMENTAIRE PAR DIST_ESCL/DIST_MAIT
! ----
! ----INCONNUES STANDARDS
! OUT FFE    : FONCTIONS DE FORMES DEPL_ESCL
! OUT FFM    : FONCTIONS DE FORMES DEPL_MAIT
! OUT FFL    : FONCTIONS DE FORMES LAGR.
! OUT DFFM   : DERIVEES PREMIERES DES FONCTIONS DE FORME MAITRES
! OUT JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! OUT WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! OUT DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! OUT DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
! OUT JEU    : JEU NORMAL ACTUALISE
! OUT DJEUT  : INCREMENT DEPDEL DU JEU TANGENT
! OUT NORM   : NORMALE
! OUT TAU1   : PREMIER VECTEUR TANGENT
! OUT TAU2   : SECOND VECTEUR TANGENT
! -----------------------------------------------------------------------
!     MATRICES ISSUES DE LA GEOMETRIE DIFFERENTIELLE POUR NEWTON GENE
! -----------------------------------------------------------------------
! OUT MPRT11 : MATRICE DE PROJECTION TANGENTE DANS LA DIRECTION 1
! OUT MPRT11 = TAU1*TRANSPOSE(TAU1)(matrice 3*3)
!
! OUT MPRT12 : MATRICE DE PROJECTION TANGENTE DANS LA DIRECTION 1/2
! OUT MPRT12 = TAU1*TRANSPOSE(TAU2)(matrice 3*3)
!
! OUT MPRT12 : MATRICE DE PROJECTION TANGENTE DANS LA DIRECTION 2
! OUT MPRT12 = TAU2*TRANSPOSE(TAU2)(matrice 3*3)
!
! OUT GENE11 : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT          DDGEOMM(1,1)/NORMALE  (matrice 3*3)
!
! OUT GENE21 : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT          DDGEOMM(2,1)/NORMALE  (matrice 3*3) 
!
! OUT GENE22 : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT          DDGEOMM(2,2)/NORMALE  (matrice 3*3)
!
! OUT KAPPA  : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
! OUT KAPPA(i,j) = INVERSE[TAU_i.TAU_j-JEU*(ddFFM*geomm)](matrice 2*2)
!
! OUT H : MATRICE DE SCALAIRES EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
! OUT H(i,j) = JEU*{[ddFFM(i,j)*geomm].n} (matrice 2*2)
!
! OUT A : MATRICE DE SCALAIRES DUE AU TENSEUR DE WEINTGARTEN
! OUT A(i,j) = [TAU_i.TAU_j] (matrice 2*2)
!
! OUT HA  = H/A   (matrice 2*2)
! OUT HAH = HA/H  (matrice 2*2)
!
! OUT VECH_i = KAPPA(i,m)*TAU_m
! ----------------------------------------------------------------------
!
    integer :: jpcf
    integer :: jgeom, jdepde, jdepm
    integer :: jaccm, jvitm, jvitp
    real(kind=8) :: ppe
!
    real(kind=8) :: geomae(9, 3), geomam(9, 3),ddepmam(9, 3)
    real(kind=8) :: geomm(3), geome(3)
    real(kind=8) :: ddeple(3), ddeplm(3)
    real(kind=8) :: deplme(3), deplmm(3)
!
    real(kind=8) :: dffe(2, 9), ddffe(3, 9)
    real(kind=8) :: ddffm(3, 9)
    real(kind=8) :: dffl(2, 9), ddffl(3, 9)
    real(kind=8) :: xpc, ypc, xpr, ypr
    real(kind=8) :: dnepmait1 ,dnepmait2 ,taujeu1,taujeu2
!
! ----------------------------------------------------------------------
!
!
! --- RECUPERATION DES DONNEES DE PROJECTION
!
    call jevech('PCONFR', 'L', jpcf)
    xpc = zr(jpcf-1+1)
    ypc = zr(jpcf-1+2)
    xpr = zr(jpcf-1+3)
    ypr = zr(jpcf-1+4)
    tau1(1) = zr(jpcf-1+5)
    tau1(2) = zr(jpcf-1+6)
    tau1(3) = zr(jpcf-1+7)
    tau2(1) = zr(jpcf-1+8)
    tau2(2) = zr(jpcf-1+9)
    tau2(3) = zr(jpcf-1+10)
    wpg = zr(jpcf-1+11)
    ppe = 0.d0
    geomae = 0.
    geomam = 0.
!
! TRAITEMENT CYCLAGE : ON REMPLACE LES VALEURS DE JEUX et DE NORMALES
!                      POUR AVOIR UNE MATRICE CONSISTANTE
!     
    if (l_previous) then 
        if (iresog .eq. 1) then
            xpc = zr(jpcf-1+38)
            ypc = zr(jpcf-1+39)
            xpr = zr(jpcf-1+40)
            ypr = zr(jpcf-1+41)
        endif
        tau1(1) = zr(jpcf-1+32)
        tau1(2) = zr(jpcf-1+33)
        tau1(3) = zr(jpcf-1+34)
        tau2(1) = zr(jpcf-1+35)
        tau2(2) = zr(jpcf-1+36)
        tau2(3) = zr(jpcf-1+37)
        wpg = zr(jpcf-1+11)
        ppe = 0.d0
    endif
!
! --- RECUPERATION DE LA GEOMETRIE ET DES CHAMPS DE DEPLACEMENT
!
    call jevech('PGEOMER', 'L', jgeom)
    call jevech('PDEPL_P', 'L', jdepde)
    call jevech('PDEPL_M', 'L', jdepm)
    if (ldyna) then
        call jevech('PVITE_P', 'L', jvitp)
        call jevech('PVITE_M', 'L', jvitm)
        call jevech('PACCE_M', 'L', jaccm)
    endif
    if (iresog .eq. 1) then
        ppe = 1.0d0
    endif
!
!
!
! --- FONCTIONS DE FORMES ET DERIVEES
!
    call mmform(ndim, typmae, typmam, nne, nnm,&
                xpc, ypc, xpr, ypr, ffe,&
                dffe, ddffe, ffm, dffm, ddffm,&
                ffl, dffl, ddffl)
!
! --- JACOBIEN POUR LE POINT DE CONTACT
!
    call mmmjac(typmae, jgeom, ffe, dffe, laxis,&
                nne, ndim, jacobi)
!
! --- REACTUALISATION DE LA GEOMETRIE  (MAILLAGE+DEPMOI)+PPE*DEPDEL
!     POINT_FIXE          --> PPE=0.0d0
!     NEWTON_GENE         --> PPE=1.0d0
!     NEWTON_GENE INEXACT --> 0.0d0<PPE<1.0d0
!
    call mmreac(nbdm, ndim, nne, nnm, jgeom,&
                jdepm, jdepde, ppe, geomae, geomam,ddepmam)
!
! --- CALCUL DES COORDONNEES ACTUALISEES
!
    call mmgeom(ndim, nne, nnm, ffe, ffm,&
                geomae, geomam, tau1, tau2, norm,&
                mprojn, mprojt, geome, geomm)
!
! --- CALCUL DES INCREMENTS - LAGRANGE DE CONTACT ET FROTTEMENT
!
    call mmlagm(nbdm, ndim, nnl, jdepde, ffl,&
                dlagrc, dlagrf)
!
! --- MISE A JOUR DES CHAMPS INCONNUS INCREMENTAUX - DEPLACEMENTS
!
    call mmdepm(nbdm, ndim, nne, nnm, jdepm,&
                jdepde, ffe, ffm, ddeple, ddeplm,&
                deplme, deplmm)
!
! --- CALCUL DES JEUX
!
    call mmmjeu(ndim, jeusup, norm, geome, geomm,&
                ddeple, ddeplm, mprojt, jeu, djeu,&
                djeut, iresog)
!
! TRAITEMENT CYCLAGE : ON REMPLACE LES VALEURS DE JEUX et DE NORMALES
!                      POUR AVOIR UNE MATRICE CONSISTANTE
!     
    
    if (l_previous) then 
        jeu    = zr(jpcf-1+29)
!       djeu(1)    = zr(jpcf-1+29)
!       djeu(2)    = zr(jpcf-1+29)
!       djeu(3)    = zr(jpcf-1+29)
!       djeut(1)    = zr(jpcf-1+29)
!       djeut(2)    = zr(jpcf-1+29)
!       djeut(3)    = zr(jpcf-1+29)
        dlagrc = zr(jpcf-1+26)
!       dlagrf(1) = zr(jpcf-1+26)
!       dlagrf(2) = zr(jpcf-1+26)
        
    endif

!
! MATRICES UTILITAIRES POUR LA DEUXIEME VARIATION DU GAP NORMAL
!
!
!
!    if (iresog .eq. 1) then
!
!
!
        call mmcalg(ndim, nnm, dffm, ddffm, geomam, tau1,&
                    tau2, jeu,djeu , ddepmam , norm, gene11, gene21,&
                    gene22, kappa, h, vech1, vech2,&
                    a, ha, hah, mprt11, mprt21,&
                    mprt22, mprt1n, mprt2n, granglis,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2)




!
!    endif
!
!
!
end subroutine
