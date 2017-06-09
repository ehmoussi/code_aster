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

subroutine cheddl(ideeq, neq, ino, ityp, iran,&
                  nbran)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 27/11/90
!-----------------------------------------------------------------------
!  BUT:  CHERCHER LES RANG D'UN DDL A PARTIR DE SON TYPE ET DU NOEUD
!   SUR LEQUEL IL S'APPUIE
!
!
!  ATTENTION: S'APPUIE SUR UN DEEQ PARTICULIER:
!     IDEEQ(1,I) --> NUMERO DU NOEUD SUR LEQUEL PORTE LE DDL
!     IDEEQ(2,I) --> ENTIER DU TYPE DDL
!
!  AVEC LES TYPES SUIVANTS:
!
!    DX=1    (1)    LAG SUR UN DX=-1   (7)        () PRNO-NUMDDL ASTER
!    DY=2    (2)    LAG SUR UN DY=-2   (7)
!    DZ=3    (3)    LAG SUR UN DZ=-3   (7)
!    DRX=4    (4)    LAG SUR UN DRX=-4   (7)
!    DRY=5    (5)    LAG SUR UN DRY=-5   (7)
!    DRZ=6    (6)    LAG SUR UN DRZ=-6   (7)
!
!
!  DANS LE CAS D'UN LAGRANGE PORTANT SUR PLUSIEURS DDL ET NOEUDS
!  ( TYPIQUEMENT RESULTANT D'UN LIAISON DDL) LE NUMERO DU NOEUD AINSI
!   QUE LE TYPE DE DDL SONT A ZERO
!
!
!   IL PEUT Y AVOIR DEUX RANG POUR UN NOEUD ET UN TYPE DDL DANS LE CAS
!   D'UN LAGRANGE DE DDL-BLOQUE, D'OU LA PRESENCE EN ARGUMENT DU NOMBRE
!  DE RANGS RECHERCHE
!
!  SI NBRAN=1   DDL NON TROUVE--> 0
!               DDL TROUVE--> RANG DU DDL
!
!
!  SI NBRAN=2    AUCUN DDL TROUVE-->(0,0)
!                1 DDL TROUVE-->(RANG1,RANG1)
!                2DDL TROUVE-->(RANG1,RANG2)
!
!-----------------------------------------------------------------------
!
! IDEEQ    /I/: MATRICE DEEQ DU NUMDDL
! NEQ      /I/: NOMBRE DE DDL
! INO      /I/: NUMERO DU NOEUD PORTANT LE DDL
! ITYP     /I/: NUMERO DE TYPE DU DDL (COMME DECRIT PLUS HAUT)
! IRAN     /O/: RANGS DU DDL RECHERCHE(0 SI EXISTE PAS)
! NBRAN    /I/: NOMBRE DE RANGS RECHERCHES
!
!-----------------------------------------------------------------------
!
    integer :: ideeq(2, neq), iran(nbran)
    integer :: i, icomp, ino, inobis, itybis, ityp, k
    integer :: nbran, neq
!-----------------------------------------------------------------------
!
!    MISE A ZERO PREALABLE DES RANGS
!
    do 20 i = 1, nbran
        iran(i)=0
20  end do
!
!
    i=0
    icomp=0
10  continue
    i=i+1
    inobis=ideeq(1,i)
    itybis=ideeq(2,i)
    if (inobis .eq. ino .and. itybis .eq. ityp) then
        icomp=icomp+1
        do 30 k = icomp, nbran
            iran(k)=i
30      continue
    endif
    if (i .lt. neq .and. icomp .lt. nbran) goto 10
!
end subroutine
