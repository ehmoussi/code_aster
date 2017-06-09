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

subroutine cuacat(indic, nbliac, ajliai, spliai, lmat,&
                  indfac, deficu, resocu, solveu, cncine,&
                  xjvmax)
!
!
    implicit      none
#include "asterfort/cuaca1.h"
#include "asterfort/cuaca2.h"
    integer :: indic
    integer :: nbliac
    integer :: ajliai
    integer :: spliai
    integer :: indfac
    integer :: lmat
    real(kind=8) :: xjvmax
    character(len=24) :: deficu, resocu
    character(len=19) :: solveu, cncine
!
! ----------------------------------------------------------------------
!
! ROUTINE LIAISON_UNILATER (RESOLUTION)
!
! ROUTINE MERE POUR LE CALCUL DE A.C-1.AT
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICU : SD DE DEFINITION
! IN  RESOCU : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  SOLVEU : SD SOLVEUR
! IN  LMAT   : DESCRIPTEUR DE LA MATR_ASSE DU SYSTEME MECANIQUE
! IN  CNCINE : CHAM_NO CINEMATIQUE
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
! I/O AJLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
!              LIAISON CORRECTE DU CALCUL
!              DE LA MATRICE DE CONTACT ACM1AT
! I/O XJVMAX : VALEUR DU PIVOT MAX
! I/O SPLIAI : INDICE DANS LA LISTE DES LIAISONS ACTIVES DE LA DERNIERE
!              LIAISON AYANT ETE CALCULEE POUR LE VECTEUR CM1A
! I/O INDFAC : INDICE DE DEBUT DE LA FACTORISATION
! I/O INDIC  : +1 ON A RAJOUTE UNE LIAISON
!              -1 ON A ENLEVE UNE LIAISON
!
! ----------------------------------------------------------------------
!
    if (indic .ne. -1) then
        call cuaca1(deficu, resocu, solveu, lmat, cncine,&
                    nbliac, ajliai)
    endif
    call cuaca2(deficu, resocu, nbliac, spliai, indfac,&
                lmat, xjvmax)
!
    indic = 1
!
end subroutine
