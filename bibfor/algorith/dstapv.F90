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

subroutine dstapv(nbpt, d, t, dmin, dmax,&
                  dmoy, detyp, drms, sd, sde,&
                  sd2)
!
!       MOYENNAGE STATISTIQUE DES DEPLACEMENTS
!       ALGORITHME CALCUL TEMPOREL A PAS DE TEMPS VARIABLE
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/trapez.h"
#include "asterfort/wkvect.h"
    real(kind=8) :: d(*), t(*), dmoy, detyp, drms, dmax, dmin, sd, sde, sd2
!
!
!-----------------------------------------------------------------------
    integer :: i, ift, nbpt
!-----------------------------------------------------------------------
    call jemarq()
!
!       ARGUMENTS:
!       ----------------------------------------
!       IN:
!            NBPT         NB DE POINTS DU TABLEAU A ANALYSER
!            D            TABLEAU A ANALYSER
!            T            TABLEAU DES INSTANTS CORRESPONDANTS
!
!       OUT:
!            DMOY        VALEUR MOYENNE ( COMPTAGE AU DESSUS DU SEUIL )
!            DETYP       ECART TYPE
!            DRMS        SQRT DE LA MOYENNE DES CARRES ( RMS )
!            DMAX        VALEUR MAXIMUM ABSOLU DU TABLEAU
!            DMIN        VALEUR MINIMUM ABSOLU DE LA FONCTION
!
!
!
!       VARIABLES UTILISEES
!       ----------------------------------------
!       SD SOMME DES VALEURS
!       SD2 SOMME DES CARRES DES VALEURS
!       SDD SOMME DES CARRES DES DIFFERENCES A LA MOYENNE
!
    call wkvect('&&DSTAPV.TEMP.FCNT', 'V V R', nbpt, ift)
!
    sd=0.d0
    sd2=0.d0
    dmoy = 0.d0
    drms = 0.d0
    detyp = 0.d0
    dmax=-10.d20
    dmin=-dmax
!
! --- RECHERCHE DES EXTREMAS ABSOLUS
!
    do 10 i = 1, nbpt
        if (d(i) .gt. dmax) dmax=d(i)
        if (d(i) .lt. dmin) dmin=d(i)
10  continue
!
! --- DEPLACEMENT MOYEN
!
    do 20 i = 1, nbpt
        zr(ift + i-1) = d(i)
20  continue
    call trapez(t, zr(ift), nbpt, sd)
    dmoy = sd / (t(nbpt) - t(1))
!
! --- DEPLACEMENT QUADRATIQUE MOYEN
!
    do 30 i = 1, nbpt
        zr(ift + i-1) = d(i)*d(i)
30  continue
    call trapez(t, zr(ift), nbpt, sd2)
    drms = sqrt(sd2 / (t(nbpt) - t(1)))
!
! --- DEPLACEMENT QUADRATIQUE MOYEN (MOYENNE NULLE)
!
    do 40 i = 1, nbpt
        zr(ift + i-1) = (d(i)-dmoy)*(d(i)-dmoy)
40  continue
    call trapez(t, zr(ift), nbpt, sde)
    detyp = sqrt(sde / (t(nbpt) - t(1)))
!
!
    call jedetr('&&DSTAPV.TEMP.FCNT')
    call jedema()
end subroutine
