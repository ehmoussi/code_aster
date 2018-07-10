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

! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
! aslint: disable=W1504
!
subroutine mmvppe(typmae, typmam,&
                  iresog, ndim, nne,&
                  nnm, nnl, nbdm, laxis, ldyna,&
                  xpc        , ypc      , xpr     , ypr     ,&
                  tau1       , tau2     ,&
                  jeusup, ffe, ffm, dffm, ffl,&
                  norm, mprojt, jacobi,&
                  dlagrc, dlagrf, jeu, djeu,&
                  djeut, mprojn,&
                  mprt1n, mprt2n, mprnt1, mprnt2,&
                  kappa, h, vech1, vech2,&
                  mprt11, mprt12, mprt21,&
                  mprt22,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2, l_previous,l_large_slip)
!
implicit none
!
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
real(kind=8) :: ffe(9), ffm(9), ffl(9)
real(kind=8), intent(in) :: tau1(3), tau2(3)
real(kind=8) :: norm(3)
real(kind=8) :: mprojt(3, 3)
aster_logical :: laxis, ldyna, l_previous
aster_logical, intent(in) :: l_large_slip
real(kind=8) :: jacobi
real(kind=8) :: jeusup
real(kind=8) :: dlagrc, dlagrf(2)
real(kind=8) :: jeu, djeu(3), djeut(3)
real(kind=8) :: dnepmait1 ,dnepmait2 ,taujeu1,taujeu2
real(kind=8), intent(in) :: xpc, ypc, xpr, ypr
real(kind=8), intent(out) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
real(kind=8), intent(out) :: mprt1n(3, 3), mprt2n(3, 3), mprnt1(3, 3), mprnt2(3, 3)
real(kind=8) :: kappa(2, 2), h(2, 2)
real(kind=8) :: vech1(3), vech2(3)
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
! OUT DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! OUT DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
! OUT JEU    : JEU NORMAL ACTUALISE
! OUT DJEU   : INCREMENT DEPDEL DU JEU
! OUT DJEUT  : INCREMENT DEPDEL DU JEU TANGENT
!
! ----------------------------------------------------------------------
!
    integer :: jpcf    
    integer :: i_node, i_dime
    integer :: jgeom, jdepde, jdepm
    real(kind=8) :: ppe
    real(kind=8) :: ddepmam(9, 3)
    real(kind=8) :: geomae(9, 3), geomam(9, 3)
    real(kind=8) :: slav_coor_init(3,9)
    real(kind=8) :: geomm(3), geome(3)
    real(kind=8) :: ddeple(3), ddeplm(3)
    real(kind=8) :: deplme(3), deplmm(3)
    real(kind=8) :: accme(3), vitme(3), accmm(3), vitmm(3)
    real(kind=8) :: vitpe(3), vitpm(3)
    real(kind=8) :: dffe(2, 9), ddffe(3, 9)
    real(kind=8) :: dffm(2, 9), ddffm(3, 9)
    real(kind=8) :: dffl(2, 9), ddffl(3, 9)
    real(kind=8) :: mprojn(3, 3)
    aster_logical :: l_axis_warn
    real(kind=8) :: gene11(3,3), gene21(3,3), gene22(3,3)
    real(kind=8) :: a(2, 2), ha(2, 2), hah(2, 2)
!
! ----------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
    djeut   = 0.d0
    ddeple  = 0.d0
    ddeplm  = 0.d0
    ddepmam = 0.d0
!
! --- RECUPERATION DE LA GEOMETRIE ET DES CHAMPS DE DEPLACEMENT
!
    call jevech('PGEOMER', 'L', jgeom)
    call jevech('PDEPL_P', 'L', jdepde)
    call jevech('PDEPL_M', 'L', jdepm)
!
! - Coefficient to update geometry
!
    ppe = 0.d0
    if (iresog .eq. 1) then
        ppe = 1.d0
    endif
!
! - Initial coordinates
!
    do i_node = 1, nne
        do i_dime = 1, ndim
            slav_coor_init(i_dime, i_node) = zr(jgeom+(i_node-1)*ndim+i_dime-1)
        end do
    end do
!
! - Get shape functions
!
    call mmform(ndim  ,&
                typmae, typmam,&
                nne   , nnm   ,&
                xpc   , ypc   , xpr  , ypr,&
                ffe   , dffe  , ddffe,&
                ffm   , dffm  , ddffm,&
                ffl   , dffl  , ddffl)
!
! - Compute jacobian on slave element
!
    call mmmjac(laxis , nne           , ndim,&
                typmae, slav_coor_init,&
                ffe   , dffe          ,&
                jacobi, l_axis_warn)
    if (l_axis_warn) then
        call utmess('A', 'CONTACT2_14')
    endif
!
! - Update geometry
!
    call mmreac(nbdm  , ndim  ,&
                nne   , nnm   ,&
                jgeom , jdepm , jdepde , ppe,&
                geomae, geomam, ddepmam)
!
! - Compute local basis
!
    call mmgeom(ndim  ,&
                nne   , nnm   ,&
                ffe   , ffm   ,&
                geomae, geomam,&
                tau1  , tau2  ,&
                norm  , mprojn, mprojt,&
                geome , geomm )
!
! - Compute increment of Lagrange multipliers
!
    call mmlagm(nbdm  , ndim  , nnl, jdepde, ffl,&
                dlagrc, dlagrf)

!
! - Compute increment of displacements
!
    call mmdepm(nbdm  , ndim  ,&
                nne   , nnm   ,&
                jdepm , jdepde,&
                ffe   , ffm   ,&
                ddeple, ddeplm,&
                deplme, deplmm)
!
! - Compute increment of speeds/accelerations
!
    if (ldyna) then
        call mmvitm(nbdm , ndim , nne  , nnm  ,&
                    ffe  , ffm  ,&
                    vitme, vitmm, vitpe, vitpm,&
                    accme, accmm)
    endif
!
! - Compute gaps
!
    call mmmjeu(ndim  , iresog, jeusup,&
                geome , geomm ,&
                ddeple, ddeplm,&
                norm  , mprojt,&
                jeu   , djeu  , djeut )
!
! TRAITEMENT CYCLAGE : ON REMPLACE LES VALEURS DE JEUX et DE NORMALES
!                      POUR AVOIR UNE MATRICE CONSISTANTE
!
    if (l_previous) then
        jeu    = zr(jpcf-1+29)
        dlagrc = zr(jpcf-1+26)
    endif
!
! - Compute projection matrices for second variation of gap
!
    call mmcalg(ndim     , l_large_slip,&
                nnm      , dffm        , ddffm ,&
                geomam   , ddepmam     ,&
                tau1     , tau2        , norm  ,&
                jeu      , djeu        ,&
                gene11   , gene21      , gene22,&
                kappa    , h           ,&
                vech1    , vech2       ,&
                a        , ha          , hah   ,&
                mprt11   , mprt12      , mprt21, mprt22,&
                mprt1n   , mprt2n      , mprnt1, mprnt2,&
                taujeu1  , taujeu2     ,&
                dnepmait1, dnepmait2)
!
end subroutine
