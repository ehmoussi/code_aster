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

subroutine lecelt(iunv, maxnod, nbtyma, indic, permut,&
                  codgra, node, nbnode)
    implicit none
!     ================================================================
!A PRESUPER
!
!     =============================================================
!     !                                                           !
!     !  FONCTION: LECTURE DES NOEUDS DES MAILLES DE CODE GRAPH-  !
!     !            IQUE CODGRA.                                   !
!     !            !!!!!  PERMUTATION EVENTUELLE !!!!!            !
!     !  (CF. DOCUMENT INTERFACE SUPERTAB-ASTER )  !
!     =============================================================
!     !                                                           !
!     !  ROUTINE APPELE: IUNIFI (FONCTION)                        !
!     !                                                           !
!     !  ROUTINE APPELANTE: SLEELT                                !
!     !                                                           !
!     =============================================================
!     !                                                           !
!     !                 ***************                           !
!     !                 *  ARGUMENTS  *                           !
!     !                 ***************                           !
!     !                                                           !
!     !  ******************************************************** !
!     !  *   NOM     * TYPE  * MODE *ALTERE *     ROLE          * !
!     !  ******************************************************** !
!     !  *           *       *      *       *                   * !
!     !  * MAXNOD    *INTEGER*ENTREE* NON   *NBRE MAXI DE NOEUDS* !
!     !  *           *       *      *       *POUR UNE MAILLE    * !
!     !  *           *       *      *       *                   * !
!     !  * NBTYMA    *INTEGER*ENTREE* NON   *NBRE DE TYPES DE   * !
!     !  *           *       *      *       * MAILLES SUPERTAB  * !
!     !  *           *       *      *       *                   * !
!     !  * INDIC     *INTEGER*ENTREE* NON   * INDIQUE S'IL FAUT * !
!     !  *           *       *      *       *FAIRE 1 PERMUTATION* !
!     !  *           *       *      *       *                   * !
!     !  * PERMUT    *INTEGER*ENTREE* NON   * TABLEAU DE PERMU- * !
!     !  *           *       *      *       *  TATION           * !
!     !  *           *       *      *       *                   * !
!     !  * CODGRA    *INTEGER*ENTREE* NON   * CODE GRAPHIQUE DE * !
!     !  *           *       *      *       * LA MAILLE A LIRE  * !
!     !  *           *       *      *       *                   * !
!     !  * NBNODE    *INTEGER*ENTREE* NON   * NBRE DE NOEUDS DE * !
!     !  *           *       *      *       *  CETTE MAILLE     * !
!     !  *           *       *      *       *                   * !
!     !  * NODE      *INTEGER*SORTIE* NON   * TABLEAU DES NOEUDS* !
!     !  *           *       *      *       *(PARFOIS PERMUTES) * !
!     !  *           *       *      *       * DE LA MAILLE      * !
!     !  *           *       *      *       *                   * !
!     !  ******************************************************** !
!     !                                                           !
!     !   VARIABLES LOCALES:  NODLU(2)--> TABLEAU DE TRAVAIL      !
!     !   ------------------                                      !
!     =============================================================
!
!  --> DECLARATION DES ARGUMENTS
#include "asterfort/iunifi.h"
    integer :: maxnod, nbtyma
    integer :: codgra, node(maxnod), nbnode
    integer :: permut(maxnod, nbtyma), indic(nbtyma)
!  --> DECLARATION DES VARIABLES LOCALES
    integer :: nodlu(32), ii
!  --> DECLARATION DES INDICES DE BOUCLES
    integer :: i
    integer :: imes, iunv
!-----------------------------------------------------------------------
!
    read (iunv,'(8I10)') (nodlu(i),i=1,nbnode)
!
    if (indic(codgra) .eq. -1) then
        imes = iunifi('MESSAGE')
        write (imes,*) 'MAILLE DE TYPE ',codgra,' NON TRAITE'
    else if (indic(codgra).eq.0) then
!
        do 1 i = 1, nbnode
            node(i) = nodlu(i)
 1      continue
!
    else if (indic(codgra).eq.1) then
!
        do 2 i = 1, nbnode
            ii = permut(i,codgra)
            node(ii) = nodlu(i)
 2      continue
!
    endif
!
end subroutine
