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

subroutine zevolu(cine, zbeta, zbetam, dinst, tp,&
                  k, n, tdeq, tfeq, coeffc,&
                  m, ar, br, g, dg)
!
implicit none
!
#include "asterfort/tempeq.h"
!
real(kind=8), intent(in) :: zbeta, zbetam
real(kind=8), intent(in) :: tdeq, tfeq
real(kind=8), intent(in) :: k, n
real(kind=8) :: dinst, tp
real(kind=8) :: coeffc, m, ar, br
real(kind=8) :: g, dg
integer :: cine, chau
parameter     (chau=1)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase (zircaloy)
!
! Compute G function
!
! --------------------------------------------------------------------------------------------------
!
! In  zbeta               : proportion of beta phase (current)
! In  zbetam              : proportion of beta phase (previous)
! In  tdeq                : transformation temperature - Begin
! In  tfeq                : transformation temperature - End
! In  k                   : material parameter (META_ZIRC)
! In  n                   : material parameter (META_ZIRC)
!
! --------------------------------------------------------------------------------------------------
!
!
!............................................
! CALCUL PHASE METALLURGIQUE POUR EDGAR
! CALCUL DE LA FONCTION G ET DE SA DERIVEE
!............................................
!
! IN   CINE     : CINTETIQUE A INTEGRER
!                 'CHAU' : CINETIQUE AU CHAUFFAGE
!                 'REFR' : CINETIQUE AU REFROIDISSEMENT
! IN   Z        : PROPORTION DE PHASE BETA
! IN   ZM       : PROPORTION DE PHASE BETA A INSTANT MOINS
! IN   DINST    : INCREMENT DE TEMPS ENTRE PLUS ET MOINS
! IN   TP       : TEMPERATURE
! IN   K,N      : PARAMETRES MATERIAU POUR MODELE A L EQUILIBRE
! IN   TDEQ     : TEMPERATURE A L EQUILIBRE DE DEBUT DE TRANSF.
! IN   TFEQ     : TEMPERATURE QUASISTATIQUE DE FIN DE TRANSF.
! IN   COEFFC,M : PARAMETRES MATERIAU POUR MODELE AU CHAUFFAGE
! IN   AR,BR    : PARAMETRES MATERIAU POUR MODELE AU REFROIDISSEMENT
! OUT  G        : LOI D EVOLUTION DE LA PROPORTION DE LA PHASE BETA
! OUT  DG       : DERIVEE DE LA FONCTION G PAR RAPPORT A Z
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: teq, dvteq
!
! --------------------------------------------------------------------------------------------------
!

! 
! - Evaluate equivalent temperature
!
    call tempeq(zbeta,&
                tdeq , tfeq ,&
                k    , n    ,&
                teq  , dvteq)
!
! 2 - CALCUL DE LA FONCTION G ET DE SA DERIVEE
!
    if (cine .eq. chau) then
        g=zbeta-zbetam-dinst*coeffc*((abs(tp-teq))**m)
        dg=1.d0+m*dinst*coeffc*((abs(tp-teq))**(m-1.d0))*dvteq
    else
! CINE .EQ. REFR
        g=dinst*exp(ar+br*abs(tp-teq))
        dg=1.d0+abs(tp-teq)*g*(1.d0-2.d0*zbeta)
        dg=dg+dvteq*g*zbeta*(1.d0-zbeta)*(1.d0+br*abs(tp-teq))
        g=zbeta-zbetam+abs(tp-teq)*g*zbeta*(1.d0-zbeta)
    endif
!
end subroutine
