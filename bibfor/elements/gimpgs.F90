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

subroutine gimpgs(result, nnoff, absc, gs, numero,&
                  gi, ndeg, ndimte, gthi, extim,&
                  time, iordr, unit)
    implicit none
#include "asterf_types.h"
! ......................................................................
!
!     - FONCTION REALISEE:  IMPRESSION DU TAUX DE RESTITUTION D'ENERGIE
!                           LOCAL SUIVANT LA METHODE CHOISIE
!  ENTREE
!
!    RESULT       --> NOM UTILISATEUR DU RESULTAT ET TABLE
!    NNOFF        --> NOMBRE DE NOEUDS DU FOND DE FISSURE
!    ABSC         --> ABSCISSES CURVILIGNES
!    GS           --> VALEURS DE G(S)
!    NUMERO       --> NUMERO DE LA METHODE   1 : THETA-LEGENDRE
!                                            2 : THETA-LAGRANGE
!                                            3 : LAGRANGE-LAGRANGE
!    UNIT         --> UNITE DU FICHIER D'AFFICHAGE
!    GI           --> VALEURS DES GI=<G,THETAI>
!    NDEG         --> DEGRE DU POLYNOME DE LEGENDRE
!    GTHI         --> VALEURS DES G ELEMENTAIRES AVANT LISSAGE
!    EXTIM        --> .TRUE. => TIME EXISTE
!    TIME         --> INSTANT DE CALCUL A IMPRIMER
!    IORDR        --> NUMERO D'ORDRE A IMPRIMER
! ......................................................................
!
    integer :: nnoff, unit, numero, ndeg, iordr, i, i1, ndimte
    real(kind=8) :: gs(1), gthi(1), gi(1), time, absc(*)
    aster_logical :: extim
    character(len=8) :: result
! ......................................................................
!
    write(unit,*)
!
    if (numero .eq. 1) then
        write(unit,555) ndeg
    else if (numero.eq.2) then
        write(unit,556) ndeg
    else if (numero.eq.3) then
        write(unit,557)
    else if (numero.eq.4) then
        write(unit,558)
    endif
!
    write(unit,666)
    write(unit,*)
!
    if (numero .ne. 1) then
        write(unit,770)
        write(unit,*)
        write(unit,*) ' NOEUD    GELEM(THETAI)'
        write(unit,*)
        if (numero .eq. 5) then
            do i = 1, ndimte
                write(unit,110) i,gthi(i)
            end do
        else
            do i = 1, nnoff
                write(unit,110) i,gthi(i)
            end do
        endif
        write(unit,*)
    endif
!
    if ((numero.eq.1) .or. (numero.eq.2)) then
        write(unit,777)
        write(unit,*)
        do i = 1, ndeg+1
            i1 = i-1
            write(unit,*) 'DEGRE ',i1,' : ',gi(i)
        end do
        write(unit,*)
    endif
!
    if (extim) then
        write(unit,*) '          INSTANT : ',time
        write(unit,*) '          +++++++'
    else if (iordr.ne.0) then
        write(unit,*) '          NUMERO D''ORDRE : ',iordr
        write(unit,*) '          ++++++++++++++'
    endif
    write(unit,*)
    write(unit,*)  'TAUX DE RESTITUTION D''ENERGIE LOCAL : ',result
    write(unit,*)
    write(unit,*)  ' ABSC_CURV       G(S)'
    write(unit,*)
    do i = 1, nnoff
        write(unit,111) absc(i), gs(i)
    end do
    write(unit,*)
!
    110 format(1x,i2,6x,1pd12.5)
    111 format(1x,2(1pd12.5,4x))
    555 format('THETA_LEGENDRE  G_LEGENDRE (DEGRE ',i2,')')
    556 format('THETA_LAGRANGE  G_LEGENDRE (DEGRE ',i2,')')
    557 format('THETA_LAGRANGE  G_LAGRANGE')
    558 format('THETA_LAGRANGE  G_LAGRANGE_NO_NO')
    666 format(37('*'))
    770 format('VALEURS DE G ELEMENTAIRES AVANT LISSAGE :')
    777 format('COEF DE G(S) DANS LA BASE DE POLYNOMES DE LEGENDRE :')
!
end subroutine
