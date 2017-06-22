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

subroutine mefgec(ndim, nbcyl, som, xint, yint,&
                  rint, dcent, ficent, d, fi)
! aslint: disable=
    implicit none
!
#include "asterc/r8pi.h"
#include "asterfort/utmess.h"
    integer :: ndim(14), nbcyl
    real(kind=8) :: som(9), xint(*), yint(*), rint(*), dcent(*), ficent(*)
    real(kind=8) :: d(nbcyl, nbcyl), fi(nbcyl, nbcyl)
!     CALCUL DES COORDONNEES POLAIRES ABSOLUES ET RELATIVES DES CENTRES
!     DES CYLINDRES
!     OPERATEUR APPELANT : OP0144 , FLUST3, MEFIST
! ----------------------------------------------------------------------
!     OPTION DE CALCUL   : CALC_FLUI_STRU , CALCUL DES PARAMETRES DE
!     COUPLAGE FLUIDE-STRUCTURE POUR UNE CONFIGURATION DE TYPE "FAISCEAU
!     DE TUBES SOUS ECOULEMENT AXIAL"
! ----------------------------------------------------------------------
! IN  : NDIM   : TABLEAU DES DIMENSIONS
! IN  : NBCYL  : NOMBRE DE CYLINDRES
! IN  : SOM    : COORDONNEES DES SOMMETS DE L'ENCEINTE RECTANGULAIRE
!                OU XEXT,YEXT,REXT
! IN  : XINT   : COORDONNEES 'X' DES CENTRES DES CYLINDRES DANS
!                LE REPERE AXIAL
! IN  : YINT   : COORDONNEES 'Y' DES CENTRES DES CYLINDRES DANS
!                LE REPERE AXIAL
! IN  : RINT   : RAYONS DES CYLINDRES
! OUT : DCENT  : DISTANCE DU CENTRE DES CYLINDRES AU CENTRE DE
!                L ENCEINTE
! OUT : FICENT : ANGLE POLAIRE PAR RAPPORT AU CENTRE DE L ENCEINTE
! OUT : D      : DISTANCE RELATIVE ENTRE LES CENTRES DES CYLINDRES
! OUT : FI     : ANGLE POLAIRE RELATIF PAR RAPPORT AU CENTRE DE CHAQUE
!                CYLINDRE
! ----------------------------------------------------------------------
    integer :: i, j
    character(len=3) :: note, not2
    character(len=24) :: valk(2)
! ----------------------------------------------------------------------
!
! --- LECTURE DES DIMENSIONS
!-----------------------------------------------------------------------
    real(kind=8) :: delta, pi, rext, xext, yext
!-----------------------------------------------------------------------
    nbcyl = ndim(3)
!
!
    pi = r8pi()
    xext = som(1)
    yext = som(2)
    rext = som(3)
!
! --- (DCENT,FICENT) : COORDONNEES POLAIRES DES CENTRES
! ---                  DES CYLINDRES INTERIEURS
!
    do 10 i = 1, nbcyl
        dcent(i) = sqrt( ( xint(i)-xext)*(xint(i)-xext) + (yint(i)-yext) *(yint(i)-yext ) )
        if (dcent(i) .ne. 0.d0) then
            ficent(i) = acos((xint(i)-xext)/dcent(i))
            if ((yint(i)-yext) .lt. 0.d0) then
                ficent(i) = 2.d0*pi-ficent(i)
            endif
        else
            ficent(i) = 0.d0
        endif
10  end do
!
! --- (D,FI) : COORDONNEES POLAIRES RELATIVES DES CENTRES
! ---          DES CYLINDRES LES UNS PAR RAPPORT AUX AUTRES
!
    do 30 i = 1, nbcyl
        do 20 j = 1, nbcyl
            d(j,i) = sqrt(&
                     ( xint(i)-xint(j))*(xint(i)-xint(j))+ (yint(i)-yint(j))*(yint(i)-yint(j) ))
            if (i .ne. j) then
                if ((rint(j)+rint(i)) .ge. d(j,i)) then
                    write(note(1:3),'(I3.3)') i
                    write(not2(1:3),'(I3.3)') j
                    valk(1) = note
                    valk(2) = not2
                    call utmess('F', 'ALGELINE_80', nk=2, valk=valk)
                endif
            endif
!
            if (d(j,i) .ne. 0.d0) then
                fi(j,i) = acos((xint(i)-xint(j))/d(j,i))
                if ((yint(i)-yint(j)) .lt. 0.d0) then
                    fi(j,i) = 2.d0*pi-fi(j,i)
                endif
            else
                fi(j,i) = 0.d0
            endif
!
20      continue
30  end do
!
! --- VERIFICATION DE L INCLUSION DE TOUS LES CYLINDRES DANS
! --- L ENCEINTE CIRCULAIRE
!
!
    do 40 i = 1, nbcyl
        delta = sqrt((xint(i)-xext)**2+(yint(i)*yext)**2)
        if (delta .ge. (rext-rint(i))) then
            write(note(1:3),'(I3.3)') i
            call utmess('F', 'ALGELINE_81', sk=note)
        endif
40  end do
!
!
end subroutine
