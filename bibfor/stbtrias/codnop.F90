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

subroutine codnop(nom1, nom2, ic, nc)
    implicit none
!     ===================================
!
!     ===============================================================
!     !                                                             !
!     !  AUTEUR:J.F.LAMAUDIERE                         DATE:1/12/89 !
!     !                                                             !
!     !  LOGISCOPE STATIQUE :09/02/90                               !
!     !                                                             !
!     !  LOGISCOPE DYNAMIQUE (35 JEUX TESTS) :21/02/90              !
!     !                                                             !
!     ===============================================================
!     !                                                             !
!     !  FONCTION: CETTE ROUTINE PERMET L'ECRITURE D'UNE CHAINE !
!     !            DE CARACTERES DANS UNE AUTRE.                    !
!     !                                                             !
!     ===============================================================
!     !                                                             !
!     !  ROUTINE APPELANTES : ECRNEU                                !
!     !                           : SLECOR                          !
!     !                           : ECRELT                          !
!     !                           : SLEGRO                          !
!     !                           : SLEGEO                          !
!     !                           : ECFACH                          !
!     !                                                             !
!     ==============================================================!
!     !                                                             !
!     !                    ***************                          !
!     !                    *  ARGUMENTS  *                          !
!     !                    ***************                          !
!     !                                                             !
!     ! *********************************************************** !
!     ! *   NOM  *  TYPE  * MODE *ALTERE *        ROLE            * !
!     ! *********************************************************** !
!     ! * NOM1   *CHARACTE*SORTIE* OUI   *  CHAINE DE CARACTERE   * !
!     ! *        *        *      *       * RESULTAT DE LA CONCATE-* !
!     ! *        *        *      *       *   NATION               * !
!     ! *        *        *      *       *                        * !
!     ! * NOM2   *CHARACTE*ENTREE* NON   * CHAINE DE CARACTERES A * !
!     ! *        *        *      *       *   CONCATENER           * !
!     ! *        *        *      *       *                        * !
!     ! * IC     *INTEGER *ENTREE* NON   * DEBUT DE LA POSITION DE* !
!     ! *        *        *      *       *LA CHAINE NOM2 DANS NOM1* !
!     ! *        *        *      *       *                        * !
!     ! * NC     *INTEGER *ENTREE* NON   * FIN DE LA POSITION     * !
!     ! *        *        *      *       * ABSOLUE DE LA CHAINE   * !
!     ! *        *        *      *       *  NOM2 DANS NOM1        * !
!     ! *********************************************************** !
!     !                                                             !
!     ===============================================================
!
!  --> DECLARATION DES ARGUMENTS
    character(len=*) :: nom1, nom2
    integer :: ic, nc
!
!  --> DECLARATION INDICE DE BOUCLE
    integer :: i
!
!  ---------- FIN DECLARATIONS _________
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    do 10 i = ic, nc
        nom1(i:i)=' '
10  end do
!
    write(nom1(ic:nc),'(A)') nom2
end subroutine
