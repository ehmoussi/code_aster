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

subroutine jemarq()
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
! ----------------------------------------------------------------------
! INCREMENTE LA MARQUE COURANTE
!
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
#include "jeveux_private.h"
#include "asterfort/assert.h"
#include "asterfort/jjalls.h"
#include "asterfort/jjlidy.h"
    integer :: k, n
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    integer :: nrhcod, nremax, nreuti
    common /icodje/  nrhcod(n) , nremax(n) , nreuti(n)
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
! ----------------------------------------------------------------------
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    integer :: ipgc, kdesma(2), lgd, lgduti, kposma(2), lgp, lgputi
    common /iadmje/  ipgc,kdesma,   lgd,lgduti,kposma,   lgp,lgputi
    integer :: istat
    common /istaje/  istat(4)
    real(kind=8) :: svuse, smxuse
    common /statje/  svuse,smxuse
! ----------------------------------------------------------------------
    integer :: iadma(1), iadrs, lsi, ktempo(2)
! ----------------------------------------------------------------------
    if (kdesma(1) .eq. 0) then
!
! ----- CREATION DES SEGMENTS DE VALEURS DE GESTION DES MARQUES
!
        lgd = nremax(1)+nremax(2)+nremax(3)+nremax(4)+nremax(5)
        call jjalls(lgd*lois, 0, 'V', 'I', lois,&
                    'INIT', iadma, iadrs, kdesma(1), kdesma(2))
        iszon(jiszon+kdesma(1)-1) = istat(2)
        iszon(jiszon+iszon(jiszon+kdesma(1)-4)-4) = istat(4)
        lgduti = 0
        lgp = 50
        svuse = svuse + (iszon(jiszon+kdesma(1)-4) - kdesma(1) + 4)
        call jjalls(lgp*lois, 0, 'V', 'I', lois,&
                    'INIT', iadma, iadrs, kposma(1), kposma(2))
        iszon(jiszon+kposma(1)-1) = istat(2)
        iszon(jiszon+iszon(jiszon+kposma(1)-4)-4) = istat(4)
        lgputi = 0
        svuse = svuse + (iszon(jiszon+kposma(1)-4) - kposma(1) + 4)
        smxuse = max(smxuse,svuse)
    else if (lgputi .eq. lgp) then
!
! ------ AGRANDISSEMENT DE L'OBJET DONNANT LES POSITIONS
!
        lsi = lgp
        lgp = 2*lgp
        call jjalls(lgp*lois, 0, 'V', 'I', lois,&
                    'INIT', iadma, iadrs, ktempo(1), ktempo(2))
        iszon(jiszon+ktempo(1)-1) = istat(2)
        iszon(jiszon+iszon(jiszon+ktempo(1)-4)-4) = istat(4)
        svuse = svuse + (iszon(jiszon+ktempo(1)-4) - ktempo(1) + 4)
        smxuse = max(smxuse,svuse)
        do 100 k = 1, lsi
            iszon(jiszon+ktempo(1)+k-1) = iszon(jiszon+kposma(1)+k-1)
100      continue
        call jjlidy(kposma(2), kposma(1))
        kposma(1) = ktempo(1)
        kposma(2) = ktempo(2)
    endif
!
! --- ACTUALISATION DE LA POSITION DES OBJETS MARQUES
!
    iszon(jiszon + kposma(1) + ipgc ) = lgduti
    lgputi = lgputi + 1
    ipgc = ipgc + 1
!
!     SI IPGC > 200 C'EST PROBABLEMENT QU'UNE ROUTINE
!     FAIT JEMARQ SANS FAIRE JEDEMA
    ASSERT(ipgc.lt.200)
!
! FIN ------------------------------------------------------------------
end subroutine
