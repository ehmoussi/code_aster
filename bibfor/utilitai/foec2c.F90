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

subroutine foec2c(iuni, v, nbcoup, n1, n2,&
                  nompar, nomres)
    implicit none
    integer :: iuni, nbcoup, n1, n2
    real(kind=8) :: v(3*nbcoup)
    character(len=*) :: nompar, nomres
!     ECRITURE DES COUPLES (PARAMETRE, RESULTAT) D'UNE FONCTION,
!     DU N1-IEME AU N2-IEME
!     ------------------------------------------------------------------
!     ARGUMENTS D'ENTREE:
!        IUNI  : NUMERO D'UNITE LOGIQUE D'ECRITURE
!        VEC   : VECTEUR DES VALEURS (PARAMETRES ET RESULTATS)
!        NBCOUP: NOMBRE DE COUPLES DE VALEURS
!        N1, N2: NUMEROS DE DEBUT ET FIN DE LA LISTE
!        NOMPAR: NOM DU PARAMETRE
!        NOMRES: NOM DU RESULTAT
!     ------------------------------------------------------------------
    character(len=8) :: gva, gfo
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, j
!-----------------------------------------------------------------------
    n1=min(n1,nbcoup)
    n2=min(n2,nbcoup)
!
    gva = nompar
    gfo = nomres
    write(iuni, 100 )&
     &    ( ('<-PARAMETRE->     <-RESULTAT->       ')  , j=1,2  ) ,&
     &    ( ('   '//gva//'           '//gfo//'       '),i=1,2)
    write(iuni,101) (v(i),v(nbcoup+(2*i-1)),v(nbcoup+(2*i)),i=n1,n2)
!
    100 format(/,1x,2a,/,1x,2a )
    101 format( 2(1x,1pe11.4,1x,1pe11.4,1x,1pe11.4,1x) )
end subroutine
