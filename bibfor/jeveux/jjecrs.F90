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

subroutine jjecrs(iadmi, iclas, idos, idco, cus,&
                  jmarq)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "jeveux_private.h"
#include "asterfort/jjalls.h"
#include "asterfort/jjlidy.h"
    integer :: iadmi, iclas, idos, idco, jmarq(2)
    character(len=*) :: cus
! ----------------------------------------------------------------------
! ACTUALISE LES ENTIERS ENCADRANT UN SEGMENT DE VALEURS
!
! IN  IADMI  : ADRESSE DU PREMIER MOT DU SEGMENT DE VALEUR
! IN  ICLAS  : CLASSE DE L'OBJET JEVEUX
! IN  IDOS   : IDENTIFICATEUR D'OBJET SIMPLE OU D'OBJET DE COLLECTION
! IN  IDCO   : IDENTIFICATEUR DE COLLECTION
! IN  CUS    : USAGE DU SEGMENT DE VALEUR EN ACCES U
! OUT JMARQ  : JMARQ(1) MARQUE AFFECTEE AU SEGMENT DE VALEUR ASSOCIE
!              JMARQ(2) ADRESSE DE L'OBJET DANS LE DESCRIPTEUR DESMA
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
! ----------------------------------------------------------------------
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    integer :: istat
    common /istaje/  istat(4)
! ---                  ISTAT(1)->X , (2)->U , (3)->A , (4)->D
    integer :: ipgc, kdesma(2), lgd, lgduti, kposma(2), lgp, lgputi
    common /iadmje/  ipgc,kdesma,   lgd,lgduti,kposma,   lgp,lgputi
    real(kind=8) :: svuse, smxuse
    common /statje/  svuse,smxuse
! ----------------------------------------------------------------------
    integer :: ista1, ista2, is, ktempo(2)
! DEB ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: iadma(1), iadrs, k, lsi
!-----------------------------------------------------------------------
    ista1 = iszon(jiszon+iadmi-1)
    is = jiszon+iszon(jiszon+iadmi-4)
    ista2 = iszon(is-4)
!
! --- ACCES EN ECRITURE : ON PASSE A UD
!
    if (cus .eq. 'E') then
        if (ista1 .eq. istat(1)) then
            iszon(jiszon+iadmi-1) = istat(2)
            iszon(jiszon+iadmi-2) = idos
            iszon(is-3) = idco
            iszon(is-2) = iclas
            svuse = svuse + (iszon(jiszon+iadmi-4) - iadmi + 4)
            smxuse = max(smxuse,svuse)
        endif
        iszon(is-4) = istat(4)
!
! --- ACCES EN LECTURE : 1/ XD ET UD PASSENT A UD
!                        2/ XX ET XA PASSENT A UA
!
    else if (cus .eq. 'L') then
        if (ista1 .eq. istat(1)) then
            svuse = svuse + (iszon(jiszon+iadmi-4) - iadmi + 4)
            smxuse = max(smxuse,svuse)
        endif
        if (ista2 .eq. istat(4)) then
            iszon(jiszon+iadmi-1) = istat(2)
        else
            iszon(jiszon+iadmi-1) = istat(2)
            iszon(jiszon+iadmi-2) = idos
            iszon(is-4) = istat(3)
            iszon(is-3) = idco
            iszon(is-2) = iclas
        endif
    endif
    if (ista1 .eq. istat(1)) then
        jmarq(1) = ipgc
        if (ipgc .gt. 0) then
            if (lgduti .eq. lgd) then
!
! ------- AGRANDISSEMENT DE L'OBJET CONTENANT LES ADRESSES
!
                lsi = lgd
                lgd = 2*lgd
                call jjalls(lgd*lois, 0, 'V', 'I', lois,&
                            'INIT', iadma, iadrs, ktempo(1), ktempo(2))
                iszon(jiszon+ktempo(1)-1) = istat(2)
                iszon(jiszon+iszon(jiszon+ktempo(1)-4)-4) = istat(4)
                svuse = svuse + (iszon(jiszon+ktempo(1)-4) - ktempo(1) + 4)
                smxuse = max(smxuse,svuse)
                do 100 k = 1, lsi
                    iszon(jiszon+ktempo(1)+k-1) = iszon(jiszon+kdesma( 1)+k-1)
100              continue
                call jjlidy(kdesma(2), kdesma(1))
                kdesma(1) = ktempo(1)
                kdesma(2) = ktempo(2)
            endif
            lgduti = lgduti+1
            iszon(jiszon + kdesma(1) + lgduti - 1) = iadmi
            jmarq(2) = lgduti
        endif
    else if (ipgc .eq. -1) then
        if (jmarq(1) .ne. -3) then
            jmarq(1) = ipgc
            if (jmarq(2) .gt. 0) then
                iszon(jiszon + kdesma(1) + jmarq(2) - 1 ) = 0
                jmarq(2) = 0
            endif
        endif
    else if (ipgc .eq. -3) then
        jmarq(1) = ipgc
        if (jmarq(2) .gt. 0) then
            iszon(jiszon + kdesma(1) + jmarq(2) - 1 ) = 0
            jmarq(2) = 0
        endif
    endif
! FIN ------------------------------------------------------------------
end subroutine
