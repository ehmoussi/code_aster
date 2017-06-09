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

subroutine zevolu(cine, z, zm, dinst, tp,&
                  k, n, tdeq, tfeq, coeffc,&
                  m, ar, br, g, dg)
!
!
    implicit none
#include "asterfort/tempeq.h"
    real(kind=8) :: z, zm, dinst, tp
    real(kind=8) :: k, n, tdeq, tfeq, coeffc, m, ar, br
    real(kind=8) :: g, dg
    integer :: cine, chau
    parameter     (chau=1)
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
    real(kind=8) :: teq, dvteq
!
! 1 - CALCUL DE LA TEMPERATURE A L EQUILIBRE POUR Z ET DE SA DERIVEE
!
    call tempeq(z, tdeq, tfeq, k, n,&
                teq, dvteq)
!
! 2 - CALCUL DE LA FONCTION G ET DE SA DERIVEE
!
    if (cine .eq. chau) then
        g=z-zm-dinst*coeffc*((abs(tp-teq))**m)
        dg=1.d0+m*dinst*coeffc*((abs(tp-teq))**(m-1.d0))*dvteq
    else
! CINE .EQ. REFR
        g=dinst*exp(ar+br*abs(tp-teq))
        dg=1.d0+abs(tp-teq)*g*(1.d0-2.d0*z)
        dg=dg+dvteq*g*z*(1.d0-z)*(1.d0+br*abs(tp-teq))
        g=z-zm+abs(tp-teq)*g*z*(1.d0-z)
    endif
!
end subroutine
