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

subroutine jjallt(lonoi, ic, gi, typei, ltypi,&
                  ci, jctab, jcdyn)
! aslint: disable=C1002,W0405
    implicit none
#include "jeveux.h"
#include "asterfort/jjalls.h"
    integer :: lonoi, ic, ltypi, jctab
    character(len=*) :: gi, typei, ci
!-----------------------------------------------------------------------
! CHAPEAU A LA ROUTINE JJALLS POUR PLACER CORRECTEMENT LE SEGMENT DE
! VALEURS EN FONCTION DU TYPE ASSOCIE
!
! IN   LONOI  : LONGUEUR DU SEGMENT DE VALEURS
! IN   IC     : CLASSE DE L'OBJET
! IN   GI     : GENRE DE L'OBJET
! IN   TYPEI  : TYPE DE L'OBJET
! IN   LTYPI  : LONGUEUR DU TYPE
! IN   CI     : = 'INIT' POUR INITIALISER LE SEGMENT DE VALEUR
! OUT  JCTAB  : ADRESSE PAR RAPPORT AU COMMUN DE REFERENCE EN
!               SEGMENTATION MEMOIRE
! OUT  JCDYN  : ADRESSE PAR RAPPORT AU COMMUN DE REFERENCE EN
!               ALLOCATION DYNAMIQUE
!
    integer :: izr(1), izc(1), izl(1), izk8(1), izk16(1), izk24(1)
    integer :: izk32(1), izk80(1), jbid, izi4(1), jcdyn
    equivalence    (izr,zr),(izc,zc),(izl,zl),(izk8,zk8),(izk16,zk16),&
     &               (izk24,zk24),(izk32,zk32),(izk80,zk80),(izi4,zi4)
! DEB ------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    jctab = 0
    if (typei(1:1) .eq. 'I') then
        call jjalls(lonoi, ic, gi, typei, ltypi,&
                    ci, zi, jbid, jctab, jcdyn)
    else if (typei .eq. 'S') then
        call jjalls(lonoi, ic, gi, typei, ltypi,&
                    ci, izi4, jbid, jctab, jcdyn)
    else if (typei(1:1) .eq. 'R') then
        call jjalls(lonoi, ic, gi, typei, ltypi,&
                    ci, izr, jbid, jctab, jcdyn)
    else if (typei(1:1) .eq. 'C') then
        call jjalls(lonoi, ic, gi, typei, ltypi,&
                    ci, izc, jbid, jctab, jcdyn)
    else if (typei(1:1) .eq. 'K') then
        if (ltypi .eq. 8) then
            call jjalls(lonoi, ic, gi, typei, ltypi,&
                        ci, izk8, jbid, jctab, jcdyn)
        else if (ltypi .eq. 16) then
            call jjalls(lonoi, ic, gi, typei, ltypi,&
                        ci, izk16, jbid, jctab, jcdyn)
        else if (ltypi .eq. 24) then
            call jjalls(lonoi, ic, gi, typei, ltypi,&
                        ci, izk24, jbid, jctab, jcdyn)
        else if (ltypi .eq. 32) then
            call jjalls(lonoi, ic, gi, typei, ltypi,&
                        ci, izk32, jbid, jctab, jcdyn)
        else if (ltypi .eq. 80) then
            call jjalls(lonoi, ic, gi, typei, ltypi,&
                        ci, izk80, jbid, jctab, jcdyn)
        endif
    else if (typei(1:1) .eq. 'L') then
        call jjalls(lonoi, ic, gi, typei, ltypi,&
                    ci, izl, jbid, jctab, jcdyn)
    endif
! FIN ------------------------------------------------------------------
end subroutine
