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

subroutine lc0001(fami, kpg, ksp, ndim, imate,&
                  neps, deps, nsig, sigm, option,&
                  angmas, sigp, vip, typmod, ndsde,&
                  dsidep, codret)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/nmelas.h"
#include "asterfort/nmorth.h"
#include "asterfort/rccoma.h"
    integer :: imate, ndim, kpg, ksp, codret, icodre
    integer :: neps, nsig, ndsde
    real(kind=8) :: angmas(3), deps(neps), sigm(nsig), sigp(nsig)
    real(kind=8) :: vip(1), dsidep(ndsde)
    character(len=16) :: option
    character(len=8) :: typmod(*)
    character(len=*) :: fami
    character(len=16) :: mcmate
!

!
! ======================================================================
!.......................................................................
!
!     BUT: LOI DE COMPORTEMENT ELASTIQUE
!
!          RELATIONS : 'ELAS'
!
!       IN      FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!       IN      KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
!       IN      NDIM    DIMENSION DE L ESPACE (3D=3,2D=2,1D=1)
!               TYPMOD  TYPE DE MODELISATION
!               IMATE    ADRESSE DU MATERIAU CODE
!               COMPOR    COMPORTEMENT DE L ELEMENT
!                     COMPOR(1) = RELATION DE COMPORTEMENT (CHABOCHE...)
!                     COMPOR(2) = NB DE VARIABLES INTERNES
!                     COMPOR(3) = TYPE DE DEFORMATION (PETIT,JAUMANN...)
!               CRIT    CRITERES  LOCAUX
!                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
!                                 (ITER_INTE_MAXI == ITECREL)
!                       CRIT(2) = TYPE DE JACOBIEN A T+DT
!                                 (TYPE_MATR_COMP == MACOMP)
!                                 0 = EN VITESSE     > SYMETRIQUE
!                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
!                                 9 = methode IMPLEX
!                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
!                                 (RESI_INTE_RELA == RESCREL)
!                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
!                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
!                                 (ITER_INTE_PAS == ITEDEC)
!                                 0 = PAS DE REDECOUPAGE
!                                 N = NOMBRE DE PALIERS
!               INSTAM   INSTANT T
!               INSTAP   INSTANT T+DT
!               EPSM   DEFORMATION TOTALE A T
!               DEPS   INCREMENT DE DEFORMATION TOTALE
!               SIGM    CONTRAINTE A T
!               VIM    VARIABLES INTERNES A T    + INDICATEUR ETAT T
!               OPTION     OPTION DE CALCUL A FAIRE
!                             'RIGI_MECA_TANG'> DSIDEP(T)
!                             'FULL_MECA'     > DSIDEP(T+DT) , SIG(T+DT)
!                             'RAPH_MECA'     > SIG(T+DT)
!                             'RIGI_MECA_IMPLEX' > DSIDEP(T), SIGEXTR
!               WKIN  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES
!                       AUX LOIS DE COMPORTEMENT (DIMENSION MAXIMALE
!                       FIXEE EN DUR)
!               ANGMAS
!       OUT     SIGP    CONTRAINTE A T+DT
!               VIP    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
!               DSIDEP    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
!.......................................................................
!               CODRET
!
!
!
!     RECUPERATION DE MCMATER (APPELE A TORT 'PHENOMENE')
    call rccoma(imate, 'ELAS', 1, mcmate, icodre)
    ASSERT(icodre.eq.0)
!
    if (mcmate .eq. 'ELAS') then
!
        call nmelas(fami, kpg, ksp, ndim, typmod,&
                    imate, deps, sigm, option, sigp,&
                    vip, dsidep, codret)
!
    else if (mcmate.eq.'ELAS_ORTH'.or.mcmate.eq.'ELAS_ISTR') then
!
        call nmorth(fami, kpg, ksp, ndim, mcmate,&
                    imate, 'T', deps, sigm, option,&
                    angmas, sigp, vip(1), dsidep)
    endif
!
!
end subroutine
