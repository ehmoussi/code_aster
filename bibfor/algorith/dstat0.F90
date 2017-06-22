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

subroutine dstat0(nbpt, d, dmoy, detyp, drms,&
                  dmax, dmin)
! CETTE ROUTINE EST EN FAIT L'ANCIENNE DSTAT RENOMMEE DSTAT0
!
!       MOYENNAGE STATISTIQUE DES DEPLACEMENTS AMV
!
!
!
    implicit none
    real(kind=8) :: d(*), dmoy, detyp, drms, dmax, dmin, sd2, sd, sdd
!
!
!       ARGUMENTS:
!       ----------------------------------------
!       IN:
!            NBPT         NB DE POINTS DU TABLEAU A ANALYSER
!            D            TABLEAU A ANALYSER
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
!-----------------------------------------------------------------------
    integer :: i, nbpt
!-----------------------------------------------------------------------
    sd = 0.d0
    sd2 = 0.d0
    sdd = 0.d0
    dmax = -10.d20
    dmin = -dmax
!
    do 10 i = 1, nbpt
!
        sd = sd + d(i)
        sd2 = sd2 + d(i)**2
!
!           RECHERCHE DES EXTREMAS ABSOLUS
!
        if (d(i) .gt. dmax) dmax = d(i)
        if (d(i) .lt. dmin) dmin = d(i)
!
!
10  end do
    dmoy = sd/nbpt
!
    do 20 i = 1, nbpt
        sdd = sdd + (d(i)-dmoy)**2
20  end do
!
    drms = sqrt(sd2/nbpt)
    detyp = sqrt(sdd/nbpt)
!
end subroutine
