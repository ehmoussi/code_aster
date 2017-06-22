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

subroutine glrcmm(zimat, matr, ep, surfgp, p,&
                  epst, deps, dsig, ecr, delas,&
                  dsidep, crit, codret)
    implicit none
!
!     ROUTINE DE RECUPERATION DE PARAMETRES
!     ET DE LANCEMENT DU CALCUL DU COMPORTEMENT
!
! IN  ZIMAT : NUMERO DU MATERIAU
! IN  MATR : TABLEAU DES PARAMETRES MATERIAUX HOMOGENEISES
! IN  EP : EPAISSEUR TOTALE
! IN  SURFGP : SURFACE ASSOCIEE AU POINT DE GAUSS
! IN  P : MATRICE DE PASSAGE GLOBAL -> LOCAL
! IN  EPST : TENSEUR DEFORMATION TOTALE
! IN  DEPS : INCREMENT DE DEFORMATION
! IN  CRIT : CRITERES DE CONVERGENCE LOCAUX
!            (1) = NB ITERATIONS MAXI A CONVERGENCE
!                  (ITER_INTE_MAXI == ITECREL)
!            (2) = TYPE DE JACOBIEN A T+DT
!                  (TYPE_MATR_COMP == MACOMP)
!                   0 = EN VITESSE     >SYMETRIQUE
!                   1 = EN INCREMENTAL >NON-SYMETRIQUE
!            (3) = VALEUR TOLERANCE DE CONVERGENCE
!                  (RESI_INTE_RELA == RESCREL)
!            (5) = NOMBRE D'INCREMENTS POUR LE
!                  REDECOUPAGE LOCAL DU PAS DE TEMPS
!                  (ITER_INTE_PAS  == ITEDEC)
!                  -1,0,1 = PAS DE REDECOUPAGE
!                   N = NOMBRE DE PALIERS
!            (6) = TYPE D INTEGRATION LOCAL POUR LA LOI DE
!                  COMPORTEMENT (ALGO_INTE)
!
! OUT DSIG :
! OUT ECR : TABLEAU DES VARIABLES INTERNES
! OUT DELAS : MATRICE ELASTIQUE
! OUT DSIDEP : MATRICE TANGENTE
! OUT CODRET  : CODE RETOUR DE L'INTEGRATION INTEGRATION DU
!               0 => PAS DE PROBLEME
!               1 => ABSENCE DE CONVERGENCE
! person_in_charge: sebastien.fayolle at edf.fr
!
#include "asterfort/glrcdd.h"
#include "asterfort/matmul.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
    integer :: i, zimat, kpg, spt
    integer :: codret
!
    real(kind=8) :: ep, surfgp, p(3, 3), deps(*), epst(*)
    real(kind=8) :: dsig(*), matr(*), ecr(*)
    real(kind=8) :: vglob(3), vloc(3), q(2, 2), alphor
    real(kind=8) :: maxmp(2), minmp(2), r8bid
    real(kind=8) :: mp1n0, mp2n0, crit(*)
    real(kind=8) :: normn, normm, dsidep(6, *), delas(6, *), valres(4)
!
    integer :: codres(8)
    character(len=8) :: fami, poum
    character(len=16) :: nomres(8)
    character(len=32) :: phenom
!
    r8bid = 0.d0
!
    phenom = 'GLRC_DAMAGE'
!
!     TRANSFORMATION DES DONNEES
!
    if (ecr(12) .lt. 5.d0) then
        do 10, i = 1,3
        vglob(i) = ecr(10 + i)
10      continue
        call matmul(p, vglob, 3, 3, 1,&
                    vloc)
!
        alphor = atan2(vloc(2),vloc(1))
!
        ecr(11) = alphor
        ecr(12) = 10.d0
        ecr(13) = 10.d0
    else
        alphor = ecr(11)
    endif
!
!     MATRICE DE PASSATE ORTHO -> LOCAL
    q(1,1) = cos(alphor)
    q(2,1) = sin(alphor)
    q(1,2) = -q(2,1)
    q(2,2) = q(1,1)
!
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
    nomres(1)='MPCST'
!
    call rcvalb(fami, kpg, spt, poum, zimat,&
                ' ', phenom, 0, ' ', [0.d0],&
                1, nomres, valres, codres, 1)
!
    if (valres(1) .eq. 0.d0) then
        nomres(1) = 'MAXMP1'
        nomres(2) = 'MINMP1'
        nomres(3) = 'MAXMP2'
        nomres(4) = 'MINMP2'
        call rcvalb(fami, kpg, spt, poum, zimat,&
                    ' ', phenom, 0, ' ', [r8bid],&
                    4, nomres, valres, codres, 1)
        maxmp(1) = valres(1)
        maxmp(2) = valres(3)
        minmp(1) = valres(2)
        minmp(2) = valres(4)
    else
        nomres(1) = 'FMEX1'
        nomres(2) = 'FMEX2'
        nomres(3) = 'FMEY1'
        nomres(4) = 'FMEY2'
        nomres(5) = 'MAXMP1'
        nomres(6) = 'MINMP1'
        nomres(7) = 'MAXMP2'
        nomres(8) = 'MINMP2'
!
        do 50, i=1,2
        call rcvalb(fami, kpg, spt, poum, zimat,&
                    ' ', phenom, 1, 'X ', [0.d0],&
                    2, nomres(2*(i-1)+1), valres, codres, 1)
        mp1n0 = valres(1)
        mp2n0 = valres(2)
!
        call rcvalb(fami, kpg, spt, poum, zimat,&
                    ' ', phenom, 0, ' ', [r8bid],&
                    2, nomres(2*(i-1)+5), valres, codres, 1)
        maxmp(i) = valres(1)
        minmp(i) = valres(2)
!
        if ((mp1n0 .lt. 0.d0) .or. (mp2n0 .gt. 0.d0) .or. (maxmp(i)- minmp(i) .le. 0.d0)) then
            call utmess('F', 'ELEMENTS_87')
        endif
50      continue
    endif
!
    nomres(1) = 'NORMM'
    nomres(2) = 'NORMN'
    call rcvalb(fami, kpg, spt, poum, zimat,&
                ' ', phenom, 0, ' ', [r8bid],&
                2, nomres, valres, codres, 0)
    normm = valres(1)
    normn = valres(2)
!
!     ROUTINE DE POST ET PRE TRAITEMENT
!     POUR L INTEGRATION DE LA LOI DE COMPORTEMENT GLRC_DAMAGE
    call glrcdd(zimat, maxmp, minmp, matr, ep,&
                surfgp, q, epst, deps, dsig,&
                ecr, delas, dsidep, normm, normn,&
                crit, codret)
!
!
end subroutine
