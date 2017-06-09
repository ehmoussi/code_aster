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

subroutine cov4v5(coddes, codgra)
    implicit none
!
!     !                                                          !
!     !  AUTEURS:J.F.LAMAUDIERE                   DATE:18/04/91  !
!     !                                                          !
!     !                                                          !
!     ============================================================
!     !                                                          !
!     !  FONCTION:ASSURE LA CORRESPONDANCE ENTRE LE CODE DESCRI- !
!     !           PTEUR ( SUPERTAB I-DEAS 5.0 ) ET LE CODE GRA   !
!     !           PHIQUE ( SUPERTAB I-DEAS 4.0) POUR LES MAILLES !
!     !                                                          !
!     ============================================================
!     !                                                          !
!     !  SOUS PROGRAMMES APPELES : NEANT                         !
!     !                                                          !
!     !  SOUS PROGRAMME APPELANT : PRESUP                        !
!     !                                                          !
!     ============================================================
!     !                                                          !
!     !                   ***************                        !
!     !                   *  ARGUMENTS  *                        !
!     !                   ***************                        !
!     !                                                          !
!     !  ******************************************************  !
!     !  *   NOM    *  TYPE * MODE *MODIFIE*      ROLE        *  !
!     !  ******************************************************  !
!     !  *          *       *      *       *                  *  !
!     !  * CODDES   *INTEGER*ENTREE* NON   *CODE DESCRIPTEUR  *  !
!     !  *          *       *      *       * POUR UNE MAILLE  *  !
!     !  *          *       *      *       * (I-DEAS 5.0)     *  !
!     !  *          *       *      *       *                  *  !
!     !  * CODGRA   *INTEGER*SORTIE* NON   *CODE GRAPHIQUE    *  !
!     !  *          *       *      *       * DE LA MEME MAILLE*  !
!     !  *          *       *      *       *                  *  !
!     !  ******************************************************  !
!     !                                                          !
!     ============================================================
!
!  --> DECLARATION DES ARGUMENTS
    integer :: coddes, codgra
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (coddes .eq. 171) then
        codgra=1
        else if (coddes.eq.91 .or. coddes.eq.61 .or. coddes.eq.41 .or.&
    coddes.eq.51 .or. coddes.eq.74 .or. coddes.eq.81) then
        codgra=2
    else if (coddes.eq.11 .or. coddes.eq.21 .or. coddes.eq.23) then
        codgra=1
    else if (coddes.eq.22 .or. coddes.eq.24) then
        codgra=35
        else if (coddes.eq.92 .or. coddes.eq.62 .or. coddes.eq.42 .or.&
    coddes.eq.52 .or. coddes.eq.72 .or. coddes.eq.82) then
        codgra=3
        else if (coddes.eq.93 .or. coddes.eq.63 .or. coddes.eq.43 .or.&
    coddes.eq.53 .or. coddes.eq.73) then
        codgra=4
        else if (coddes.eq.94 .or. coddes.eq.64 .or. coddes.eq.44 .or.&
    coddes.eq.54 .or. coddes.eq.71 .or. coddes.eq.84) then
        codgra=5
        else if (coddes.eq.95 .or. coddes.eq.65 .or. coddes.eq.55 .or.&
    coddes.eq.45 .or. coddes.eq.75 .or. coddes.eq.85) then
        codgra=6
        else if (coddes.eq.96 .or. coddes.eq.66 .or. coddes.eq.46 .or.&
    coddes.eq.56 .or. coddes.eq.76) then
        codgra=7
    else if (coddes.eq.101) then
        codgra=8
    else if (coddes.eq.102) then
        codgra=9
    else if (coddes.eq.103) then
        codgra=10
    else if (coddes.eq.104) then
        codgra=11
    else if (coddes.eq.105) then
        codgra=12
    else if (coddes.eq.106) then
        codgra=13
    else if (coddes.eq.111) then
        codgra=14
    else if (coddes.eq.118) then
        codgra=15
    else if (coddes.eq.112) then
        codgra=16
    else if (coddes.eq.113) then
        codgra=17
    else if (coddes.eq.114) then
        codgra=18
    else if (coddes.eq.115) then
        codgra=19
    else if (coddes.eq.116) then
        codgra=20
    else if (coddes.eq.117) then
        codgra=21
    else if (coddes.eq.136 .or. coddes.eq.137) then
        codgra=29
    else if (coddes.eq.138 .or. coddes.eq.139) then
        codgra=30
    else if (coddes.eq.141) then
        codgra=31
    else if (coddes.eq.142) then
        codgra=32
    else if (coddes.eq.161) then
        codgra=33
    else if (coddes.eq.121) then
        codgra=34
    else if (coddes.eq.172) then
        codgra=35
    endif
!
end subroutine
