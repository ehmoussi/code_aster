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

subroutine uttrif(vale, nb, typfon)
    implicit none
#include "asterc/getres.h"
#include "asterfort/utmess.h"
    integer :: nb
    real(kind=8) :: vale(*)
    character(len=*) :: typfon
!     TRI DES FONCTIONS PAR ABSCISSES CROISSANTES
!     (METHODE DE REMONTEE DES BULLES REPRIS DE UTTRIR)
! ----------------------------------------------------------------------
! POUR LES FONCTIONS A VALEURS REELLES :
! IN/OUT : VALE   : ABSCISSES, VALEUR
!                   SOUS LA FORME X1,X2,... Y1,Y2,...
! POUR LES FONCTIONS A VALEURS COMPLEXES :
! IN/OUT : VALE   : ABSCISSES, PARTIE REELLE, PARTIE IMAGINAIRE
!                   SOUS LA FORME X1,Y1,Z1, X2,Y2,Z2, ...
! IN     : NB     : NBRE DE POINTS DE LA FONCTION
! IN     : TYPFON : TYPE DE LA FONCTION A REORDONNER
! ----------------------------------------------------------------------
    integer :: j, l, incrs, is9
    real(kind=8) :: xt
    character(len=16) :: nomcmd, k16b1, k16b2
!
    if (typfon .eq. 'FONCTION') then
!        --- TRI BULLE ---
        if (nb .gt. 1) then
!            --- CHOIX DE L'INCREMENT ---
            incrs = 1
            is9 = nb / 9
10          continue
            if (incrs .lt. is9) then
                incrs = 3*incrs+1
                goto 10
            endif
!            --- REMONTEE DES BULLES ---
120          continue
            do 150 j = incrs+1, nb
                l = j-incrs
130              continue
                if (l .gt. 0) then
                    if (vale(l) .gt. vale(l+incrs)) then
!                     --- PERMUTATION DES ABSCISSES ---
                        xt = vale(l)
                        vale(l) = vale(l+incrs)
                        vale(l+incrs) = xt
!                     --- PERMUTATION DES ORDONNEES ---
                        xt = vale(l+nb)
                        vale(l+nb) = vale(l+nb+incrs)
                        vale(l+nb+incrs) = xt
                        l = l - incrs
                        goto 130
                    endif
                endif
150          continue
            incrs = incrs/3
            if (incrs .ge. 1) goto 120
        endif
    else if (typfon.eq.'FONCT_C') then
!        --- TRI BULLE ---
        if (nb .gt. 1) then
!            --- CHOIX DE L'INCREMENT ---
            incrs = 1
            is9 = nb / 9
11          continue
            if (incrs .lt. is9) then
                incrs = 3*incrs+1
                goto 11
            endif
!            --- REMONTEE DES BULLES ---
121          continue
            do 151 j = incrs+1, nb
                l = j-incrs
131              continue
                if (l .gt. 0) then
                    if (vale(l) .gt. vale(l+incrs)) then
!                     --- PERMUTATION DES ABSCISSES ---
                        xt = vale(l)
                        vale(l) = vale(l+incrs)
                        vale(l+incrs) = xt
!                     --- PERMUTATION DES PARTIES REELLES ---
                        xt = vale(nb+2*(l-1)+1)
                        vale(nb+2*(l-1)+1) = vale(nb+2*(l+incrs-1)+1)
                        vale(nb+2*(l+incrs-1)+1) = xt
!                     --- PERMUTATION DES PARTIES IMAGINAIRES ---
                        xt = vale(nb+2*(l-1)+2)
                        vale(nb+2*(l-1)+2) = vale(nb+2*(l+incrs-1)+2)
                        vale(nb+2*(l+incrs-1)+2) = xt
                        l = l - incrs
                        goto 131
                    endif
                endif
151          continue
            incrs = incrs/3
            if (incrs .ge. 1) goto 121
        endif
    else
        call getres(k16b1, k16b2, nomcmd)
        call utmess('F', 'UTILITAI5_58')
    endif
!
end subroutine
