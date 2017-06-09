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

subroutine nmpime(fami, kpg, ksp, imate, option,&
                  xlong0, a, xlongm, dlong0, ncstpm,&
                  cstpm, vim, effnom, vip, effnop,&
                  klv, fono)
!
    implicit none
!-----------------------------------------------------------------------
#include "asterfort/nm1dpm.h"
#include "asterfort/r8inir.h"
#include "asterfort/verift.h"
    integer :: nbt, neq, nvar
    real(kind=8) :: dsde
!-----------------------------------------------------------------------
    parameter   (neq = 6,nbt = 21,nvar=8)
!
    character(len=*) :: fami, option
    real(kind=8) :: xlong0, a, xlongm
    integer :: kpg, ksp, ncstpm, imate
    real(kind=8) :: cstpm(ncstpm)
    real(kind=8) :: dlong0
    real(kind=8) :: effnom, vim(nvar)
    real(kind=8) :: effnop, vip(nvar), fono(neq), klv(nbt)
! -----------------------------------------------------------------
!
!    TRAITEMENT DE LA RELATION DE COMPORTEMENT -ELASTOPLASTICITE-
!    ECROUISSAGE NON LINEAIRE - MODELE DE PINTO MENEGOTTO
!    POUR UN ELEMENT BARRE DE TYPE MECA_ BARRE
!
! -----------------------------------------------------------------
! IN  : E      : MODULE D'YOUNG
!       XLONG0 : LONGUEUR DE L'ELEMENT DE BARRE AU REPOS
!       A      : SECTION DE LA BARRE
!       NCSTPM : NOMBRE DE CONSTANTES DE MATERIAU
!       CSTPM  : CONSTANTES DE MATERIAU :
!           E      : MODULE D'YOUNG
!           SY     : LIMITE ELASTIQUE
!           EPSU   : DEFORMATION ULTIME
!           SU     : CONTRAINTE ULTIME
!           EPSH   : DEFORMATION A LA FIN DU PALIER PLASTIQUE PARFAIT
!           R0     : COEFFICIENT EXPERIMENTAL
!           B      : COEFFICIENT
!           A1     : COEFFICIENT EXPERIMENTAL
!           A2     : COEFFICIENT EXPERIMENTAL
!           ELAN   : RAPPORT LONGUEUR/DIAMETRE DE LA BARRE
!           A6     : COEFFICIENT EXPERIMENTAL FLAMMBAGE
!           C      : COEFFICIENT EXPERIMENTAL FLAMMBAGE
!           COA    : COEFFICIENT EXPERIMENTAL FLAMMBAGE
!       DLONG0 : INCREMENT D'ALLONGEMENT DE L'ELEMENT
!       XLONGM : LONGUEUR DE L'ELEMENT AU TEMPS MOINS
!       EFFNOM : EFFORT NORMAL PRECEDENT
!       OPTION : OPTION DEMANDEE (R_M_T,FULL OU RAPH_MECA)
!
! OUT : EFFNOP   : CONTRAINTE A L'INSTANT ACTUEL
!       VIP    : VARIABLE INTERNE A L'INSTANT ACTUEL
!       FONO   : FORCES NODALES COURANTES
!       KLV    : MATRICE TANGENTE
!
!----------VARIABLES LOCALES
!
    real(kind=8) :: sigm
    real(kind=8) :: epsm
    real(kind=8) :: epsp
    real(kind=8) :: sigp, xrig
    real(kind=8) :: deps, epsthe
!
!
!----------INITIALISATIONS
!
    call r8inir(nbt, 0.d0, klv, 1)
    call r8inir(neq, 0.d0, fono, 1)
!
!----------RECUPERATION DES CARACTERISTIQUES
!
    call verift(fami, kpg, ksp, 'T', imate,&
                epsth_=epsthe)
!
    epsm = (xlongm-xlong0)/xlong0
    epsp = (xlongm+dlong0-xlong0)/xlong0
    deps = epsp - epsm - epsthe
    sigm = effnom/a
!
    call nm1dpm(fami, kpg, ksp, imate, option,&
                nvar, ncstpm, cstpm, sigm, vim,&
                deps, vip, sigp, dsde)
!
    effnop=sigp*a
!
! --- CALCUL DES FORCES NODALES
!
    fono(1) = -effnop
    fono(4) = effnop
!
! ----------------------------------------------------------------
!
!
!
! --- CALCUL DU COEFFICIENT NON NUL DE LA MATRICE TANGENTE
!
    if (option(1:10) .eq. 'RIGI_MECA_' .or. option(1:9) .eq. 'FULL_MECA') then
!
        xrig= dsde*a/xlong0
        klv(1) = xrig
        klv(7) = -xrig
        klv(10) = xrig
    endif
!
end subroutine
