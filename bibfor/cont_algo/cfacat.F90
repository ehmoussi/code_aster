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

subroutine cfacat(indic, nbliac, ajliai, spliai,&
                  indfac, &
                  sdcont_defi, sdcont_solv, solveu, lmat, &
                  xjvmax)
!
implicit none
!
#include "asterfort/cfaca1.h"
#include "asterfort/cfaca2.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: nbliac
    integer :: indic, ajliai, spliai
    integer :: indfac, lmat
    real(kind=8) :: xjvmax
    character(len=24) :: sdcont_defi, sdcont_solv
    character(len=19) :: solveu
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete methods - Compute A.C-1.AT
!
! --------------------------------------------------------------------------------------------------
!
! IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  SOLVEU : SD SOLVEUR
! IN  LMAT   : DESCRIPTEUR DE LA MATR_ASSE DU SYSTEME MECANIQUE
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
! --------------------------------------------------------------------------------------------------
!
    if (indic .ne. -1) then
        call cfaca1(nbliac, ajliai, &
                    sdcont_defi, sdcont_solv, solveu,&
                    lmat)
    endif
    call cfaca2(nbliac, spliai, &
                indfac, sdcont_solv, lmat,&
                xjvmax)
!
    indic = 1
!
end subroutine
