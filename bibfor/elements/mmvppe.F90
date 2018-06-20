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

subroutine mmvppe(typmae, typmam, iresog, ndim, nne,&
                  nnm, nnl, nbdm, laxis, ldyna,&
                  lpenac, jeusup, ffe, ffm, dffm, ffl,&
                  norm, tau1, tau2, mprojt, jacobi,&
                  wpg, dlagrc, dlagrf, jeu, djeu,&
                  djeut, mprojn,&
                  mprt1n, mprt2n, gene11, gene21,&
                  gene22, kappa, h, vech1, vech2,&
                  a, ha, hah, mprt11, mprt21,&
                  mprt22,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2, l_previous)
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
#include "asterfort/mmcalg.h"
#include "asterfort/mmreac.h"
#include "asterfort/mmvitm.h"
#include "asterfort/utmess.h"
    character(len=8) :: typmae, typmam
    integer :: iresog
    integer :: ndim, nne, nnm, nnl, nbdm
    real(kind=8) :: ppe
    real(kind=8) :: ffe(9), ffm(9), ffl(9)
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: norm(3)
    real(kind=8) :: mprojt(3, 3)
    aster_logical :: laxis, ldyna, lpenac,l_previous
    real(kind=8) :: jacobi, wpg
    real(kind=8) :: jeusup
    real(kind=8) :: dlagrc, dlagrf(2)
    real(kind=8) :: jeu, djeu(3), djeut(3),ddepmam(9, 3)
    integer      :: granglis
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! PREPARATION DES CALCULS DES VECTEURS - CALCUL DES QUANTITES
! CAS POIN_ELEM
!
! ----------------------------------------------------------------------
!
!
! IN  IRESOG : ALGO. DE RESOLUTION POUR LA GEOMETRIE
!              0 - POINT FIXE
!              1 - NEWTON
! IN  TYPMAE : TYPE DE LA MAILLE ESCLAVE
! IN  TYPMAM : TYPE DE LA MAILLE MAITRE
! IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  NNL    : NOMBRE DE NOEUDS PORTANT UN LAGRANGE DE CONTACT/FROTT
! IN  NBDM   : NOMBRE DE COMPOSANTES/NOEUD DES DEPL+LAGR_C+LAGR_F
! IN  LAXIS  : .TRUE. SI AXISYMETRIE
! IN  LDYNA  : .TRUE. SI DYNAMIQUE
! IN  JEUSUP : JEU SUPPLEMENTAIRE PAR DIST_ESCL/DIST_MAIT
! OUT FFE    : FONCTIONS DE FORMES DEPL_ESCL
! OUT FFM    : FONCTIONS DE FORMES DEPL_MAIT
! OUT FFL    : FONCTIONS DE FORMES LAGR.
! OUT NORM   : NORMALE
! OUT TAU1   : PREMIER VECTEUR TANGENT
! OUT TAU2   : SECOND VECTEUR TANGENT
! OUT MPROJT : MATRICE DE PROJECTION TANGENTE [Pt]
! OUT JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! OUT WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! OUT DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! OUT DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
! OUT JEU    : JEU NORMAL ACTUALISE
! OUT DJEU   : INCREMENT DEPDEL DU JEU
! OUT DJEUT  : INCREMENT DEPDEL DU JEU TANGENT
!
! ----------------------------------------------------------------------
!
    integer :: jpcf,i
    integer :: jgeom, jdepde, jdepm
    integer :: jaccm, jvitm, jvitp
    real(kind=8) :: geomae(9, 3), geomam(9, 3)
    real(kind=8) :: geomm(3), geome(3)
    real(kind=8) :: ddeple(3), ddeplm(3)
    real(kind=8) :: deplme(3), deplmm(3)
    real(kind=8) :: accme(3), vitme(3), accmm(3), vitmm(3)
    real(kind=8) :: vitpe(3), vitpm(3)
    real(kind=8) :: dffe(2, 9), ddffe(3, 9)
    real(kind=8) :: dffm(2, 9), ddffm(3, 9)
    real(kind=8) :: dffl(2, 9), ddffl(3, 9)
    real(kind=8) :: xpc, ypc, xpr, ypr
    real(kind=8) :: mprojn(3, 3)
    real(kind=8) :: tmp,vec(3),valmax,valmin
    
    real(kind=8) :: dnepmait1 ,dnepmait2 ,taujeu1,taujeu2
    
    real(kind=8) :: mprt1n(3, 3), mprt2n(3, 3)

    real(kind=8) :: mprt11(3, 3), mprt21(3, 3), mprt22(3, 3)
!
    real(kind=8) :: gene11(3, 3), gene21(3, 3), gene22(3, 3)
    
    real(kind=8) :: kappa(2, 2), a(2, 2), h(2, 2), ha(2, 2), hah(2, 2)
!
    real(kind=8) :: vech1(3), vech2(3)
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
    tmp=0.0
    valmax=0.0
    djeut = 0.
    ddeple = 0.
    ddeplm = 0.
    granglis = 1.
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
!
! --- MISE A JOUR DES CHAMPS INCONNUS INCREMENTAUX - DEPLACEMENTS
!
    call mmdepm(nbdm, ndim, nne, nnm, jdepm,&
                jdepde, ffe, ffm, ddeple, ddeplm,&
                deplme, deplmm)
!
! --- CALCUL DES VITESSES/ACCELERATIONS
!
    if (ldyna) then
        call mmvitm(nbdm, ndim, nne, nnm, ffe,&
                    ffm, jvitm, jaccm, jvitp, vitme,&
                    vitmm, vitpe, vitpm, accme, accmm)
    endif
!
! --- CALCUL DU JEU NORMAL
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


!     if (iresog .eq. 1) then

        call mmcalg(ndim, nnm, dffm, ddffm, geomam, tau1,&
                    tau2, jeu,djeu ,djeut, ddepmam , norm, gene11, gene21,&
                    gene22, kappa, h, vech1, vech2,&
                    a, ha, hah, mprt11, mprt21,&
                    mprt22, mprt1n, mprt2n,mprojt, iresog,granglis,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2)

!     endif


!
!
end subroutine
