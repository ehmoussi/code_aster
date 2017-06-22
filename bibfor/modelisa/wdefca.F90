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

function wdefca(ino, s, alpha, f0, frco,&
                frli)
    implicit none
!  DESCRIPTION : CALCUL D'UNE ENERGIE DE DEFORMATION POUR DETERMINATION
!  -----------   ITERATIVE DE LA LONGUEUR SUR LAQUELLE ON DOIT PRENDRE
!                EN COMPTE LES PERTES DE TENSION PAR RECUL DE L'ANCRAGE
!                APPELANT : ANCRCA
!
!  IN     : INO    : INTEGER , SCALAIRE
!                    INDICE DU NOEUD DONT L'ABSCISSE CURVILIGNE
!                    CORRESPOND A L'ESTIMATION A L'ITERATION COURANTE
!                    DE LA LONGUEUR SUR LAQUELLE ON PREND EN COMPTE
!                    LES PERTES DE TENSION PAR RECUL DE L'ANCRAGE
!  IN     : S      : REAL*8 , VECTEUR DE DIMENSION NBNO
!                    CONTIENT LES VALEURS DE L'ABSCISSE CURVILIGNE
!                    LE LONG DU CABLE
!  IN     : ALPHA  : REAL*8 , VECTEUR DE DIMENSION NBNO
!                    CONTIENT LES VALEURS DE LA DEVIATION ANGULAIRE
!                    CUMULEE LE LONG DU CABLE
!  IN     : F0     : REAL*8 , SCALAIRE
!                    VALEUR DE LA TENSION APPLIQUEE A L'UN OU AUX DEUX
!                    ANCRAGES ACTIFS DU CABLE
!  IN     : FRCO   : REAL*8 , SCALAIRE
!                    VALEUR DU COEFFICIENT DE FROTTEMENT EN COURBE
!                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
!  IN     : FRLI   : REAL*8 , SCALAIRE
!                    VALEUR DU COEFFICIENT DE FROTTEMENT EN LIGNE
!                    (CONTACT ENTRE LE CABLE ACIER ET LE MASSIF BETON)
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
    real(kind=8) :: wdefca
!
! ARGUMENTS
! ---------
    integer :: ino
    real(kind=8) :: s(*), alpha(*), f0, frco, frli
!
! VARIABLES LOCALES
! -----------------
    integer :: i
    real(kind=8) :: xi, xip1, xref
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
    if (ino .eq. 1) then
        wdefca = 0.0d0
        goto 9999
    endif
!
    xref = - frco * alpha(ino) - frli * s(ino)
    xref = 2.0d0 * xref
    xref = dble(exp(xref))
!
    wdefca = 0.0d0
    do 10 i = 1, ino-1
        xi = - frco * alpha(i) - frli * s(i)
        xi = dble(exp(xi))
        xip1 = - frco * alpha(i+1) - frli * s(i+1)
        xip1 = dble(exp(xip1))
        wdefca = wdefca + ( xi - xref/xi + xip1 - xref/xip1 ) / 2.0d0 * ( s(i+1) - s(i) )
10  end do
    wdefca = wdefca * f0
!
9999  continue
!
! --- FIN DE WDEFCA.
end function
