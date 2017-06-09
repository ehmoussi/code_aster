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

subroutine pipeex(mat, sup, sud, mup, mud,&
                  vim, tau, copilo)
!
!
    implicit none
#include "asterfort/rcvalb.h"
    integer :: mat
    real(kind=8) :: sup(3), sud(3), mup(3), mud(3), tau, vim(*), copilo(5)
! ----------------------------------------------------------------------
!     PILOTAGE PRED_ELAS POUR LA LOI D'INTERFACE OUVERTURE
!
! IN  MAT    : MATERIAU
! IN  SUP    : SAUT DU AUX CHARGES FIXES
! IN  SUD    : SAUT DU AUX CHARGES PILOTEES
! IN  MUP    : MULTIPLICATEUR DU AUX CHARGES FIXES
! IN  MUD    : MULTIPLICATEUR DU AUX CHARGES PILOTEES
! IN  VIM    : VARIABLES INTERNES EN T-
! IN  TAU    : 2ND MEMBRE DE L'EQUATION F(ETA)=TAU
! OUT COPILO : COEFFICIENTS DU TIR ELASTIQUE LINEARISE AUTOUR DES SOL.
!                FEL = COPILO(1) + COPILO(2)*ETA
!                FEL = COPILO(3) + COPILO(4)*ETA
!                COPILO(5) <> R8VIDE => PAS DE SOLUTION
! ----------------------------------------------------------------------
    real(kind=8) :: sc, gc, dc, h, r, ka, ga, sk, val(3), tmp
    real(kind=8) :: tt, tpn, tdn, tauref
    integer :: cod(3), kpg, spt
    character(len=16) :: nom(3)
    character(len=8) ::  fami, poum
!
    data nom /'GC','SIGM_C','PENA_LAGR'/
! ----------------------------------------------------------------------
!
!
! -- CAS DE L'ENDOMMAGEMENT SATURE
!
    ga = vim(4) + tau
    if (ga .gt. 1.d0) goto 9999
!
! -- RECUPERATION DES PARAMETRES PHYSIQUES
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    call rcvalb(fami, kpg, spt, poum, mat,&
                ' ', 'RUPT_FRAG', 0, ' ', [0.d0],&
                3, nom, val, cod, 2)
    gc = val(1)
    sc = val(2)
    dc = 3.2*gc/sc
    h = sc/dc
    r = h * val(3)
!
!    CALCUL DE KAPPA : KA = DC*(1-SQRT(1-GA))
!
    tmp = sqrt(max(0.d0,1.d0-ga))
    tmp = dc*(1.d0-tmp)
    tmp = max(0.d0,tmp)
    tmp = min(dc,tmp)
    ka = tmp
    sk = max(0.d0,sc - h*ka)
!
!   CALCUL DU SEUIL
!
    tt = r*ka + sk
    tauref = tau/tt
!
! -- CALCUL DU SECOND MEMBRE
!
    tpn = mup(1) + r*sup(1)
    tdn = mud(1) + r*sud(1)
!
! -- PILOTAGE DU POINT
!
    copilo(1) = tauref * tpn
    copilo(2) = tauref * tdn
!
9999  continue
end subroutine
