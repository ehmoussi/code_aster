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

subroutine foverf(v, nc, ier)
    implicit none
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
    integer :: nc, ier, i, isens, ilarge, niv, ifm
    real(kind=8) :: v(nc)
    character(len=16) :: nomcmd, typfon
    character(len=19) :: nomfon
!     VERIFICATION DU CARACTERE CROISSANT OU DECROISSANT
!     DES VALEURS DANS V
!     ------------------------------------------------------------------
! IN     : V   : VECTEUR DES VALEURS
! IN     : NC  : NOMBRE DE POINTS
! IN/OUT : IER :
!  EN ENTREE :   0 : SI ON VEUT SIMPLEMENT RECUPERER LE SENS
!             <> 0 : DECLENCHE UNE ERREUR SI LE SENS N'EST PAS VERIFIE
!  EN SORTIE : LE SENS DE LA LISTE DES PARAMETRES
!  CODE DU SENS : 2 : STRICTEMENT CROISSANT
!                 1 : CROISSANT AU SENS LARGE
!                 0 : NON MONOTONE
!                -1 : DECROISSANT AU SENS LARGE
!                -2 : STRICTEMENT DECROISSANT
!  EX : SI EN ENTREE IER=1 ET QUE LA LISTE N'EST PAS CROISSANTE, ERREUR
!  REM : S'IL N'Y A QU'UNE VALEUR, ON RETOURNE LA MEME VALEUR
!     ------------------------------------------------------------------
!
!     ISENS (TRAVAIL) : 1 SI CROIS, -1 SI DECROIS,
!                      99 SI ON NE SAIT PAS, 0 NON MONOTONE
!     ILARGE : 0 SI AU SENS LARGE, 1 SI STRICT
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call infniv(ifm, niv)
!
    if (nc .gt. 1) then
        isens=99
        ilarge=1
        i=2
        if (v(i) .eq. v(i-1)) then
            ilarge=0
        else if (v(i).gt.v(i-1)) then
            isens=1
        else
            isens=-1
        endif
!
        do 10 i = 3, nc
            if (v(i) .eq. v(i-1)) then
                ilarge=0
                if (niv .ge. 2) then
                    write(ifm,1000) i,v(i)
                endif
            else if (v(i).gt.v(i-1)) then
                if (isens .eq. 99 .or. isens .eq. 1) then
                    isens=1
                else
                    isens=0
                    if (niv .ge. 2) then
                        write(ifm,1001) i,v(i-1),v(i)
                    endif
                endif
            else
                if (isens .eq. 99 .or. isens .eq. -1) then
                    isens=-1
                else
                    isens=0
                    if (niv .ge. 2) then
                        write(ifm,1002) i,v(i-1),v(i)
                    endif
                endif
            endif
!         POUR SORTIE ANTICIPEE DE LA BOUCLE
            if (isens .eq. 0) goto 11
10      continue
11      continue
        if (isens .eq. 99) then
!         AU CAS OU ON NE SAIT TOUJOURS PAS
            isens=1
            ilarge=0
        endif
        isens=isens+(isens*ilarge)
!       ON RENVOIT LE SENS OU UN MESSAGE D'ERREUR
        if (ier .eq. 0) then
            ier=isens
        else if (ier.ne.isens) then
            call getres(nomfon, typfon, nomcmd)
            if (ier .eq. 2) then
!            PARAMETRES NON STRICTEMENT CROISSANTS
                call utmess('F', 'FONCT0_44', sk=nomfon)
            else if (ier.eq.1) then
!           PARAMETRES NON CROISSANTS
                call utmess('F', 'FONCT0_45', sk=nomfon)
            else if (ier.eq.-1) then
!           PARAMETRES NON DECROISSANTS
                call utmess('F', 'FONCT0_46', sk=nomfon)
            else if (ier.eq.-2) then
!           PARAMETRES NON STRICTEMENT DECROISSANTS
                call utmess('F', 'FONCT0_47', sk=nomfon)
            endif
            ASSERT(.false.)
        endif
    else
!        UNE SEULE VALEUR, ON RETOURNE CROISSANT STRICT SI IER=0
        if (ier .eq. 0) then
            isens=2
        else
!        ON RETOURNE CE QU'ON A DEMANDE
            isens=ier
        endif
    endif
    ier=isens
!
    1000 format('EGALITE       I=',i6,'   VALEUR(I)   :',1pe16.9)
    1001 format('CROISSANT     I=',i6,'   VALEUR(I-1) :',1pe16.9,&
     &       '   VALEUR(I)   :',1pe16.9)
    1002 format('DECROISSANT   I=',i6,'   VALEUR(I-1) :',1pe16.9,&
     &       '   VALEUR(I)   :',1pe16.9)
!
end subroutine
